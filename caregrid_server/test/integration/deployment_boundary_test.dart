import 'package:caregrid_server/src/core/access.dart';
import 'package:caregrid_server/src/generated/protocol.dart';
import 'package:caregrid_server/src/seed/seeder.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Deployment boundaries with an existing seeded database',
    (sessionBuilder, endpoints) {
      late TestSessionBuilder admin;
      setUp(() async {
        final session = sessionBuilder.build();
        await Seeder.seedIfEmpty(session);
        final user = await AppUser.db.findFirstRow(
          session,
          where: (t) => t.handle.equals('ops.admin'),
        );
        admin = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            '${user!.id}',
            {Access.scopeFor(user.role)},
          ),
        );
      });

      final forbidden = throwsA(
        isA<CareGridException>().having((e) => e.code, 'code', 'forbidden'),
      );

      test('PIN hints and PIN token issuance remain disabled', () async {
        await expectLater(
          endpoints.account.demoAccounts(sessionBuilder),
          forbidden,
        );
        await expectLater(
          endpoints.account.signIn(sessionBuilder, 'cmd.night', '1111'),
          forbidden,
        );
      });

      test('even a privileged caller cannot run or reset the demo', () async {
        await expectLater(endpoints.simulation.status(admin), forbidden);
        await expectLater(
          endpoints.simulation.start(admin, 'hostel', true),
          forbidden,
        );
        await expectLater(endpoints.simulation.stop(admin, 1), forbidden);
        await expectLater(endpoints.simulation.clear(admin), forbidden);
        await expectLater(endpoints.admin.resetDemo(admin), forbidden);
      });
    },
    configOverride: (config) => config.copyWith(runMode: 'production'),
  );
}
