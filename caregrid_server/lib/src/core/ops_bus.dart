import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'clock.dart';

/// Live push channel. Every state change posts a minimal [OpsEvent] tagged
/// with its campus; streams deliver only the subscriber's own campus, and
/// clients refetch the role-filtered data they are allowed to see.
class OpsBus {
  OpsBus._();

  static const channel = 'caregrid-ops';

  static Future<void> publish(
    Session session,
    String kind, {
    required int? campusId,
    int? incidentId,
    String? message,
  }) async {
    await session.messages.postMessage(
      channel,
      OpsEvent(
        kind: kind,
        campusId: campusId,
        incidentId: incidentId,
        message: message,
        at: CampusClock.now(),
      ),
    );
  }
}
