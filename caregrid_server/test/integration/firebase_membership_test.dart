import 'package:caregrid_server/src/core/access.dart';
import 'package:caregrid_server/src/generated/protocol.dart';
import 'package:caregrid_server/src/identity/firebase_authenticator.dart';
import 'package:caregrid_server/src/identity/bootstrap_membership.dart';
import 'package:caregrid_server/src/identity/firebase_token_verifier.dart';
import 'package:caregrid_server/src/seed/seeder.dart';
import 'package:test/test.dart';

import '../helpers/firebase_fixture.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Verified Firebase identity and SQL membership',
    (sessions, endpoints) {
      late FirebaseAuthenticator authenticator;
      late AppUser user;
      setUp(() async {
        final session = sessions.build();
        await Seeder.seedIfEmpty(session);
        user = (await AppUser.db.findFirstRow(
          session,
          where: (t) => t.handle.equals('cmd.night'),
        ))!;
        user.firebaseUid = null;
        user.tokensValidAfter = null;
        user.disabled = false;
        user = await AppUser.db.updateRow(session, user);
        authenticator = FirebaseAuthenticator(
          FirebaseTokenVerifier(
            projectId: firebaseTestProject,
            client: firebaseTestClient(),
            now: () => firebaseTestNow,
          ),
        );
      });
      tearDown(() => authenticator.verifier.close());

      Future<void> bind() async {
        await BootstrapMembership.execute(sessions.build(), [
          'bind',
          user.handle,
          'firebase-user-1',
        ]);
        user = (await AppUser.db.findById(sessions.build(), user.id!))!;
      }

      test(
        'a valid but unbound Firebase account cannot enrol or choose a role',
        () async {
          final before = await AppUser.db.count(sessions.build());
          expect(
            await authenticator.authenticate(
              sessions.build(),
              firebaseTestToken(),
            ),
            isNull,
          );
          expect(await AppUser.db.count(sessions.build()), before);
        },
      );

      test(
        'SQL role wins over forged role/email claims in a signed token',
        () async {
          await bind();
          final auth = await authenticator.authenticate(
            sessions.build(),
            firebaseTestToken(
              claims: {
                'role': 'admin',
                'email': 'ops.admin@example.test',
                'email_verified': true,
              },
            ),
          );
          expect(auth!.userIdentifier, '${user.id}');
          expect(auth.scopes, {Access.scopeFor(UserRole.command)});
          expect(auth.authId, 'firebase:firebase-user-1');
          expect(user.toJsonForProtocol().keys, isNot(contains('firebaseUid')));
          expect(
            user.toJsonForProtocol().keys,
            isNot(contains('tokensValidAfter')),
          );
        },
      );

      test(
        'disabled membership denies the next request and direct endpoint access',
        () async {
          await bind();
          await BootstrapMembership.execute(sessions.build(), [
            'disable',
            user.handle,
          ]);
          expect(
            await authenticator.authenticate(
              sessions.build(),
              firebaseTestToken(),
            ),
            isNull,
          );
          final disabled = sessions.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              '${user.id}',
              {Access.scopeFor(user.role)},
            ),
          );
          await expectLater(
            endpoints.account.me(disabled),
            throwsA(isA<CareGridException>()),
          );
          await BootstrapMembership.execute(sessions.build(), [
            'enable',
            user.handle,
          ]);
          expect(
            await authenticator.authenticate(
              sessions.build(),
              firebaseTestToken(),
            ),
            isNotNull,
          );
        },
      );

      test(
        'SQL revocation cutoff requires a later Firebase reauthentication',
        () async {
          await bind();
          user.tokensValidAfter = firebaseTestNow.subtract(
            const Duration(seconds: 30),
          );
          await AppUser.db.updateRow(sessions.build(), user);
          expect(
            await authenticator.authenticate(
              sessions.build(),
              firebaseTestToken(),
            ),
            isNull,
          );
          expect(
            await authenticator.authenticate(
              sessions.build(),
              firebaseTestToken(claims: {'auth_time': firebaseTestSeconds - 1}),
            ),
            isNotNull,
          );
        },
      );
      test(
        'bootstrap refuses silent rebinding and records administrative revocation',
        () async {
          await bind();
          await expectLater(
            BootstrapMembership.execute(sessions.build(), [
              'bind',
              user.handle,
              'different-identity',
            ]),
            throwsStateError,
          );
          await BootstrapMembership.execute(sessions.build(), [
            'revoke',
            user.handle,
          ]);
          final updated = (await AppUser.db.findById(
            sessions.build(),
            user.id!,
          ))!;
          expect(updated.tokensValidAfter, isNotNull);
          final record = await AuditRecord.db.findFirstRow(
            sessions.build(),
            where: (t) =>
                t.action.equals('membership-revoke') &
                t.target.equals(user.handle),
          );
          expect(record!.role, 'deployment-operator');
        },
      );

      test(
        'competing bootstrap jobs cannot replace the winning identity binding',
        () async {
          final results = await Future.wait(
            ['competing-identity-a', 'competing-identity-b'].map((uid) async {
              try {
                await BootstrapMembership.execute(sessions.build(), [
                  'bind',
                  user.handle,
                  uid,
                ]);
                return uid;
              } on StateError {
                return null;
              }
            }),
          );
          final winners = results.whereType<String>().toList();
          expect(winners, hasLength(1));
          final updated = (await AppUser.db.findById(
            sessions.build(),
            user.id!,
          ))!;
          expect(updated.firebaseUid, winners.single);
        },
      );

      test(
        'synthetic bootstrap requires an explicit operator opt-in',
        () async {
          await expectLater(
            BootstrapMembership.execute(sessions.build(), ['seed-synthetic']),
            throwsStateError,
          );
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
