import 'dart:io';

/// Campus-local time helpers. Policies are time-aware (a hostel fall at 02:00
/// is treated differently from one at 14:00), so every hour lookup goes
/// through here.
class CampusClock {
  CampusClock._();

  /// Offset of campus local time from UTC. Configure with the
  /// `CAREGRID_UTC_OFFSET_MINUTES` environment variable.
  static final Duration utcOffset = Duration(
    minutes:
        int.tryParse(
          Platform.environment['CAREGRID_UTC_OFFSET_MINUTES'] ?? '',
        ) ??
        330,
  );

  static DateTime now() => DateTime.now().toUtc();

  /// Local hour (0-23) on campus for [utc].
  static int localHour(DateTime utc) => utc.toUtc().add(utcOffset).hour;

  /// True when [hour] falls in the window [start, end), wrapping midnight.
  static bool hourInWindow(int hour, int? start, int? end) {
    if (start == null || end == null) return true;
    if (start == end) return true;
    if (start < end) return hour >= start && hour < end;
    return hour >= start || hour < end;
  }
}

/// Formats a duration as `1m 25s` for timeline text.
String formatSeconds(num seconds) {
  final s = seconds.round();
  if (s < 60) return '${s}s';
  final m = s ~/ 60;
  final rest = s % 60;
  return rest == 0 ? '${m}m' : '${m}m ${rest}s';
}
