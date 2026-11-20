import 'package:caregrid_server/src/core/runtime_policy.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/serverpod_shared.dart' show ServerpodRole;
import 'package:test/test.dart';

void main() {
  RuntimePolicy policy(String mode, [Map<String, String> env = const {}]) =>
      RuntimePolicy(mode, environment: env);

  test('only local development and test enable demo capabilities', () {
    expect(policy('development').demoEnabled, isTrue);
    expect(policy('test').demoEnabled, isTrue);
    for (final mode in ['production', 'staging', 'custom']) {
      expect(policy(mode).demoEnabled, isFalse);
      expect(policy(mode).watchdogEnabled, isFalse);
    }
    expect(policy('development', {'K_SERVICE': 'api'}).demoEnabled, isFalse);
    expect(policy('test', {'CLOUD_RUN_JOB': 'migrate'}).demoEnabled, isFalse);
  });

  test('deployed worker is explicit and combined role is local only', () {
    expect(
      policy('production', {
        'CAREGRID_PROCESS_ROLE': 'watchdog',
      }).watchdogEnabled,
      isTrue,
    );
    expect(
      () => policy('production', {'CAREGRID_PROCESS_ROLE': 'all'}).validate(),
      throwsStateError,
    );
    expect(
      () => policy('test', {'CAREGRID_PROCESS_ROLE': 'typo'}).validate(),
      throwsStateError,
    );
    expect(
      () => policy('development', {'K_SERVICE': 'api'}).validate(),
      throwsStateError,
    );
  });

  final base = ServerpodConfig(
    runMode: 'production',
    apiServer: ServerConfig(
      port: 8080,
      publicHost: 'caregrid.example.org',
      publicPort: 443,
      publicScheme: 'https',
    ),
  );

  test('Cloud Run ingress follows PORT without changing the public URL', () {
    final config = RuntimePolicy.configure(
      base,
      environment: {'K_SERVICE': 'api', 'PORT': '9090'},
    );
    expect(config.apiServer.port, 9090);
    expect(config.apiServer.publicHost, base.apiServer.publicHost);
    expect(config.apiServer.publicScheme, 'https');
    expect(config.apiServer.publicPort, 443);
    for (final port in ['', 'invalid', '0', '65536']) {
      expect(
        () => RuntimePolicy.configure(
          base,
          environment: {'K_SERVICE': 'api', 'PORT': port},
        ),
        throwsStateError,
      );
    }
  });

  test('Cloud Run migration job does not need a listening port', () {
    final config = RuntimePolicy.configure(
      base.copyWith(role: ServerpodRole.maintenance),
      environment: {'CLOUD_RUN_JOB': 'caregrid-migrate'},
    );
    expect(config.role, ServerpodRole.maintenance);
    expect(config.apiServer.port, 8080);
  });
}
