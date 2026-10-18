import 'dart:math' as math;

import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

import '../core/format.dart';

/// Schematic live map of the campus digital twin: roads, zones, gates,
/// open incidents and responder positions. Coordinates come from the twin
/// (1000 x 700 canvas units), so no map tiles or API keys are needed.
class CampusMap extends StatelessWidget {
  const CampusMap({
    super.key,
    required this.twin,
    this.highlightRoute = const [],
    this.onZoneTap,
  });

  final CampusTwin twin;

  /// Zone codes of a route to draw on top (e.g. a responder's route).
  final List<String> highlightRoute;
  final void Function(Zone zone)? onZoneTap;

  static const canvas = Size(1000, 700);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: canvas.width / canvas.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale = constraints.maxWidth / canvas.width;
          return GestureDetector(
            onTapUp: onZoneTap == null
                ? null
                : (details) {
                    final p = details.localPosition / scale;
                    Zone? nearest;
                    var best = 40.0;
                    for (final z in twin.zones) {
                      final d = (Offset(z.x, z.y) - p).distance;
                      if (d < best) {
                        best = d;
                        nearest = z;
                      }
                    }
                    if (nearest != null) onZoneTap!(nearest);
                  },
            child: CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxWidth * 0.7),
              painter: _MapPainter(
                twin: twin,
                scale: scale,
                highlightRoute: highlightRoute,
                textColor: Theme.of(context).colorScheme.onSurface,
                background: Theme.of(context).colorScheme.surfaceContainerLow,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter({
    required this.twin,
    required this.scale,
    required this.highlightRoute,
    required this.textColor,
    required this.background,
  });

  final CampusTwin twin;
  final double scale;
  final List<String> highlightRoute;
  final Color textColor;
  final Color background;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = background);
    canvas.save();
    canvas.scale(scale);
    final zones = {for (final z in twin.zones) z.code: z};
    Offset at(String code) {
      final z = zones[code]!;
      return Offset(z.x, z.y);
    }

    // Roads.
    for (final r in twin.roads) {
      if (!zones.containsKey(r.fromZone) || !zones.containsKey(r.toZone)) {
        continue;
      }
      final paint = Paint()
        ..strokeWidth = r.isOutsideCampus ? 4 : 7
        ..strokeCap = StrokeCap.round
        ..color = switch (r.status) {
          RoadStatus.blocked => Colors.red.shade400,
          RoadStatus.congested => Colors.orange.shade300,
          RoadStatus.open =>
            r.isOutsideCampus ? Colors.grey.shade400 : Colors.blueGrey.shade200,
        };
      canvas.drawLine(at(r.fromZone), at(r.toZone), paint);
    }

    // Highlighted route.
    for (var i = 0; i < highlightRoute.length - 1; i++) {
      if (!zones.containsKey(highlightRoute[i]) ||
          !zones.containsKey(highlightRoute[i + 1])) {
        continue;
      }
      canvas.drawLine(
        at(highlightRoute[i]),
        at(highlightRoute[i + 1]),
        Paint()
          ..strokeWidth = 9
          ..strokeCap = StrokeCap.round
          ..color = Colors.blue.withValues(alpha: 0.7),
      );
    }

    // Incident halos.
    for (final i in twin.activeIncidents) {
      if (!zones.containsKey(i.zoneCode)) continue;
      final color = Palette.severity(i.severity);
      canvas.drawCircle(
        at(i.zoneCode),
        42,
        Paint()..color = color.withValues(alpha: 0.18),
      );
      canvas.drawCircle(
        at(i.zoneCode),
        42,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = color,
      );
    }

    // Zones.
    for (final z in twin.zones) {
      final o = Offset(z.x, z.y);
      switch (z.type) {
        case ZoneType.junction:
          canvas.drawCircle(o, 5, Paint()..color = Colors.blueGrey.shade400);
          continue;
        case ZoneType.gate:
          final passable = z.isOpen || z.emergencyOverride;
          canvas.drawRect(
            Rect.fromCenter(center: o, width: 22, height: 22),
            Paint()
              ..color = z.isOpen
                  ? Colors.green.shade600
                  : passable
                  ? Colors.amber.shade700
                  : Colors.red.shade600,
          );
        case ZoneType.outside:
          canvas.drawCircle(o, 7, Paint()..color = Colors.grey);
        default:
          canvas.drawCircle(o, 18, Paint()..color = _zoneColor(z.type));
      }
      _label(canvas, z.name, o + const Offset(0, 22), 13);
    }

    // Responders (offset around their current zone so they do not overlap).
    final byZone = <String, int>{};
    for (final r in twin.responders) {
      final zoneCode = twin.responderPositions[r.code] ?? r.zoneCode;
      if (!zones.containsKey(zoneCode)) continue;
      final n = byZone[zoneCode] = (byZone[zoneCode] ?? 0) + 1;
      final angle = n * 1.1;
      final o = at(zoneCode) + Offset(math.cos(angle), math.sin(angle)) * 26;
      canvas.drawCircle(o, 8, Paint()..color = Palette.responder(r.status));
      canvas.drawCircle(
        o,
        8,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.white,
      );
      _label(canvas, r.code, o + const Offset(0, -20), 10);
    }
    canvas.restore();
  }

  Color _zoneColor(ZoneType type) => switch (type) {
    ZoneType.hostel => Colors.indigo.shade300,
    ZoneType.hospital => Colors.red.shade300,
    ZoneType.lab => Colors.purple.shade300,
    ZoneType.sports => Colors.green.shade300,
    ZoneType.admin => Colors.brown.shade300,
    _ => Colors.teal.shade300,
  };

  void _label(Canvas canvas, String text, Offset center, double fontSize) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: textColor, fontSize: fontSize),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 160);
    painter.paint(canvas, center - Offset(painter.width / 2, 0));
  }

  @override
  bool shouldRepaint(covariant _MapPainter old) =>
      old.twin != twin || old.highlightRoute != highlightRoute;
}

/// Legend explaining map symbols.
class MapLegend extends StatelessWidget {
  const MapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    Widget item(Color color, String label, {bool square = false}) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: square ? BoxShape.rectangle : BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: [
        item(Colors.green, 'Unit available'),
        item(Colors.blue, 'Unit assigned'),
        item(Colors.orange, 'Unit busy'),
        item(Colors.grey, 'Unit offline'),
        item(Colors.green.shade600, 'Gate open', square: true),
        item(
          Colors.amber.shade700,
          'Gate closed, emergency override',
          square: true,
        ),
        item(Colors.red.shade600, 'Gate closed', square: true),
        item(Colors.red.shade400, 'Road blocked', square: true),
        item(Colors.orange.shade300, 'Road congested', square: true),
      ],
    );
  }
}
