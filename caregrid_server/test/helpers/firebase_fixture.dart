// The committed RSA key/certificate are generated test fixtures, never deployed.
import 'dart:convert';
import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const firebaseTestProject = 'caregrid-test-project';
final firebaseTestNow = DateTime.utc(2026, 11, 20);
final firebaseTestSeconds = firebaseTestNow.millisecondsSinceEpoch ~/ 1000;
final firebaseTestCertificate = File(
  'test/fixtures/firebase-test-cert.pem',
).readAsStringSync();
final firebaseTestKey = RSAPrivateKey(
  File('test/fixtures/firebase-test-key.pem').readAsStringSync(),
);

String firebaseTestToken({
  Map<String, dynamic> claims = const {},
  String kid = 'test-key',
}) => JWT(
  {
    'aud': firebaseTestProject,
    'iss': 'https://securetoken.google.com/$firebaseTestProject',
    'sub': 'firebase-user-1',
    'iat': firebaseTestSeconds - 10,
    'exp': firebaseTestSeconds + 3600,
    'auth_time': firebaseTestSeconds - 60,
    ...claims,
  },
  header: {'kid': kid},
).sign(firebaseTestKey, algorithm: JWTAlgorithm.RS256, noIssueAt: true);

MockClient firebaseTestClient() => MockClient(
  (_) async => http.Response(
    jsonEncode({'test-key': firebaseTestCertificate}),
    200,
    headers: {'cache-control': 'public, max-age=3600'},
  ),
);
