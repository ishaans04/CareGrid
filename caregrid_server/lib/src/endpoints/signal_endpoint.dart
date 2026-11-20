import 'package:serverpod/serverpod.dart';

import '../agent/incident_agent.dart';
import '../core/access.dart';
import '../core/audit.dart';
import '../generated/protocol.dart';

/// Edge event bus ingress. Edge gateways (or an operator) post normalized
/// signals; the Incident Agent turns them into incidents on the caller's
/// campus. Supplying [SignalInput.eventId] makes retries safe.
class SignalEndpoint extends Endpoint {
  Future<SensorEvent> ingest(Session session, SignalInput input) async {
    final actor = await Access.require(session, {
      UserRole.command,
      UserRole.admin,
    });
    final event = await IncidentAgent.ingest(session, actor.campusId, input);
    await Audit.log(
      session,
      actor,
      'manual-signal',
      target: input.zoneCode,
      detail: input.eventType.label,
    );
    return event;
  }

  /// Most recent signals and what the agent did with each (command only).
  Future<List<SensorEvent>> recent(Session session, int limit) async {
    final actor = await Access.require(session, {UserRole.command});
    return SensorEvent.db.find(
      session,
      where: (t) => t.campusId.equals(actor.campusId),
      orderBy: (t) => t.receivedAt.desc(),
      limit: limit.clamp(1, 200),
    );
  }
}
