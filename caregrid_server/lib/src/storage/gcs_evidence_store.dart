import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:googleapis_auth/auth_io.dart' as google;
import 'package:http/http.dart' as http;

import '../core/access.dart';
import '../generated/protocol.dart';
import 'evidence_image.dart';

typedef EvidenceClientFactory =
    Future<http.Client> Function(http.Client transport);

class GcsEvidenceConfig {
  GcsEvidenceConfig(this.bucket) {
    if (!RegExp(r'^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$').hasMatch(bucket)) {
      throw ArgumentError('Use a fixed Google bucket name without dots.');
    }
  }
  final String bucket;
}

/// Optional private GCS broker. No public links, signing keys, bucket ACL
/// changes, external URLs or automatic mutation retries are accepted here.
class GcsEvidenceStore {
  GcsEvidenceStore({
    this.config,
    EvidenceClientFactory? clientFactory,
    this.configurationError = false,
    this.requestTimeout = const Duration(seconds: 8),
  }) : _clientFactory = clientFactory ?? _workloadClient;

  factory GcsEvidenceStore.fromEnvironment() {
    if (Platform.environment['CAREGRID_EVIDENCE_ENABLED'] != 'true') {
      return GcsEvidenceStore();
    }
    try {
      return GcsEvidenceStore(
        config: GcsEvidenceConfig(
          Platform.environment['CAREGRID_EVIDENCE_BUCKET'] ?? '',
        ),
      );
    } on ArgumentError {
      return GcsEvidenceStore(configurationError: true);
    }
  }

  static final instance = GcsEvidenceStore.fromEnvironment();
  final GcsEvidenceConfig? config;
  final bool configurationError;
  final Duration requestTimeout;
  final EvidenceClientFactory _clientFactory;
  int _inFlight = 0;
  static final _random = Random.secure();
  static final _keyPattern = RegExp(r'^[a-f0-9]{64}$');
  static final _generationPattern = RegExp(r'^[1-9][0-9]{0,29}$');
  static const _fields =
      'name,size,contentType,contentEncoding,generation,metageneration,timeCreated,metadata';

  static Future<http.Client> _workloadClient(http.Client transport) =>
      Platform.environment.containsKey('K_SERVICE')
      ? google.clientViaMetadataServer(baseClient: transport)
      : google.clientViaApplicationDefaultCredentials(
          scopes: ['https://www.googleapis.com/auth/devstorage.read_write'],
          baseClient: transport,
        );

  static String _prefix(int incidentId) {
    if (incidentId <= 0) throw badRequest('Use a valid incident.');
    return 'caregrid/v1/incidents/$incidentId/';
  }

  static String _name(int incidentId, String key) {
    if (!_keyPattern.hasMatch(key)) {
      throw badRequest('Use a valid attachment key.');
    }
    return '${_prefix(incidentId)}$key';
  }

  static void _generation(String generation) {
    if (!_generationPattern.hasMatch(generation)) {
      throw badRequest('Use a valid attachment generation.');
    }
  }

  Uri _uri({
    String? object,
    bool upload = false,
    Map<String, String> query = const {},
  }) => Uri(
    scheme: 'https',
    host: 'storage.googleapis.com',
    pathSegments: [
      if (upload) 'upload',
      'storage',
      'v1',
      'b',
      config!.bucket,
      'o',
      ?object,
    ],
    queryParameters: query.isEmpty ? null : query,
  );

