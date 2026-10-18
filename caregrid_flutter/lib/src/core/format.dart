import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

/// Shared formatting and semantic colors. Visual design is intentionally
/// minimal: these are the hooks a designer replaces.
class Fmt {
  Fmt._();

  static String time(DateTime t) {
    final l = t.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(l.hour)}:${two(l.minute)}:${two(l.second)}';
  }

  static String dateTime(DateTime t) {
    final l = t.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(l.day)}/${two(l.month)} ${two(l.hour)}:${two(l.minute)}';
  }

  static String seconds(num s) {
    final v = s.round().abs();
    if (v < 60) return '${v}s';
    final m = v ~/ 60;
    final r = v % 60;
    if (m < 60) return r == 0 ? '${m}m' : '${m}m ${r}s';
    return '${m ~/ 60}h ${m % 60}m';
  }

  static String ago(DateTime t) {
    final d = DateTime.now().toUtc().difference(t.toUtc());
    if (d.inSeconds < 60) return '${d.inSeconds}s ago';
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }

  static String percent(double? v) =>
      v == null ? 'n/a' : '${v.toStringAsFixed(1)}%';

  static String confidence(double v) => '${(v * 100).round()}%';
}

class Palette {
  Palette._();

  static Color severity(Severity s) => switch (s) {
    Severity.p0 => Colors.red.shade700,
    Severity.p1 => Colors.deepOrange,
    Severity.p2 => Colors.amber.shade800,
    Severity.p3 => Colors.blueGrey,
  };

  static Color state(IncidentState s) => switch (s) {
    IncidentState.detected || IncidentState.review => Colors.purple,
    IncidentState.verified => Colors.indigo,
    IncidentState.dispatched ||
    IncidentState.acknowledged ||
    IncidentState.enRoute => Colors.blue,
    IncidentState.onScene || IncidentState.care => Colors.teal,
    IncidentState.resolved => Colors.green,
    IncidentState.dismissed => Colors.grey,
  };

  static Color responder(ResponderStatus s) => switch (s) {
    ResponderStatus.available => Colors.green,
    ResponderStatus.assigned => Colors.blue,
    ResponderStatus.busy => Colors.orange,
    ResponderStatus.offline => Colors.grey,
  };

  static Color health(AssetHealth h) => switch (h) {
    AssetHealth.online => Colors.green,
    AssetHealth.degraded => Colors.orange,
    AssetHealth.offline => Colors.red,
  };
}
