import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

import '../../../client.dart';
import '../../core/app_session.dart';
import '../../core/format.dart';
import '../../widgets/campus_map.dart';
import '../../widgets/chips.dart';
import '../../widgets/live_loader.dart';
import '../../widgets/section.dart';
import '../command/incident_console_screen.dart';

/// Live campus map: incidents, unit positions, gates and road state.
/// Tap a zone for its cameras, units and incidents.
class LiveMapScreen extends StatelessWidget {
  const LiveMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = AppSession.instance.user?.role;
    final canOpen =
        role == UserRole.command ||
        role == UserRole.medical ||
        role == UserRole.admin;
    return LiveLoader<CampusTwin>(
      load: client.campus.twin,
      builder: (context, twin, _) => PageBody(
        maxWidth: 1300,
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            child: CampusMap(
              twin: twin,
              onZoneTap: (zone) => _showZone(context, twin, zone),
            ),
          ),
          const SizedBox(height: 8),
          const MapLegend(),
          const SizedBox(height: 16),
          Section(
            title: 'On the map now',
            child: twin.activeIncidents.isEmpty
                ? const Text('No open incidents visible to your role.')
                : Column(
                    children: [
                      for (final i in twin.activeIncidents)
                        ListTile(
                          leading: SeverityTag(i.severity),
                          title: Text('${i.code} · ${i.title}'),
                          subtitle: Text('${i.state.label} · ${i.zoneName}'),
                          onTap: canOpen
                              ? () => IncidentConsoleScreen.open(context, i.id)
                              : null,
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _showZone(BuildContext context, CampusTwin twin, Zone zone) {
    final cameras = twin.cameras.where((c) => c.zoneCode == zone.code).toList();
    final units = twin.responders
        .where(
          (r) => (twin.responderPositions[r.code] ?? r.zoneCode) == zone.code,
        )
        .toList();
    final incidents = twin.activeIncidents
        .where((i) => i.zoneCode == zone.code)
        .toList();
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        children: [
          Text(zone.name, style: Theme.of(context).textTheme.titleLarge),
          Text(
            '${zone.type.label} · ${zone.code}'
            '${zone.isRestricted ? ' · restricted' : ''}'
            '${zone.type == ZoneType.gate ? ' · ${zone.isOpen ? 'open' : 'closed'}${zone.emergencyOverride ? ' (emergency override)' : ''}' : ''}',
          ),
          if (zone.description != null) Text(zone.description!),
          const SizedBox(height: 12),
          if (cameras.isNotEmpty) ...[
            Text('Cameras', style: Theme.of(context).textTheme.titleSmall),
            for (final c in cameras)
              ListTile(
                dense: true,
                leading: Icon(
                  Icons.videocam_outlined,
                  color: Palette.health(c.health),
                ),
                title: Text('${c.code} · ${c.label}'),
                subtitle: Text(c.health.name),
              ),
          ],
          if (units.isNotEmpty) ...[
            Text('Units here', style: Theme.of(context).textTheme.titleSmall),
            for (final r in units)
              ListTile(
                dense: true,
                leading: Icon(
                  Icons.circle,
                  color: Palette.responder(r.status),
                  size: 14,
                ),
                title: Text(r.name),
                subtitle: Text('${r.type.label} · ${r.status.name}'),
              ),
          ],
          if (incidents.isNotEmpty) ...[
            Text('Incidents', style: Theme.of(context).textTheme.titleSmall),
            for (final i in incidents) Text('${i.code} · ${i.title}'),
          ],
        ],
      ),
    );
  }
}
