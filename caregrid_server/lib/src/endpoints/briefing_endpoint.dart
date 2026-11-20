import 'package:serverpod/serverpod.dart';

import '../ai/briefing_snapshot.dart';
import '../ai/gemini_briefing.dart';
import '../core/access.dart';
import '../core/audit.dart';
import '../core/clock.dart';
import '../generated/protocol.dart';
import '../response/orchestrator.dart';

/// Optional prose assistance. No model output enters the response state machine.
class BriefingEndpoint extends Endpoint {
  BriefingEndpoint({GeminiBriefing? briefing})
    : _briefing = briefing ?? GeminiBriefing.instance;

  final GeminiBriefing _briefing;

  Future<IncidentBrief> generate(Session session, int incidentId) async {
    final actor = await Access.require(session, {UserRole.command});
    final before = await _snapshot(session, incidentId);
    final service = _briefing;
    var result = await service.generate(before);
    final after = await _snapshot(session, incidentId);
    if (before.cacheKey != after.cacheKey) {
      result = const BriefDraft('stale');
    }
    await Audit.log(
      session,
      actor,
      'handoff-brief',
      target: before.incidentCode,
      detail: '${result.status}; ${GeminiBriefing.promptVersion}',
    );
    return IncidentBrief(
      incidentCode: before.incidentCode,
      generatedAt: CampusClock.now(),
      sourceUpdatedAt: before.sourceUpdatedAt,
      status: result.status,
      summary: result.summary,
      evidenceRefs: result.evidenceRefs,
      model: service.config?.model,
      promptVersion: GeminiBriefing.promptVersion,
      notice: switch (result.status) {
        'generated' =>
          'Gemini draft: review every statement against the response record. '
              'Fact references validate identifiers, not factual correctness. '
              'This draft cannot authorize an action.',
        'disabled' =>
          'Gemini is not enabled. Use the recorded evidence and response timeline.',
        'busy' || 'cooldown' =>
          'Briefing is busy. Continue response actions; request a draft later.',
        'stale' =>
          'The response record changed. This draft was discarded; refresh before requesting another.',
        _ =>
          'Gemini briefing is unavailable. Use the recorded evidence and response timeline.',
      },
    );
  }

  static Future<BriefingSnapshot> _snapshot(Session session, int id) async =>
      BriefingSnapshot.fromRecords(
        await Orchestrator.load(session, id),
        await Orchestrator.dispatchesOf(session, id),
      );
}
