/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:caregrid_server/src/generated/enums/asset_health.dart'
    as _ifcvjbz9;
import 'package:caregrid_server/src/generated/enums/responder_status.dart'
    as _i8ne4834;
import 'package:caregrid_server/src/generated/enums/road_status.dart'
    as _ihptcq2s;
import 'package:caregrid_server/src/generated/incidents/signal_input.dart'
    as _if0yn4ji;
import 'package:caregrid_server/src/generated/readiness/stress_scenario.dart'
    as _ifrvbi5l;
import 'package:caregrid_server/src/generated/twin/zone_policy.dart'
    as _i6gqfmnl;
import 'package:serverpod/serverpod.dart' as _is;
import '../endpoints/account_endpoint.dart' as _iaho7ul5;
import '../endpoints/admin_endpoint.dart' as _i5t1w2d2;
import '../endpoints/analytics_endpoint.dart' as _ibbhv9ku;
import '../endpoints/briefing_endpoint.dart' as _iz0srkm9;
import '../endpoints/campus_endpoint.dart' as _i70hkba8;
import '../endpoints/care_endpoint.dart' as _iuxmpckp;
import '../endpoints/evidence_endpoint.dart' as _i2cvsm7u;
import '../endpoints/incident_endpoint.dart' as _idvfe0v9;
import '../endpoints/live_endpoint.dart' as _ixgr9pqx;
import '../endpoints/readiness_endpoint.dart' as _i0a0ux16;
import '../endpoints/responder_endpoint.dart' as _ixab9ci6;
import '../endpoints/signal_endpoint.dart' as _iirj0uqq;
import '../endpoints/simulation_endpoint.dart' as _i0zgu2b0;
import '../endpoints/sos_endpoint.dart' as _iesxivqt;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'account': _iaho7ul5.AccountEndpoint()
        ..initialize(
          server,
          'account',
          null,
        ),
      'admin': _i5t1w2d2.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
      'analytics': _ibbhv9ku.AnalyticsEndpoint()
        ..initialize(
          server,
          'analytics',
          null,
        ),
      'briefing': _iz0srkm9.BriefingEndpoint()
        ..initialize(
          server,
          'briefing',
          null,
        ),
      'campus': _i70hkba8.CampusEndpoint()
        ..initialize(
          server,
          'campus',
          null,
        ),
      'care': _iuxmpckp.CareEndpoint()
        ..initialize(
          server,
          'care',
          null,
        ),
      'evidence': _i2cvsm7u.EvidenceEndpoint()
        ..initialize(
          server,
          'evidence',
          null,
        ),
      'incident': _idvfe0v9.IncidentEndpoint()
        ..initialize(
          server,
          'incident',
          null,
        ),
      'live': _ixgr9pqx.LiveEndpoint()
        ..initialize(
          server,
          'live',
          null,
        ),
      'readiness': _i0a0ux16.ReadinessEndpoint()
        ..initialize(
          server,
          'readiness',
          null,
        ),
      'responder': _ixab9ci6.ResponderEndpoint()
        ..initialize(
          server,
          'responder',
          null,
        ),
      'signal': _iirj0uqq.SignalEndpoint()
        ..initialize(
          server,
          'signal',
          null,
        ),
      'simulation': _i0zgu2b0.SimulationEndpoint()
        ..initialize(
          server,
          'simulation',
          null,
        ),
      'sos': _iesxivqt.SosEndpoint()
        ..initialize(
          server,
          'sos',
          null,
        ),
    };
    connectors['account'] = _is.EndpointConnector(
      name: 'account',
      endpoint: endpoints['account']!,
      methodConnectors: {
        'demoAccounts': _is.MethodConnector(
          name: 'demoAccounts',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['account'] as _iaho7ul5.AccountEndpoint)
                  .demoAccounts(session),
        ),
        'signIn': _is.MethodConnector(
          name: 'signIn',
          params: {
            'handle': _is.ParameterDescription(
              name: 'handle',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'pin': _is.ParameterDescription(
              name: 'pin',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['account'] as _iaho7ul5.AccountEndpoint).signIn(
                    session,
                    params['handle'],
                    params['pin'],
                  ),
        ),
        'me': _is.MethodConnector(
          name: 'me',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['account'] as _iaho7ul5.AccountEndpoint).me(
                session,
              ),
        ),
        'signOut': _is.MethodConnector(
          name: 'signOut',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['account'] as _iaho7ul5.AccountEndpoint)
                  .signOut(session),
        ),
      },
    );
    connectors['admin'] = _is.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'policies': _is.MethodConnector(
          name: 'policies',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i5t1w2d2.AdminEndpoint)
                  .policies(session),
        ),
        'updatePolicy': _is.MethodConnector(
          name: 'updatePolicy',
          params: {
            'policy': _is.ParameterDescription(
              name: 'policy',
              type: _is.getType<_i6gqfmnl.ZonePolicy>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).updatePolicy(
                    session,
                    params['policy'],
                  ),
        ),
        'setCameraHealth': _is.MethodConnector(
          name: 'setCameraHealth',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'health': _is.ParameterDescription(
              name: 'health',
              type: _is.getType<_ifcvjbz9.AssetHealth>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i5t1w2d2.AdminEndpoint)
                  .setCameraHealth(
                    session,
                    params['code'],
                    params['health'],
                  ),
        ),
        'setGate': _is.MethodConnector(
          name: 'setGate',
          params: {
            'zoneCode': _is.ParameterDescription(
              name: 'zoneCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'isOpen': _is.ParameterDescription(
              name: 'isOpen',
              type: _is.getType<bool>(),
              nullable: false,
            ),
            'emergencyOverride': _is.ParameterDescription(
              name: 'emergencyOverride',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).setGate(
                    session,
                    params['zoneCode'],
                    params['isOpen'],
                    params['emergencyOverride'],
                  ),
        ),
        'setRoadStatus': _is.MethodConnector(
          name: 'setRoadStatus',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<_ihptcq2s.RoadStatus>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).setRoadStatus(
                    session,
                    params['code'],
                    params['status'],
                  ),
        ),
        'setResponderStatus': _is.MethodConnector(
          name: 'setResponderStatus',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<_i8ne4834.ResponderStatus>(),
              nullable: false,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i5t1w2d2.AdminEndpoint)
                  .setResponderStatus(
                    session,
                    params['code'],
                    params['status'],
                    params['note'],
                  ),
        ),
        'auditLog': _is.MethodConnector(
          name: 'auditLog',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).auditLog(
                    session,
                    params['limit'],
                  ),
        ),
        'users': _is.MethodConnector(
          name: 'users',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).users(
                session,
              ),
        ),
        'resetDemo': _is.MethodConnector(
          name: 'resetDemo',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i5t1w2d2.AdminEndpoint)
                  .resetDemo(session),
        ),
      },
    );
    connectors['analytics'] = _is.EndpointConnector(
      name: 'analytics',
      endpoint: endpoints['analytics']!,
      methodConnectors: {
        'metrics': _is.MethodConnector(
          name: 'metrics',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['analytics'] as _ibbhv9ku.AnalyticsEndpoint)
                  .metrics(session),
        ),
      },
    );
    connectors['briefing'] = _is.EndpointConnector(
      name: 'briefing',
      endpoint: endpoints['briefing']!,
      methodConnectors: {
        'generate': _is.MethodConnector(
          name: 'generate',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['briefing'] as _iz0srkm9.BriefingEndpoint)
                  .generate(
                    session,
                    params['incidentId'],
                  ),
        ),
      },
    );
    connectors['campus'] = _is.EndpointConnector(
      name: 'campus',
      endpoint: endpoints['campus']!,
      methodConnectors: {
        'twin': _is.MethodConnector(
          name: 'twin',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['campus'] as _i70hkba8.CampusEndpoint).twin(
                session,
              ),
        ),
        'route': _is.MethodConnector(
          name: 'route',
          params: {
            'from': _is.ParameterDescription(
              name: 'from',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'to': _is.ParameterDescription(
              name: 'to',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['campus'] as _i70hkba8.CampusEndpoint).route(
                    session,
                    params['from'],
                    params['to'],
                  ),
        ),
      },
    );
    connectors['care'] = _is.EndpointConnector(
      name: 'care',
      endpoint: endpoints['care']!,
      methodConnectors: {
        'cases': _is.MethodConnector(
          name: 'cases',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['care'] as _iuxmpckp.CareEndpoint).cases(session),
        ),
        'markReady': _is.MethodConnector(
          name: 'markReady',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['care'] as _iuxmpckp.CareEndpoint).markReady(
                    session,
                    params['incidentId'],
                  ),
        ),
      },
    );
    connectors['evidence'] = _is.EndpointConnector(
      name: 'evidence',
      endpoint: endpoints['evidence']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'pageToken': _is.ParameterDescription(
              name: 'pageToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['evidence'] as _i2cvsm7u.EvidenceEndpoint).list(
                    session,
                    params['incidentId'],
                    params['pageToken'],
                  ),
        ),
        'upload': _is.MethodConnector(
          name: 'upload',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'mediaType': _is.ParameterDescription(
              name: 'mediaType',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'base64Data': _is.ParameterDescription(
              name: 'base64Data',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['evidence'] as _i2cvsm7u.EvidenceEndpoint).upload(
                    session,
                    params['incidentId'],
                    params['mediaType'],
                    params['base64Data'],
                  ),
        ),
        'read': _is.MethodConnector(
          name: 'read',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'key': _is.ParameterDescription(
              name: 'key',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'generation': _is.ParameterDescription(
              name: 'generation',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['evidence'] as _i2cvsm7u.EvidenceEndpoint).read(
                    session,
                    params['incidentId'],
                    params['key'],
                    params['generation'],
                  ),
        ),
        'remove': _is.MethodConnector(
          name: 'remove',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'key': _is.ParameterDescription(
              name: 'key',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'generation': _is.ParameterDescription(
              name: 'generation',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['evidence'] as _i2cvsm7u.EvidenceEndpoint).remove(
                    session,
                    params['incidentId'],
                    params['key'],
                    params['generation'],
                  ),
        ),
      },
    );
    connectors['incident'] = _is.EndpointConnector(
      name: 'incident',
      endpoint: endpoints['incident']!,
      methodConnectors: {
        'board': _is.MethodConnector(
          name: 'board',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['incident'] as _idvfe0v9.IncidentEndpoint)
                  .board(session),
        ),
        'detail': _is.MethodConnector(
          name: 'detail',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['incident'] as _idvfe0v9.IncidentEndpoint).detail(
                    session,
                    params['incidentId'],
                  ),
        ),
        'confirmDispatch': _is.MethodConnector(
          name: 'confirmDispatch',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'responderCodes': _is.ParameterDescription(
              name: 'responderCodes',
              type: _is.getType<List<String>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['incident'] as _idvfe0v9.IncidentEndpoint)
                  .confirmDispatch(
                    session,
                    params['incidentId'],
                    params['responderCodes'],
                  ),
        ),
        'releaseUnit': _is.MethodConnector(
          name: 'releaseUnit',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'dispatchId': _is.ParameterDescription(
              name: 'dispatchId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['incident'] as _idvfe0v9.IncidentEndpoint)
                  .releaseUnit(
                    session,
                    params['incidentId'],
                    params['dispatchId'],
                    params['reason'],
                  ),
        ),
        'claim': _is.MethodConnector(
          name: 'claim',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['incident'] as _idvfe0v9.IncidentEndpoint).claim(
                    session,
                    params['incidentId'],
                  ),
        ),
        'escalate': _is.MethodConnector(
          name: 'escalate',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['incident'] as _idvfe0v9.IncidentEndpoint)
                  .escalate(
                    session,
                    params['incidentId'],
                    params['note'],
                  ),
        ),
        'addNote': _is.MethodConnector(
          name: 'addNote',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['incident'] as _idvfe0v9.IncidentEndpoint).addNote(
                    session,
                    params['incidentId'],
                    params['note'],
                  ),
        ),
        'dismiss': _is.MethodConnector(
          name: 'dismiss',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['incident'] as _idvfe0v9.IncidentEndpoint).dismiss(
                    session,
                    params['incidentId'],
                    params['reason'],
                  ),
        ),
        'resolve': _is.MethodConnector(
          name: 'resolve',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'outcome': _is.ParameterDescription(
              name: 'outcome',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['incident'] as _idvfe0v9.IncidentEndpoint).resolve(
                    session,
                    params['incidentId'],
                    params['outcome'],
                  ),
        ),
      },
    );
    connectors['live'] = _is.EndpointConnector(
      name: 'live',
      endpoint: endpoints['live']!,
      methodConnectors: {
        'watch': _is.MethodStreamConnector(
          name: 'watch',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['live'] as _ixgr9pqx.LiveEndpoint).watch(session),
        ),
      },
    );
    connectors['readiness'] = _is.EndpointConnector(
      name: 'readiness',
      endpoint: endpoints['readiness']!,
      methodConnectors: {
        'scenarios': _is.MethodConnector(
          name: 'scenarios',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['readiness'] as _i0a0ux16.ReadinessEndpoint)
                  .scenarios(session),
        ),
        'run': _is.MethodConnector(
          name: 'run',
          params: {
            'scenarioCode': _is.ParameterDescription(
              name: 'scenarioCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['readiness'] as _i0a0ux16.ReadinessEndpoint).run(
                    session,
                    params['scenarioCode'],
                  ),
        ),
        'runCustom': _is.MethodConnector(
          name: 'runCustom',
          params: {
            'scenario': _is.ParameterDescription(
              name: 'scenario',
              type: _is.getType<_ifrvbi5l.StressScenario>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['readiness'] as _i0a0ux16.ReadinessEndpoint)
                  .runCustom(
                    session,
                    params['scenario'],
                  ),
        ),
        'runAll': _is.MethodConnector(
          name: 'runAll',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['readiness'] as _i0a0ux16.ReadinessEndpoint)
                  .runAll(session),
        ),
        'history': _is.MethodConnector(
          name: 'history',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['readiness'] as _i0a0ux16.ReadinessEndpoint)
                  .history(
                    session,
                    params['limit'],
                  ),
        ),
        'applyFix': _is.MethodConnector(
          name: 'applyFix',
          params: {
            'fixCode': _is.ParameterDescription(
              name: 'fixCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['readiness'] as _i0a0ux16.ReadinessEndpoint)
                  .applyFix(
                    session,
                    params['fixCode'],
                  ),
        ),
      },
    );
    connectors['responder'] = _is.EndpointConnector(
      name: 'responder',
      endpoint: endpoints['responder']!,
      methodConnectors: {
        'home': _is.MethodConnector(
          name: 'home',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['responder'] as _ixab9ci6.ResponderEndpoint)
                  .home(session),
        ),
        'acknowledge': _is.MethodConnector(
          name: 'acknowledge',
          params: {
            'dispatchId': _is.ParameterDescription(
              name: 'dispatchId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['responder'] as _ixab9ci6.ResponderEndpoint)
                  .acknowledge(
                    session,
                    params['dispatchId'],
                  ),
        ),
        'enRoute': _is.MethodConnector(
          name: 'enRoute',
          params: {
            'dispatchId': _is.ParameterDescription(
              name: 'dispatchId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['responder'] as _ixab9ci6.ResponderEndpoint)
                  .enRoute(
                    session,
                    params['dispatchId'],
                  ),
        ),
        'arrive': _is.MethodConnector(
          name: 'arrive',
          params: {
            'dispatchId': _is.ParameterDescription(
              name: 'dispatchId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['responder'] as _ixab9ci6.ResponderEndpoint)
                  .arrive(
                    session,
                    params['dispatchId'],
                  ),
        ),
        'startCare': _is.MethodConnector(
          name: 'startCare',
          params: {
            'dispatchId': _is.ParameterDescription(
              name: 'dispatchId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['responder'] as _ixab9ci6.ResponderEndpoint)
                  .startCare(
                    session,
                    params['dispatchId'],
                  ),
        ),
        'complete': _is.MethodConnector(
          name: 'complete',
          params: {
            'dispatchId': _is.ParameterDescription(
              name: 'dispatchId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['responder'] as _ixab9ci6.ResponderEndpoint)
                  .complete(
                    session,
                    params['dispatchId'],
                    params['note'],
                  ),
        ),
        'decline': _is.MethodConnector(
          name: 'decline',
          params: {
            'dispatchId': _is.ParameterDescription(
              name: 'dispatchId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['responder'] as _ixab9ci6.ResponderEndpoint)
                  .decline(
                    session,
                    params['dispatchId'],
                    params['reason'],
                  ),
        ),
        'setAvailability': _is.MethodConnector(
          name: 'setAvailability',
          params: {
            'available': _is.ParameterDescription(
              name: 'available',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['responder'] as _ixab9ci6.ResponderEndpoint)
                  .setAvailability(
                    session,
                    params['available'],
                  ),
        ),
      },
    );
    connectors['signal'] = _is.EndpointConnector(
      name: 'signal',
      endpoint: endpoints['signal']!,
      methodConnectors: {
        'ingest': _is.MethodConnector(
          name: 'ingest',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_if0yn4ji.SignalInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['signal'] as _iirj0uqq.SignalEndpoint).ingest(
                    session,
                    params['input'],
                  ),
        ),
        'recent': _is.MethodConnector(
          name: 'recent',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['signal'] as _iirj0uqq.SignalEndpoint).recent(
                    session,
                    params['limit'],
                  ),
        ),
      },
    );
    connectors['simulation'] = _is.EndpointConnector(
      name: 'simulation',
      endpoint: endpoints['simulation']!,
      methodConnectors: {
        'status': _is.MethodConnector(
          name: 'status',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['simulation'] as _i0zgu2b0.SimulationEndpoint)
                      .status(session),
        ),
        'start': _is.MethodConnector(
          name: 'start',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'autopilot': _is.ParameterDescription(
              name: 'autopilot',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['simulation'] as _i0zgu2b0.SimulationEndpoint)
                      .start(
                        session,
                        params['code'],
                        params['autopilot'],
                      ),
        ),
        'stop': _is.MethodConnector(
          name: 'stop',
          params: {
            'runId': _is.ParameterDescription(
              name: 'runId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['simulation'] as _i0zgu2b0.SimulationEndpoint)
                      .stop(
                        session,
                        params['runId'],
                      ),
        ),
        'clear': _is.MethodConnector(
          name: 'clear',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['simulation'] as _i0zgu2b0.SimulationEndpoint)
                      .clear(session),
        ),
      },
    );
    connectors['sos'] = _is.EndpointConnector(
      name: 'sos',
      endpoint: endpoints['sos']!,
      methodConnectors: {
        'raise': _is.MethodConnector(
          name: 'raise',
          params: {
            'zoneCode': _is.ParameterDescription(
              name: 'zoneCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'locationDetail': _is.ParameterDescription(
              name: 'locationDetail',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'forSelf': _is.ParameterDescription(
              name: 'forSelf',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['sos'] as _iesxivqt.SosEndpoint).raise(
                session,
                params['zoneCode'],
                params['locationDetail'],
                params['note'],
                params['forSelf'],
              ),
        ),
        'mine': _is.MethodConnector(
          name: 'mine',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sos'] as _iesxivqt.SosEndpoint).mine(session),
        ),
        'cancel': _is.MethodConnector(
          name: 'cancel',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['sos'] as _iesxivqt.SosEndpoint).cancel(
                session,
                params['incidentId'],
                params['reason'],
              ),
        ),
      },
    );
  }
}
