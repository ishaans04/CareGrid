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
import '../../widgets/timeline_view.dart';

/// Incident detail: evidence, agent reasoning, policy, recommended response,
/// Proof-of-Response per unit, victims, timeline and the human actions this
/// viewer is allowed to take. Shared by command, medical and admin; the
/// server redacts per role.
class IncidentDetailScreen extends StatelessWidget {
  const IncidentDetailScreen({super.key, required this.incidentId});

  final int incidentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Incident')),
      body: LiveLoader<IncidentDetail>(
        load: () => client.incident.detail(incidentId),
        builder: (context, d, reload) {
          final i = d.incident;
          return PageBody(
            children: [
              _Header(detail: d),
              _ActionBar(detail: d, reload: reload),
              const SizedBox(height: 12),
              if (d.plan != null && i.dispatchedAt == null)
                _PlanSection(detail: d, plan: d.plan!),
              if (d.dispatches.isNotEmpty)
                Section(
                  title: 'Proof-of-Response',
                  child: Column(
                    children: [
                      for (final dispatch in d.dispatches.reversed)
                        ProofTracker(dispatch: dispatch),
                    ],
                  ),
                ),
              if (d.plan != null &&
                  i.dispatchedAt != null &&
                  d.plan!.warnings.isNotEmpty)
                Section(
                  title: 'Planner warnings',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [for (final w in d.plan!.warnings) Text('• $w')],
                  ),
                ),
              if (d.victims.isNotEmpty)
                Section(
                  title: 'Linked victims (${d.victims.length})',
                  child: Column(
                    children: [
                      for (final v in d.victims)
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.personal_injury_outlined),
                          title: Text('${v.code} · ${v.title}'),
                          subtitle: Text(
                            '${v.eventType.label} · ${v.locationDetail ?? v.zoneName}',
                          ),
                        ),
                    ],
                  ),
                ),
              if (i.reasoning.isNotEmpty)
                Section(
                  title: 'Agent reasoning',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final r in i.reasoning)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• $r'),
                        ),
                    ],
                  ),
                ),
              if (i.negativeEvidence.isNotEmpty)
                Section(
                  title: 'Negative evidence',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final n in i.negativeEvidence) Text('• $n'),
                    ],
                  ),
                ),
              if (d.policy != null) _PolicySection(policy: d.policy!),
              if (d.signals.isNotEmpty)
                Section(
                  title: 'Signals (evidence)',
                  child: Column(
                    children: [
                      for (final s in d.signals)
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.sensors),
                          title: Text(
                            '${s.source.label}: ${s.eventType.label}'
                            '${s.cameraCode == null ? '' : ' on ${s.cameraCode}'}'
                            ' (${Fmt.confidence(s.confidence)})',
                          ),
                          subtitle: Text(
                            '${Fmt.time(s.observedAt)} · ${s.detail ?? ''}'
                            '${s.trackId == null ? '' : ' · track ${s.trackId}'}'
                            '\n${s.outcome ?? ''}',
                          ),
                          isThreeLine: true,
                        ),
                    ],
                  ),
                ),
              Section(
                title: 'Timeline',
                child: TimelineView(entries: d.timeline),
              ),
              if (d.redactions.isNotEmpty)
                Section(
                  title: 'Hidden for your role (${d.viewerRole.label})',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [for (final r in d.redactions) Text('• $r')],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.detail});

  final IncidentDetail detail;

  @override
  Widget build(BuildContext context) {
    final i = detail.incident;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            SeverityTag(i.severity),
            StateTag(i.state),
            EscalationTag(i.escalationLevel),
            ObservabilityTag(i.observability),
            if (i.corroborated) const Tag('Corroborated', color: Colors.green),
            if (i.needsHumanReview)
              const Tag('Human review', color: Colors.purple),
            if (i.hospitalNotified)
              Tag(
                i.hospitalReady ? 'Hospital ready' : 'Hospital pre-alerted',
                color: Colors.red.shade300,
                icon: Icons.local_hospital,
              ),
            if (i.scenarioRunId != null)
              const Tag('Simulation', color: Colors.blueGrey),
          ],
        ),
        const SizedBox(height: 8),
        Text('${i.code} · ${i.title}', style: text.headlineSmall),
        Text(
          '${detail.zoneName} (${detail.zoneType.label})'
          '${i.locationDetail == null ? '' : ' · ${i.locationDetail}'}',
          style: text.titleSmall,
        ),
        const SizedBox(height: 4),
        Text(
          '${i.consequence} · ${i.family.label} · source ${i.source.label} · '
          'confidence ${Fmt.confidence(i.confidence)} · onset ${Fmt.time(i.onsetAt)}'
          '${i.ownerName == null ? '' : ' · owner ${i.ownerName}'}',
        ),
        if (i.nextAction != null) ...[
          const SizedBox(height: 8),
          Text('Next action: ${i.nextAction}', style: text.titleMedium),
        ],
        if (i.state.open && i.nextDeadline != null)
          DeadlineCountdown(
            deadline: i.nextDeadline,
            label: i.nextDeadlineLabel,
          ),
        if (!i.state.open && i.closureNote != null) ...[
          const SizedBox(height: 8),
          Text('${i.state.label}: ${i.closureNote}', style: text.titleMedium),
        ],
        _StageStrip(incident: i),
      ],
    );
  }
}

