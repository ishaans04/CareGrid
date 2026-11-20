import 'package:serverpod/serverpod.dart';

import '../core/clock.dart';
import '../generated/protocol.dart';
import '../seed/seeder.dart';

/// Privileged deployment-job commands. This is never registered as an RPC.
class BootstrapMembership {
  BootstrapMembership._();

  static Future<void> execute(
    Session session,
    List<String> args, {
    bool allowSyntheticSeed = false,
  }) async {
    if (args.length == 1 && args.single == 'seed-synthetic') {
      if (!allowSyntheticSeed) {
        throw StateError(
          'Synthetic seeding requires an explicit deployment-job opt-in.',
        );
      }
      await Seeder.seedIfEmpty(session);
      await _audit(session, 'bootstrap-synthetic-campus', null, null);
      return;
    }
    if (args.length < 2 ||
        !{'bind', 'disable', 'enable', 'revoke'}.contains(args.first)) {
      throw ArgumentError(
        'Use seed-synthetic, bind HANDLE FIREBASE_UID, disable HANDLE, enable HANDLE or revoke HANDLE.',
      );
    }
    final command = args.first;
    if (args.length != (command == 'bind' ? 3 : 2)) {
      throw ArgumentError('Invalid command arguments.');
    }
    if (command == 'bind' &&
        (args[2].isEmpty ||
            args[2].length > 128 ||
            args[2].contains(RegExp(r'\s')))) {
      throw ArgumentError(
        'Use the Firebase UID, not an email address or token.',
      );
    }
    await session.db.transaction((transaction) async {
      final user = await AppUser.db.findFirstRow(
        session,
        where: (t) => t.handle.equals(args[1]),
        transaction: transaction,
        lockMode: LockMode.forUpdate,
      );
      if (user == null) {
        throw StateError('The CareGrid membership must already exist.');
      }
      switch (command) {
        case 'bind':
          if (user.firebaseUid != null && user.firebaseUid != args[2]) {
            throw StateError(
              'This membership is already bound to another identity.',
            );
          }
          user.firebaseUid = args[2];
        case 'disable':
          user.disabled = true;
        case 'enable':
          user.disabled = false;
        case 'revoke':
          user.tokensValidAfter = CampusClock.now();
      }
      await AppUser.db.updateRow(session, user, transaction: transaction);
      await _audit(session, 'membership-$command', user.handle, transaction);
    });
  }

  static Future<void> _audit(
    Session session,
    String action,
    String? handle,
    Transaction? transaction,
  ) async {
    await AuditRecord.db.insertRow(
      session,
      AuditRecord(
        at: CampusClock.now(),
        userName: 'Privileged deployment job',
        role: 'deployment-operator',
        action: action,
        target: handle,
      ),
      transaction: transaction,
    );
  }
}
