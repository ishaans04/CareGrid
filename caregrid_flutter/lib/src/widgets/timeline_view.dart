import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

import '../core/format.dart';

/// The incident's audit timeline: the institutional memory.
class TimelineView extends StatelessWidget {
  const TimelineView({super.key, required this.entries});

  final List<TimelineEntry> entries;

  static IconData iconFor(TimelineKind kind) => switch (kind) {
    TimelineKind.signal => Icons.sensors,
    TimelineKind.agent => Icons.psychology_outlined,
    TimelineKind.policy => Icons.rule,
    TimelineKind.dispatch => Icons.send,
    TimelineKind.responder => Icons.directions_run,
    TimelineKind.proof => Icons.verified_outlined,
    TimelineKind.escalation => Icons.warning_amber,
    TimelineKind.operatorAction => Icons.person_outline,
    TimelineKind.care => Icons.local_hospital_outlined,
    TimelineKind.closure => Icons.flag_outlined,
    TimelineKind.system => Icons.settings,
  };

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const Text('No timeline entries.');
    return Column(
      children: [
        for (final e in entries)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              iconFor(e.kind),
              color: e.kind == TimelineKind.escalation ? Colors.red : null,
            ),
            title: Text(e.message),
            subtitle: Text('${Fmt.time(e.at)} · ${e.actor}'),
          ),
      ],
    );
  }
}