/// MTTC stage by stage for this incident.
class _StageStrip extends StatelessWidget {
  const _StageStrip({required this.incident});

  final Incident incident;

  @override
  Widget build(BuildContext context) {
    final i = incident;
    String? gap(DateTime? a, DateTime? b) =>
        a == null || b == null ? null : Fmt.seconds(b.difference(a).inSeconds);
    final stages = <(String, String?)>[
      ('Detect', gap(i.onsetAt, i.detectedAt)),
      ('Verify', gap(i.detectedAt, i.verifiedAt)),
      ('Dispatch', gap(i.verifiedAt, i.dispatchedAt)),
      ('Ack', gap(i.dispatchedAt, i.acknowledgedAt)),
      ('Arrive', gap(i.acknowledgedAt, i.onSceneAt)),
      ('Care', gap(i.onSceneAt, i.careAt)),
      ('MTTC', gap(i.onsetAt, i.careAt)),
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final (name, value) in stages)
            Chip(
              visualDensity: VisualDensity.compact,
              label: Text('$name ${value ?? '–'}'),
            ),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.detail, required this.reload});

  final IncidentDetail detail;
  final Future<void> Function() reload;

  @override
  Widget build(BuildContext context) {
    final i = detail.incident;
    final actions = detail.allowedActions;
    if (actions.isEmpty) return const SizedBox.shrink();
    final id = i.id!;

    Future<void> act(Future<void> Function() call, String done) async {
      if (await runAction(context, call, success: done)) await reload();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (actions.contains('confirmDispatch') && i.dispatchedAt == null)
            FilledButton.icon(
              icon: const Icon(Icons.send),
              label: const Text('Confirm & dispatch'),
              onPressed: () => act(
                () => client.incident.confirmDispatch(id, null),
                'Units dispatched.',
              ),
            ),
          if (actions.contains('confirmDispatch'))
            OutlinedButton.icon(
              icon: const Icon(Icons.group_add_outlined),
              label: Text(
                i.dispatchedAt == null ? 'Choose units' : 'Add units',
              ),
              onPressed: () async {
                final codes = await _pickUnits(context, detail);
                if (codes == null || codes.isEmpty) return;
                await act(
                  () => client.incident.confirmDispatch(id, codes),
                  'Dispatched ${codes.join(', ')}.',
                );
              },
            ),
          if (actions.contains('claim'))
            OutlinedButton(
              onPressed: () => act(
                () => client.incident.claim(id),
                'You own this incident.',
              ),
              child: const Text('Take ownership'),
            ),
          if (actions.contains('markReady'))
            FilledButton.icon(
              icon: const Icon(Icons.bed_outlined),
              label: const Text('Ready to receive'),
              onPressed: () => act(
                () => client.care.markReady(id),
                'Hospital marked ready.',
              ),
            ),
          if (actions.contains('escalate'))
            OutlinedButton.icon(
              icon: const Icon(Icons.warning_amber),
              label: const Text('Escalate'),
              onPressed: () async {
                final note = await askText(
                  context,
                  title: 'Escalate ${i.code}',
                  label: 'Why',
                  required: false,
                );
                if (note == null) return;
                await act(
                  () => client.incident.escalate(id, note),
                  'Escalated.',
                );
              },
            ),
          if (actions.contains('note') || actions.contains('careNote'))
            OutlinedButton.icon(
              icon: const Icon(Icons.note_add_outlined),
              label: Text(actions.contains('careNote') ? 'Care note' : 'Note'),
              onPressed: () async {
                final note = await askText(
                  context,
                  title: 'Add note',
                  label: 'Note',
                );
                if (note == null) return;
                await act(
                  () => client.incident.addNote(id, note),
                  'Note added.',
                );
              },
            ),
          if (actions.contains('resolve'))
            FilledButton.icon(
              icon: const Icon(Icons.flag),
              label: const Text('Resolve'),
              onPressed: () async {
                final outcome = await askText(
                  context,
                  title: 'Resolve ${i.code}',
                  label: 'Outcome (what care or action happened)',
                  confirm: 'Resolve',
                );
                if (outcome == null) return;
                await act(
                  () => client.incident.resolve(id, outcome),
                  'Resolved.',
                );
              },
            ),
          if (actions.contains('dismiss'))
            TextButton.icon(
              icon: const Icon(Icons.block),
              label: const Text('Dismiss (false positive)'),
              onPressed: () async {
                final reason = await askText(
                  context,
                  title: 'Dismiss ${i.code}',
                  label: 'Reason (kept for site learning)',
                  confirm: 'Dismiss',
                );
                if (reason == null) return;
                await act(
                  () => client.incident.dismiss(id, reason),
                  'Dismissed.',
                );
              },
            ),
        ],
      ),
    );
  }

  Future<List<String>?> _pickUnits(BuildContext context, IncidentDetail d) {
    final options = [...?d.plan?.options, ...?d.plan?.alternatives];
    final selected = <String>{};
    return showDialog<List<String>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Choose units (operator override)'),
          content: SizedBox(
            width: 480,
            child: options.isEmpty
                ? const Text('No available units can reach this zone.')
                : ListView(
                    shrinkWrap: true,
                    children: [
                      for (final o in options)
                        CheckboxListTile(
                          value: selected.contains(o.responderCode),
                          onChanged: (v) => setState(() {
                            v == true
                                ? selected.add(o.responderCode)
                                : selected.remove(o.responderCode);
                          }),
                          title: Text(
                            '${o.responderName} (${o.responderType.label})',
                          ),
                          subtitle: Text(
                            'ETA ${Fmt.seconds(o.etaSeconds)} · ${o.distanceMeters} m'
                            '${o.withinSla ? '' : ' · misses SLA'}',
                          ),
                        ),
                    ],
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, selected.toList()),
              child: const Text('Dispatch selected'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanSection extends StatelessWidget {
  const _PlanSection({required this.detail, required this.plan});

  final IncidentDetail detail;
  final ResponsePlan plan;

  @override
  Widget build(BuildContext context) {
    return Section(
      title:
          'Recommended response (arrival SLA ${Fmt.seconds(plan.arrivalSlaSeconds)})',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final o in plan.options)
            Card(
              child: ListTile(
                leading: Icon(
                  o.withinSla
                      ? Icons.check_circle_outline
                      : Icons.error_outline,
                  color: o.withinSla ? Colors.green : Colors.red,
                ),
                title: Text(
                  '${o.responderName} · ${o.responderType.label} (${o.role})',
                ),
                subtitle: Text(
                  'ETA ${Fmt.seconds(o.etaSeconds)} · ${o.distanceMeters} m\n'
                  '${o.routeNames.join(' > ')}',
                ),
                isThreeLine: true,
              ),
            ),
          for (final w in plan.warnings)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '⚠ $w',
                style: const TextStyle(color: Colors.deepOrange),
              ),
            ),
        ],
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  const _PolicySection({required this.policy});

  final ZonePolicy policy;

  @override
  Widget build(BuildContext context) {
    final p = policy;
    return Section(
      title: 'Policy ${p.code}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(p.name, style: Theme.of(context).textTheme.titleSmall),
          Text(
            '${p.severity.label} · verify at ${Fmt.confidence(p.minConfidence)}'
            '${p.requireCorroboration ? ' + corroboration' : ''}'
            '${p.autoDispatch ? ' · auto-dispatch' : ' · operator confirms'}\n'
            'SLAs: confirm ${Fmt.seconds(p.verifySlaSeconds)} · ack '
            '${Fmt.seconds(p.ackSlaSeconds)} · arrival ${Fmt.seconds(p.arrivalSlaSeconds)} · '
            'care ${Fmt.seconds(p.careSlaSeconds)}\n'
            'Units: ${p.responderTypes.map((t) => t.label).join(', ')}'
            '${p.fallbackTypes.isEmpty ? '' : ' (fallback: ${p.fallbackTypes.map((t) => t.label).join(', ')})'}',
          ),
          const SizedBox(height: 6),
          for (final (n, step) in p.instructions.indexed)
            Text('${n + 1}. $step'),
        ],
      ),
    );
  }
}
