import 'package:serverpod/serverpod.dart';

import '../core/clock.dart';
import '../core/ops_bus.dart';
import '../generated/protocol.dart';

/// Real-time push over Serverpod's managed WebSocket.
class LiveEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Emits an [OpsEvent] whenever anything operational changes.
  Stream<OpsEvent> watch(Session session) async* {
    yield OpsEvent(kind: 'hello', at: CampusClock.now());
    yield* session.messages.createStream<OpsEvent>(OpsBus.channel);
  }
}
