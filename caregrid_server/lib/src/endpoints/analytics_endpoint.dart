import 'package:serverpod/serverpod.dart';

import '../analytics/metrics_service.dart';
import '../core/access.dart';
import '../generated/protocol.dart';

/// After-Action Analytics: MTTC stage by stage, RCI, false escalations and
/// blind spots, for leadership and operations.
class AnalyticsEndpoint extends Endpoint {
  Future<OpsMetrics> metrics(Session session) async {
    await Access.require(session, {UserRole.command, UserRole.admin});
    return MetricsService.compute(session);
  }
}
