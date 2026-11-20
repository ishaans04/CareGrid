/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:caregrid_server/src/generated/access/app_user.dart'
    as _ix2i9ay5;
import 'package:caregrid_server/src/generated/access/audit_record.dart'
    as _i4l5173s;
import 'package:caregrid_server/src/generated/access/demo_account.dart'
    as _i97xkteh;
import 'package:caregrid_server/src/generated/incidents/sensor_event.dart'
    as _ijtpiixj;
import 'package:caregrid_server/src/generated/readiness/stress_scenario.dart'
    as _ifrvbi5l;
import 'package:caregrid_server/src/generated/readiness/stress_test_run.dart'
    as _i7amlooz;
import 'package:caregrid_server/src/generated/twin/zone_policy.dart'
    as _i6gqfmnl;
import 'package:caregrid_server/src/generated/views/care_case.dart'
    as _i3dtfzqd;
import 'package:caregrid_server/src/generated/views/sos_status.dart'
    as _ivqnwjsb;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'access/app_user.dart' as _iwbuzrtm;
import 'access/audit_record.dart' as _inbrvjr3;
import 'access/auth_token.dart' as _ivq2qjjo;
import 'access/care_grid_exception.dart' as _i4e1ds00;
import 'access/demo_account.dart' as _ikp8ifqs;
import 'access/sign_in_result.dart' as _ii02desn;
import 'enums/asset_health.dart' as _iafup8z9;
import 'enums/dispatch_status.dart' as _i17wqy4s;
import 'enums/event_family.dart' as _idspv1yy;
import 'enums/event_type.dart' as _ieodkyuw;
import 'enums/incident_state.dart' as _i3ox4omb;
import 'enums/observability.dart' as _ijbl1che;
import 'enums/responder_status.dart' as _iito6g4l;
import 'enums/responder_type.dart' as _ibv84qfn;
import 'enums/road_status.dart' as _ig6l8r1a;
import 'enums/severity.dart' as _i0yrjrt4;
import 'enums/signal_source.dart' as _ixf557v3;
import 'enums/stress_failure_kind.dart' as _ijbusfl4;
import 'enums/timeline_kind.dart' as _i430br9d;
import 'enums/user_role.dart' as _iez5w9yk;
import 'enums/verdict.dart' as _iasvrkwu;
import 'enums/zone_type.dart' as _iaz6xvg2;
import 'incidents/incident.dart' as _i4zinos7;
import 'incidents/sensor_event.dart' as _iyiaaekw;
import 'incidents/signal_input.dart' as _igo2svs2;
import 'incidents/timeline_entry.dart' as _i97csrvw;
import 'readiness/readiness_summary.dart' as _ileajsn8;
import 'readiness/stage_estimate.dart' as _itoxh6hp;
import 'readiness/stress_failure.dart' as _i6xikljp;
import 'readiness/stress_fix.dart' as _iwebk8fi;
import 'readiness/stress_scenario.dart' as _ilyjz5ws;
import 'readiness/stress_test_run.dart' as _itadwlnx;
import 'response/dispatch.dart' as _if82mktm;
import 'response/plan_option.dart' as _i4tsze0k;
import 'response/response_plan.dart' as _i83nmjlo;
import 'response/route_plan.dart' as _innnctpn;
import 'simulation/scenario_info.dart' as _iyf1dz2p;
import 'simulation/scenario_run.dart' as _i555kad7;
import 'simulation/simulation_status.dart' as _i216yyh2;
import 'twin/camera.dart' as _iznodk4a;
import 'twin/responder.dart' as _iombuvto;
import 'twin/road_segment.dart' as _iqmbpj37;
import 'twin/zone.dart' as _i5d9qpt0;
import 'twin/zone_policy.dart' as _i0bge9o7;
import 'views/campus_twin.dart' as _iqt6besl;
import 'views/care_case.dart' as _i2egsg9j;
import 'views/evidence_content.dart' as _i8js0qii;
import 'views/evidence_file.dart' as _ijaoliqc;
import 'views/evidence_page.dart' as _ig1wbv10;
import 'views/incident_brief.dart' as _izalsqqh;
import 'views/incident_detail.dart' as _iv8abos3;
import 'views/incident_summary.dart' as _i028ji74;
import 'views/ops_board.dart' as _ifqwjb8e;
import 'views/ops_event.dart' as _iz030ym9;
import 'views/ops_metrics.dart' as _izhon84m;
import 'views/responder_home.dart' as _imjqk5v8;
import 'views/responder_task.dart' as _itb553ix;
import 'views/sos_status.dart' as _iiaeposo;
export 'access/app_user.dart';
export 'access/audit_record.dart';
export 'access/auth_token.dart';
export 'access/care_grid_exception.dart';
export 'access/demo_account.dart';
export 'access/sign_in_result.dart';
export 'enums/asset_health.dart';
export 'enums/dispatch_status.dart';
export 'enums/event_family.dart';
export 'enums/event_type.dart';
export 'enums/incident_state.dart';
export 'enums/observability.dart';
export 'enums/responder_status.dart';
export 'enums/responder_type.dart';
export 'enums/road_status.dart';
export 'enums/severity.dart';
export 'enums/signal_source.dart';
export 'enums/stress_failure_kind.dart';
export 'enums/timeline_kind.dart';
export 'enums/user_role.dart';
export 'enums/verdict.dart';
export 'enums/zone_type.dart';
export 'incidents/incident.dart';
export 'incidents/sensor_event.dart';
export 'incidents/signal_input.dart';
export 'incidents/timeline_entry.dart';
export 'readiness/readiness_summary.dart';
export 'readiness/stage_estimate.dart';
export 'readiness/stress_failure.dart';
export 'readiness/stress_fix.dart';
export 'readiness/stress_scenario.dart';
export 'readiness/stress_test_run.dart';
export 'response/dispatch.dart';
export 'response/plan_option.dart';
export 'response/response_plan.dart';
export 'response/route_plan.dart';
export 'simulation/scenario_info.dart';
export 'simulation/scenario_run.dart';
export 'simulation/simulation_status.dart';
export 'twin/camera.dart';
export 'twin/responder.dart';
export 'twin/road_segment.dart';
export 'twin/zone.dart';
export 'twin/zone_policy.dart';
export 'views/campus_twin.dart';
export 'views/care_case.dart';
export 'views/evidence_content.dart';
export 'views/evidence_file.dart';
export 'views/evidence_page.dart';
export 'views/incident_brief.dart';
export 'views/incident_detail.dart';
export 'views/incident_summary.dart';
export 'views/ops_board.dart';
export 'views/ops_event.dart';
export 'views/ops_metrics.dart';
export 'views/responder_home.dart';
export 'views/responder_task.dart';
export 'views/sos_status.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'app_user',
      dartName: 'AppUser',
      schema: 'public',
      module: 'caregrid',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'handle',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'displayName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:UserRole',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'responderCode',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'pin',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'firebaseUid',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'disabled',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'tokensValidAfter',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'app_user__handle__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'handle',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'app_user_firebase_uid_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'firebaseUid',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'audit_record',
      dartName: 'AuditRecord',
      schema: 'public',
      module: 'caregrid',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'at',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'userName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'action',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'target',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'detail',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'audit_at_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'at',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'auth_token',
      dartName: 'AuthToken',
      schema: 'public',
      module: 'caregrid',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'token',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'expiresAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'auth_token__token__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'token',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'camera',
      dartName: 'Camera',
      schema: 'public',
      module: 'caregrid',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'code',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'zoneCode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'label',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'health',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AssetHealth',
          columnDefault: '\'online\'',
        ),
        _isp.ColumnDefinition(
          name: 'adjacentCameras',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'privacyMasked',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'camera__code__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'code',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'dispatch',
      dartName: 'Dispatch',
      schema: 'public',
      module: 'caregrid',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'incidentId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'responderCode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'responderName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'responderType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ResponderType',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:DispatchStatus',
        ),
        _isp.ColumnDefinition(
          name: 'route',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'distanceMeters',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'etaSeconds',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'offeredAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'ackDeadline',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'acknowledgedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'enRouteAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'arrivalDeadline',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'onSceneAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'careAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'completedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'progress',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'arrivalSource',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'stalled',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'note',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'dispatch_incident_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'incidentId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'incident',
      dartName: 'Incident',
      schema: 'public',
      module: 'caregrid',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'code',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'eventType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:EventType',
        ),
        _isp.ColumnDefinition(
          name: 'family',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:EventFamily',
        ),
        _isp.ColumnDefinition(
          name: 'severity',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:Severity',
        ),
        _isp.ColumnDefinition(
          name: 'state',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:IncidentState',
        ),
        _isp.ColumnDefinition(
          name: 'zoneCode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'locationDetail',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'primaryCameraCode',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'trackId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'source',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:SignalSource',
        ),
        _isp.ColumnDefinition(
          name: 'confidence',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'corroborated',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'observability',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:Observability',
          columnDefault: '\'full\'',
        ),
        _isp.ColumnDefinition(
          name: 'consequence',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'policyCode',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'reasoning',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'negativeEvidence',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'nextAction',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'parentIncidentId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'escalationLevel',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'needsHumanReview',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'ownerName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'hospitalNotified',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'hospitalReady',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'reporterUserId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'scenarioRunId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'contextHour',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'onsetAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'detectedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'verifiedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'dispatchedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'acknowledgedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'enRouteAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'onSceneAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'careAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'resolvedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'dismissedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'closureNote',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'nextDeadline',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'nextDeadlineLabel',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'incident__code__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'code',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'incident_state_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'state',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'incident_zone_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'zoneCode',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'responder',
      dartName: 'Responder',
      schema: 'public',
      module: 'caregrid',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'code',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'type',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ResponderType',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ResponderStatus',
          columnDefault: '\'available\'',
        ),
        _isp.ColumnDefinition(
          name: 'zoneCode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'baseZoneCode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'speedMetersPerMin',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'mobilizationSeconds',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'capabilities',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'contact',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'activeDispatchId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'statusNote',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'responder__code__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'code',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'road_segment',
      dartName: 'RoadSegment',
      schema: 'public',
      module: 'caregrid',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'code',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'fromZone',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'toZone',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'lengthMeters',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:RoadStatus',
          columnDefault: '\'open\'',
        ),
        _isp.ColumnDefinition(
          name: 'isOutsideCampus',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'road_segment__code__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'code',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'scenario_run',
      dartName: 'ScenarioRun',
      schema: 'public',
      module: 'caregrid',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'scenarioCode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'startedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'startedBy',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'autopilot',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'stepsTotal',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'stepsEmitted',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'faults',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'sensor_event',
      dartName: 'SensorEvent',
      schema: 'public',
      module: 'caregrid',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'source',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:SignalSource',
        ),
        _isp.ColumnDefinition(
          name: 'eventType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:EventType',
        ),
        _isp.ColumnDefinition(
          name: 'zoneCode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'cameraCode',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'trackId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'confidence',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'detail',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'locationDetail',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'observedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'receivedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'incidentId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'outcome',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'contextHour',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'scenarioRunId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'reporterUserId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'sensor_event_incident_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'incidentId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'stress_scenario',
      dartName: 'StressScenario',
      schema: 'public',
      module: 'caregrid',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'code',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'zoneCode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'eventType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:EventType',
        ),
        _isp.ColumnDefinition(
          name: 'hour',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'failures',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:StressFailure>',
        ),
        _isp.ColumnDefinition(
          name: 'builtIn',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'stress_scenario__code__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'code',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'stress_test_run',
      dartName: 'StressTestRun',
      schema: 'public',
      module: 'caregrid',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'scenarioCode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'scenarioName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'ranAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'ranBy',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'verdict',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:Verdict',
        ),
        _isp.ColumnDefinition(
          name: 'predictedSeconds',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'slaSeconds',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'policyCode',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'stages',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:StageEstimate>',
        ),
        _isp.ColumnDefinition(
          name: 'responderPlan',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'findings',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'fixes',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:StressFix>',
        ),
        _isp.ColumnDefinition(
          name: 'verdictAfterFix',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:Verdict?',
        ),
        _isp.ColumnDefinition(
          name: 'predictedAfterFixSeconds',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'planAfterFix',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'timeline_entry',
      dartName: 'TimelineEntry',
      schema: 'public',
      module: 'caregrid',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'incidentId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'at',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'kind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:TimelineKind',
        ),
        _isp.ColumnDefinition(
          name: 'actor',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'message',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'sensitive',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'timeline_incident_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'incidentId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'zone',
      dartName: 'Zone',
      schema: 'public',
      module: 'caregrid',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'code',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'type',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ZoneType',
        ),
        _isp.ColumnDefinition(
          name: 'x',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'y',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'isOpen',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _isp.ColumnDefinition(
          name: 'emergencyOverride',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'isRestricted',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'privacySensitive',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'zone__code__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'code',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'zone_policy',
      dartName: 'ZonePolicy',
      schema: 'public',
      module: 'caregrid',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'code',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'zoneType',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:ZoneType?',
        ),
        _isp.ColumnDefinition(
          name: 'family',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:EventFamily',
        ),
        _isp.ColumnDefinition(
          name: 'startHour',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'endHour',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'severity',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:Severity',
        ),
        _isp.ColumnDefinition(
          name: 'minConfidence',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'requireCorroboration',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'autoDispatch',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'notifyHospital',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'responderTypes',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:ResponderType>',
        ),
        _isp.ColumnDefinition(
          name: 'fallbackTypes',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:ResponderType>',
        ),
        _isp.ColumnDefinition(
          name: 'verifySlaSeconds',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'ackSlaSeconds',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'arrivalSlaSeconds',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'careSlaSeconds',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'instructions',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'zone_policy__code__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'code',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _iwbuzrtm.AppUser) {
      return _iwbuzrtm.AppUser.fromJson(data) as T;
    }
    if (t == _inbrvjr3.AuditRecord) {
      return _inbrvjr3.AuditRecord.fromJson(data) as T;
    }
    if (t == _ivq2qjjo.AuthToken) {
      return _ivq2qjjo.AuthToken.fromJson(data) as T;
    }
    if (t == _i4e1ds00.CareGridException) {
      return _i4e1ds00.CareGridException.fromJson(data) as T;
    }
    if (t == _ikp8ifqs.DemoAccount) {
      return _ikp8ifqs.DemoAccount.fromJson(data) as T;
    }
    if (t == _ii02desn.SignInResult) {
      return _ii02desn.SignInResult.fromJson(data) as T;
    }
    if (t == _iafup8z9.AssetHealth) {
      return _iafup8z9.AssetHealth.fromJson(data) as T;
    }
    if (t == _i17wqy4s.DispatchStatus) {
      return _i17wqy4s.DispatchStatus.fromJson(data) as T;
    }
    if (t == _idspv1yy.EventFamily) {
      return _idspv1yy.EventFamily.fromJson(data) as T;
    }
    if (t == _ieodkyuw.EventType) {
      return _ieodkyuw.EventType.fromJson(data) as T;
    }
    if (t == _i3ox4omb.IncidentState) {
      return _i3ox4omb.IncidentState.fromJson(data) as T;
    }
    if (t == _ijbl1che.Observability) {
      return _ijbl1che.Observability.fromJson(data) as T;
    }
    if (t == _iito6g4l.ResponderStatus) {
      return _iito6g4l.ResponderStatus.fromJson(data) as T;
    }
    if (t == _ibv84qfn.ResponderType) {
      return _ibv84qfn.ResponderType.fromJson(data) as T;
    }
    if (t == _ig6l8r1a.RoadStatus) {
      return _ig6l8r1a.RoadStatus.fromJson(data) as T;
    }
    if (t == _i0yrjrt4.Severity) {
      return _i0yrjrt4.Severity.fromJson(data) as T;
    }
    if (t == _ixf557v3.SignalSource) {
      return _ixf557v3.SignalSource.fromJson(data) as T;
    }
    if (t == _ijbusfl4.StressFailureKind) {
      return _ijbusfl4.StressFailureKind.fromJson(data) as T;
    }
    if (t == _i430br9d.TimelineKind) {
      return _i430br9d.TimelineKind.fromJson(data) as T;
    }
    if (t == _iez5w9yk.UserRole) {
      return _iez5w9yk.UserRole.fromJson(data) as T;
    }
    if (t == _iasvrkwu.Verdict) {
      return _iasvrkwu.Verdict.fromJson(data) as T;
    }
    if (t == _iaz6xvg2.ZoneType) {
      return _iaz6xvg2.ZoneType.fromJson(data) as T;
    }
    if (t == _i4zinos7.Incident) {
      return _i4zinos7.Incident.fromJson(data) as T;
    }
    if (t == _iyiaaekw.SensorEvent) {
      return _iyiaaekw.SensorEvent.fromJson(data) as T;
    }
    if (t == _igo2svs2.SignalInput) {
      return _igo2svs2.SignalInput.fromJson(data) as T;
    }
    if (t == _i97csrvw.TimelineEntry) {
      return _i97csrvw.TimelineEntry.fromJson(data) as T;
    }
    if (t == _ileajsn8.ReadinessSummary) {
      return _ileajsn8.ReadinessSummary.fromJson(data) as T;
    }
    if (t == _itoxh6hp.StageEstimate) {
      return _itoxh6hp.StageEstimate.fromJson(data) as T;
    }
    if (t == _i6xikljp.StressFailure) {
      return _i6xikljp.StressFailure.fromJson(data) as T;
    }
    if (t == _iwebk8fi.StressFix) {
      return _iwebk8fi.StressFix.fromJson(data) as T;
    }
    if (t == _ilyjz5ws.StressScenario) {
      return _ilyjz5ws.StressScenario.fromJson(data) as T;
    }
    if (t == _itadwlnx.StressTestRun) {
      return _itadwlnx.StressTestRun.fromJson(data) as T;
    }
    if (t == _if82mktm.Dispatch) {
      return _if82mktm.Dispatch.fromJson(data) as T;
    }
    if (t == _i4tsze0k.PlanOption) {
      return _i4tsze0k.PlanOption.fromJson(data) as T;
    }
    if (t == _i83nmjlo.ResponsePlan) {
      return _i83nmjlo.ResponsePlan.fromJson(data) as T;
    }
    if (t == _innnctpn.RoutePlan) {
      return _innnctpn.RoutePlan.fromJson(data) as T;
    }
    if (t == _iyf1dz2p.ScenarioInfo) {
      return _iyf1dz2p.ScenarioInfo.fromJson(data) as T;
    }
    if (t == _i555kad7.ScenarioRun) {
      return _i555kad7.ScenarioRun.fromJson(data) as T;
    }
    if (t == _i216yyh2.SimulationStatus) {
      return _i216yyh2.SimulationStatus.fromJson(data) as T;
    }
    if (t == _iznodk4a.Camera) {
      return _iznodk4a.Camera.fromJson(data) as T;
    }
    if (t == _iombuvto.Responder) {
      return _iombuvto.Responder.fromJson(data) as T;
    }
    if (t == _iqmbpj37.RoadSegment) {
      return _iqmbpj37.RoadSegment.fromJson(data) as T;
    }
    if (t == _i5d9qpt0.Zone) {
      return _i5d9qpt0.Zone.fromJson(data) as T;
    }
    if (t == _i0bge9o7.ZonePolicy) {
      return _i0bge9o7.ZonePolicy.fromJson(data) as T;
    }
    if (t == _iqt6besl.CampusTwin) {
      return _iqt6besl.CampusTwin.fromJson(data) as T;
    }
    if (t == _i2egsg9j.CareCase) {
      return _i2egsg9j.CareCase.fromJson(data) as T;
    }
    if (t == _i8js0qii.EvidenceContent) {
      return _i8js0qii.EvidenceContent.fromJson(data) as T;
    }
    if (t == _ijaoliqc.EvidenceFile) {
      return _ijaoliqc.EvidenceFile.fromJson(data) as T;
    }
    if (t == _ig1wbv10.EvidencePage) {
      return _ig1wbv10.EvidencePage.fromJson(data) as T;
    }
    if (t == _izalsqqh.IncidentBrief) {
      return _izalsqqh.IncidentBrief.fromJson(data) as T;
    }
    if (t == _iv8abos3.IncidentDetail) {
      return _iv8abos3.IncidentDetail.fromJson(data) as T;
    }
    if (t == _i028ji74.IncidentSummary) {
      return _i028ji74.IncidentSummary.fromJson(data) as T;
    }
    if (t == _ifqwjb8e.OpsBoard) {
      return _ifqwjb8e.OpsBoard.fromJson(data) as T;
    }
    if (t == _iz030ym9.OpsEvent) {
      return _iz030ym9.OpsEvent.fromJson(data) as T;
    }
    if (t == _izhon84m.OpsMetrics) {
      return _izhon84m.OpsMetrics.fromJson(data) as T;
    }
    if (t == _imjqk5v8.ResponderHome) {
      return _imjqk5v8.ResponderHome.fromJson(data) as T;
    }
    if (t == _itb553ix.ResponderTask) {
      return _itb553ix.ResponderTask.fromJson(data) as T;
    }
    if (t == _iiaeposo.SosStatus) {
      return _iiaeposo.SosStatus.fromJson(data) as T;
    }
    if (t == _is.getType<_iwbuzrtm.AppUser?>()) {
      return (data != null ? _iwbuzrtm.AppUser.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_inbrvjr3.AuditRecord?>()) {
      return (data != null ? _inbrvjr3.AuditRecord.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ivq2qjjo.AuthToken?>()) {
      return (data != null ? _ivq2qjjo.AuthToken.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i4e1ds00.CareGridException?>()) {
      return (data != null ? _i4e1ds00.CareGridException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ikp8ifqs.DemoAccount?>()) {
      return (data != null ? _ikp8ifqs.DemoAccount.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ii02desn.SignInResult?>()) {
      return (data != null ? _ii02desn.SignInResult.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iafup8z9.AssetHealth?>()) {
      return (data != null ? _iafup8z9.AssetHealth.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i17wqy4s.DispatchStatus?>()) {
      return (data != null ? _i17wqy4s.DispatchStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_idspv1yy.EventFamily?>()) {
      return (data != null ? _idspv1yy.EventFamily.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ieodkyuw.EventType?>()) {
      return (data != null ? _ieodkyuw.EventType.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i3ox4omb.IncidentState?>()) {
      return (data != null ? _i3ox4omb.IncidentState.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ijbl1che.Observability?>()) {
      return (data != null ? _ijbl1che.Observability.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iito6g4l.ResponderStatus?>()) {
      return (data != null ? _iito6g4l.ResponderStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ibv84qfn.ResponderType?>()) {
      return (data != null ? _ibv84qfn.ResponderType.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ig6l8r1a.RoadStatus?>()) {
      return (data != null ? _ig6l8r1a.RoadStatus.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i0yrjrt4.Severity?>()) {
      return (data != null ? _i0yrjrt4.Severity.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ixf557v3.SignalSource?>()) {
      return (data != null ? _ixf557v3.SignalSource.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ijbusfl4.StressFailureKind?>()) {
      return (data != null ? _ijbusfl4.StressFailureKind.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i430br9d.TimelineKind?>()) {
      return (data != null ? _i430br9d.TimelineKind.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iez5w9yk.UserRole?>()) {
      return (data != null ? _iez5w9yk.UserRole.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iasvrkwu.Verdict?>()) {
      return (data != null ? _iasvrkwu.Verdict.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iaz6xvg2.ZoneType?>()) {
      return (data != null ? _iaz6xvg2.ZoneType.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i4zinos7.Incident?>()) {
      return (data != null ? _i4zinos7.Incident.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iyiaaekw.SensorEvent?>()) {
      return (data != null ? _iyiaaekw.SensorEvent.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_igo2svs2.SignalInput?>()) {
      return (data != null ? _igo2svs2.SignalInput.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i97csrvw.TimelineEntry?>()) {
      return (data != null ? _i97csrvw.TimelineEntry.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ileajsn8.ReadinessSummary?>()) {
      return (data != null ? _ileajsn8.ReadinessSummary.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_itoxh6hp.StageEstimate?>()) {
      return (data != null ? _itoxh6hp.StageEstimate.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i6xikljp.StressFailure?>()) {
      return (data != null ? _i6xikljp.StressFailure.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iwebk8fi.StressFix?>()) {
      return (data != null ? _iwebk8fi.StressFix.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ilyjz5ws.StressScenario?>()) {
      return (data != null ? _ilyjz5ws.StressScenario.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_itadwlnx.StressTestRun?>()) {
      return (data != null ? _itadwlnx.StressTestRun.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_if82mktm.Dispatch?>()) {
      return (data != null ? _if82mktm.Dispatch.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i4tsze0k.PlanOption?>()) {
      return (data != null ? _i4tsze0k.PlanOption.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i83nmjlo.ResponsePlan?>()) {
      return (data != null ? _i83nmjlo.ResponsePlan.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_innnctpn.RoutePlan?>()) {
      return (data != null ? _innnctpn.RoutePlan.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iyf1dz2p.ScenarioInfo?>()) {
      return (data != null ? _iyf1dz2p.ScenarioInfo.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i555kad7.ScenarioRun?>()) {
      return (data != null ? _i555kad7.ScenarioRun.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i216yyh2.SimulationStatus?>()) {
      return (data != null ? _i216yyh2.SimulationStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iznodk4a.Camera?>()) {
      return (data != null ? _iznodk4a.Camera.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iombuvto.Responder?>()) {
      return (data != null ? _iombuvto.Responder.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iqmbpj37.RoadSegment?>()) {
      return (data != null ? _iqmbpj37.RoadSegment.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i5d9qpt0.Zone?>()) {
      return (data != null ? _i5d9qpt0.Zone.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i0bge9o7.ZonePolicy?>()) {
      return (data != null ? _i0bge9o7.ZonePolicy.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iqt6besl.CampusTwin?>()) {
      return (data != null ? _iqt6besl.CampusTwin.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i2egsg9j.CareCase?>()) {
      return (data != null ? _i2egsg9j.CareCase.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i8js0qii.EvidenceContent?>()) {
      return (data != null ? _i8js0qii.EvidenceContent.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ijaoliqc.EvidenceFile?>()) {
      return (data != null ? _ijaoliqc.EvidenceFile.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ig1wbv10.EvidencePage?>()) {
      return (data != null ? _ig1wbv10.EvidencePage.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_izalsqqh.IncidentBrief?>()) {
      return (data != null ? _izalsqqh.IncidentBrief.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iv8abos3.IncidentDetail?>()) {
      return (data != null ? _iv8abos3.IncidentDetail.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i028ji74.IncidentSummary?>()) {
      return (data != null ? _i028ji74.IncidentSummary.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ifqwjb8e.OpsBoard?>()) {
      return (data != null ? _ifqwjb8e.OpsBoard.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iz030ym9.OpsEvent?>()) {
      return (data != null ? _iz030ym9.OpsEvent.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_izhon84m.OpsMetrics?>()) {
      return (data != null ? _izhon84m.OpsMetrics.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_imjqk5v8.ResponderHome?>()) {
      return (data != null ? _imjqk5v8.ResponderHome.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_itb553ix.ResponderTask?>()) {
      return (data != null ? _itb553ix.ResponderTask.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iiaeposo.SosStatus?>()) {
      return (data != null ? _iiaeposo.SosStatus.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_itadwlnx.StressTestRun>) {
      return (data as List)
              .map((e) => deserialize<_itadwlnx.StressTestRun>(e))
              .toList()
          as T;
    }
    if (t == List<_i6xikljp.StressFailure>) {
      return (data as List)
              .map((e) => deserialize<_i6xikljp.StressFailure>(e))
              .toList()
          as T;
    }
    if (t == List<_itoxh6hp.StageEstimate>) {
      return (data as List)
              .map((e) => deserialize<_itoxh6hp.StageEstimate>(e))
              .toList()
          as T;
    }
    if (t == List<_iwebk8fi.StressFix>) {
      return (data as List)
              .map((e) => deserialize<_iwebk8fi.StressFix>(e))
              .toList()
          as T;
    }
    if (t == List<_i4tsze0k.PlanOption>) {
      return (data as List)
              .map((e) => deserialize<_i4tsze0k.PlanOption>(e))
              .toList()
          as T;
    }
    if (t == List<_iyf1dz2p.ScenarioInfo>) {
      return (data as List)
              .map((e) => deserialize<_iyf1dz2p.ScenarioInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i555kad7.ScenarioRun>) {
      return (data as List)
              .map((e) => deserialize<_i555kad7.ScenarioRun>(e))
              .toList()
          as T;
    }
    if (t == List<_ibv84qfn.ResponderType>) {
      return (data as List)
              .map((e) => deserialize<_ibv84qfn.ResponderType>(e))
              .toList()
          as T;
    }
    if (t == List<_i5d9qpt0.Zone>) {
      return (data as List).map((e) => deserialize<_i5d9qpt0.Zone>(e)).toList()
          as T;
    }
    if (t == List<_iqmbpj37.RoadSegment>) {
      return (data as List)
              .map((e) => deserialize<_iqmbpj37.RoadSegment>(e))
              .toList()
          as T;
    }
    if (t == List<_iznodk4a.Camera>) {
      return (data as List)
              .map((e) => deserialize<_iznodk4a.Camera>(e))
              .toList()
          as T;
    }
    if (t == List<_iombuvto.Responder>) {
      return (data as List)
              .map((e) => deserialize<_iombuvto.Responder>(e))
              .toList()
          as T;
    }
    if (t == List<_i028ji74.IncidentSummary>) {
      return (data as List)
              .map((e) => deserialize<_i028ji74.IncidentSummary>(e))
              .toList()
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == List<_ijaoliqc.EvidenceFile>) {
      return (data as List)
              .map((e) => deserialize<_ijaoliqc.EvidenceFile>(e))
              .toList()
          as T;
    }
    if (t == List<_i97csrvw.TimelineEntry>) {
      return (data as List)
              .map((e) => deserialize<_i97csrvw.TimelineEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_if82mktm.Dispatch>) {
      return (data as List)
              .map((e) => deserialize<_if82mktm.Dispatch>(e))
              .toList()
          as T;
    }
    if (t == List<_iyiaaekw.SensorEvent>) {
      return (data as List)
              .map((e) => deserialize<_iyiaaekw.SensorEvent>(e))
              .toList()
          as T;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)),
          )
          as T;
    }
    if (t == List<_i97xkteh.DemoAccount>) {
      return (data as List)
              .map((e) => deserialize<_i97xkteh.DemoAccount>(e))
              .toList()
          as T;
    }
    if (t == List<_i6gqfmnl.ZonePolicy>) {
      return (data as List)
              .map((e) => deserialize<_i6gqfmnl.ZonePolicy>(e))
              .toList()
          as T;
    }
    if (t == List<_i4l5173s.AuditRecord>) {
      return (data as List)
              .map((e) => deserialize<_i4l5173s.AuditRecord>(e))
              .toList()
          as T;
    }
    if (t == List<_ix2i9ay5.AppUser>) {
      return (data as List)
              .map((e) => deserialize<_ix2i9ay5.AppUser>(e))
              .toList()
          as T;
    }
    if (t == List<_i3dtfzqd.CareCase>) {
      return (data as List)
              .map((e) => deserialize<_i3dtfzqd.CareCase>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _is.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_ifrvbi5l.StressScenario>) {
      return (data as List)
              .map((e) => deserialize<_ifrvbi5l.StressScenario>(e))
              .toList()
          as T;
    }
    if (t == List<_i7amlooz.StressTestRun>) {
      return (data as List)
              .map((e) => deserialize<_i7amlooz.StressTestRun>(e))
              .toList()
          as T;
    }
    if (t == List<_ijtpiixj.SensorEvent>) {
      return (data as List)
              .map((e) => deserialize<_ijtpiixj.SensorEvent>(e))
              .toList()
          as T;
    }
    if (t == List<_ivqnwjsb.SosStatus>) {
      return (data as List)
              .map((e) => deserialize<_ivqnwjsb.SosStatus>(e))
              .toList()
          as T;
    }
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _iwbuzrtm.AppUser => 'AppUser',
      _inbrvjr3.AuditRecord => 'AuditRecord',
      _ivq2qjjo.AuthToken => 'AuthToken',
      _i4e1ds00.CareGridException => 'CareGridException',
      _ikp8ifqs.DemoAccount => 'DemoAccount',
      _ii02desn.SignInResult => 'SignInResult',
      _iafup8z9.AssetHealth => 'AssetHealth',
      _i17wqy4s.DispatchStatus => 'DispatchStatus',
      _idspv1yy.EventFamily => 'EventFamily',
      _ieodkyuw.EventType => 'EventType',
      _i3ox4omb.IncidentState => 'IncidentState',
      _ijbl1che.Observability => 'Observability',
      _iito6g4l.ResponderStatus => 'ResponderStatus',
      _ibv84qfn.ResponderType => 'ResponderType',
      _ig6l8r1a.RoadStatus => 'RoadStatus',
      _i0yrjrt4.Severity => 'Severity',
      _ixf557v3.SignalSource => 'SignalSource',
      _ijbusfl4.StressFailureKind => 'StressFailureKind',
      _i430br9d.TimelineKind => 'TimelineKind',
      _iez5w9yk.UserRole => 'UserRole',
      _iasvrkwu.Verdict => 'Verdict',
      _iaz6xvg2.ZoneType => 'ZoneType',
      _i4zinos7.Incident => 'Incident',
      _iyiaaekw.SensorEvent => 'SensorEvent',
      _igo2svs2.SignalInput => 'SignalInput',
      _i97csrvw.TimelineEntry => 'TimelineEntry',
      _ileajsn8.ReadinessSummary => 'ReadinessSummary',
      _itoxh6hp.StageEstimate => 'StageEstimate',
      _i6xikljp.StressFailure => 'StressFailure',
      _iwebk8fi.StressFix => 'StressFix',
      _ilyjz5ws.StressScenario => 'StressScenario',
      _itadwlnx.StressTestRun => 'StressTestRun',
      _if82mktm.Dispatch => 'Dispatch',
      _i4tsze0k.PlanOption => 'PlanOption',
      _i83nmjlo.ResponsePlan => 'ResponsePlan',
      _innnctpn.RoutePlan => 'RoutePlan',
      _iyf1dz2p.ScenarioInfo => 'ScenarioInfo',
      _i555kad7.ScenarioRun => 'ScenarioRun',
      _i216yyh2.SimulationStatus => 'SimulationStatus',
      _iznodk4a.Camera => 'Camera',
      _iombuvto.Responder => 'Responder',
      _iqmbpj37.RoadSegment => 'RoadSegment',
      _i5d9qpt0.Zone => 'Zone',
      _i0bge9o7.ZonePolicy => 'ZonePolicy',
      _iqt6besl.CampusTwin => 'CampusTwin',
      _i2egsg9j.CareCase => 'CareCase',
      _i8js0qii.EvidenceContent => 'EvidenceContent',
      _ijaoliqc.EvidenceFile => 'EvidenceFile',
      _ig1wbv10.EvidencePage => 'EvidencePage',
      _izalsqqh.IncidentBrief => 'IncidentBrief',
      _iv8abos3.IncidentDetail => 'IncidentDetail',
      _i028ji74.IncidentSummary => 'IncidentSummary',
      _ifqwjb8e.OpsBoard => 'OpsBoard',
      _iz030ym9.OpsEvent => 'OpsEvent',
      _izhon84m.OpsMetrics => 'OpsMetrics',
      _imjqk5v8.ResponderHome => 'ResponderHome',
      _itb553ix.ResponderTask => 'ResponderTask',
      _iiaeposo.SosStatus => 'SosStatus',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('caregrid.', '');
    }

    switch (data) {
      case _iwbuzrtm.AppUser():
        return 'AppUser';
      case _inbrvjr3.AuditRecord():
        return 'AuditRecord';
      case _ivq2qjjo.AuthToken():
        return 'AuthToken';
      case _i4e1ds00.CareGridException():
        return 'CareGridException';
      case _ikp8ifqs.DemoAccount():
        return 'DemoAccount';
      case _ii02desn.SignInResult():
        return 'SignInResult';
      case _iafup8z9.AssetHealth():
        return 'AssetHealth';
      case _i17wqy4s.DispatchStatus():
        return 'DispatchStatus';
      case _idspv1yy.EventFamily():
        return 'EventFamily';
      case _ieodkyuw.EventType():
        return 'EventType';
      case _i3ox4omb.IncidentState():
        return 'IncidentState';
      case _ijbl1che.Observability():
        return 'Observability';
      case _iito6g4l.ResponderStatus():
        return 'ResponderStatus';
      case _ibv84qfn.ResponderType():
        return 'ResponderType';
      case _ig6l8r1a.RoadStatus():
        return 'RoadStatus';
      case _i0yrjrt4.Severity():
        return 'Severity';
      case _ixf557v3.SignalSource():
        return 'SignalSource';
      case _ijbusfl4.StressFailureKind():
        return 'StressFailureKind';
      case _i430br9d.TimelineKind():
        return 'TimelineKind';
      case _iez5w9yk.UserRole():
        return 'UserRole';
      case _iasvrkwu.Verdict():
        return 'Verdict';
      case _iaz6xvg2.ZoneType():
        return 'ZoneType';
      case _i4zinos7.Incident():
        return 'Incident';
      case _iyiaaekw.SensorEvent():
        return 'SensorEvent';
      case _igo2svs2.SignalInput():
        return 'SignalInput';
      case _i97csrvw.TimelineEntry():
        return 'TimelineEntry';
      case _ileajsn8.ReadinessSummary():
        return 'ReadinessSummary';
      case _itoxh6hp.StageEstimate():
        return 'StageEstimate';
      case _i6xikljp.StressFailure():
        return 'StressFailure';
      case _iwebk8fi.StressFix():
        return 'StressFix';
      case _ilyjz5ws.StressScenario():
        return 'StressScenario';
      case _itadwlnx.StressTestRun():
        return 'StressTestRun';
      case _if82mktm.Dispatch():
        return 'Dispatch';
      case _i4tsze0k.PlanOption():
        return 'PlanOption';
      case _i83nmjlo.ResponsePlan():
        return 'ResponsePlan';
      case _innnctpn.RoutePlan():
        return 'RoutePlan';
      case _iyf1dz2p.ScenarioInfo():
        return 'ScenarioInfo';
      case _i555kad7.ScenarioRun():
        return 'ScenarioRun';
      case _i216yyh2.SimulationStatus():
        return 'SimulationStatus';
      case _iznodk4a.Camera():
        return 'Camera';
      case _iombuvto.Responder():
        return 'Responder';
      case _iqmbpj37.RoadSegment():
        return 'RoadSegment';
      case _i5d9qpt0.Zone():
        return 'Zone';
      case _i0bge9o7.ZonePolicy():
        return 'ZonePolicy';
      case _iqt6besl.CampusTwin():
        return 'CampusTwin';
      case _i2egsg9j.CareCase():
        return 'CareCase';
      case _i8js0qii.EvidenceContent():
        return 'EvidenceContent';
      case _ijaoliqc.EvidenceFile():
        return 'EvidenceFile';
      case _ig1wbv10.EvidencePage():
        return 'EvidencePage';
      case _izalsqqh.IncidentBrief():
        return 'IncidentBrief';
      case _iv8abos3.IncidentDetail():
        return 'IncidentDetail';
      case _i028ji74.IncidentSummary():
        return 'IncidentSummary';
      case _ifqwjb8e.OpsBoard():
        return 'OpsBoard';
      case _iz030ym9.OpsEvent():
        return 'OpsEvent';
      case _izhon84m.OpsMetrics():
        return 'OpsMetrics';
      case _imjqk5v8.ResponderHome():
        return 'ResponderHome';
      case _itb553ix.ResponderTask():
        return 'ResponderTask';
      case _iiaeposo.SosStatus():
        return 'SosStatus';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AppUser') {
      return deserialize<_iwbuzrtm.AppUser>(data['data']);
    }
    if (dataClassName == 'AuditRecord') {
      return deserialize<_inbrvjr3.AuditRecord>(data['data']);
    }
    if (dataClassName == 'AuthToken') {
      return deserialize<_ivq2qjjo.AuthToken>(data['data']);
    }
    if (dataClassName == 'CareGridException') {
      return deserialize<_i4e1ds00.CareGridException>(data['data']);
    }
    if (dataClassName == 'DemoAccount') {
      return deserialize<_ikp8ifqs.DemoAccount>(data['data']);
    }
    if (dataClassName == 'SignInResult') {
      return deserialize<_ii02desn.SignInResult>(data['data']);
    }
    if (dataClassName == 'AssetHealth') {
      return deserialize<_iafup8z9.AssetHealth>(data['data']);
    }
    if (dataClassName == 'DispatchStatus') {
      return deserialize<_i17wqy4s.DispatchStatus>(data['data']);
    }
    if (dataClassName == 'EventFamily') {
      return deserialize<_idspv1yy.EventFamily>(data['data']);
    }
    if (dataClassName == 'EventType') {
      return deserialize<_ieodkyuw.EventType>(data['data']);
    }
    if (dataClassName == 'IncidentState') {
      return deserialize<_i3ox4omb.IncidentState>(data['data']);
    }
    if (dataClassName == 'Observability') {
      return deserialize<_ijbl1che.Observability>(data['data']);
    }
    if (dataClassName == 'ResponderStatus') {
      return deserialize<_iito6g4l.ResponderStatus>(data['data']);
    }
    if (dataClassName == 'ResponderType') {
      return deserialize<_ibv84qfn.ResponderType>(data['data']);
    }
    if (dataClassName == 'RoadStatus') {
      return deserialize<_ig6l8r1a.RoadStatus>(data['data']);
    }
    if (dataClassName == 'Severity') {
      return deserialize<_i0yrjrt4.Severity>(data['data']);
    }
    if (dataClassName == 'SignalSource') {
      return deserialize<_ixf557v3.SignalSource>(data['data']);
    }
    if (dataClassName == 'StressFailureKind') {
      return deserialize<_ijbusfl4.StressFailureKind>(data['data']);
    }
    if (dataClassName == 'TimelineKind') {
      return deserialize<_i430br9d.TimelineKind>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_iez5w9yk.UserRole>(data['data']);
    }
    if (dataClassName == 'Verdict') {
      return deserialize<_iasvrkwu.Verdict>(data['data']);
    }
    if (dataClassName == 'ZoneType') {
      return deserialize<_iaz6xvg2.ZoneType>(data['data']);
    }
    if (dataClassName == 'Incident') {
      return deserialize<_i4zinos7.Incident>(data['data']);
    }
    if (dataClassName == 'SensorEvent') {
      return deserialize<_iyiaaekw.SensorEvent>(data['data']);
    }
    if (dataClassName == 'SignalInput') {
      return deserialize<_igo2svs2.SignalInput>(data['data']);
    }
    if (dataClassName == 'TimelineEntry') {
      return deserialize<_i97csrvw.TimelineEntry>(data['data']);
    }
    if (dataClassName == 'ReadinessSummary') {
      return deserialize<_ileajsn8.ReadinessSummary>(data['data']);
    }
    if (dataClassName == 'StageEstimate') {
      return deserialize<_itoxh6hp.StageEstimate>(data['data']);
    }
    if (dataClassName == 'StressFailure') {
      return deserialize<_i6xikljp.StressFailure>(data['data']);
    }
    if (dataClassName == 'StressFix') {
      return deserialize<_iwebk8fi.StressFix>(data['data']);
    }
    if (dataClassName == 'StressScenario') {
      return deserialize<_ilyjz5ws.StressScenario>(data['data']);
    }
    if (dataClassName == 'StressTestRun') {
      return deserialize<_itadwlnx.StressTestRun>(data['data']);
    }
    if (dataClassName == 'Dispatch') {
      return deserialize<_if82mktm.Dispatch>(data['data']);
    }
    if (dataClassName == 'PlanOption') {
      return deserialize<_i4tsze0k.PlanOption>(data['data']);
    }
    if (dataClassName == 'ResponsePlan') {
      return deserialize<_i83nmjlo.ResponsePlan>(data['data']);
    }
    if (dataClassName == 'RoutePlan') {
      return deserialize<_innnctpn.RoutePlan>(data['data']);
    }
    if (dataClassName == 'ScenarioInfo') {
      return deserialize<_iyf1dz2p.ScenarioInfo>(data['data']);
    }
    if (dataClassName == 'ScenarioRun') {
      return deserialize<_i555kad7.ScenarioRun>(data['data']);
    }
    if (dataClassName == 'SimulationStatus') {
      return deserialize<_i216yyh2.SimulationStatus>(data['data']);
    }
    if (dataClassName == 'Camera') {
      return deserialize<_iznodk4a.Camera>(data['data']);
    }
    if (dataClassName == 'Responder') {
      return deserialize<_iombuvto.Responder>(data['data']);
    }
    if (dataClassName == 'RoadSegment') {
      return deserialize<_iqmbpj37.RoadSegment>(data['data']);
    }
    if (dataClassName == 'Zone') {
      return deserialize<_i5d9qpt0.Zone>(data['data']);
    }
    if (dataClassName == 'ZonePolicy') {
      return deserialize<_i0bge9o7.ZonePolicy>(data['data']);
    }
    if (dataClassName == 'CampusTwin') {
      return deserialize<_iqt6besl.CampusTwin>(data['data']);
    }
    if (dataClassName == 'CareCase') {
      return deserialize<_i2egsg9j.CareCase>(data['data']);
    }
    if (dataClassName == 'EvidenceContent') {
      return deserialize<_i8js0qii.EvidenceContent>(data['data']);
    }
    if (dataClassName == 'EvidenceFile') {
      return deserialize<_ijaoliqc.EvidenceFile>(data['data']);
    }
    if (dataClassName == 'EvidencePage') {
      return deserialize<_ig1wbv10.EvidencePage>(data['data']);
    }
    if (dataClassName == 'IncidentBrief') {
      return deserialize<_izalsqqh.IncidentBrief>(data['data']);
    }
    if (dataClassName == 'IncidentDetail') {
      return deserialize<_iv8abos3.IncidentDetail>(data['data']);
    }
    if (dataClassName == 'IncidentSummary') {
      return deserialize<_i028ji74.IncidentSummary>(data['data']);
    }
    if (dataClassName == 'OpsBoard') {
      return deserialize<_ifqwjb8e.OpsBoard>(data['data']);
    }
    if (dataClassName == 'OpsEvent') {
      return deserialize<_iz030ym9.OpsEvent>(data['data']);
    }
    if (dataClassName == 'OpsMetrics') {
      return deserialize<_izhon84m.OpsMetrics>(data['data']);
    }
    if (dataClassName == 'ResponderHome') {
      return deserialize<_imjqk5v8.ResponderHome>(data['data']);
    }
    if (dataClassName == 'ResponderTask') {
      return deserialize<_itb553ix.ResponderTask>(data['data']);
    }
    if (dataClassName == 'SosStatus') {
      return deserialize<_iiaeposo.SosStatus>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _iwbuzrtm.AppUser:
        return _iwbuzrtm.AppUser.t;
      case _inbrvjr3.AuditRecord:
        return _inbrvjr3.AuditRecord.t;
      case _ivq2qjjo.AuthToken:
        return _ivq2qjjo.AuthToken.t;
      case _i4zinos7.Incident:
        return _i4zinos7.Incident.t;
      case _iyiaaekw.SensorEvent:
        return _iyiaaekw.SensorEvent.t;
      case _i97csrvw.TimelineEntry:
        return _i97csrvw.TimelineEntry.t;
      case _ilyjz5ws.StressScenario:
        return _ilyjz5ws.StressScenario.t;
      case _itadwlnx.StressTestRun:
        return _itadwlnx.StressTestRun.t;
      case _if82mktm.Dispatch:
        return _if82mktm.Dispatch.t;
      case _i555kad7.ScenarioRun:
        return _i555kad7.ScenarioRun.t;
      case _iznodk4a.Camera:
        return _iznodk4a.Camera.t;
      case _iombuvto.Responder:
        return _iombuvto.Responder.t;
      case _iqmbpj37.RoadSegment:
        return _iqmbpj37.RoadSegment.t;
      case _i5d9qpt0.Zone:
        return _i5d9qpt0.Zone.t;
      case _i0bge9o7.ZonePolicy:
        return _i0bge9o7.ZonePolicy.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'caregrid';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _isp.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
