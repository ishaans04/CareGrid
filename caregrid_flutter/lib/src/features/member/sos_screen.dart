import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

import '../../../client.dart';
import '../../core/actions.dart';
import '../../core/format.dart';
import '../../widgets/chips.dart';
import '../../widgets/deadline_countdown.dart';
import '../../widgets/live_loader.dart';
import '../../widgets/section.dart';

/// Campus member app: raise an SOS and see closed-loop feedback on it.
class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LiveLoader<List<SosStatus>>(
      load: client.sos.mine,
      builder: (context, mine, reload) => PageBody(
        maxWidth: 640,
        children: [
          SizedBox(
            height: 160,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                shape: const CircleBorder(),
              ),
              onPressed: () async {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const _RaiseSosSheet(),
                );
                await reload();
              },
              child: const Text('SOS', style: TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Press SOS if you or someone near you needs urgent help. '
            'Security and the hospital see your location instantly.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Section(
            title: 'My requests',
            child: mine.isEmpty
                ? const Text('You have not raised any SOS.')
                : Column(
                    children: [
                      for (final s in mine) _SosCard(s: s, reload: reload),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _SosCard extends StatelessWidget {
  const _SosCard({required this.s, required this.reload});

  final SosStatus s;
  final Future<void> Function() reload;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                StateTag(s.state),
                const SizedBox(width: 8),
                Text('${s.code} · ${s.zoneName} · ${Fmt.time(s.raisedAt)}'),
              ],
            ),
            const SizedBox(height: 6),
            Text(s.message, style: Theme.of(context).textTheme.titleMedium),
            for (final r in s.responders) Text(r),
            if (s.sceneEta != null)
              DeadlineCountdown(deadline: s.sceneEta, label: 'Help arrives'),
            if (s.state.open)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    final reason = await askText(
                      context,
                      title: 'Cancel SOS',
                      label: 'Why is help no longer needed?',
                      required: false,
                    );
                    if (reason == null || !context.mounted) return;
                    if (await runAction(
                      context,
                      () => client.sos.cancel(s.incidentId, reason),
                      success:
                          'Sent. If help is already moving, command decides.',
                    )) {
                      await reload();
                    }
                  },
                  child: const Text('I no longer need help'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RaiseSosSheet extends StatefulWidget {
  const _RaiseSosSheet();

  @override
  State<_RaiseSosSheet> createState() => _RaiseSosSheetState();
}

class _RaiseSosSheetState extends State<_RaiseSosSheet> {
  late final Future<CampusTwin> _twin = client.campus.twin();
  String? _zone;
  bool _forSelf = true;
  final _location = TextEditingController();
  final _note = TextEditingController();

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
          final places =
              twin.zones
                  .where(
                    (z) =>
                        z.type != ZoneType.junction &&
                        z.type != ZoneType.outside,
                  )
                  .toList()
                ..sort((a, b) => a.name.compareTo(b.name));
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Where are you?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              DropdownButtonFormField<String>(
                initialValue: _zone,
                decoration: const InputDecoration(
                  labelText: 'Building / place',
                ),
                items: [
                  for (final z in places)
                    DropdownMenuItem(value: z.code, child: Text(z.name)),
                ],
                onChanged: (v) => setState(() => _zone = v),
              ),
              TextField(
                controller: _location,
                decoration: const InputDecoration(
                  labelText: 'Floor / room / landmark',
                ),
              ),
              TextField(
                controller: _note,
                decoration: const InputDecoration(
                  labelText: 'What happened (optional)',
                ),
              ),
              const SizedBox(height: 8),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('I need help')),
                  ButtonSegment(
                    value: false,
                    label: Text('Someone else needs help'),
                  ),
                ],
                selected: {_forSelf},
                onSelectionChanged: (s) => setState(() => _forSelf = s.first),
              ),
              const SizedBox(height: 12),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: _zone == null
                    ? null
                    : () async {
                        final ok = await runAction(
                          context,
                          () => client.sos.raise(
                            _zone!,
                            _location.text.trim().isEmpty
                                ? null
                                : _location.text.trim(),
                            _note.text.trim().isEmpty
                                ? null
                                : _note.text.trim(),
                            _forSelf,
                          ),
                          success: 'SOS sent. Help is being coordinated.',
                        );
                        if (ok && context.mounted) Navigator.pop(context);
                      },
                child: const Text('Send SOS'),
              ),
            ],
          );
        },
      ),
    );
  }
}
