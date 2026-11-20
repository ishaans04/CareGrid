import 'package:serverpod/serverpod.dart';

import '../core/access.dart';
import '../core/audit.dart';
import '../generated/protocol.dart';
import '../response/orchestrator.dart';
import '../storage/gcs_evidence_store.dart';

/// Every operation rechecks SQL membership and command role. Knowing an
/// incident/key/generation grants no access. No bucket URL reaches a client.
class EvidenceEndpoint extends Endpoint {
  EvidenceEndpoint({GcsEvidenceStore? store})
    : _store = store ?? GcsEvidenceStore.instance;
  final GcsEvidenceStore _store;

  Future<(Actor, Incident)> _authorize(Session session, int incidentId) async {
    final actor = await Access.require(session, {UserRole.command});
    return (actor, await Orchestrator.load(session, incidentId));
  }

  Future<EvidencePage> list(
    Session session,
    int incidentId,
    String? pageToken,
  ) async {
    final (actor, incident) = await _authorize(session, incidentId);
    await Audit.log(session, actor, 'evidence-list', target: incident.code);
    return _store.list(incidentId, pageToken: pageToken);
  }

  Future<EvidenceFile> upload(
    Session session,
    int incidentId,
    String mediaType,
    String base64Data,
  ) async {
    final (actor, incident) = await _authorize(session, incidentId);
    // Intent precedes the external mutation; SQL and GCS are not one transaction.
    await Audit.log(
      session,
      actor,
      'evidence-upload-attempt',
      target: incident.code,
    );
    final file = await _store.upload(incidentId, mediaType, base64Data);
    await Audit.log(
      session,
      actor,
      'evidence-uploaded',
      target: incident.code,
      detail:
          '${file.key}; generation=${file.generation}; sha256=${file.sha256}',
    );
    return file;
  }

  Future<EvidenceContent> read(
    Session session,
    int incidentId,
    String key,
    String generation,
  ) async {
    final (actor, incident) = await _authorize(session, incidentId);
    await Audit.log(
      session,
      actor,
      'evidence-read-attempt',
      target: incident.code,
    );
    final content = await _store.read(incidentId, key, generation);
    // Audit must succeed before any bytes are returned to the caller.
    await Audit.log(
      session,
      actor,
      'evidence-read',
      target: incident.code,
      detail:
          '${content.file.key}; generation=${content.file.generation}; sha256=${content.file.sha256}',
    );
    return content;
  }

  Future<void> remove(
    Session session,
    int incidentId,
    String key,
    String generation,
  ) async {
    final (actor, incident) = await _authorize(session, incidentId);
    await Audit.log(
      session,
      actor,
      'evidence-remove-attempt',
      target: incident.code,
    );
    await _store.remove(incidentId, key, generation);
    await Audit.log(
      session,
      actor,
      'evidence-removed',
      target: incident.code,
      detail: '$key; generation=$generation',
    );
  }
}
