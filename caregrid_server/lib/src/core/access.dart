import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// The signed-in user behind a call.
class Actor {
  Actor(this.user);

  final AppUser user;

  int get id => user.id!;
  String get name => user.displayName;
  UserRole get role => user.role;

  /// The campus every query by this actor is scoped to. Campus roles always
  /// have one ([Access.require] refuses a campus role without it); the
  /// network role never does and cannot call campus-scoped operations.
  int get campusId {
    final campus = user.campusId;
    if (campus == null) {
      throw CareGridException(
        message: 'This account is not a member of a campus.',
        code: 'forbidden',
      );
    }
    return campus;
  }

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
  static Future<Actor> require(Session session, Set<UserRole> roles) async {
    final auth = session.authenticated;
    if (auth == null) {
      throw CareGridException(message: 'Sign in first.', code: 'forbidden');
    }
    final userId = int.tryParse(auth.userIdentifier);
    final user = userId == null
        ? null
        : await AppUser.db.findById(session, userId);
    if (user == null || user.disabled) {
      throw CareGridException(message: 'Unknown user.', code: 'forbidden');
    }
    if (user.role != UserRole.network && user.campusId == null) {
      throw CareGridException(
        message: 'This membership has no campus. Contact your administrator.',
        code: 'forbidden',
      );
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

  /// Any signed-in campus role (the network role has no campus records).
  static Future<Actor> any(Session session) => require(
    session,
    UserRole.values.where((r) => r != UserRole.network).toSet(),
  );

  /// Knowing an incident id grants nothing. Another campus's incident is
  /// reported as not found, so its existence is not revealed; a care team
  /// sees only cases shared with it.
  static void requireIncident(Actor actor, Incident incident) {
    if (incident.campusId != actor.campusId) {
      throw notFound('Incident ${incident.id}');
    }
    if (actor.role == UserRole.medical && !incident.hospitalNotified) {
      throw CareGridException(
        message: 'This incident has not been shared with the care team.',
        code: 'forbidden',
      );
    }
  }

  /// Twin records (zones, units, cameras, roads, policies) of another campus
  /// are likewise reported as not found.
  static void requireCampus(Actor actor, int campusId, String what) {
    if (campusId != actor.campusId) throw notFound(what);
  }
}

CareGridException notFound(String what) =>
    CareGridException(message: '$what not found.', code: 'notFound');

CareGridException invalidState(String message) =>
    CareGridException(message: message, code: 'invalidState');

CareGridException badRequest(String message) =>
    CareGridException(message: message, code: 'badRequest');
