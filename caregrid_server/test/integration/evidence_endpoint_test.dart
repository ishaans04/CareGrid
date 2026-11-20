import 'dart:convert';

import 'package:caregrid_server/src/core/access.dart';
import 'package:caregrid_server/src/endpoints/evidence_endpoint.dart';
import 'package:caregrid_server/src/generated/protocol.dart';
import 'package:caregrid_server/src/seed/seeder.dart';
import 'package:caregrid_server/src/storage/gcs_evidence_store.dart';
import 'package:test/test.dart';

import '../helpers/evidence_fixture.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Private evidence boundary', (sessions, endpoints) {
    late TestSessionBuilder command;
    late Incident incident;
    Future<TestSessionBuilder> asRole(UserRole role) async {
      final user = (await AppUser.db.findFirstRow(
        sessions.build(),
        where: (t) => t.role.equals(role),
      ))!;
      return sessions.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          '${user.id}',
          {Access.scopeFor(role)},
        ),
      );
    }

    setUp(() async {
      await Seeder.seedIfEmpty(sessions.build());
      command = await asRole(UserRole.command);
      incident = (await Incident.db.findFirstRow(sessions.build()))!;
    });
    test(
      'every non-command role is denied every operation before storage access',
      () async {
        var called = false;
        final store = GcsEvidenceStore(
          config: GcsEvidenceConfig('caregrid-test-evidence'),
          clientFactory: (_) async {
            called = true;
            throw StateError('must not run');
          },
        );
        final endpoint = EvidenceEndpoint(store: store);
        final forbidden = throwsA(
          isA<CareGridException>().having((e) => e.code, 'code', 'forbidden'),
        );
        for (final role in [
          null,
          ...UserRole.values.where((r) => r != UserRole.command),
        ]) {
          final session = (role == null ? sessions : await asRole(role))
              .build();
          await expectLater(
            endpoint.list(session, incident.id!, null),
            forbidden,
          );
          await expectLater(
            endpoint.upload(session, incident.id!, 'image/png', evidencePng),
            forbidden,
          );
          await expectLater(
            endpoint.read(session, incident.id!, evidenceKey, '1'),
            forbidden,
          );
          await expectLater(
            endpoint.remove(session, incident.id!, evidenceKey, '1'),
            forbidden,
          );
        }
        expect(called, isFalse);
      },
    );
    test(
      'disabled broker is explicit and nonexistent incidents never reach storage',
      () async {
        final result = await endpoints.evidence.list(
          command,
          incident.id!,
          null,
        );
        expect(result.status, 'disabled');
        expect(result.files, isEmpty);
        await expectLater(
          endpoints.evidence.list(command, -1, null),
          throwsA(
            isA<CareGridException>().having((e) => e.code, 'code', 'notFound'),
          ),
        );
        expect(
          await AuditRecord.db.findFirstRow(
            sessions.build(),
            where: (t) => t.action.equals('evidence-list'),
          ),
          isNotNull,
        );
      },
    );
    test(
      'command round trip is audited without image bytes and cannot change incident state',
      () async {
        final before = jsonEncode(incident.toJson());
        final fixture = EvidenceFixture();
        final endpoint = EvidenceEndpoint(
          store: GcsEvidenceStore(
            config: GcsEvidenceConfig('caregrid-test-evidence'),
            clientFactory: (_) async => fixture.client,
          ),
        );
        final session = command.build();
        final file = await endpoint.upload(
          session,
          incident.id!,
          'image/png',
          evidencePng,
        );
        expect(
          (await endpoint.list(session, incident.id!, null)).files.single.key,
          file.key,
        );
        expect(
          (await endpoint.read(
            session,
            incident.id!,
            file.key,
            file.generation,
          )).base64Data,
          evidencePng,
        );
        await endpoint.remove(session, incident.id!, file.key, file.generation);
        expect(
          (await endpoint.list(session, incident.id!, null)).files,
          isEmpty,
        );
        final audit = await AuditRecord.db.find(
          sessions.build(),
          where: (t) => t.target.equals(incident.code),
        );
        expect(
          audit.map((a) => a.action),
          containsAll([
            'evidence-upload-attempt',
            'evidence-uploaded',
            'evidence-read-attempt',
            'evidence-read',
            'evidence-remove-attempt',
            'evidence-removed',
          ]),
        );
        expect(audit.map((a) => a.detail ?? '').join(), contains(evidenceHash));
        expect(
          audit.map((a) => a.detail ?? '').join(),
          isNot(contains(evidencePng)),
        );
        expect(
          jsonEncode(
            (await Incident.db.findById(
              sessions.build(),
              incident.id!,
            ))!.toJson(),
          ),
          before,
        );
      },
    );
  });
}
