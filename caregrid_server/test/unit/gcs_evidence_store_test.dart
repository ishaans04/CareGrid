import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:caregrid_server/src/generated/protocol.dart';
import 'package:caregrid_server/src/storage/evidence_image.dart';
import 'package:caregrid_server/src/storage/gcs_evidence_store.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

import '../helpers/evidence_fixture.dart';

Matcher errorCode(String code) =>
    isA<CareGridException>().having((e) => e.code, 'code', code);

void main() {
  test(
    'disabled storage acquires no credentials and returns no invented files',
    () async {
      var acquired = false;
      final store = GcsEvidenceStore(
        clientFactory: (_) async {
          acquired = true;
          throw StateError('No credentials');
        },
      );
      expect((await store.list(1)).status, 'disabled');
      await expectLater(
        store.upload(1, 'image/png', evidencePng),
        throwsA(errorCode('unavailable')),
      );
      expect(acquired, isFalse);
    },
  );

  test(
    'bucket, object keys, generations and pagination reject URL/path injection',
    () async {
      for (final bucket in [
        '',
        'https://example.com',
        'bucket/objects',
        'UPPER-case',
        'a.b',
      ]) {
        expect(() => GcsEvidenceConfig(bucket), throwsArgumentError);
      }
      final store = GcsEvidenceStore();
      for (final key in [
        '../other',
        '$evidenceKey/other',
        'https://example.com',
      ]) {
        await expectLater(
          store.read(1, key, '1'),
          throwsA(errorCode('badRequest')),
        );
      }
      await expectLater(
        store.read(1, evidenceKey, '0'),
        throwsA(errorCode('badRequest')),
      );
      await expectLater(store.list(0), throwsA(errorCode('badRequest')));
      await expectLater(
        store.list(1, pageToken: '\r\nheader'),
        throwsA(errorCode('badRequest')),
      );
    },
  );

  test(
    'upload/list/read/remove preserve bytes and use fixed Google endpoints with preconditions',
    () async {
      final provider = EvidenceFixture();
      final store = GcsEvidenceStore(
        config: GcsEvidenceConfig('caregrid-test-evidence'),
        clientFactory: (_) async => provider.client,
      );
      final file = await store.upload(17, 'image/png', evidencePng);
      expect(file.sha256, evidenceHash);
      expect(file.byteLength, evidenceBytes.length);
      expect(file.key, matches(RegExp(r'^[a-f0-9]{64}$')));
      final post = provider.requests.first;
      expect(post.url.host, 'storage.googleapis.com');
      expect(post.url.path, '/upload/storage/v1/b/caregrid-test-evidence/o');
      expect(post.url.queryParameters['ifGenerationMatch'], '0');
      expect(
        post.headers['Content-Type'],
        startsWith('multipart/related; boundary='),
      );
      expect(
        latin1.decode(post.bodyBytes),
        contains('private, no-store, max-age=0'),
      );
      expect(post.followRedirects, isFalse);
      final page = await store.list(17);
      expect(page.files.single.key, file.key);
      expect(
        provider.requests.last.url.queryParameters['prefix'],
        'caregrid/v1/incidents/17/',
      );
      final content = await store.read(17, file.key, file.generation);
      expect(content.base64Data, evidencePng);
      final read = provider.requests.last;
      expect(
        read.url.pathSegments.last,
        'caregrid/v1/incidents/17/${file.key}',
      );
      expect(read.url.queryParameters['ifMetagenerationMatch'], '1');
      await store.remove(17, file.key, file.generation);
      final remove = provider.requests.last;
      expect(remove.method, 'DELETE');
      expect(remove.url.queryParameters['ifGenerationMatch'], file.generation);
      expect(remove.url.queryParameters, isNot(contains('generation')));
      expect((await store.list(17)).files, isEmpty);
    },
  );

  test(
    'image limits reject unsupported, corrupt-header, oversized and decompression-sized inputs before credentials',
    () async {
      expect(EvidenceImage.decode(evidencePng, 'image/png'), evidenceBytes);
      for (final (encoded, type) in [
        (base64Encode(utf8.encode('<svg/>')), 'image/svg+xml'),
        (evidencePng, 'image/jpeg'),
        ('!bad!', 'image/png'),
        ('$evidencePng\n', 'image/png'),
        (base64Encode(List.filled(EvidenceImage.maxBytes + 1, 0)), 'image/png'),
      ]) {
        expect(
          () => EvidenceImage.decode(encoded, type),
          throwsA(errorCode('badRequest')),
        );
      }
      final large = Uint8List.fromList(evidenceBytes);
      ByteData.sublistView(large).setUint32(16, 100000);
      expect(
        () => EvidenceImage.validate(large, 'image/png'),
        throwsA(errorCode('badRequest')),
      );
      final jpeg = Uint8List.fromList([
        255,
        216,
        255,
        192,
        0,
        8,
        8,
        0,
        1,
        0,
        1,
        1,
        255,
        217,
      ]);
      expect(() => EvidenceImage.validate(jpeg, 'image/jpeg'), returnsNormally);
    },
  );

  test(
    'provider metadata cannot move an object into another incident or weaken integrity/type bounds',
    () async {
      for (final corrupt in <void Function(Map<String, dynamic>)>[
        (m) => m['name'] = 'caregrid/v1/incidents/99/$evidenceKey',
        (m) => m['size'] = '${EvidenceImage.maxBytes + 1}',
        (m) => m['contentType'] = 'text/html',
        (m) => m['contentEncoding'] = 'gzip',
        (m) => m['metadata']['sha256'] = 'invalid',
        (m) => m['metadata']['caregridIncident'] = '99',
        (m) => m['generation'] = '0',
        (m) => m['metageneration'] = null,
      ]) {
        final metadata = evidenceMetadata(17);
        corrupt(metadata);
        final store = GcsEvidenceStore(
          config: GcsEvidenceConfig('caregrid-test-evidence'),
          clientFactory: (_) async => MockClient(
            (_) async => http.Response(
              jsonEncode({
                'items': [metadata],
              }),
              200,
            ),
          ),
        );
        await expectLater(store.list(17), throwsA(errorCode('unavailable')));
      }
    },
  );

  test(
    'generation conflicts, missing objects and changed downloaded bytes never return content',
    () async {
      for (final status in [404, 412]) {
        final store = GcsEvidenceStore(
          config: GcsEvidenceConfig('caregrid-test-evidence'),
          clientFactory: (_) async => MockClient(
            (_) async => http.Response('private provider details', status),
          ),
        );
        await expectLater(
          store.read(17, evidenceKey, '123'),
          throwsA(errorCode(status == 404 ? 'notFound' : 'invalidState')),
        );
      }
      final store = GcsEvidenceStore(
        config: GcsEvidenceConfig('caregrid-test-evidence'),
        clientFactory: (_) async => MockClient(
          (r) async => r.url.queryParameters['alt'] == 'media'
              ? http.Response.bytes(List.filled(evidenceBytes.length, 0), 200)
              : http.Response(jsonEncode(evidenceMetadata(17)), 200),
        ),
      );
      await expectLater(
        store.read(17, evidenceKey, '1234567890123456789'),
        throwsA(errorCode('unavailable')),
      );
    },
  );

  test(
    'response bodies and list pages are bounded; failed mutations are not retried',
    () async {
      for (final response in [
        http.Response('redirect', 302),
        http.Response('x' * 131073, 200),
        http.Response('secret provider body', 500),
        http.Response(
          jsonEncode({'items': List.generate(51, (_) => evidenceMetadata(17))}),
          200,
        ),
      ]) {
        var calls = 0;
        final store = GcsEvidenceStore(
          config: GcsEvidenceConfig('caregrid-test-evidence'),
          clientFactory: (_) async => MockClient((r) async {
            calls++;
            expect(r.followRedirects, isFalse);
            return response;
          }),
        );
        await expectLater(store.list(17), throwsA(errorCode('unavailable')));
        expect(calls, 1);
      }
      var calls = 0;
      final store = GcsEvidenceStore(
        config: GcsEvidenceConfig('caregrid-test-evidence'),
        clientFactory: (_) async => MockClient((_) async {
          calls++;
          return http.Response('private-error', 503);
        }),
      );
      await expectLater(
        store.upload(17, 'image/png', evidencePng),
        throwsA(errorCode('unavailable')),
      );
      expect(calls, 1);
    },
  );

  test(
    'credential acquisition shares the total budget and closes a late client',
    () async {
      final gate = Completer<http.Client>();
      final client = _TrackingClient();
      final store = GcsEvidenceStore(
        config: GcsEvidenceConfig('caregrid-test-evidence'),
        requestTimeout: const Duration(milliseconds: 25),
        clientFactory: (_) => gate.future,
      );
      await expectLater(store.list(17), throwsA(errorCode('unavailable')));
      gate.complete(client);
      await Future<void>.delayed(Duration.zero);
      expect(client.closed, isTrue);
    },
  );

  test(
    'two in-flight operations bound memory and release capacity after completion',
    () async {
      final gate = Completer<void>();
      var requests = 0;
      final store = GcsEvidenceStore(
        config: GcsEvidenceConfig('caregrid-test-evidence'),
        clientFactory: (_) async => MockClient((_) async {
          requests++;
          await gate.future;
          return http.Response('{}', 200);
        }),
      );
      final first = store.list(17);
      final second = store.list(18);
      await expectLater(store.list(19), throwsA(errorCode('busy')));
      gate.complete();
      await Future.wait([first, second]);
      expect((await store.list(19)).status, 'ready');
      expect(requests, 3);
    },
  );

  test('opaque pagination stays on the fixed incident prefix', () async {
    final store = GcsEvidenceStore(
      config: GcsEvidenceConfig('caregrid-test-evidence'),
      clientFactory: (_) async => MockClient((r) async {
        expect(r.url.host, 'storage.googleapis.com');
        expect(r.url.queryParameters['prefix'], 'caregrid/v1/incidents/17/');
        expect(r.url.queryParameters['pageToken'], 'opaque+/=token');
        return http.Response('{"nextPageToken":"next-token"}', 200);
      }),
    );
    expect(
      (await store.list(17, pageToken: 'opaque+/=token')).nextPageToken,
      'next-token',
    );
  });
}

class _TrackingClient extends MockClient {
  _TrackingClient() : super((_) async => http.Response('{}', 200));
  bool closed = false;
  @override
  void close() {
    closed = true;
    super.close();
  }
}
