import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

import '../../../client.dart';
import '../../core/actions.dart';
import '../../core/app_session.dart';
import '../../core/format.dart';
import '../../widgets/live_loader.dart';
import '../../widgets/section.dart';

/// Digital twin control: response units, gates, roads and cameras. Changing
/// state here changes live routing (e.g. blocking a road reroutes units).
class TwinAdminScreen extends StatelessWidget {
  const TwinAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAdmin = AppSession.instance.user?.role == UserRole.admin;
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Units'),
              Tab(text: 'Gates'),
              Tab(text: 'Roads'),
              Tab(text: 'Cameras'),
            ],
          ),
          Expanded(
            child: LiveLoader<CampusTwin>(
              load: client.campus.twin,
              builder: (context, twin, reload) => TabBarView(
                children: [
                  _UnitsTab(twin: twin, reload: reload),
                  _GatesTab(twin: twin, reload: reload),
                  _RoadsTab(twin: twin, reload: reload),
                  _CamerasTab(twin: twin, reload: reload, editable: isAdmin),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _zoneName(CampusTwin twin, String code) =>
    twin.zones.where((z) => z.code == code).firstOrNull?.name ?? code;

class _UnitsTab extends StatelessWidget {
  const _UnitsTab({required this.twin, required this.reload});

  final CampusTwin twin;
  final Future<void> Function() reload;

  @override
  Widget build(BuildContext context) {
    return PageBody(
      children: [
        for (final type in ResponderType.values)
          if (twin.responders.any((r) => r.type == type))
            Section(
              title: type.label,
              child: Column(
                children: [
                  for (final r in twin.responders.where((r) => r.type == type))
                    Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.circle,
                          color: Palette.responder(r.status),
                        ),
                        title: Text('${r.name} (${r.code})'),
                        subtitle: Text(
                          '${r.status.name}${r.statusNote == null ? '' : ': ${r.statusNote}'}'
                          ' · at ${_zoneName(twin, twin.responderPositions[r.code] ?? r.zoneCode)}'
                          ' · base ${_zoneName(twin, r.baseZoneCode)}\n'
                          '${r.speedMetersPerMin} m/min · ready in ${r.mobilizationSeconds}s · '
                          '${r.capabilities.join(', ')} · ${r.contact}',
                        ),
                        isThreeLine: true,
                        trailing: r.status == ResponderStatus.assigned
                            ? const Text('On task')
                            : PopupMenuButton<ResponderStatus>(
                                tooltip: 'Set status',
                                onSelected: (status) async {
                                  String? note;
                                  if (status != ResponderStatus.available) {
                                    note = await askText(
                                      context,
                                      title: 'Status note',
                                      label: 'e.g. Inter-hospital transfer',
                                      required: false,
                                    );
                                    if (note == null) return;
                                  }
                                  if (!context.mounted) return;
                                  await runAction(
                                    context,
                                    () => client.admin.setResponderStatus(
                                      r.code,
                                      status,
                                      note == null || note.isEmpty
                                          ? null
                                          : note,
                                    ),
                                  );
                                  await reload();
                                },
                                itemBuilder: (_) => [
                                  for (final s in [
                                    ResponderStatus.available,
                                    ResponderStatus.busy,
                                    ResponderStatus.offline,
                                  ])
                                    PopupMenuItem(
                                      value: s,
                                      child: Text(s.name),
                                    ),
                                ],
                              ),
                      ),
                    ),
                ],
              ),
            ),
      ],
    );
  }
}

class _GatesTab extends StatelessWidget {
  const _GatesTab({required this.twin, required this.reload});

  final CampusTwin twin;
  final Future<void> Function() reload;

  @override
  Widget build(BuildContext context) {
    final gates = twin.zones.where((z) => z.type == ZoneType.gate).toList();
    return PageBody(
      children: [
        for (final g in gates)
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('${g.name} (${g.code})'),
                  subtitle: Text(g.description ?? ''),
                ),
                SwitchListTile(
                  title: const Text('Open'),
                  value: g.isOpen,
                  onChanged: (v) => runAction(
                    context,
                    () => client.admin.setGate(g.code, v, g.emergencyOverride),
                  ).then((_) => reload()),
                ),
                SwitchListTile(
                  title: const Text('Emergency override pre-authorized'),
                  subtitle: const Text(
                    'Closed gate can be opened remotely for responders',
                  ),
                  value: g.emergencyOverride,
                  onChanged: (v) => runAction(
                    context,
                    () => client.admin.setGate(g.code, g.isOpen, v),
                  ).then((_) => reload()),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _RoadsTab extends StatelessWidget {
  const _RoadsTab({required this.twin, required this.reload});

  final CampusTwin twin;
  final Future<void> Function() reload;

  @override
  Widget build(BuildContext context) {
    return PageBody(
      children: [
        const Text(
          'Block a road while a unit is moving to watch Proof-of-Response '
          'reroute it.',
        ),
        const SizedBox(height: 8),
        for (final r in twin.roads)
          ListTile(
            dense: true,
            title: Text('${r.code} · ${r.name}'),
            subtitle: Text(
              '${_zoneName(twin, r.fromZone)} - ${_zoneName(twin, r.toZone)} · '
              '${r.lengthMeters} m${r.isOutsideCampus ? ' · outside campus' : ''}',
            ),
            trailing: DropdownButton<RoadStatus>(
              value: r.status,
              items: [
                for (final s in RoadStatus.values)
                  DropdownMenuItem(value: s, child: Text(s.name)),
              ],
              onChanged: (s) {
                if (s == null) return;
                runAction(
                  context,
                  () => client.admin.setRoadStatus(r.code, s),
                ).then((_) => reload());
              },
            ),
          ),
      ],
    );
  }
}

class _CamerasTab extends StatelessWidget {
  const _CamerasTab({
    required this.twin,
    required this.reload,
    required this.editable,
  });

  final CampusTwin twin;
  final Future<void> Function() reload;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return PageBody(
      children: [
        const Text(
          'Cameras are sensors. Faces are never processed: edge inference '
          'emits anonymous track events only.',
        ),
        const SizedBox(height: 8),
        for (final c in twin.cameras)
          ListTile(
            dense: true,
            leading: Icon(
              Icons.videocam_outlined,
              color: Palette.health(c.health),
            ),
            title: Text('${c.code} · ${c.label}'),
            subtitle: Text(
              '${_zoneName(twin, c.zoneCode)}'
              '${c.adjacentCameras.isEmpty ? '' : ' · corroborates with ${c.adjacentCameras.join(', ')}'}',
            ),
            trailing: editable
                ? DropdownButton<AssetHealth>(
                    value: c.health,
                    items: [
                      for (final h in AssetHealth.values)
                        DropdownMenuItem(value: h, child: Text(h.name)),
                    ],
                    onChanged: (h) {
                      if (h == null) return;
                      runAction(
                        context,
                        () => client.admin.setCameraHealth(c.code, h),
                      ).then((_) => reload());
                    },
                  )
                : Text(c.health.name),
          ),
      ],
    );
  }
}
