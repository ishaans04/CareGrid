import 'dart:convert';
import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../core/access.dart';
import '../core/audit.dart';
import '../core/clock.dart';
import '../core/runtime_policy.dart';
import '../generated/protocol.dart';
import '../seed/campus_seed.dart';

/// Demo sign-in. Each seeded account represents one role; production would
/// replace this with campus SSO behind the same authentication handler.
class AccountEndpoint extends Endpoint {
  static final _random = Random.secure();

  /// Accounts listed on the sign-in screen, grouped by campus.
  Future<List<DemoAccount>> demoAccounts(Session session) async {
    RuntimePolicy.requireDemo(session);
    final users = await AppUser.db.find(session, orderBy: (t) => t.id);
    final campuses = {
      for (final c in await Campus.db.find(session)) c.id!: c,
    };
    final descriptions = {
      for (final seed in CampusSeeds.all)
        for (final u in seed.users) u.handle: u.description,
      for (final u in CampusSeeds.networkUsers) u.handle: u.description,
    };
    final accounts = [
      for (final u in users)
        DemoAccount(
          handle: u.handle,
          displayName: u.displayName,
          role: u.role,
          title: u.title,
          pinHint: u.pin ?? '',
          description: descriptions[u.handle] ?? u.title,
          campusCode: campuses[u.campusId]?.code ?? 'network',
          campusName: campuses[u.campusId]?.name ?? 'All campuses',
        ),
    ];
    // Group by campus (in campus order, network accounts last) while keeping
    // each campus's accounts in seed order.
    final campusOrder = [for (final c in campuses.values) c.code];
    final seedOrder = {for (final (i, a) in accounts.indexed) a.handle: i};
    int rank(DemoAccount a) {
      final i = campusOrder.indexOf(a.campusCode);
      return i < 0 ? campusOrder.length : i;
    }

    return accounts..sort((x, y) {
      final byCampus = rank(x).compareTo(rank(y));
      return byCampus != 0
          ? byCampus
          : seedOrder[x.handle]!.compareTo(seedOrder[y.handle]!);
    });
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