  Future<EvidencePage> list(int incidentId, {String? pageToken}) async {
    final prefix = _prefix(incidentId);
    if (pageToken != null &&
        (pageToken.isEmpty ||
            pageToken.length > 4096 ||
            RegExp(r'[\x00-\x20]').hasMatch(pageToken))) {
      throw badRequest('Use a valid attachment page token.');
    }
    if (config == null) {
      return EvidencePage(
        status: configurationError ? 'unavailable' : 'disabled',
        files: [],
        notice: configurationError
            ? 'Private attachments are unavailable. Continue using the response record.'
            : 'Google evidence storage is not enabled. Continue using the response record.',
      );
    }
    return _run((client) async {
      final json = await _json(
        client,
        http.Request(
          'GET',
          _uri(
            query: {
              'prefix': prefix,
              'maxResults': '50',
              'fields': 'items($_fields),nextPageToken',
              'pageToken': ?pageToken,
            },
          ),
        ),
      );
      final items = json['items'] ?? [];
      final next = json['nextPageToken'];
      if (items is! List ||
          items.length > 50 ||
          (next != null &&
              (next is! String ||
                  next.isEmpty ||
                  next.length > 4096 ||
                  RegExp(r'[\x00-\x20]').hasMatch(next)))) {
        throw const FormatException();
      }
      return EvidencePage(
        status: 'ready',
        files: items.map((item) => _file(item, incidentId)).toList(),
        nextPageToken: next as String?,
        notice:
            'Private command attachments. Original metadata may be present; treat images as unverified observations.',
      );
    });
  }

  Future<EvidenceFile> upload(
    int incidentId,
    String mediaType,
    String base64Data,
  ) async {
    final bytes = EvidenceImage.decode(base64Data, mediaType);
    final key = List.generate(
      32,
      (_) => _random.nextInt(256),
    ).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    final name = _name(incidentId, key);
    final digest = sha256.convert(bytes).toString();
    return _run((client) async {
      final boundary = 'caregrid_$key';
      final metadata = jsonEncode({
        'name': name,
        'contentType': mediaType,
        'cacheControl': 'private, no-store, max-age=0',
        'metadata': {
          'caregridIncident': '$incidentId',
          'sha256': digest,
          'schemaVersion': '1',
        },
      });
      final body = BytesBuilder()
        ..add(
          utf8.encode(
            '--$boundary\r\nContent-Type: application/json; charset=UTF-8\r\n\r\n$metadata\r\n--$boundary\r\nContent-Type: $mediaType\r\n\r\n',
          ),
        )
        ..add(bytes)
        ..add(utf8.encode('\r\n--$boundary--\r\n'));
      final request =
          http.Request(
              'POST',
              _uri(
                upload: true,
                query: {
                  'uploadType': 'multipart',
                  'ifGenerationMatch': '0',
                  'fields': _fields,
                },
              ),
            )
            ..headers['Content-Type'] = 'multipart/related; boundary=$boundary'
            ..bodyBytes = body.takeBytes();
      final file = _file(await _json(client, request), incidentId, key: key);
      if (file.sha256 != digest ||
          file.byteLength != bytes.length ||
          file.mediaType != mediaType) {
        throw const FormatException();
      }
      return file;
    });
  }

  Future<EvidenceContent> read(
    int incidentId,
    String key,
    String generation,
  ) async {
    final name = _name(incidentId, key);
    _generation(generation);
    return _run((client) async {
      final file = await _metadata(client, incidentId, key, generation);
      final bytes = await _bytes(
        client,
        http.Request(
          'GET',
          _uri(
            object: name,
            query: {
              'alt': 'media',
              'ifGenerationMatch': generation,
              'ifMetagenerationMatch': file.metageneration,
            },
          ),
        ),
        EvidenceImage.maxBytes,
      );
      if (bytes.length != file.byteLength ||
          sha256.convert(bytes).toString() != file.sha256) {
        throw const FormatException();
      }
      EvidenceImage.validate(bytes, file.mediaType);
      return EvidenceContent(file: file, base64Data: base64Encode(bytes));
    });
  }

  /// Removes the live object only. Versioning/soft delete can retain bytes.
  Future<void> remove(int incidentId, String key, String generation) async {
    final name = _name(incidentId, key);
    _generation(generation);
    return _run((client) async {
      final file = await _metadata(client, incidentId, key, generation);
      await _bytes(
        client,
        http.Request(
          'DELETE',
          _uri(
            object: name,
            query: {
              'ifGenerationMatch': generation,
              'ifMetagenerationMatch': file.metageneration,
            },
          ),
        ),
        0,
        expectedStatus: 204,
      );
    });
  }

