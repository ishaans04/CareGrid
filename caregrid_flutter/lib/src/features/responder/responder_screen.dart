import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

import '../../../client.dart';
import '../../core/actions.dart';
import '../../core/format.dart';
import '../../widgets/chips.dart';
import '../../widgets/deadline_countdown.dart';
import '../../widgets/live_loader.dart';
import '../../widgets/proof_tracker.dart';
import '../../widgets/section.dart';

/// Responder View: one task, minimum necessary context, and one big button
/// for the next Proof-of-Response step.
class ResponderScreen extends StatelessWidget {
  const ResponderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LiveLoader<ResponderHome>(
      load: client.responder.home,
      builder: (context, home, reload) {
        final r = home.responder;
        final task = home.task;
        return PageBody(
          maxWidth: 700,
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.circle, color: Palette.responder(r.status)),
                title: Text('${r.name} · ${r.type.label}'),
                subtitle: Text(
                  '${r.status.name}${r.statusNote == null ? '' : ' (${r.statusNote})'}'
                  ' · at ${home.zoneName} · ${r.capabilities.join(', ')}',
                ),
                trailing: task == null
                    ? Switch(
                        value: r.status == ResponderStatus.available,
                        onChanged: (v) => runAction(
                          context,
                          () => client.responder.setAvailability(v),
                          success: v ? 'On duty.' : 'Off duty.',
                        ).then((_) => reload()),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            if (task == null)
              const EmptyState(
                'Standing by. New tasks appear here instantly.',
                icon: Icons.notifications_none,
              )
            else
              _TaskView(task: task, reload: reload),
            if (home.recent.isNotEmpty)
              Section(
                title: 'Recent tasks',
                child: Column(
                  children: [
                    for (final d in home.recent)
                      ListTile(
                        dense: true,
                        title: Text(
                          'Incident #${d.incidentId} · ${d.status.label}',
                        ),
                        subtitle: Text(Fmt.dateTime(d.offeredAt)),
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

class _TaskView extends StatelessWidget {
  const _TaskView({required this.task, required this.reload});

  final ResponderTask task;
  final Future<void> Function() reload;

  @override
  Widget build(BuildContext context) {
    final d = task.dispatch;
    final id = d.id!;

    Future<void> act(Future<void> Function() call, String done) async {
      if (await runAction(context, call, success: done)) await reload();
    }

    final (label, icon, call) = switch (d.status) {
      DispatchStatus.offered => (
        'Acknowledge',
        Icons.check,
        () => act(() => client.responder.acknowledge(id), 'Acknowledged.'),
      ),
      DispatchStatus.acknowledged => (
        'Start moving',
        Icons.directions_run,
        () => act(() => client.responder.enRoute(id), 'Route tracking on.'),
      ),
      DispatchStatus.enRoute => (
        'Arrived on scene',
        Icons.place,
        () => act(() => client.responder.arrive(id), 'Arrival recorded.'),
      ),
      DispatchStatus.onScene => (
        'Start care / action',
        Icons.medical_services_outlined,
        () => act(() => client.responder.startCare(id), 'Care started.'),
      ),
      _ => (
        'Complete my task',
        Icons.flag,
        () async {
          final note = await askText(
            context,
            title: 'Complete task',
            label: 'Handover note',
            required: false,
          );
          if (note == null) return;
          await act(
            () => client.responder.complete(id, note),
            'Task completed.',
          );
        },
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 6,
          children: [
            SeverityTag(task.severity),
            Tag(d.status.label, color: Colors.blue),
            if (task.hospitalNotified)
              const Tag('Hospital alerted', color: Colors.red),
          ],
        ),
        const SizedBox(height: 8),
        Text(task.nature, style: Theme.of(context).textTheme.headlineSmall),
        Text(
          '${task.zoneName}${task.locationDetail == null ? '' : ' · ${task.locationDetail}'}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text('Incident ${task.incidentCode}'),
        const SizedBox(height: 12),
        FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
          icon: Icon(icon),
          label: Text(label),
          onPressed: call,
        ),
        if (d.status == DispatchStatus.offered ||
            d.status == DispatchStatus.acknowledged)
          TextButton(
            onPressed: () async {
              final reason = await askText(
                context,
                title: 'Decline task',
                label: 'Reason (another unit is sent)',
              );
              if (reason == null) return;
              await act(
                () => client.responder.decline(id, reason),
                'Declined.',
              );
            },
            child: const Text('Decline'),
          ),
        const SizedBox(height: 12),
        if (d.status == DispatchStatus.offered)
          DeadlineCountdown(deadline: d.ackDeadline, label: 'Acknowledge'),
        Section(
          title: 'Route',
          child: Text(
            task.routeNames.isEmpty ? 'On site' : task.routeNames.join(' > '),
          ),
        ),
        Section(
          title: 'What to do',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (n, step) in task.instructions.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('${n + 1}. $step'),
                ),
            ],
          ),
        ),
        if (task.otherResponders.isNotEmpty)
          Section(
            title: 'Other units',
            child: Text(task.otherResponders.join('\n')),
          ),
        ProofTracker(dispatch: d),
      ],
    );
  }
}
