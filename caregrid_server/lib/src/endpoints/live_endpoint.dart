import 'package:serverpod/serverpod.dart';

import '../core/access.dart';
import '../core/clock.dart';
import '../core/ops_bus.dart';
import '../generated/protocol.dart';

/// Real-time push over Serverpod's managed WebSocket.
class LiveEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Emits an [OpsEvent] whenever anything operational changes on the
  /// caller's campus. The network role receives a content-free "something
  /// changed on campus X" signal and refetches its aggregates.
  Stream<OpsEvent> watch(Session session) async* {
    final actor = await Access.require(session, UserRole.values.toSet());
    final campusId = actor.user.campusId;
    yield OpsEvent(kind: 'hello', campusId: campusId, at: CampusClock.now());
    await for (final event in session.messages.createStream<OpsEvent>(
      OpsBus.channel,
    )) {
      if (actor.role == UserRole.network) {
        yield OpsEvent(
          kind: 'campus',
          campusId: event.campusId,
          at: event.at,
        );
      } else if (event.campusId == null || event.campusId == campusId) {
        yield event;
      }
    }
  }
}
