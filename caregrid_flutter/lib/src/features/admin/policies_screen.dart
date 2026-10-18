import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

import '../../../client.dart';
import '../../core/actions.dart';
import '../../core/format.dart';
import '../../widgets/chips.dart';
import '../../widgets/live_loader.dart';
import '../../widgets/section.dart';

/// Policy (SOP) engine configuration: what counts as an incident in a zone at
/// a time, how sure the agent must be, who responds, and every SLA.
class PoliciesScreen extends StatelessWidget {
  const PoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LiveLoader<List<ZonePolicy>>(
      load: client.admin.policies,
      builder: (context, policies, reload) => PageBody(
        children: [
          const Text(
            'The most specific policy wins: a zone-type match beats a wildcard, '
            'an hour window beats all-day.',
          ),
          const SizedBox(height: 12),
          for (final p in policies)
            Card(
              child: ExpansionTile(
                title: Text('${p.code} · ${p.name}'),
                subtitle: Wrap(
                  spacing: 6,
                  children: [
                    SeverityTag(p.severity),
                    Tag(
                      p.zoneType?.label ?? 'Any zone',
                      color: Colors.blueGrey,
                    ),
                    Tag(p.family.label, color: Colors.indigo),
                    if (p.startHour != null)
                      Tag(
                        '${p.startHour}:00-${p.endHour}:00',
                        color: Colors.teal,
                      ),
                    if (p.autoDispatch)
                      const Tag('Auto-dispatch', color: Colors.red),
                  ],
                ),
                childrenPadding: const EdgeInsets.all(16),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verify at ${Fmt.confidence(p.minConfidence)}'
                    '${p.requireCorroboration ? ' with corroboration' : ''}; '
                    '${p.notifyHospital ? 'hospital pre-alert; ' : ''}'
                    'units ${p.responderTypes.map((t) => t.label).join(', ')}'
                    '${p.fallbackTypes.isEmpty ? '' : ' (fallback ${p.fallbackTypes.map((t) => t.label).join(', ')})'}\n'
                    'SLAs: confirm ${Fmt.seconds(p.verifySlaSeconds)}, ack ${Fmt.seconds(p.ackSlaSeconds)}, '
                    'arrival ${Fmt.seconds(p.arrivalSlaSeconds)}, care ${Fmt.seconds(p.careSlaSeconds)}',
                  ),
                  const SizedBox(height: 8),
                  for (final (n, s) in p.instructions.indexed)
                    Text('${n + 1}. $s'),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit'),
                      onPressed: () async {
                        final updated = await showDialog<ZonePolicy>(
                          context: context,
                          builder: (_) => _PolicyEditor(policy: p),
                        );
                        if (updated == null || !context.mounted) return;
                        await runAction(
                          context,
                          () => client.admin.updatePolicy(updated),
                          success: 'Policy ${p.code} saved.',
                        );
                        await reload();
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PolicyEditor extends StatefulWidget {
  const _PolicyEditor({required this.policy});

  final ZonePolicy policy;

  @override
  State<_PolicyEditor> createState() => _PolicyEditorState();
}

class _PolicyEditorState extends State<_PolicyEditor> {
  late ZonePolicy _p = widget.policy.copyWith();

  Widget _seconds(String label, int value, ZonePolicy Function(int) apply) {
    return TextFormField(
      initialValue: '$value',
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: '$label (seconds)'),
      onChanged: (v) {
        final parsed = int.tryParse(v);
        if (parsed != null && parsed > 0) _p = apply(parsed);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit ${_p.code}'),
      content: SizedBox(
        width: 480,
        child: ListView(
          shrinkWrap: true,
          children: [
            DropdownButtonFormField<Severity>(
              initialValue: _p.severity,
              decoration: const InputDecoration(labelText: 'Severity'),
              items: [
                for (final s in Severity.values)
                  DropdownMenuItem(value: s, child: Text(s.label)),
              ],
              onChanged: (s) => setState(() => _p = _p.copyWith(severity: s)),
            ),
            Text('Minimum confidence ${Fmt.confidence(_p.minConfidence)}'),
            Slider(
              value: _p.minConfidence,
              min: 0.3,
              max: 0.99,
              onChanged: (v) =>
                  setState(() => _p = _p.copyWith(minConfidence: v)),
            ),
            SwitchListTile(
              title: const Text('Require corroboration'),
              value: _p.requireCorroboration,
              onChanged: (v) =>
                  setState(() => _p = _p.copyWith(requireCorroboration: v)),
            ),
            SwitchListTile(
              title: const Text('Auto-dispatch (life-safety only)'),
              value: _p.autoDispatch,
              onChanged: (v) =>
                  setState(() => _p = _p.copyWith(autoDispatch: v)),
            ),
            SwitchListTile(
              title: const Text('Pre-alert hospital'),
              value: _p.notifyHospital,
              onChanged: (v) =>
                  setState(() => _p = _p.copyWith(notifyHospital: v)),
            ),
            _seconds(
              'Operator confirmation SLA',
              _p.verifySlaSeconds,
              (v) => _p.copyWith(verifySlaSeconds: v),
            ),
            _seconds(
              'Acknowledgement SLA',
              _p.ackSlaSeconds,
              (v) => _p.copyWith(ackSlaSeconds: v),
            ),
            _seconds(
              'Arrival SLA (from onset)',
              _p.arrivalSlaSeconds,
              (v) => _p.copyWith(arrivalSlaSeconds: v),
            ),
            _seconds(
              'Care start SLA',
              _p.careSlaSeconds,
              (v) => _p.copyWith(careSlaSeconds: v),
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
          onPressed: () => Navigator.pop(context, _p),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
