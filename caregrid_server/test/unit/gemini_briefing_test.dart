import 'dart:async';
import 'dart:convert';

import 'package:caregrid_server/src/ai/briefing_snapshot.dart';
import 'package:caregrid_server/src/ai/gemini_briefing.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

import '../helpers/briefing_fixture.dart';

void main() {
  test(
    'disabled/misconfigured assistance never requests credentials',
    () async {
      var calls = 0;
      Future<http.Client> factory(http.Client _) async {
        calls++;
        throw StateError('must not run');
      }

      for (final misconfigured in [false, true]) {
        final service = GeminiBriefing(
          configurationError: misconfigured,
          clientFactory: factory,
        );
        expect(
          (await service.generate(briefingTestSnapshot())).status,
          misconfigured ? 'unavailable' : 'disabled',
        );
      }
      expect(calls, 0);
    },
  );

  test('configuration cannot redirect credentials to an arbitrary host', () {
    for (final location in [
      'https://evil.test',
      '../global',
      'asia-south1/x',
    ]) {
      expect(
        () => GeminiBriefingConfig(
          projectId: 'caregrid-test-project',
          location: location,
          model: 'gemini-test-fixture',
        ),
        throwsArgumentError,
      );
    }
    expect(
      briefingTestConfig().uri.host,
      'asia-south1-aiplatform.googleapis.com',
    );
  });

  test(
    'input minimization and structured tool-less request are enforced',
    () async {
      final snapshot = briefingTestSnapshot();
      final service = GeminiBriefing(
        config: briefingTestConfig(),
        clientFactory: (_) async => MockClient((request) async {
          expect(request.url, briefingTestConfig().uri);
          expect(request.followRedirects, isFalse);
          expect(request.body, isNot(contains('PRIVATE')));
          expect(request.body, isNot(contains('INC-TEST')));
          expect(request.body, isNot(contains('reporterUserId')));
          final data = jsonDecode(request.body) as Map;
          expect(data.containsKey('tools'), isFalse);
          expect(
            data['generationConfig']['responseMimeType'],
            'application/json',
          );
          expect(data['generationConfig']['responseSchema']['type'], 'OBJECT');
          final sent = jsonDecode(
            data['contents'][0]['parts'][0]['text'] as String,
          );
          expect(sent, snapshot.facts);
          return briefingTestResponse();
        }),
      );
      final draft = await service.generate(snapshot);
      expect(draft.status, 'generated');
      expect(draft.evidenceRefs, ['recorded_state', 'arrivals_recorded']);
      expect(snapshot.facts, isNot(contains('location')));
      expect(
        () => snapshot.facts['extra'] = 'injected',
        throwsUnsupportedError,
      );
    },
  );

  test(
    'wrong references, extra authority fields and incomplete output fail closed',
    () async {
      final invalid = [
        {
          'summary': 'Arrived',
          'evidenceRefs': ['invented_camera'],
        },
        {'summary': 'Arrived', 'evidenceRefs': []},
        {
          'summary': 'Arrived',
          'evidenceRefs': ['recorded_state', 'recorded_state'],
        },
        {
          'summary': 'Dispatch now',
          'evidenceRefs': ['recorded_state'],
          'action': 'dispatch',
        },
        {
          'summary': '',
          'evidenceRefs': ['recorded_state'],
        },
        {
          'summary': List.filled(601, 'x').join(),
          'evidenceRefs': ['recorded_state'],
        },
      ];
      for (final value in invalid) {
        final service = GeminiBriefing(
          config: briefingTestConfig(),
          clientFactory: (_) async =>
              MockClient((_) async => briefingTestResponse(output: value)),
        );
        final result = await service.generate(briefingTestSnapshot());
        expect(result.status, 'unavailable');
        expect(result.summary, isNull);
      }
      for (final reason in ['MAX_TOKENS', 'SAFETY', 'RECITATION']) {
        final service = GeminiBriefing(
          config: briefingTestConfig(),
          clientFactory: (_) async => MockClient(
            (_) async => briefingTestResponse(finishReason: reason),
          ),
        );
        expect(
          (await service.generate(briefingTestSnapshot())).status,
          'unavailable',
        );
      }
    },
  );

  test(
    'cache is version-bound; cooldown and single-flight bound spend',
    () async {
      final entered = Completer<void>();
      final release = Completer<void>();
      var calls = 0;
      var now = briefingTestTime;
      final service = GeminiBriefing(
        config: briefingTestConfig(),
        now: () => now,
        clientFactory: (_) async => MockClient((_) async {
          calls++;
          if (!entered.isCompleted) entered.complete();
          await release.future;
          return briefingTestResponse();
        }),
      );
      final first = service.generate(briefingTestSnapshot());
      await entered.future;
      expect((await service.generate(briefingTestSnapshot())).status, 'busy');
      release.complete();
      expect((await first).status, 'generated');
      expect(
        (await service.generate(briefingTestSnapshot())).status,
        'generated',
      );
      expect(calls, 1);
      final changed = briefingTestIncident()..hospitalNotified = true;
      final snapshot = BriefingSnapshot.fromRecords(changed, []);
      expect((await service.generate(snapshot)).status, 'cooldown');
      now = now.add(const Duration(seconds: 11));
      expect((await service.generate(snapshot)).status, 'generated');
      expect(calls, 2);
    },
  );

  test(
    'failed requests are not retried and the circuit recovers after its window',
    () async {
      var calls = 0;
      var now = briefingTestTime;
      var healthy = false;
      final service = GeminiBriefing(
        config: briefingTestConfig(),
        now: () => now,
        clientFactory: (_) async => MockClient((_) async {
          calls++;
          return healthy
              ? briefingTestResponse()
              : http.Response('PRIVATE PROVIDER ERROR', 503);
        }),
      );
      for (var i = 0; i < 3; i++) {
        expect(
          (await service.generate(briefingTestSnapshot())).status,
          'unavailable',
        );
        now = now.add(const Duration(seconds: 11));
      }
      expect(calls, 3);
      expect(
        (await service.generate(briefingTestSnapshot())).status,
        'unavailable',
      );
      expect(calls, 3);
      now = now.add(const Duration(minutes: 1));
      healthy = true;
      expect(
        (await service.generate(briefingTestSnapshot())).status,
        'generated',
      );
      expect(calls, 4);
    },
  );

  test('credential acquisition is inside the total timeout budget', () async {
    final release = Completer<http.Client>();
    final service = GeminiBriefing(
      config: briefingTestConfig(),
      requestTimeout: const Duration(milliseconds: 10),
      clientFactory: (_) => release.future,
    );
    final result = await service.generate(briefingTestSnapshot());
    expect(result.status, 'unavailable');
    expect(result.summary, isNull);
    release.complete(MockClient((_) async => throw StateError('late request')));
    await Future<void>.delayed(Duration.zero);
  });

  test(
    'oversized and blocked provider responses are never presented as drafts',
    () async {
      for (final response in [
        http.Response(List.filled(65537, 'x').join(), 200),
        http.Response(
          jsonEncode({
            'promptFeedback': {'blockReason': 'SAFETY'},
          }),
          200,
        ),
        http.Response('not JSON', 200),
      ]) {
        final service = GeminiBriefing(
          config: briefingTestConfig(),
          clientFactory: (_) async => MockClient((_) async => response),
        );
        expect(
          (await service.generate(briefingTestSnapshot())).status,
          'unavailable',
        );
      }
    },
  );
}
