import 'package:serverpod/serverpod.dart';

/// Serializes watchdog passes across Cloud Run revisions using PostgreSQL.
/// The transaction owns the advisory lock and releases it on disconnect/error.
/// Operational queries in [work] use the normal session/pool; this lock does
/// not make incident transitions atomic with concurrent operator commands.
class WatchdogCoordinator {
  WatchdogCoordinator._();

  static Future<bool> runExclusive(
    Session session,
    Future<void> Function() work,
  ) => session.db.transaction((transaction) async {
    // App-specific two-int lock namespace. No request data is interpolated.
    final result = await session.db.unsafeQuery(
      'SELECT pg_try_advisory_xact_lock(1128354380, 1)',
      transaction: transaction,
    );
    if (result.first.first != true) return false;
    await work();
    return true;
  });
}
