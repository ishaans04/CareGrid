import 'dart:convert';

import 'package:caregrid_server/src/identity/firebase_token_verifier.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

import '../helpers/firebase_fixture.dart';

void main() {
  final rejected = throwsA(isA<FirebaseTokenException>());
  late FirebaseTokenVerifier verifier;
  setUp(
    () => verifier = FirebaseTokenVerifier(
      projectId: firebaseTestProject,
      client: firebaseTestClient(),
      now: () => firebaseTestNow,
    ),
  );
  tearDown(() => verifier.close());

  test(
    'valid RSA signature yields a Firebase UID with no client roles',
    () async {
      final identity = await verifier.verify(
        firebaseTestToken(claims: {'role': 'admin'}),
      );
      expect(identity.uid, 'firebase-user-1');
      expect(
        identity.authenticatedAt,
        firebaseTestNow.subtract(const Duration(seconds: 60)),
      );
    },
  );

  test(
    'rejects tampering, algorithm confusion and malformed headers',
    () async {
      final token = firebaseTestToken();
      final parts = token.split('.');
      final altered = base64Url
          .encode(utf8.encode('{"sub":"other-user"}'))
          .replaceAll('=', '');
      await expectLater(
        verifier.verify('${parts[0]}.$altered.${parts[2]}'),
        rejected,
      );
      final hmac = JWT(
        {'sub': 'other-user'},
        header: {'kid': 'test-key'},
      ).sign(SecretKey('test-only'));
      for (final bad in [
        hmac,
        'invalid',
        '${'x' * 16385}.x.x',
        firebaseTestToken(kid: ''),
      ]) {
        await expectLater(verifier.verify(bad), rejected);
      }
    },
  );

  test(
    'rejects wrong project/issuer and invalid required identity/time claims',
    () async {
      for (final claims in <Map<String, dynamic>>[
        {'aud': 'another-project'},
        {
          'aud': [firebaseTestProject],
        },
        {'iss': 'https://evil.example'},
        {'sub': ''},
        {'sub': 'x' * 129},
        {'sub': null},
        {'exp': firebaseTestSeconds},
        {'exp': null},
        {'exp': 'future'},
        {'iat': firebaseTestSeconds + 1},
        {'iat': null},
        {'auth_time': firebaseTestSeconds + 1},
        {'auth_time': null},
        {'nbf': firebaseTestSeconds + 1},
        {
          'firebase': {'tenant': 'unconfigured-tenant'},
        },
      ]) {
        await expectLater(
          verifier.verify(firebaseTestToken(claims: claims)),
          rejected,
          reason: 'Rejected claim keys: ${claims.keys.join(', ')}',
        );
      }
    },
  );

  test(
    'caches Google keys, coalesces requests, and refreshes a rotated kid',
    () async {
      var now = firebaseTestNow;
      var calls = 0;
      var kid = 'test-key';
      final client = MockClient((request) async {
        expect(request.url, FirebaseTokenVerifier.certificatesUri);
        calls++;
        return http.Response(
          jsonEncode({kid: firebaseTestCertificate}),
          200,
          headers: {'cache-control': 'public, max-age=3600', 'age': '30'},
        );
      });
      final cache = FirebaseTokenVerifier(
        projectId: firebaseTestProject,
        client: client,
        now: () => now,
      );
      addTearDown(cache.close);
      await Future.wait(
        List.generate(4, (_) => cache.verify(firebaseTestToken())),
      );
      expect(calls, 1);
      await expectLater(
        cache.verify(firebaseTestToken(kid: 'unknown-key')),
        rejected,
      );
      expect(calls, 1);
      now = now.add(const Duration(seconds: 61));
      kid = 'rotated-key';
      expect(
        (await cache.verify(firebaseTestToken(kid: kid))).uid,
        'firebase-user-1',
      );
      expect(calls, 2);
    },
  );

  test(
    'expired certificate cache fails closed during an outage and recovers',
    () async {
      var now = firebaseTestNow;
      var available = true;
      var calls = 0;
      final client = MockClient((_) async {
        calls++;
        return available
            ? http.Response(
                jsonEncode({'test-key': firebaseTestCertificate}),
                200,
                headers: {'cache-control': 'max-age=60'},
              )
            : http.Response('unavailable', 503);
      });
      final cache = FirebaseTokenVerifier(
        projectId: firebaseTestProject,
        client: client,
        now: () => now,
      );
      addTearDown(cache.close);
      await cache.verify(firebaseTestToken());
      available = false;
      now = now.add(const Duration(seconds: 61));
      await expectLater(cache.verify(firebaseTestToken()), rejected);
      await expectLater(cache.verify(firebaseTestToken()), rejected);
      expect(calls, 2);
      now = now.add(const Duration(seconds: 61));
      available = true;
      await cache.verify(firebaseTestToken());
      expect(calls, 3);
    },
  );
}
