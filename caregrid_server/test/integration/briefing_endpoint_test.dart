import 'dart:convert';

import 'package:caregrid_server/src/ai/gemini_briefing.dart';
import 'package:caregrid_server/src/core/access.dart';
import 'package:caregrid_server/src/endpoints/briefing_endpoint.dart';
import 'package:caregrid_server/src/generated/protocol.dart';
import 'package:caregrid_server/src/seed/seeder.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

import '../helpers/briefing_fixture.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Optional handoff brief boundary', (sessions, endpoints) {
    late TestSessionBuilder command;
    late Incident incident;
    Future<TestSessionBuilder> asRole(UserRole role) async {
      final user = (await AppUser.db.findFirstRow(
        sessions.build(),
        where: (t) => t.role.equals(role),
      ))!;
      return sessions.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          '${user.id}',
          {Access.scopeFor(role)},
        ),
      );
    }

    setUp(() async {
      await Seeder.seedIfEmpty(sessions.build());
      command = await asRole(UserRole.command);
      incident = (await Incident.db.findFirstRow(sessions.build()))!;
    });

    test(
      'only command can request a brief, including when Gemini is disabled',
      () async {
        final forbidden = throwsA(
          isA<CareGridException>().having((e) => e.code, 'code', 'forbidden'),
        );
        await expectLater(
          endpoints.briefing.generate(sessions, incident.id!),
          forbidden,
        );
        for (final role in UserRole.values.where(
          (r) => r != UserRole.command,
        )) {
          await expectLater(
            endpoints.briefing.generate(await asRole(role), incident.id!),
            forbidden,
          );
        }
      },
    );

    test(
      'disabled assistance returns no invented draft or incident changes',
      () async {
        final before = jsonEncode(incident.toJson());
        final result = await endpoints.briefing.generate(command, incident.id!);
        expect(result.status, 'disabled');
        expect(result.summary, isNull);
        expect(result.evidenceRefs, isEmpty);
        final after = (await Incident.db.findById(
          sessions.build(),
          incident.id!,
        ))!;
        expect(jsonEncode(after.toJson()), before);
        final audit = await AuditRecord.db.findFirstRow(
          sessions.build(),
          where: (t) =>
              t.action.equals('handoff-brief') & t.target.equals(incident.code),
        );
        expect(audit!.detail, contains('disabled'));
        expect(audit.detail, isNot(contains('summary')));
      },
    );

    test(
      'a model response is discarded if its source changes during generation',
      () async {
        final service = GeminiBriefing(
          config: briefingTestConfig(),
          clientFactory: (_) async => MockClient((_) async {
            incident.updatedAt = incident.updatedAt.add(
              const Duration(seconds: 1),
            );
            await Incident.db.updateRow(sessions.build(), incident);
            return briefingTestResponse();
          }),
        );
        final endpoint = BriefingEndpoint(briefing: service);
        final result = await endpoint.generate(command.build(), incident.id!);
        expect(result.status, 'stale');
        expect(result.summary, isNull);
        expect(result.evidenceRefs, isEmpty);
        final after = (await Incident.db.findById(
          sessions.build(),
          incident.id!,
        ))!;
        expect(after.state, incident.state);
        expect(after.severity, incident.severity);
      },
    );
  });
}
