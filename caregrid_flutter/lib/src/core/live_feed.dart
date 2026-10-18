import 'dart:async';

import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/foundation.dart';

import '../../client.dart';

/// Subscribes to the server's live stream. Screens listen to [revision] and
/// refetch their role-filtered data when it changes. A slow poll covers any
/// gap while the WebSocket reconnects.
class LiveFeed extends ChangeNotifier {
  LiveFeed._();

  static final instance = LiveFeed._();

  int revision = 0;
  bool connected = false;
  OpsEvent? lastEvent;

  StreamSubscription<OpsEvent>? _subscription;
  Timer? _poll;
  Timer? _retry;
  Timer? _debounce;

  void start() {
    stop();
    _connect();
    _poll = Timer.periodic(const Duration(seconds: 10), (_) => _bump());
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
    _poll?.cancel();
    _retry?.cancel();
    _debounce?.cancel();
    connected = false;
  }

  void _connect() {
    _subscription = client.live.watch().listen(
      (event) {
        connected = true;
        lastEvent = event;
        _bump();
      },
      onError: (_) => _disconnected(),
      onDone: _disconnected,
      cancelOnError: true,
    );
  }

  void _disconnected() {
    connected = false;
    notifyListeners();
    _retry?.cancel();
    _retry = Timer(const Duration(seconds: 3), () {
      _subscription?.cancel();
      _connect();
    });
  }

  /// Coalesces bursts of events into one refresh.
  void _bump() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      revision++;
      notifyListeners();
    });
  }
}
