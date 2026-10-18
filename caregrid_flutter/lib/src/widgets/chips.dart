import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

import '../core/format.dart';

/// Small colored label used for severity, state and status.
class Tag extends StatelessWidget {
  const Tag(this.text, {super.key, required this.color, this.icon});

  final String text;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class SeverityTag extends StatelessWidget {
  const SeverityTag(this.severity, {super.key});

  final Severity severity;

  @override
  Widget build(BuildContext context) =>
      Tag(severity.label, color: Palette.severity(severity));
}

class StateTag extends StatelessWidget {
  const StateTag(this.state, {super.key});

  final IncidentState state;

  @override
  Widget build(BuildContext context) =>
      Tag(state.label, color: Palette.state(state));
}

class EscalationTag extends StatelessWidget {
  const EscalationTag(this.level, {super.key});

  final int level;

  @override
  Widget build(BuildContext context) => level == 0
      ? const SizedBox.shrink()
      : Tag('Escalated x$level', color: Colors.red, icon: Icons.priority_high);
}

class ObservabilityTag extends StatelessWidget {
  const ObservabilityTag(this.observability, {super.key});

  final Observability observability;

  @override
  Widget build(BuildContext context) => switch (observability) {
    Observability.full => const SizedBox.shrink(),
    Observability.degraded => Tag(
      observability.label,
      color: Colors.orange,
      icon: Icons.videocam_off_outlined,
    ),
    Observability.blind => Tag(
      observability.label,
      color: Colors.red,
      icon: Icons.visibility_off,
    ),
  };
}
