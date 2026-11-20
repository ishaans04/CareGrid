import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const evidencePng =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aZ1kAAAAASUVORK5CYII=';
final evidenceBytes = base64Decode(evidencePng);
final evidenceHash = sha256.convert(evidenceBytes).toString();
final evidenceKey = 'a' * 64;

Map<String, dynamic> evidenceMetadata(int incidentId, {String? key}) => {
  'name': 'caregrid/v1/incidents/$incidentId/${key ?? evidenceKey}',
  'contentType': 'image/png',
  'size': '${evidenceBytes.length}',
  'generation': '1234567890123456789',
  'metageneration': '1',
  'timeCreated': '2026-11-20T06:00:00.000Z',
  'metadata': {
    'caregridIncident': '$incidentId',
    'schemaVersion': '1',
    'sha256': evidenceHash,
  },
};

/// In-memory provider fixture only, never a claim of a live Google operation.
class EvidenceFixture {
  final Map<String, Map<String, dynamic>> objects = {};
  final List<http.Request> requests = [];
  late final client = MockClient((request) async {
    requests.add(request);
    if (request.method == 'POST') {
      final body = latin1.decode(request.bodyBytes);
      final key = RegExp(
        r'caregrid/v1/incidents/([0-9]+)/([a-f0-9]{64})',
      ).firstMatch(body)!;
      final metadata = evidenceMetadata(int.parse(key[1]!), key: key[2]);
      objects[metadata['name']] = metadata;
      return http.Response(jsonEncode(metadata), 200);
    }
    final name = request.url.pathSegments.last;
    if (request.method == 'GET' && name == 'o') {
      final prefix = request.url.queryParameters['prefix']!;
      return http.Response(
        jsonEncode({
          'items': objects.values
              .where((m) => (m['name'] as String).startsWith(prefix))
              .toList(),
        }),
        200,
      );
    }
    final metadata = objects[name];
    if (metadata == null) return http.Response('{}', 404);
    if (request.url.queryParameters['ifGenerationMatch'] !=
        metadata['generation']) {
      return http.Response('{}', 412);
    }
    if (request.method == 'DELETE') {
      objects.remove(name);
      return http.Response('', 204);
    }
    if (request.url.queryParameters['alt'] == 'media') {
      return http.Response.bytes(evidenceBytes, 200);
    }
    return http.Response(jsonEncode(metadata), 200);
  });
}
