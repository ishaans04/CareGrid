import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

import '../../../client.dart';
import '../../core/actions.dart';
import '../../core/format.dart';
import '../../widgets/live_loader.dart';
import '../../widgets/section.dart';

/// Governance: who saw what, who dispatched, who overrode the AI, and when.
/// Also the demo reset.
class AuditScreen extends StatelessWidget {
  const AuditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LiveLoader<(List<AuditRecord>, List<AppUser>)>(
      load: () async =>
          (await client.admin.auditLog(200), await client.admin.users()),
      builder: (context, data, reload) {
        final (records, users) = data;
        return PageBody(
          children: [
            Section(
              title: 'Demo data',
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Restore the seeded campus twin, policies and incident '
                      'history. Users and this audit log are kept.',
                    ),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Reset demo'),
                    onPressed: () async {
                      final ok = await confirm(
                        context,
                        title: 'Reset demo data?',
                        message:
                            'All incidents, rehearsal results and twin '
                            'changes are replaced by the seed data.',
                        action: 'Reset',
                      );
                      if (!ok || !context.mounted) return;
                      await runAction(
                        context,
                        client.admin.resetDemo,
                        success: 'Demo data restored.',
                      );
                      await reload();
                    },
                  ),
                ],
              ),
            ),
            Section(
              title: 'Users and roles (${users.length})',
              child: Column(
                children: [
                  for (final u in users)
                    ListTile(
                      dense: true,
                      title: Text('${u.displayName} · ${u.role.label}'),
                      subtitle: Text(
                        '${u.handle} · ${u.title}'
                        '${u.responderCode == null ? '' : ' · unit ${u.responderCode}'}',
                      ),
                    ),
                ],
              ),
            ),
            Section(
              title: 'Audit log (latest ${records.length})',
              child: Column(
                children: [
                  for (final r in records)
                    ListTile(
                      dense: true,
                      leading: Text(Fmt.time(r.at)),
                      title: Text(
                        '${r.userName} (${r.role}) · ${r.action}'
                        '${r.target == null ? '' : ' · ${r.target}'}',
                      ),
                      subtitle: r.detail == null ? null : Text(r.detail!),
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
