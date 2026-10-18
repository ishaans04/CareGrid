import 'dart:async';

import 'package:caregrid_client/caregrid_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

import 'src/core/app_session.dart';

// The server URL comes from `--dart-define=SERVER_URL=...`, then
// assets/config.json (served by the CareGrid server for the web build),
// then http://localhost:8080/. On a physical phone, use your computer's LAN IP.
final serverUrl = getServerUrl();

/// Global client generated from the server's endpoints.
late final Client client;

Future<void> initializeClient() async {
  client = Client(await serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authKeyProvider = TokenKeyProvider();
}
