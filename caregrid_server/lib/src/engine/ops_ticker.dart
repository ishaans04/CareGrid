import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../response/proof_of_response.dart';
import '../simulation/simulation_engine.dart';

/// One-second heartbeat that drives the simulator and the Proof-of-Response
/// watchdog. Single-instance prototype: a multi-instance deployment would
/// move this to a recurring future call guarded by a lock.
class OpsTicker {
  OpsTicker._();

  static Timer? _timer;
  static bool _busy = false;

  static void start(Serverpod pod) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick(pod));
  }

  static void stop() => _timer?.cancel();

  static Future<void> _tick(Serverpod pod) async {
    if (_busy) return;
    _busy = true;
    final session = await pod.createSession(enableLogging: false);
    try {
      await SimulationEngine.tick(session);
      await ProofOfResponse.tick(session);
    } catch (e, st) {
      session.log(
        'Ops tick failed: $e',
        level: LogLevel.error,
        exception: e,
        stackTrace: st,
      );
    } finally {
      await session.close();
      _busy = false;
    }
  }
}
