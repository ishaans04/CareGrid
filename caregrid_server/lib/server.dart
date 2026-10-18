import 'dart:io';

import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';

import 'src/cache_busting.dart';
import 'src/core/access.dart';
import 'src/core/clock.dart';
import 'src/engine/ops_ticker.dart';
import 'src/generated/protocol.dart';
import 'src/generated/serverpod.dart';
import 'src/seed/seeder.dart';
import 'src/simulation/simulation_engine.dart';
import 'src/web/routes/app_config_route.dart';

/// The starting point of the CareGrid server.
void run(List<String> args) async {
  final pod = Serverpod(
    args,
    authenticationHandler: _authenticate,
  );

  // Serve all files in the web/static relative directory under /web.
  pod.webServer.addRoute(
    StaticRoute.withCacheBusting(cacheBustingConfig),
    cacheBustingConfig.mountPrefix,
  );

  // Serve the app config (API URL) to the Flutter web app.
  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/assets/assets/config.json',
  );

  // Serve the Flutter web app at / once it has been built.
  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    pod.webServer.addRoute(
      FlutterRoute(appDir, enableWasmHeaders: false),
      '/',
    );
  } else {
    final defaultRoute = StaticRoute.file(
      File(Uri(path: 'web/pages/build_flutter_app.html').toFilePath()),
    );
    pod.webServer.addMiddleware(
      FallbackMiddleware(
        fallback: defaultRoute,
        on: (response) => response.statusCode == 404,
      ).call,
      '/',
    );
    pod.webServer.addRoute(defaultRoute, '/**');
  }

  // Works with Serverpod Cloud without extra configuration.
  pod.addCloudStorage(
    await ServerpodCloudProvider.private(
      fallback: () => DatabaseCloudStorage('private'),
    ),
  );
  pod.addCloudStorage(
    await ServerpodCloudProvider.public(
      fallback: () => DatabaseCloudStorage('public'),
    ),
  );

  await pod.start();

  // Seed the reference campus on first boot, close scenario runs orphaned by
  // a restart, then start the Proof-of-Response / simulation heartbeat.
  final session = await pod.createSession(enableLogging: false);
  try {
    await Seeder.seedIfEmpty(session);
    await SimulationEngine.closeOrphans(session);
  } finally {
    await session.close();
  }
  OpsTicker.start(pod);
}

/// Validates a CareGrid bearer token and grants the user's role as a scope.
Future<AuthenticationInfo?> _authenticate(Session session, String token) async {
  final row = await AuthToken.db.findFirstRow(
    session,
    where: (t) => t.token.equals(token),
  );
  if (row == null || row.expiresAt.isBefore(CampusClock.now())) return null;
  final user = await AppUser.db.findById(session, row.userId);
  if (user == null) return null;
  return AuthenticationInfo(
    '${user.id}',
    {Access.scopeFor(user.role)},
    authId: token,
  );
}
