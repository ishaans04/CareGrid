import 'dart:async';

import 'package:caregrid_server/src/core/locks.dart';
import 'package:caregrid_server/src/generated/protocol.dart';
import 'package:caregrid_server/src/seed/seeder.dart';
import 'package:serverpod/serverpod.dart' hide Responder;
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Proves the row lock behind unit reservation and dispatch transitions
/// actually serializes two independent database connections. Nothing is
/// written, so parallel test files are unaffected.
void main() {
  withServerpod(
    'Row locks across independent SQL sessions',
    (
      sessionBuilder,
      endpoints,
    ) {
      late Session first;
      late Session second;
      setUp(() async {
        final pod = sessionBuilder.build().serverpod;
        first = await pod.createSession(enableLogging: false);
        second = await pod.createSession(enableLogging: false);
        await Seeder.seedIfEmpty(first);
      });
      tearDown(() async {
        await first.close();
        await second.close();
      });

      test(
        'a second transaction waits until the first releases the unit',
        () async {
          final unit = (await Responder.db.findFirstRow(
            first,
            where: (t) => t.code.equals('AMB-A2'),
          ))!;
          final held = Completer<void>();
          final release = Completer<void>();
          final order = <String>[];

          final holder = RowLock.on(first, LockedTable.responder, unit.id!, (
            _,
          ) async {
            order.add('first acquired');
            held.complete();
            await release.future;
            order.add('first released');
          });
          await held.future;

          final waiter = RowLock.on(second, LockedTable.responder, unit.id!, (
            _,
          ) async {
            order.add('second acquired');
          });
          await Future<void>.delayed(const Duration(milliseconds: 400));
          expect(
            order,
            ['first acquired'],
            reason: 'the competing transaction must block on the row lock',
          );

          release.complete();
          await holder;
          await waiter;
          expect(order, [
            'first acquired',
            'first released',
            'second acquired',
          ]);
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
