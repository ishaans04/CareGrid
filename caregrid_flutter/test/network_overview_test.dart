import 'package:caregrid_client/caregrid_client.dart';
import 'package:caregrid_flutter/client.dart';
import 'package:caregrid_flutter/src/features/shell/home_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

late NetworkOverview fixtureOverview;

class _NetworkEndpoint extends Fake implements EndpointNetwork {
  @override
  Future<NetworkOverview> overview() async => fixtureOverview;
}

// Any attempt to query campus case endpoints fails the test through Fake.
class _NetworkClient extends Fake implements Client {
  @override
  final EndpointNetwork network = _NetworkEndpoint();
}

CampusPulse _campus() => CampusPulse(
  code: 'fixture',
  name: 'Fixture Campus',
  shortName: 'Fixture',
  fictional: true,
  openIncidents: 2,
  urgentOpen: 1,
  escalatedOpen: 0,
  overdueOpen: 0,
  unitsAvailable: 3,
  unitsTotal: 4,
  camerasDegraded: 1,
  camerasTotal: 6,
  resolved30d: 0,
);

void main() {
  setUpAll(() {
    client = _NetworkClient();
  });

  Future<void> openNetwork(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeShell(
          user: AppUser(
            handle: 'network',
            displayName: 'Network operator',
            role: UserRole.network,
            title: 'Network',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('network role opens aggregates without campus operation routes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1100, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    fixtureOverview = NetworkOverview(
      generatedAt: DateTime.utc(2026, 11, 20),
      campuses: [_campus()],
    );

    await openNetwork(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Fixture Campus'), findsOneWidget);
    expect(find.text('3/4'), findsOneWidget);
    expect(find.text('Not measured'), findsNWidgets(2));
    expect(find.text('Not run'), findsOneWidget);
    expect(find.text('SOS'), findsNothing);
    expect(find.text('Incidents'), findsNothing);
    expect(find.text('Readiness Lab'), findsNothing);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('network role reports an empty campus inventory', (tester) async {
    fixtureOverview = NetworkOverview(
      generatedAt: DateTime.utc(2026, 11, 20),
      campuses: [],
    );

    await openNetwork(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('No campuses available.'), findsOneWidget);
    expect(find.text('0%'), findsNothing);
  });
}
