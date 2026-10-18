import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

import '../../../client.dart';
import '../../core/actions.dart';
import '../../core/app_session.dart';
import '../../core/format.dart';
import '../../widgets/chips.dart';
import '../../widgets/live_loader.dart';
import '../../widgets/section.dart';

/// Readiness Lab: the Stress-Test Engine rehearses compound failures on the
/// digital twin before a real emergency, reports findings, and proposes fixes
/// that can be applied to the live twin.
class ReadinessLabScreen extends StatefulWidget {
  const ReadinessLabScreen({super.key});

  @override
  State<ReadinessLabScreen> createState() => _ReadinessLabScreenState();
}

class _ReadinessLabScreenState extends State<ReadinessLabScreen> {
  ReadinessSummary? _summary;
  final Map<String, StressTestRun> _latest = {};

  bool get _isAdmin => AppSession.instance.user?.role == UserRole.admin;

  Future<void> _runAll() async {
    await runAction(context, () async {
      final summary = await client.readiness.runAll();
      setState(() {
        _summary = summary;
        for (final r in summary.runs) {
          _latest[r.scenarioCode] = r;
        }
      });
    });
  }

  Future<void> _run(String code) async {
    await runAction(context, () async {
      final run = await client.readiness.run(code);
      setState(() => _latest[code] = run);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LiveLoader<(List<StressScenario>, List<StressTestRun>)>(
      load: () async => (
        await client.readiness.scenarios(),
        await client.readiness.history(20),
      ),
      builder: (context, data, reload) {
        final (scenarios, history) = data;
        // History is newest first: keep the latest run per scenario.
        for (final run in history) {
          _latest.putIfAbsent(run.scenarioCode, () => run);
        }
        return PageBody(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.fact_check_outlined, size: 36),
                title: Text(
                  _summary == null
                      ? 'Campus readiness: run all rehearsals to score'
                      : 'Campus readiness: ${_summary!.scorePercent}% '
                            '(${_summary!.passed}/${_summary!.total} scenarios pass)',
                ),
                subtitle: const Text(
                  'Each rehearsal predicts detection, verification, dispatch, '
                  'acknowledgement and travel on a private copy of the twin.',
                ),
                trailing: FilledButton(
                  onPressed: _runAll,
                  child: const Text('Run all'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Section(
              title: 'Rehearsals',
              trailing: _isAdmin
                  ? TextButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Custom'),
                      onPressed: () async {
                        final run = await showDialog<StressTestRun>(
                          context: context,
                          builder: (_) => const _CustomScenarioDialog(),
                        );
                        if (run != null) {
                          setState(() => _latest[run.scenarioCode] = run);
                          await reload();
                        }
                      },
                    )
                  : null,
              child: Column(
                children: [
                  for (final s in scenarios)
                    _ScenarioResult(
                      scenario: s,
                      run: _latest[s.code],
                      canApply: _isAdmin,
                      onRun: () => _run(s.code),
                      onApplied: () => _run(s.code),
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

class _ScenarioResult extends StatelessWidget {
  const _ScenarioResult({
    required this.scenario,
    required this.run,
    required this.canApply,
    required this.onRun,
    required this.onApplied,
  });

  final StressScenario scenario;
  final StressTestRun? run;
  final bool canApply;
  final VoidCallback onRun;
  final VoidCallback onApplied;

  @override
  Widget build(BuildContext context) {
    final s = scenario;
    final r = run;
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
                    s.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (r != null)
                  Tag(
                    r.verdict == Verdict.pass ? 'PASS' : 'FAIL',
                    color: r.verdict == Verdict.pass
                        ? Colors.green
                        : Colors.red,
                  ),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: onRun, child: const Text('Run')),
              ],
            ),
            Text(s.description),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                Tag(
                  '${s.eventType.label} · ${s.zoneCode} · '
                  '${s.hour.toString().padLeft(2, '0')}:00',
                  color: Colors.blueGrey,
                ),
                for (final f in s.failures)
                  Tag('${f.kind.label}: ${f.target}', color: Colors.deepOrange),
              ],
            ),
            if (r != null) ...[
              const Divider(),
              Text(
                'Predicted onset-to-arrival ${Fmt.seconds(r.predictedSeconds)} '
                'vs SLA ${Fmt.seconds(r.slaSeconds)} (${r.policyCode ?? 'no policy'})',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Wrap(
                spacing: 6,
                children: [
                  for (final st in r.stages)
                    Chip(
                      visualDensity: VisualDensity.compact,
                      label: Text('${st.label} ${Fmt.seconds(st.seconds)}'),
                    ),
                ],
              ),
              for (final line in r.responderPlan) Text('• $line'),
              if (r.findings.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text('Findings', style: Theme.of(context).textTheme.titleSmall),
                for (final f in r.findings)
                  Text(
                    '• $f',
                    style: const TextStyle(color: Colors.deepOrange),
                  ),
              ],
              if (r.fixes.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text('Fixes', style: Theme.of(context).textTheme.titleSmall),
                for (final fix in r.fixes)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      fix.passesAlone
                          ? Icons.check_circle
                          : Icons.add_circle_outline,
                      color: fix.passesAlone ? Colors.green : null,
                    ),
                    title: Text(fix.title),
                    subtitle: Text(
                      '${fix.detail}${fix.passesAlone ? ' Re-run passes with this fix alone.' : ''}',
                    ),
                    trailing: canApply && fix.applicable
                        ? TextButton(
                            onPressed: () async {
                              final ok = await confirm(
                                context,
                                title: 'Apply to the live twin?',
                                message: fix.detail,
                                action: 'Apply',
                              );
                              if (!ok || !context.mounted) return;
                              String? message;
                              if (await runAction(context, () async {
                                message = await client.readiness.applyFix(
                                  fix.code,
                                );
                              })) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(message ?? 'Applied.'),
                                    ),
                                  );
                                }
                                onApplied();
                              }
                            },
                            child: const Text('Apply'),
                          )
                        : null,
                  ),
              ],
              if (r.verdictAfterFix != null)
                Text(
                  'With fixes: ${r.verdictAfterFix == Verdict.pass ? 'PASS' : 'FAIL'}'
                  '${r.predictedAfterFixSeconds == null ? '' : ' (${Fmt.seconds(r.predictedAfterFixSeconds!)})'}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: r.verdictAfterFix == Verdict.pass
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              Text(
                'Ran ${Fmt.dateTime(r.ranAt)} by ${r.ranBy}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Builds an ad-hoc rehearsal: an emergency plus failures, then runs it.
class _CustomScenarioDialog extends StatefulWidget {
  const _CustomScenarioDialog();

  @override
  State<_CustomScenarioDialog> createState() => _CustomScenarioDialogState();
}

class _CustomScenarioDialogState extends State<_CustomScenarioDialog> {
  late final Future<CampusTwin> _twin = client.campus.twin();
  final _name = TextEditingController(text: 'Custom rehearsal');
  String? _zone;
  EventType _type = EventType.personDown;
  int _hour = 2;
  final List<StressFailure> _failures = [];
  StressFailureKind _kind = StressFailureKind.responderBusy;
  String? _target;

  List<String> _targetsFor(CampusTwin twin) => switch (_kind) {
    StressFailureKind.responderBusy =>
      twin.responders.map((r) => r.code).toList(),
    StressFailureKind.gateClosed =>
      twin.zones
          .where((z) => z.type == ZoneType.gate)
          .map((z) => z.code)
          .toList(),
    StressFailureKind.roadBlocked => twin.roads.map((r) => r.code).toList(),
    _ => twin.cameras.map((c) => c.code).toList(),
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Custom rehearsal'),
      content: SizedBox(
        width: 520,
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
            final targets = _targetsFor(twin);
            return ListView(
              shrinkWrap: true,
              children: [
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                DropdownButtonFormField<String>(
                  initialValue: _zone,
                  decoration: const InputDecoration(labelText: 'Where'),
                  items: [
                    for (final z in twin.zones.where(
                      (z) =>
                          z.type != ZoneType.junction &&
                          z.type != ZoneType.outside,
                    ))
                      DropdownMenuItem(value: z.code, child: Text(z.name)),
                  ],
                  onChanged: (v) => setState(() => _zone = v),
                ),
                DropdownButtonFormField<EventType>(
                  initialValue: _type,
                  decoration: const InputDecoration(labelText: 'Emergency'),
                  items: [
                    for (final t in EventType.values.where((t) => !t.negative))
                      DropdownMenuItem(value: t, child: Text(t.label)),
                  ],
                  onChanged: (v) => setState(() => _type = v ?? _type),
                ),
                Row(
                  children: [
                    const Text('Local hour'),
                    Expanded(
                      child: Slider(
                        value: _hour.toDouble(),
                        min: 0,
                        max: 23,
                        divisions: 23,
                        label: '${_hour.toString().padLeft(2, '0')}:00',
                        onChanged: (v) => setState(() => _hour = v.round()),
                      ),
                    ),
                    Text('${_hour.toString().padLeft(2, '0')}:00'),
                  ],
                ),
                const Divider(),
                Text('Failures', style: Theme.of(context).textTheme.titleSmall),
                for (final f in _failures)
                  ListTile(
                    dense: true,
                    title: Text('${f.kind.label}: ${f.target}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _failures.remove(f)),
                    ),
                  ),
                DropdownButtonFormField<StressFailureKind>(
                  initialValue: _kind,
                  decoration: const InputDecoration(labelText: 'Failure type'),
                  items: [
                    for (final k in StressFailureKind.values)
                      DropdownMenuItem(value: k, child: Text(k.label)),
                  ],
                  onChanged: (v) => setState(() {
                    _kind = v ?? _kind;
                    _target = null;
                  }),
                ),
                DropdownButtonFormField<String>(
                  key: ValueKey(_kind),
                  initialValue: _target,
                  decoration: const InputDecoration(labelText: 'Target'),
                  items: [
                    for (final t in targets)
                      DropdownMenuItem(value: t, child: Text(t)),
                  ],
                  onChanged: (v) => setState(() => _target = v),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add failure'),
                    onPressed: _target == null
                        ? null
                        : () => setState(() {
                            _failures.add(
                              StressFailure(kind: _kind, target: _target!),
                            );
                            _target = null;
                          }),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _zone == null
              ? null
              : () async {
                  StressTestRun? run;
                  final ok = await runAction(context, () async {
                    run = await client.readiness.runCustom(
                      StressScenario(
                        code: 'custom',
                        name: _name.text.trim().isEmpty
                            ? 'Custom rehearsal'
                            : _name.text.trim(),
                        description: 'Built in the Readiness Lab.',
                        zoneCode: _zone!,
                        eventType: _type,
                        hour: _hour,
                        failures: _failures,
                      ),
                    );
                  });
                  if (ok && context.mounted) Navigator.pop(context, run);
                },
          child: const Text('Run rehearsal'),
        ),
      ],
    );
  }
}
