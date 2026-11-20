import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart' as google;
import 'package:http/http.dart' as http;

import 'briefing_snapshot.dart';

class GeminiBriefingConfig {
  GeminiBriefingConfig({
    required this.projectId,
    required this.location,
    required this.model,
  }) {
    if (!RegExp(r'^[a-z][a-z0-9-]{4,28}[a-z0-9]$').hasMatch(projectId) ||
        !(location == 'global' ||
            RegExp(r'^[a-z]+-[a-z]+[0-9]$').hasMatch(location)) ||
        !RegExp(r'^gemini-[a-z0-9][a-z0-9.-]{0,95}$').hasMatch(model)) {
      throw ArgumentError(
        'Use a fixed Google project, location and Gemini ID.',
      );
    }
  }

  final String projectId;
  final String location;
  final String model;

  Uri get uri => Uri.https(
    location == 'global'
        ? 'aiplatform.googleapis.com'
        : '$location-aiplatform.googleapis.com',
    '/v1/projects/$projectId/locations/$location/publishers/google/models/$model:generateContent',
  );
}

class BriefDraft {
  const BriefDraft(this.status, {this.summary, this.evidenceRefs = const []});
  final String status;
  final String? summary;
  final List<String> evidenceRefs;
}

typedef BriefingClientFactory =
    Future<http.Client> Function(http.Client transport);

/// Optional, tool-less model adapter. It has no database/dispatch dependency.
/// Limits are per API process, not a fleet-wide budget or availability promise.
class GeminiBriefing {
  GeminiBriefing({
    this.config,
    BriefingClientFactory? clientFactory,
    DateTime Function()? now,
    this.requestTimeout = const Duration(seconds: 8),
    this.minimumInterval = const Duration(seconds: 10),
    this.configurationError = false,
  }) : _clientFactory = clientFactory ?? _workloadClient,
       _now = now ?? DateTime.now;

  factory GeminiBriefing.fromEnvironment() {
    final env = Platform.environment;
    if (env['CAREGRID_GEMINI_ENABLED'] != 'true') return GeminiBriefing();
    try {
      return GeminiBriefing(
        config: GeminiBriefingConfig(
          projectId: env['FIREBASE_PROJECT_ID'] ?? '',
          location: env['CAREGRID_GEMINI_LOCATION'] ?? '',
          model: env['CAREGRID_GEMINI_MODEL'] ?? '',
        ),
      );
    } on ArgumentError {
      return GeminiBriefing(configurationError: true);
    }
  }

  static final instance = GeminiBriefing.fromEnvironment();
  static const promptVersion = 'handoff-facts-v1';
  static const _instructions =
      'Write a concise factual handoff draft for a campus command operator. '
      'Use only the supplied enum/count facts. They are records, not medical '
      'findings or proof of a physical outcome. A recorded incident stage does '
      'not mean all units reached that stage; use the per-unit counts. '
      'Mention simulation when true. Do not diagnose, prescribe treatment, '
      'change severity, recommend allocations, dispatch, resolve or assert '
      'unrecorded arrival/care. Do not add names, locations or invented facts. '
      'Return summary (at most 600 characters) and evidenceRefs containing '
      'the supplied fact IDs supporting the summary. Human review is required.';

  final GeminiBriefingConfig? config;
  final bool configurationError;
  final Duration requestTimeout;
  final Duration minimumInterval;
  final BriefingClientFactory _clientFactory;
  final DateTime Function() _now;
  final Map<String, ({BriefDraft draft, DateTime expires})> _cache = {};
  bool _busy = false;
  int _failures = 0;
  DateTime? _nextAttempt;
  DateTime? _openUntil;

  static Future<http.Client> _workloadClient(http.Client transport) {
    if (Platform.environment.containsKey('K_SERVICE')) {
      // Attached identity only on Cloud Run; no credential file or HOME needed.
      return google.clientViaMetadataServer(baseClient: transport);
    }
    return google.clientViaApplicationDefaultCredentials(
      scopes: ['https://www.googleapis.com/auth/cloud-platform'],
      baseClient: transport,
    );
  }

