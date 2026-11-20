import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

import '../../../client.dart';
import '../../core/format.dart';
import '../../widgets/live_loader.dart';
import '../../widgets/section.dart';

/// Read-only cross-campus aggregates; campus case endpoints are not queried.
class NetworkOverviewScreen extends StatelessWidget {
  const NetworkOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LiveLoader<NetworkOverview>(
      load: () => client.network.overview(),
      builder: (context, overview, reload) => PageBody(
        children: [
          Section(
            title: 'Network overview',
            trailing: IconButton(
              tooltip: 'Refresh overview',
              onPressed: reload,
              icon: const Icon(Icons.refresh),
            ),
            child: Text(
              'Counts and timings only. No incident details or dispatch actions.\n'
              'Snapshot: ${Fmt.dateTime(overview.generatedAt)}',
            ),
          ),
          if (overview.campuses.isEmpty)
            const EmptyState('No campuses available.'),
          for (final campus in overview.campuses)
            Section(
              title: campus.name,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    [
                      if (campus.city != null) campus.city!,
                      campus.fictional
                          ? 'Fictional campus'
                          : 'Mapped campus; synthetic operations',
                    ].join(' · '),
                  ),
                  if (campus.attribution != null) Text(campus.attribution!),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      MetricTile(
                        label: 'Open incidents',
                        value: '${campus.openIncidents}',
                      ),
                      MetricTile(
                        label: 'Urgent open',
                        value: '${campus.urgentOpen}',
                      ),
                      MetricTile(
                        label: 'Escalated open',
                        value: '${campus.escalatedOpen}',
                      ),
                      MetricTile(
                        label: 'Overdue open',
                        value: '${campus.overdueOpen}',
                      ),
                      MetricTile(
                        label: 'Units available',
                        value: '${campus.unitsAvailable}/${campus.unitsTotal}',
                      ),
                      MetricTile(
                        label: 'Cameras degraded',
                        value:
                            '${campus.camerasDegraded}/${campus.camerasTotal}',
                      ),
                      MetricTile(
                        label: 'Resolved (30 days)',
                        value: '${campus.resolved30d}',
                      ),
                      MetricTile(
                        label: 'Onset to care (30 days)',
                        value: campus.mttcSeconds == null
                            ? 'Not measured'
                            : Fmt.seconds(campus.mttcSeconds!),
                      ),
                      MetricTile(
                        label: 'Response integrity (30 days)',
                        value: campus.rciPercent == null
                            ? 'Not measured'
                            : Fmt.percent(campus.rciPercent),
                      ),
                      MetricTile(
                        label: 'Readiness',
                        value: campus.readinessPercent == null
                            ? 'Not run'
                            : '${campus.readinessPercent}%',
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
