import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'access.dart';
import 'clock.dart';

/// Writes the access and action audit log: who saw what, who dispatched,
/// who overrode the AI, and when. Each record belongs to the actor's campus,
/// so one campus's administrators never read another's log.
class Audit {
  Audit._();

  static Future<void> log(
    Session session,
    Actor? actor,
    String action, {
    String? target,
    String? detail,
    int? campusId,
  }) async {
    await AuditRecord.db.insertRow(
      session,
      AuditRecord(
        campusId: campusId ?? actor?.user.campusId,
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