  Future<EvidenceFile> _metadata(
    http.Client client,
    int incidentId,
    String key,
    String generation,
  ) async {
    final file = _file(
      await _json(
        client,
        http.Request(
          'GET',
          _uri(
            object: _name(incidentId, key),
            query: {'ifGenerationMatch': generation, 'fields': _fields},
          ),
        ),
      ),
      incidentId,
      key: key,
    );
    if (file.generation != generation) throw const FormatException();
    return file;
  }

  EvidenceFile _file(dynamic value, int incidentId, {String? key}) {
    if (value is! Map<String, dynamic>) throw const FormatException();
    final name = value['name'];
    final prefix = _prefix(incidentId);
    final metadata = value['metadata'];
    final length = value['size'] is String ? int.tryParse(value['size']) : null;
    final created = value['timeCreated'] is String
        ? DateTime.tryParse(value['timeCreated'])
        : null;
    if (name is! String ||
        !name.startsWith(prefix) ||
        !_keyPattern.hasMatch(name.substring(prefix.length)) ||
        (key != null && name != '$prefix$key') ||
        metadata is! Map ||
        metadata['caregridIncident'] != '$incidentId' ||
        metadata['schemaVersion'] != '1' ||
        metadata['sha256'] is! String ||
        !_keyPattern.hasMatch(metadata['sha256']) ||
        length == null ||
        length <= 0 ||
        length > EvidenceImage.maxBytes ||
        created == null ||
        !['image/png', 'image/jpeg'].contains(value['contentType']) ||
        (value['contentEncoding'] != null && value['contentEncoding'] != '') ||
        value['generation'] is! String ||
        !_generationPattern.hasMatch(value['generation']) ||
        value['metageneration'] is! String ||
        !_generationPattern.hasMatch(value['metageneration'])) {
      throw const FormatException();
    }
    return EvidenceFile(
      key: name.substring(prefix.length),
      mediaType: value['contentType'],
      byteLength: length,
      sha256: metadata['sha256'],
      generation: value['generation'],
      metageneration: value['metageneration'],
      createdAt: created.toUtc(),
    );
  }

  Future<Map<String, dynamic>> _json(
    http.Client client,
    http.Request request,
  ) async {
    final value = jsonDecode(
      utf8.decode(await _bytes(client, request, 131072)),
    );
    if (value is! Map<String, dynamic>) throw const FormatException();
    return value;
  }

  Future<Uint8List> _bytes(
    http.Client client,
    http.Request request,
    int limit, {
    int expectedStatus = 200,
  }) async {
    request.followRedirects = false;
    final response = await client.send(request);
    if (response.statusCode == 404) throw notFound('Attachment');
    if (response.statusCode == 412) {
      throw invalidState(
        'The attachment changed. Refresh the attachment list before trying again.',
      );
    }
    if (response.statusCode != expectedStatus ||
        (response.contentLength != null && response.contentLength! > limit)) {
      throw const FormatException();
    }
    final builder = BytesBuilder();
    await for (final chunk in response.stream) {
      if (builder.length + chunk.length > limit) throw const FormatException();
      builder.add(chunk);
    }
    return builder.takeBytes();
  }

  Future<T> _run<T>(Future<T> Function(http.Client) action) async {
    if (config == null) {
      throw CareGridException(
        message: 'Private evidence storage is not enabled or is unavailable.',
        code: 'unavailable',
      );
    }
    if (_inFlight >= 2) {
      throw CareGridException(
        message:
            'Private evidence storage is busy. Continue response actions and try later.',
        code: 'busy',
      );
    }
    _inFlight++;
    final transport = http.Client();
    http.Client? authorized;
    var ended = false;
    try {
      return await (() async {
        authorized = await _clientFactory(transport);
        if (ended) {
          authorized!.close();
          throw StateError('Request budget expired.');
        }
        return action(authorized!);
      })().timeout(requestTimeout);
    } on CareGridException {
      rethrow;
    } catch (_) {
      // An upload timeout has an uncertain outcome. Never retry it automatically.
      throw CareGridException(
        message:
            'Private evidence storage could not complete this request. Refresh the attachment list before repeating an upload or removal.',
        code: 'unavailable',
      );
    } finally {
      ended = true;
      authorized?.close();
      transport.close();
      _inFlight--;
    }
  }
}
