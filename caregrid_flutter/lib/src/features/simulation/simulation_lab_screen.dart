import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

import '../../../client.dart';
import '../../core/actions.dart';
import '../../core/format.dart';
import '../../widgets/chips.dart';
import '../../widgets/live_loader.dart';
import '../../widgets/section.dart';

/// Simulation Lab: play seeded emergencies through the real pipeline, with
/// autopilot (simulated operator, crews and hospital) or by hand.
class SimulationLabScreen extends StatefulWidget {
  const SimulationLabScreen({super.key});

  @override
  State<SimulationLabScreen> createState() => _SimulationLabScreenState();
}

class _SimulationLabScreenState extends State<SimulationLabScreen> {
  bool _autopilot = true;

  @override
  Widget build(BuildContext context) {
    return LiveLoader<(SimulationStatus, List<SensorEvent>)>(
      load: () async => (
        await client.simulation.status(),
        await client.signal.recent(25),
      ),
      builder: (context, data, reload) {
        final (status, signals) = data;
        return PageBody(
          children: [
            Card(
              child: SwitchListTile(
                value: _autopilot,
                onChanged: (v) => setState(() => _autopilot = v),
                title: const Text('Autopilot'),
                subtitle: const Text(
                  'On: a simulated operator, crews and hospital act on time so '
                  'the whole loop runs unattended. Off: you act as the operator '
                  'and the crews (sign in as a responder in another window).',
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.cleaning_services_outlined),
                  label: const Text('Stand down all simulation incidents'),
                  onPressed: () => runAction(
                    context,
                    () async {
                      final n = await client.simulation.clear();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$n incident(s) stood down.')),
                        );
                      }
                    },
                  ).then((_) => reload()),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Section(
              title: 'Scenarios',
              child: Column(
                children: [
                  for (final s in status.scenarios)
                    _ScenarioCard(
                      scenario: s,
                      onRun: () => runAction(
                        context,
                        () => client.simulation.start(s.code, _autopilot),
                        success:
                            'Started "${s.title}". Watch the Incidents tab.',
                      ).then((_) => reload()),
                    ),
                ],
              ),
            ),
            Section(
              title: 'Recent runs',
              child: Column(
                children: [
                  for (final r in status.runs)
                    ListTile(
                      dense: true,
                      title: Text(r.title),
                      subtitle: Text(
                        '${r.status} · ${r.stepsEmitted}/${r.stepsTotal} signals · '
                        '${r.autopilot ? 'autopilot' : 'manual'} · ${Fmt.time(r.startedAt)}'
                        '${r.faults.isEmpty ? '' : ' · faults ${r.faults.join(', ')}'}',
                      ),
                      trailing: r.status == 'running'
                          ? TextButton(
                              onPressed: () => runAction(
                                context,
                                () => client.simulation.stop(r.id!),
                              ).then((_) => reload()),
                              child: const Text('Stop'),
                            )
                          : null,
                    ),
                ],
              ),
            ),
            Section(
              title: 'Edge event bus: latest signals',
              child: Column(
                children: [
                  for (final s in signals)
                    ListTile(
                      dense: true,
                      leading: Icon(
                        s.eventType.negative ? Icons.undo : Icons.sensors,
                      ),
                      title: Text(
                        '${s.source.label} · ${s.eventType.label} · ${s.zoneCode}'
                        '${s.cameraCode == null ? '' : ' · ${s.cameraCode}'}'
                        ' (${Fmt.confidence(s.confidence)})',
                      ),
                      subtitle: Text(
                        '${Fmt.time(s.receivedAt)} · ${s.outcome ?? ''}',
                      ),
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

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({required this.scenario, required this.onRun});

  final ScenarioInfo scenario;
  final VoidCallback onRun;

  @override
  Widget build(BuildContext context) {
    final s = scenario;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    s.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Run'),
                  onPressed: onRun,
                ),
              ],
            ),
            Text(s.description),
            const SizedBox(height: 4),
            Text(
              'Expected: ${s.expected}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                Tag(
                  '${s.steps} signal(s) · zone ${s.zoneCode}',
                  color: Colors.blueGrey,
                ),
                for (final d in s.demonstrates) Tag(d, color: Colors.indigo),
                for (final f in s.faults) Tag('Fault: $f', color: Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
