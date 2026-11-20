import 'package:serverpod/serverpod.dart';

import '../core/access.dart';
import '../generated/protocol.dart';
import 'firebase_token_verifier.dart';

/// Firebase proves identity. The SQL membership alone grants a CareGrid role.
class FirebaseAuthenticator {
  FirebaseAuthenticator(this.verifier);

  final FirebaseTokenVerifier verifier;

  Future<AuthenticationInfo?> authenticate(
    Session session,
    String token,
  ) async {
    final FirebaseIdentity identity;
    try {
      identity = await verifier.verify(token);
    } on FirebaseTokenException {
      return null;
    }
    final user = await AppUser.db.findFirstRow(
      session,
      where: (t) => t.firebaseUid.equals(identity.uid),
    );
    if (user == null ||
        user.disabled ||
        (user.tokensValidAfter != null &&
            !identity.authenticatedAt.isAfter(user.tokensValidAfter!))) {
      return null;
    }
    return AuthenticationInfo('${user.id}', {
      Access.scopeFor(user.role),
    }, authId: 'firebase:${identity.uid}');
  }
}
