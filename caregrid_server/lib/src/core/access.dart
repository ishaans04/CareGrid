import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// The signed-in user behind a call.
class Actor {
  Actor(this.user);

  final AppUser user;

  int get id => user.id!;
  String get name => user.displayName;
  UserRole get role => user.role;

  /// Label used in timelines and the audit log, e.g. 'Riya Menon (command)'.
  String get label => '${user.displayName} (${user.role.name})';
}

/// Role checks shared by every endpoint. Scopes carry the role name, set by
/// the authentication handler in server.dart.
class Access {
  Access._();

  /// Scope granted to every token of a user with [role].
  static Scope scopeFor(UserRole role) => Scope('role:${role.name}');

  /// Loads the caller and checks they hold one of [roles]. Throws a typed
  /// [CareGridException] the app can show.
  static Future<Actor> require(
    Session session,
    Set<UserRole> roles,
  ) async {
    final auth = session.authenticated;
    if (auth == null) {
      throw CareGridException(message: 'Sign in first.', code: 'forbidden');
    }
    final userId = int.tryParse(auth.userIdentifier);
    final user = userId == null
        ? null
        : await AppUser.db.findById(session, userId);
    if (user == null) {
      throw CareGridException(message: 'Unknown user.', code: 'forbidden');
    }
    if (roles.isNotEmpty && !roles.contains(user.role)) {
      throw CareGridException(
        message:
            'The ${user.role.label} role cannot do this. '
            'Allowed: ${roles.map((r) => r.label).join(', ')}.',
        code: 'forbidden',
      );
    }
    return Actor(user);
  }

  /// Any signed-in role.
  static Future<Actor> any(Session session) =>
      require(session, UserRole.values.toSet());
}

CareGridException notFound(String what) =>
    CareGridException(message: '$what not found.', code: 'notFound');

CareGridException invalidState(String message) =>
    CareGridException(message: message, code: 'invalidState');

CareGridException badRequest(String message) =>
    CareGridException(message: message, code: 'badRequest');
