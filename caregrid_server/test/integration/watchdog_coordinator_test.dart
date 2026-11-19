import 'dart:async';

import 'package:caregrid_server/src/engine/watchdog_coordinator.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Watchdog ownership across independent SQL sessions', (
    sessionBuilder,
    endpoints,
  ) {
    late Session first;
    late Session second;
    setUp(() async {
      final pod = sessionBuilder.build().serverpod;
      first = await pod.createSession(enableLogging: false);
      second = await pod.createSession(enableLogging: false);
    });
    tearDown(() async {
      await first.close();
      await second.close();
    });

    test(
      'a competing revision skips a pass, then takes over after release',
      () async {
        final entered = Completer<void>();
        final release = Completer<void>();
        final pass = WatchdogCoordinator.runExclusive(first, () async {
          entered.complete();
          await release.future;
        });
        try {
          await entered.future;
          var duplicate = false;
          expect(
            await WatchdogCoordinator.runExclusive(second, () async {
              duplicate = true;
            }),
            isFalse,
          );
          expect(duplicate, isFalse);
        } finally {
          release.complete();
          await pass;
        }
        expect(
          await WatchdogCoordinator.runExclusive(second, () async {}),
          isTrue,
        );
      },
    );

    test('a failed worker releases its ownership for the next pass', () async {
      await expectLater(
        WatchdogCoordinator.runExclusive(
          first,
          () async => throw StateError('test failure'),
        ),
        throwsStateError,
      );
      expect(
        await WatchdogCoordinator.runExclusive(second, () async {}),
        isTrue,
      );
    });
  });
}
