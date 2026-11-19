import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/serverpod_shared.dart' show ServerpodRole;

import '../generated/protocol.dart';

/// Deployment controls are read on the server, never from a caller's request.
class RuntimePolicy {
  RuntimePolicy(this.runMode, {Map<String, String>? environment})
    : environment = environment ?? Platform.environment;

  final String runMode;
  final Map<String, String> environment;

  bool get isCloudRun =>
      environment.containsKey('K_SERVICE') ||
      environment.containsKey('CLOUD_RUN_JOB');

  bool get demoEnabled =>
      !isCloudRun && {'development', 'test'}.contains(runMode);

  String get processRole =>
      environment['CAREGRID_PROCESS_ROLE'] ?? (demoEnabled ? 'all' : 'api');

  bool get watchdogEnabled => processRole == 'all' || processRole == 'watchdog';

  void validate() {
    if (!{'api', 'watchdog', 'all'}.contains(processRole)) {
      throw StateError('CAREGRID_PROCESS_ROLE must be api, watchdog or all.');
    }
    if (isCloudRun && runMode != 'production') {
      throw StateError('Cloud Run must use the production run mode.');
    }
    if (!demoEnabled && processRole == 'all') {
      throw StateError(
        'Use separate api and watchdog processes in deployment.',
      );
    }
  }

  static RuntimePolicy forSession(Session session) =>
      RuntimePolicy(session.serverpod.config.runMode);

  static void requireDemo(Session session) {
    if (!forSession(session).demoEnabled) {
      throw CareGridException(
        message: 'Demo accounts and simulations are disabled in deployment.',
        code: 'forbidden',
      );
    }
  }

  /// Cloud Run selects the ingress port. Other Serverpod listeners stay private
  /// inside the container and are not exposed by the Cloud Run service.
  static ServerpodConfig configure(
    ServerpodConfig config, {
    Map<String, String>? environment,
  }) {
    final policy = RuntimePolicy(config.runMode, environment: environment);
    policy.validate();
    if (!policy.isCloudRun || config.role == ServerpodRole.maintenance) {
      return config;
    }
    final port = int.tryParse(policy.environment['PORT'] ?? '');
    if (port == null || port < 1 || port > 65535) {
      throw StateError('Cloud Run must supply a valid PORT.');
    }
    final api = config.apiServer;
    return config.copyWith(
      apiServer: ServerConfig(
        port: port,
        publicHost: api.publicHost,
        publicPort: api.publicPort,
        publicScheme: api.publicScheme,
      ),
    );
  }
}
