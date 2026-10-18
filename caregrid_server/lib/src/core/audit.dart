import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'access.dart';
import 'clock.dart';

/// Writes the access and action audit log: who saw what, who dispatched,
/// who overrode the AI, and when.
class Audit {
  Audit._();

  static Future<void> log(
    Session session,
    Actor? actor,
    String action, {
    String? target,
    String? detail,
  }) async {
    await AuditRecord.db.insertRow(
      session,
      AuditRecord(
        at: CampusClock.now(),
        userId: actor?.id,
        userName: actor?.name ?? 'CareGrid system',
        role: actor?.role.name ?? 'system',
        action: action,
        target: target,
        detail: detail,
      ),
    );
  }
}
