import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

import '../core/format.dart';
import 'chips.dart';
import 'deadline_countdown.dart';

/// Proof-of-Response for one dispatch: each verified state with its
/// timestamp, route progress, and the next expected milestone.
class ProofTracker extends StatelessWidget {
  const ProofTracker({super.key, required this.dispatch});

  final Dispatch dispatch;

  @override
  Widget build(BuildContext context) {
    final d = dispatch;
    final steps = <(String, DateTime?)>[
      ('Dispatched', d.offeredAt),
      ('Acknowledged', d.acknowledgedAt),
      ('Moving', d.enRouteAt),
      ('On scene', d.onSceneAt),
      ('Care / action', d.careAt),
      ('Completed', d.completedAt),
    ];
    final (deadline, label) = switch (d.status) {
      DispatchStatus.offered => (d.ackDeadline, 'Acknowledge'),
      DispatchStatus.enRoute => (d.arrivalDeadline, 'Arrive'),
      _ => (null, null),
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  d.responderName,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Tag(
                  d.status.label,
                  color: d.status.active ? Colors.blue : Colors.grey,
                ),
                Text(
                  '${d.responderType.label} · ${d.role}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (d.stalled)
                  const Tag('Stalled', color: Colors.red, icon: Icons.warning),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final (name, at) in steps)
                  Chip(
                    visualDensity: VisualDensity.compact,
                    avatar: Icon(
                      at == null
                          ? Icons.radio_button_unchecked
                          : Icons.check_circle,
                      size: 16,
                      color: at == null ? Colors.grey : Colors.green,
                    ),
                    label: Text(at == null ? name : '$name ${Fmt.time(at)}'),
                  ),
              ],
            ),
            if (d.status == DispatchStatus.enRoute) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(value: d.progress),
              const SizedBox(height: 4),
              Text(
                '${(d.progress * 100).round()}% of ${d.distanceMeters} m · '
                'ETA ${Fmt.seconds(d.etaSeconds)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (d.route.isNotEmpty)
              Text(
                'Route: ${d.route.join(' > ')}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (d.arrivalSource != null)
              Text(
                'Arrival verified by ${d.arrivalSource}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (d.note != null)
              Text(
                'Note: ${d.note}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (deadline != null) ...[
              const SizedBox(height: 6),
              DeadlineCountdown(deadline: deadline, label: label),
            ],
          ],
        ),
      ),
    );
  }
}
