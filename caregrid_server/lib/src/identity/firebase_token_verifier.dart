import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;

class FirebaseTokenException implements Exception {
  const FirebaseTokenException();
}

class FirebaseIdentity {
  const FirebaseIdentity({required this.uid, required this.authenticatedAt});

  final String uid;
  final DateTime authenticatedAt;
}

/// Firebase's documented third-party JWT verification flow. The JWT library
/// verifies RSA signatures; this adapter selects Google's key by kid and checks
/// the Firebase project and mandatory claims. No client role/email is trusted.
class FirebaseTokenVerifier {
  FirebaseTokenVerifier({
    required this.projectId,
    http.Client? client,
    DateTime Function()? now,
  }) : _client = client ?? http.Client(),
       _now = now ?? DateTime.now {
    if (!RegExp(r'^[a-z][a-z0-9-]{4,28}[a-z0-9]$').hasMatch(projectId)) {
      throw ArgumentError('A valid Firebase project ID is required.');
    }
  }

  static final certificatesUri = Uri.parse(
    'https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com',
  );

  final String projectId;
  final http.Client _client;
  final DateTime Function() _now;
  Map<String, RSAPublicKey> _keys = {};
  DateTime _expires = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  DateTime _retryAfter = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  Future<void>? _refreshing;

  void close() => _client.close();

  Future<FirebaseIdentity> verify(String token) async {
    try {
      if (token.length > 16384 || token.split('.').length != 3) {
        throw const FirebaseTokenException();
      }
      final header = JWT.decode(token).header;
      final kid = header?['kid'];
      if (header?['alg'] != 'RS256' ||
          kid is! String ||
          kid.isEmpty ||
          kid.length > 128) {
        throw const FirebaseTokenException();
      }
      await _ensureKeys(kid);
      final key = _keys[kid];
      if (key == null) throw const FirebaseTokenException();
      final jwt = JWT.verify(
        token,
        key,
        checkHeaderType: false,
        checkExpiresIn: false,
        checkNotBefore: false,
      );
      final claims = jwt.payload;
      if (claims is! Map<String, dynamic> ||
          claims['aud'] != projectId ||
          claims['iss'] != 'https://securetoken.google.com/$projectId') {
        throw const FirebaseTokenException();
      }
      final uid = claims['sub'];
      final exp = claims['exp'];
      final issued = claims['iat'];
      final authTime = claims['auth_time'];
      final nbf = claims['nbf'];
      final firebase = claims['firebase'];
      final seconds = _now().toUtc().millisecondsSinceEpoch ~/ 1000;
      if (uid is! String ||
          uid.isEmpty ||
          uid.length > 128 ||
          exp is! int ||
          exp <= seconds ||
          issued is! int ||
          issued < 0 ||
          issued > seconds ||
          exp <= issued ||
          authTime is! int ||
          authTime < 0 ||
          authTime > seconds ||
          (nbf != null && (nbf is! int || nbf > seconds)) ||
          (firebase is Map && firebase.containsKey('tenant'))) {
        throw const FirebaseTokenException();
      }
      return FirebaseIdentity(
        uid: uid,
        authenticatedAt: DateTime.fromMillisecondsSinceEpoch(
          authTime * 1000,
          isUtc: true,
        ),
      );
    } catch (_) {
      // Do not log raw tokens, payloads or certificate responses.
      throw const FirebaseTokenException();
    }
  }

  Future<void> _ensureKeys(String kid) async {
    final now = _now().toUtc();
    if (now.isBefore(_expires) && _keys.containsKey(kid)) return;
    final pending = _refreshing;
    if (pending != null) {
      await pending;
    } else {
      // Bound unknown-kid refreshes and failed Google requests to one/minute.
      if (now.isBefore(_retryAfter)) throw const FirebaseTokenException();
      final refresh = _refreshKeys();
      _refreshing = refresh;
      try {
        await refresh;
      } finally {
        _refreshing = null;
      }
    }
    if (!_now().toUtc().isBefore(_expires)) {
      throw const FirebaseTokenException();
    }
  }

  Future<void> _refreshKeys() async {
    _retryAfter = _now().toUtc().add(const Duration(minutes: 1));
    final response = await _client
        .get(certificatesUri)
        .timeout(const Duration(seconds: 5));
    if (response.statusCode != 200 || response.bodyBytes.length > 1048576) {
      throw const FirebaseTokenException();
    }
    final data = jsonDecode(response.body);
    if (data is! Map<String, dynamic> || data.isEmpty) {
      throw const FirebaseTokenException();
    }
    final keys = <String, RSAPublicKey>{};
    for (final entry in data.entries) {
      if (entry.value is! String) throw const FirebaseTokenException();
      keys[entry.key] = RSAPublicKey.cert(entry.value as String);
    }
    final maxAge = int.tryParse(
      RegExp(
            r'(?:^|[,\s])max-age=(\d+)',
          ).firstMatch(response.headers['cache-control'] ?? '')?.group(1) ??
          '',
    );
    final age = int.tryParse(response.headers['age'] ?? '0') ?? 0;
    if (maxAge == null || maxAge <= age || age < 0) {
      throw const FirebaseTokenException();
    }
    _keys = keys;
    _expires = _now().toUtc().add(
      Duration(seconds: (maxAge - age).clamp(1, 86400)),
    );
  }
}
