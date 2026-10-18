import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

import '../../../client.dart';
import '../../core/format.dart';
import '../../widgets/live_loader.dart';
import '../../widgets/section.dart';

/// After-Action Analytics: MTTC stage by stage, Response Completion
/// Integrity, false escalations and blind spots. Seeded history plus every
/// incident run in this prototype. Numbers are measurements of the prototype,
/// not claims about a real deployment.
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LiveLoader<OpsMetrics>(
      load: client.analytics.metrics,
      builder: (context, m, _) {
        final maxStage = m.stages.isEmpty
            ? 1.0
            : m.stages.map((s) => s.seconds).reduce((a, b) => a > b ? a : b);
        return PageBody(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                MetricTile(
                  label: 'MTTC',
                  value: m.mttcSeconds == null
                      ? 'n/a'
                      : Fmt.seconds(m.mttcSeconds!),
                  caption: 'Mean time to care',
                ),
                MetricTile(
                  label: 'RCI',
                  value: Fmt.percent(m.rciPercent),
                  caption: 'Response completion integrity',
                ),
                MetricTile(
                  label: 'False escalation',
                  value: Fmt.percent(m.falseEscalationPercent),
                  caption: 'Verified, then dismissed',
                ),
                MetricTile(
                  label: 'Blind-spot rate',
                  value: Fmt.percent(m.blindSpotPercent),
                  caption: 'Degraded or no coverage',
                ),
                MetricTile(
                  label: 'Incidents',
                  value: '${m.incidentsTotal}',
                  caption:
                      '${m.resolved} resolved · ${m.dismissed} dismissed · ${m.open} open',
                ),
                MetricTile(
                  label: 'Escalations',
                  value: '${m.escalations}',
                  caption: 'Missed milestones and manual',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Section(
              title: 'MTTC, stage by stage (mean)',
              child: Column(
                children: [
                  for (final s in m.stages)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          SizedBox(width: 130, child: Text(s.label)),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: s.seconds / maxStage,
                              minHeight: 10,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 70,
                            child: Text(Fmt.seconds(s.seconds)),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            _CountSection(
              title: 'Dismissal reasons (site learning)',
              counts: m.dismissReasons,
            ),
            _CountSection(title: 'By event family', counts: m.byFamily),
            _CountSection(title: 'By severity', counts: m.bySeverity),
            _CountSection(
              title: 'By zone (coverage planning)',
              counts: m.byZone,
            ),
          ],
        );
      },
    );
  }
}

class _CountSection extends StatelessWidget {
  const _CountSection({required this.title, required this.counts});

  final String title;
  final Map<String, int> counts;

  @override
  Widget build(BuildContext context) {
    final entries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Section(
      title: title,
      child: entries.isEmpty
          ? const Text('No data yet.')
          : Column(
              children: [
                for (final e in entries)
                  ListTile(
                    dense: true,
                    title: Text(e.key),
                    trailing: Text('${e.value}'),
                  ),
              ],
            ),
    );
  }
}
