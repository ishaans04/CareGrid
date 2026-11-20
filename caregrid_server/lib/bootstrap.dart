import 'dart:io';

import 'src/core/runtime_policy.dart';
import 'src/generated/serverpod.dart';
import 'src/identity/bootstrap_membership.dart';

/// Executed in a private Cloud Run job using the same immutable server image.
Future<void> bootstrap(List<String> args) async {
  final pod = Serverpod([
    '--mode=production',
    '--logging=normal',
  ], configOverride: RuntimePolicy.configure);
  await pod.start();
  final session = await pod.createSession(enableLogging: false);
  try {
    await BootstrapMembership.execute(
      session,
      args,
      allowSyntheticSeed:
          Platform.environment['CAREGRID_BOOTSTRAP_SYNTHETIC'] == 'true',
    );
    stdout.writeln(
      'CareGrid deployment command completed. Review its SQL and Cloud Audit records.',
    );
  } finally {
    await session.close();
    await pod.shutdown(exitProcess: false);
  }
}
