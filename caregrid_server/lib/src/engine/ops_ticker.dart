import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../core/runtime_policy.dart';
import '../response/proof_of_response.dart';
import '../simulation/simulation_engine.dart';
import 'watchdog_coordinator.dart';

/// One-second heartbeat that drives the simulator and the Proof-of-Response
/// watchdog. Deployment runs this only in a continuously allocated worker;
/// SQL deadlines survive restarts and a database lock coordinates revisions.
class OpsTicker {
  OpsTicker._();

  static Timer? _timer;
  static Future<void>? _inFlight;

  static void start(Serverpod pod) {
    _timer?.cancel();
    pod.experimental.shutdownTasks.removeTask('caregrid-watchdog');
    pod.experimental.shutdownTasks.addTask('caregrid-watchdog', stop);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick(pod));
    _tick(pod);
  }

  static Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
    await _inFlight;
  }

  static void _tick(Serverpod pod) {
    if (_inFlight != null) return;
    _inFlight = _run(pod).whenComplete(() => _inFlight = null);
  }

  static Future<void> _run(Serverpod pod) async {
    Session? session;
    try {
      session = await pod.createSession(enableLogging: false);
      if (RuntimePolicy(pod.config.runMode).demoEnabled) {
        await SimulationEngine.tick(session);
        await ProofOfResponse.tick(session);
      } else {
        final active = session;
        await WatchdogCoordinator.runExclusive(active, () async {
          await ProofOfResponse.tick(active, includeSimulations: false);
        });
      }
    } catch (e) {
      _reportFailure('watchdog_pass_failed', e);
    } finally {
      try {
        await session?.close();
      } catch (e) {
        _reportFailure('watchdog_cleanup_failed', e);
      }
    }
  }

  static void _reportFailure(String event, Object error) {
    // Cloud Logging recognizes structured JSON. Avoid incident payloads,
    // tokens or database connection strings in error text.
    stderr.writeln(
      jsonEncode({
        'severity': 'ERROR',
        'message': event,
        'errorType': error.runtimeType.toString(),
      }),
    );
  }
}
