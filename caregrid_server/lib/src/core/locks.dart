import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Tables whose rows are locked for state transitions. The enum name is the
/// SQL table name, so no caller-supplied text reaches the lock statement.
enum LockedTable { dispatch, responder, incident }

/// Pessimistic row locks for transitions that independent actors race: a
/// responder acknowledging while the watchdog times the offer out, two
/// operators reserving the same ambulance, or a watchdog pass saving an
/// incident that an operator changed a moment earlier.
///
/// The lock is held by a database transaction and released when it commits
/// or rolls back. Work inside [RowLock.on] must use the supplied transaction.
class RowLock {
  RowLock._();

  static Future<R> on<R>(
    Session session,
    LockedTable table,
    int id,
    Future<R> Function(Transaction transaction) body,
  ) => session.db.transaction((transaction) async {
    await session.db.unsafeQuery(
      'SELECT id FROM "${table.name}" WHERE id = @id FOR UPDATE',
      parameters: QueryParameters.named({'id': id}),
      transaction: transaction,
    );
    return body(transaction);
  });

  /// Reads an incident's current revision while holding its row lock.
  static Future<int?> incidentRevision(
    Session session,
    int incidentId,
    Transaction transaction,
  ) async {
    final rows = await session.db.unsafeQuery(
      'SELECT "revision" FROM "incident" WHERE id = @id FOR UPDATE',
      parameters: QueryParameters.named({'id': incidentId}),
      transaction: transaction,
    );
    if (rows.isEmpty) return null;
    return rows.first.first as int;
  }
}

/// Raised when a save starts from an outdated incident revision. Human
/// callers see it as a typed conflict; the watchdog retries on its next pass.
CareGridException staleIncident(String code) => CareGridException(
  message:
      '$code changed while this action was being recorded. Review the latest '
      'record before acting again.',
  code: 'conflict',
);

bool isConflict(Object error) =>
    error is CareGridException && error.code == 'conflict';
