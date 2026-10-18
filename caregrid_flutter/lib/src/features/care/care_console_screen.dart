import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

import '../../../client.dart';
import '../../core/actions.dart';
import '../../core/format.dart';
import '../../widgets/chips.dart';
import '../../widgets/deadline_countdown.dart';
import '../../widgets/live_loader.dart';
import '../../widgets/section.dart';
import '../command/incident_console_screen.dart';

/// Hospital / Care Console: incoming emergency context, location, ETA and
/// handoff state. Clinicians decide diagnosis and treatment, not CareGrid.
class CareConsoleScreen extends StatelessWidget {
  const CareConsoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LiveLoader<List<CareCase>>(
      load: client.care.cases,
      builder: (context, cases, reload) {
        final open = cases.where((c) => c.state.open).toList();
        final closed = cases.where((c) => !c.state.open).toList();
        return PageBody(
          children: [
            Section(
              title: 'Incoming (${open.length})',
              child: open.isEmpty
                  ? const EmptyState(
                      'No incoming cases.',
                      icon: Icons.local_hospital_outlined,
                    )
                  : Column(
                      children: [
                        for (final c in open) _CaseCard(c: c, reload: reload),
                      ],
                    ),
            ),
            Section(
              title: 'Closed in the last 12 hours',
              child: Column(
                children: [
                  for (final c in closed)
                    ListTile(
                      dense: true,
                      title: Text('${c.code} · ${c.nature}'),
                      subtitle: Text('${c.zoneName} · ${c.handoffState}'),
                      onTap: () =>
                          IncidentConsoleScreen.open(context, c.incidentId),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CaseCard extends StatelessWidget {
  const _CaseCard({required this.c, required this.reload});

  final CareCase c;
  final Future<void> Function() reload;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                SeverityTag(c.severity),
                StateTag(c.state),
                Tag(c.handoffState, color: Colors.teal),
                if (c.hospitalReady)
                  const Tag('Ready to receive', color: Colors.green),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${c.code} · ${c.nature}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${c.zoneName}${c.locationDetail == null ? '' : ' · ${c.locationDetail}'}'
              ' · onset ${Fmt.time(c.onsetAt)} (${Fmt.ago(c.onsetAt)})',
            ),
            if (c.ambulanceCode != null)
              Text('Ambulance ${c.ambulanceCode}: ${c.ambulanceStatus}'),
            if (c.sceneEta != null)
              DeadlineCountdown(
                deadline: c.sceneEta,
                label: 'First unit on scene',
              ),
            if (c.responders.isNotEmpty)
              Text(
                c.responders.join(' · '),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (c.careNotes.isNotEmpty) ...[
              const SizedBox(height: 6),
              for (final n in c.careNotes.reversed.take(3))
                Text('• $n', style: Theme.of(context).textTheme.bodySmall),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                if (!c.hospitalReady)
                  FilledButton.icon(
                    icon: const Icon(Icons.bed_outlined),
                    label: const Text('Ready to receive'),
                    onPressed: () async {
                      if (await runAction(
                        context,
                        () => client.care.markReady(c.incidentId),
                        success: 'Command and units informed.',
                      )) {
                        await reload();
                      }
                    },
                  ),
                OutlinedButton(
                  onPressed: () =>
                      IncidentConsoleScreen.open(context, c.incidentId),
                  child: const Text('Open case'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
