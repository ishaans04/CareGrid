import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

import '../../core/app_session.dart';
import '../../core/live_feed.dart';
import '../admin/audit_screen.dart';
import '../admin/policies_screen.dart';
import '../admin/readiness_lab_screen.dart';
import '../admin/twin_admin_screen.dart';
import '../analytics/analytics_screen.dart';
import '../care/care_console_screen.dart';
import '../command/incident_console_screen.dart';
import '../map/live_map_screen.dart';
import '../member/sos_screen.dart';
import '../network/network_overview_screen.dart';
import '../responder/responder_screen.dart';
import '../simulation/simulation_lab_screen.dart';

/// One navigation destination of a role's console.
class _Destination {
  const _Destination(this.label, this.icon, this.builder);

  final String label;
  final IconData icon;
  final WidgetBuilder builder;
}

/// Role-based shell: each role gets only the surfaces its job needs.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.user});

  final AppUser user;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  List<_Destination> get _destinations => switch (widget.user.role) {
    UserRole.network => [
      _Destination(
        'Network overview',
        Icons.hub_outlined,
        (_) => const NetworkOverviewScreen(),
      ),
    ],
    UserRole.command => [
      _Destination(
        'Incidents',
        Icons.space_dashboard_outlined,
        (_) => const IncidentConsoleScreen(),
      ),
      _Destination(
        'Live map',
        Icons.map_outlined,
        (_) => const LiveMapScreen(),
      ),
      _Destination('Twin', Icons.hub_outlined, (_) => const TwinAdminScreen()),
      _Destination(
        'Simulation',
        Icons.science_outlined,
        (_) => const SimulationLabScreen(),
      ),
      _Destination(
        'Analytics',
        Icons.insights_outlined,
        (_) => const AnalyticsScreen(),
      ),
    ],
    UserRole.medical => [
      _Destination(
        'Care console',
        Icons.local_hospital_outlined,
        (_) => const CareConsoleScreen(),
      ),
      _Destination(
        'Live map',
        Icons.map_outlined,
        (_) => const LiveMapScreen(),
      ),
    ],
    UserRole.responder => [
      _Destination(
        'My task',
        Icons.assignment_ind_outlined,
        (_) => const ResponderScreen(),
      ),
      _Destination('Map', Icons.map_outlined, (_) => const LiveMapScreen()),
    ],
    UserRole.admin => [
      _Destination(
        'Readiness',
        Icons.fact_check_outlined,
        (_) => const ReadinessLabScreen(),
      ),
      _Destination('Twin', Icons.hub_outlined, (_) => const TwinAdminScreen()),
      _Destination('Policies', Icons.rule, (_) => const PoliciesScreen()),
      _Destination(
        'Analytics',
        Icons.insights_outlined,
        (_) => const AnalyticsScreen(),
      ),
      _Destination(
        'Audit',
        Icons.receipt_long_outlined,
        (_) => const AuditScreen(),
      ),
    ],
    UserRole.member => [
      _Destination('SOS', Icons.sos_outlined, (_) => const SosScreen()),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final destinations = _destinations;
    final index = _index.clamp(0, destinations.length - 1);
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final body = KeyedSubtree(
      key: ValueKey(index),
      child: destinations[index].builder(context),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('CareGrid · ${destinations[index].label}'),
        actions: [
          const _LiveIndicator(),
          if (MediaQuery.sizeOf(context).width >= 600)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(
                  '${widget.user.displayName} (${widget.user.role.label})',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: AppSession.instance.signOut,
          ),
        ],
      ),
      body: wide && destinations.length > 1
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: index,
                  labelType: NavigationRailLabelType.all,
                  onDestinationSelected: (i) => setState(() => _index = i),
                  destinations: [
                    for (final d in destinations)
                      NavigationRailDestination(
                        icon: Icon(d.icon),
                        label: Text(d.label),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: body),
              ],
            )
          : body,
      bottomNavigationBar: wide || destinations.length < 2
          ? null
          : NavigationBar(
              selectedIndex: index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: [
                for (final d in destinations)
                  NavigationDestination(icon: Icon(d.icon), label: d.label),
              ],
            ),
    );
  }
}

/// Shows whether the live WebSocket feed is connected.
class _LiveIndicator extends StatelessWidget {
  const _LiveIndicator();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LiveFeed.instance,
      builder: (context, _) {
        final on = LiveFeed.instance.connected;
        return Tooltip(
          message: on ? 'Live updates connected' : 'Reconnecting (polling)',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              on ? Icons.wifi_tethering : Icons.wifi_tethering_off,
              color: on ? Colors.green : Colors.orange,
            ),
          ),
        );
      },
    );
  }
}
