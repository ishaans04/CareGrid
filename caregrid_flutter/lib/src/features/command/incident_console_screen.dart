import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

import '../../../client.dart';
import '../../core/actions.dart';
import '../../core/format.dart';
import '../../widgets/incident_tile.dart';
import '../../widgets/live_loader.dart';
import '../../widgets/section.dart';
import 'incident_detail_screen.dart';

/// Incident Console: one prioritized queue of owned incidents. No alert queue:
/// every row is an incident with an owner, a state and a next action.
class IncidentConsoleScreen extends StatelessWidget {
  const IncidentConsoleScreen({super.key});

  static void open(BuildContext context, int incidentId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => IncidentDetailScreen(incidentId: incidentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => const ManualSignalSheet(),
        ),
        icon: const Icon(Icons.add_alert_outlined),
        label: const Text('Report signal'),
      ),
      body: LiveLoader<OpsBoard>(
        load: client.incident.board,
        builder: (context, board, _) => PageBody(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                MetricTile(
                  label: 'Open incidents',
                  value: '${board.active.length}',
                  caption: board.campusName,
                ),
                MetricTile(
                  label: 'Escalated',
                  value: '${board.escalatedOpen}',
                  color: board.escalatedOpen > 0 ? Colors.red : null,
                ),
                MetricTile(
                  label: 'Units available',
                  value:
                      '${board.respondersAvailable}/${board.respondersTotal}',
                ),
                MetricTile(
                  label: 'Cameras degraded',
                  value: '${board.camerasDegraded}/${board.camerasTotal}',
                  color: board.camerasDegraded > 0 ? Colors.orange : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Section(
              title: 'Active incidents (most urgent first)',
              child: board.active.isEmpty
                  ? const EmptyState(
                      'No open incidents. Run a scenario from the Simulation '
                      'tab or report a signal.',
                      icon: Icons.check_circle_outline,
                    )
                  : Column(
                      children: [
                        for (final i in board.active)
                          IncidentTile(
                            incident: i,
                            onTap: () => open(context, i.id),
                          ),
                      ],
                    ),
            ),
            Section(
              title: 'Closed in the last 24 hours (${board.recent.length})',
              child: Column(
                children: [
                  for (final i in board.recent)
                    ListTile(
                      dense: true,
                      title: Text('${i.code} · ${i.title}'),
                      subtitle: Text(
                        '${i.state.label} · ${Fmt.dateTime(i.onsetAt)}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => open(context, i.id),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lets an operator inject a signal by hand (radio call, walk-in report),
/// exactly like an edge gateway would.
class ManualSignalSheet extends StatefulWidget {
  const ManualSignalSheet({super.key});

  @override
  State<ManualSignalSheet> createState() => _ManualSignalSheetState();
}

class _ManualSignalSheetState extends State<ManualSignalSheet> {
  late final Future<CampusTwin> _twin = client.campus.twin();
  String? _zone;
  EventType _type = EventType.personDown;
  final _detail = TextEditingController();
  final _location = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: FutureBuilder<CampusTwin>(
        future: _twin,
        builder: (context, snapshot) {
          final twin = snapshot.data;
          if (twin == null) {
            return const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final places = twin.zones
              .where(
                (z) =>
                    z.type != ZoneType.junction && z.type != ZoneType.outside,
              )
              .toList();
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Report a signal',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _zone,
                decoration: const InputDecoration(labelText: 'Zone'),
                items: [
                  for (final z in places)
                    DropdownMenuItem(value: z.code, child: Text(z.name)),
                ],
                onChanged: (v) => setState(() => _zone = v),
              ),
              DropdownButtonFormField<EventType>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Event'),
                items: [
                  for (final t in EventType.values.where((t) => !t.negative))
                    DropdownMenuItem(value: t, child: Text(t.label)),
                ],
                onChanged: (v) => setState(() => _type = v ?? _type),
              ),
              TextField(
                controller: _location,
                decoration: const InputDecoration(
                  labelText: 'Location detail (floor, room, landmark)',
                ),
              ),
              TextField(
                controller: _detail,
                decoration: const InputDecoration(
                  labelText: 'What was reported',
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: _zone == null
                      ? null
                      : () async {
                          final ok = await runAction(
                            context,
                            () => client.signal.ingest(
                              SignalInput(
                                source: SignalSource.operatorReport,
                                eventType: _type,
                                zoneCode: _zone!,
                                confidence: 0.9,
                                detail: _detail.text.trim().isEmpty
                                    ? null
                                    : _detail.text.trim(),
                                locationDetail: _location.text.trim().isEmpty
                                    ? null
                                    : _location.text.trim(),
                              ),
                            ),
                            success: 'Signal sent to the Incident Agent.',
                          );
                          if (ok && context.mounted) Navigator.pop(context);
                        },
                  child: const Text('Send to Incident Agent'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