  Future<BriefDraft> generate(BriefingSnapshot snapshot) async {
    final settings = config;
    if (settings == null) {
      return BriefDraft(configurationError ? 'unavailable' : 'disabled');
    }
    final now = _now().toUtc();
    _cache.removeWhere((_, value) => !now.isBefore(value.expires));
    final cached = _cache[snapshot.cacheKey];
    if (cached != null) return cached.draft;
    if (_busy) return const BriefDraft('busy');
    if (_openUntil != null && now.isBefore(_openUntil!)) {
      return const BriefDraft('unavailable');
    }
    if (_nextAttempt != null && now.isBefore(_nextAttempt!)) {
      return const BriefDraft('cooldown');
    }
    _busy = true;
    _nextAttempt = now.add(minimumInterval);
    final transport = http.Client();
    http.Client? authorized;
    var ended = false;
    try {
      final operation = () async {
        authorized = await _clientFactory(transport);
        if (ended) {
          authorized!.close();
          throw StateError('Request budget expired.');
        }
        final request = http.Request('POST', settings.uri)
          ..followRedirects = false
          ..headers['Content-Type'] = 'application/json'
          ..body = jsonEncode({
            'systemInstruction': {
              'parts': [
                {'text': _instructions},
              ],
            },
            'contents': [
              {
                'role': 'user',
                'parts': [
                  {'text': jsonEncode(snapshot.facts)},
                ],
              },
            ],
            'generationConfig': {
              'temperature': 0.1,
              'candidateCount': 1,
              'maxOutputTokens': 512,
              'responseMimeType': 'application/json',
              'responseSchema': {
                'type': 'OBJECT',
                'required': ['summary', 'evidenceRefs'],
                'properties': {
                  'summary': {'type': 'STRING'},
                  'evidenceRefs': {
                    'type': 'ARRAY',
                    'items': {
                      'type': 'STRING',
                      'enum': snapshot.facts.keys.toList(),
                    },
                  },
                },
              },
            },
          });
        final response = await authorized!.send(request);
        if (response.statusCode != 200 ||
            (response.contentLength ?? 0) > 65536) {
          throw const FormatException('No usable model response.');
        }
        final bytes = <int>[];
        await for (final chunk in response.stream) {
          if (bytes.length + chunk.length > 65536) {
            throw const FormatException('Response budget exceeded.');
          }
          bytes.addAll(chunk);
        }
        return _validate(utf8.decode(bytes), snapshot.facts.keys.toSet());
      }();
      final result = await operation.timeout(requestTimeout);
      _failures = 0;
      _openUntil = null;
      if (_cache.length >= 32) _cache.remove(_cache.keys.first);
      _cache[snapshot.cacheKey] = (
        draft: result,
        expires: _now().toUtc().add(const Duration(minutes: 2)),
      );
      return result;
    } catch (_) {
      if (++_failures >= 3) {
        _openUntil = _now().toUtc().add(const Duration(minutes: 1));
      }
      // Never log model bodies, prompts, access credentials or raw errors.
      return const BriefDraft('unavailable');
    } finally {
      ended = true;
      authorized?.close();
      transport.close(); // Also aborts credential acquisition / streaming I/O.
      _busy = false;
    }
  }

  static BriefDraft _validate(String body, Set<String> allowedRefs) {
    final response = jsonDecode(body);
    if (response is! Map ||
        response['promptFeedback']?['blockReason'] != null) {
      throw const FormatException('Blocked model response.');
    }
    final candidates = response['candidates'];
    if (candidates is! List || candidates.length != 1) {
      throw const FormatException('Expected one completed response.');
    }
    final candidate = candidates.single;
    if (candidate is! Map || candidate['finishReason'] != 'STOP') {
      throw const FormatException('Incomplete model response.');
    }
    final parts = candidate['content']?['parts'];
    if (parts is! List || parts.length != 1 || parts.single is! Map) {
      throw const FormatException('Unexpected content.');
    }
    final text = parts.single['text'];
    if (text is! String || text.length > 4096) {
      throw const FormatException('Invalid structured response.');
    }
    final value = jsonDecode(text);
    if (value is! Map ||
        value.length != 2 ||
        !value.containsKey('summary') ||
        !value.containsKey('evidenceRefs')) {
      throw const FormatException('Unexpected output fields.');
    }
    final summary = value['summary'];
    final refs = value['evidenceRefs'];
    if (summary is! String ||
        summary.trim().isEmpty ||
        summary.length > 600 ||
        RegExp(r'[\x00-\x08\x0b\x0c\x0e-\x1f]').hasMatch(summary) ||
        refs is! List ||
        refs.isEmpty ||
        refs.length > allowedRefs.length ||
        refs.toSet().length != refs.length ||
        refs.any((ref) => ref is! String || !allowedRefs.contains(ref))) {
      throw const FormatException('Invalid text or fact references.');
    }
    return BriefDraft(
      'generated',
      summary: summary.trim(),
      evidenceRefs: List<String>.unmodifiable(refs.cast<String>()),
    );
  }
}
