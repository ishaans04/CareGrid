import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'clock.dart';

/// Live push channel. Every state change posts a minimal [OpsEvent]; clients
/// refetch the role-filtered data they are allowed to see.
class OpsBus {
  OpsBus._();

  static const channel = 'caregrid-ops';

  static Future<void> publish(
    Session session,
    String kind, {
    int? incidentId,
    String? message,
  }) async {
    await session.messages.postMessage(
      channel,
      OpsEvent(
        kind: kind,
        incidentId: incidentId,
        message: message,
        at: CampusClock.now(),
      ),
    );
  }
}
