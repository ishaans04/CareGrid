import 'dart:convert';
import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../core/access.dart';
import '../core/audit.dart';
import '../core/clock.dart';
import '../core/runtime_policy.dart';
import '../generated/protocol.dart';
import '../seed/seed_data.dart';

/// Demo sign-in. Each seeded account represents one role; production would
/// replace this with campus SSO behind the same authentication handler.
class AccountEndpoint extends Endpoint {
  static final _random = Random.secure();

  /// Accounts listed on the sign-in screen.
  Future<List<DemoAccount>> demoAccounts(Session session) async {
    RuntimePolicy.requireDemo(session);
    final users = await AppUser.db.find(session, orderBy: (t) => t.id);
    final descriptions = {
      for (final (handle, _, _, _, _, _, description) in SeedData.users)
        handle: description,
    };
    return [
      for (final u in users)
        DemoAccount(
          handle: u.handle,
          displayName: u.displayName,
          role: u.role,
          title: u.title,
          pinHint: u.pin ?? '',
          description: descriptions[u.handle] ?? u.title,
        ),
    ];
  }

  Future<SignInResult> signIn(
    Session session,
    String handle,
    String pin,
  ) async {
    RuntimePolicy.requireDemo(session);
    final user = await AppUser.db.findFirstRow(
      session,
      where: (t) => t.handle.equals(handle.trim()),
    );
    if (user == null || user.pin != pin.trim()) {
      throw CareGridException(
        message: 'Unknown handle or wrong PIN.',
        code: 'forbidden',
      );
    }
    final bytes = List<int>.generate(32, (_) => _random.nextInt(256));
    final token = base64Url.encode(bytes).replaceAll('=', '');
    final now = CampusClock.now();
    final expires = now.add(const Duration(days: 7));
    await AuthToken.db.insertRow(
      session,
      AuthToken(
        token: token,
        userId: user.id!,
        createdAt: now,
        expiresAt: expires,
      ),
    );
    await Audit.log(session, Actor(user), 'sign-in');
    return SignInResult(token: token, user: user, expiresAt: expires);
  }

  Future<AppUser> me(Session session) async => (await Access.any(session)).user;

  Future<void> signOut(Session session) async {
    final token = session.authenticated?.authId;
    if (token == null) return;
    await AuthToken.db.deleteWhere(
      session,
      where: (t) => t.token.equals(token),
    );
  }
}
