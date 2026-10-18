import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

import '../core/format.dart';
import 'chips.dart';
import 'deadline_countdown.dart';

/// One row of the prioritized incident queue.
class IncidentTile extends StatelessWidget {
  const IncidentTile({super.key, required this.incident, this.onTap});

  final IncidentSummary incident;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final i = incident;
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SeverityTag(i.severity),
                  StateTag(i.state),
                  EscalationTag(i.escalationLevel),
                  ObservabilityTag(i.observability),
                  if (i.needsHumanReview)
                    const Tag('Human review', color: Colors.purple),
                  if (i.victimCount > 0)
                    Tag('${i.victimCount} victim(s)', color: Colors.red),
                  if (i.fromScenario)
                    const Tag('Simulation', color: Colors.blueGrey),
                  Text(i.code, style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
              const SizedBox(height: 6),
              Text(i.title, style: Theme.of(context).textTheme.titleMedium),
              Text(
                '${i.zoneName}${i.locationDetail == null ? '' : ' · ${i.locationDetail}'}'
                ' · onset ${Fmt.time(i.onsetAt)} (${Fmt.ago(i.onsetAt)})',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (i.nextAction != null) ...[
                const SizedBox(height: 6),
                Text('Next: ${i.nextAction}'),
              ],
              if (i.responders.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  i.responders.join(' · '),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              if (i.state.open && i.nextDeadline != null) ...[
                const SizedBox(height: 6),
                DeadlineCountdown(
                  deadline: i.nextDeadline,
                  label: i.nextDeadlineLabel,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
