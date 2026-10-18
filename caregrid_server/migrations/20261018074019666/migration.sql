BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "app_user" (
    "id" bigserial PRIMARY KEY,
    "handle" text NOT NULL,
    "displayName" text NOT NULL,
    "role" text NOT NULL,
    "title" text NOT NULL,
    "responderCode" text,
    "pin" text
);

-- Indexes
CREATE UNIQUE INDEX "app_user__handle__unique_idx" ON "app_user" USING btree ("handle");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "audit_record" (
    "id" bigserial PRIMARY KEY,
    "at" timestamp without time zone NOT NULL,
    "userId" bigint,
    "userName" text NOT NULL,
    "role" text NOT NULL,
    "action" text NOT NULL,
    "target" text,
    "detail" text
);

-- Indexes
CREATE INDEX "audit_at_idx" ON "audit_record" USING btree ("at");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "auth_token" (
    "id" bigserial PRIMARY KEY,
    "token" text NOT NULL,
    "userId" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "auth_token__token__unique_idx" ON "auth_token" USING btree ("token");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "camera" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "zoneCode" text NOT NULL,
    "label" text NOT NULL,
    "health" text NOT NULL DEFAULT 'online'::text,
    "adjacentCameras" json NOT NULL,
    "privacyMasked" boolean NOT NULL DEFAULT true
);

-- Indexes
CREATE UNIQUE INDEX "camera__code__unique_idx" ON "camera" USING btree ("code");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "dispatch" (
    "id" bigserial PRIMARY KEY,
    "incidentId" bigint NOT NULL,
    "responderCode" text NOT NULL,
    "responderName" text NOT NULL,
    "responderType" text NOT NULL,
    "role" text NOT NULL,
    "status" text NOT NULL,
    "route" json NOT NULL,
    "distanceMeters" bigint NOT NULL,
    "etaSeconds" bigint NOT NULL,
    "offeredAt" timestamp without time zone NOT NULL,
    "ackDeadline" timestamp without time zone NOT NULL,
    "acknowledgedAt" timestamp without time zone,
    "enRouteAt" timestamp without time zone,
    "arrivalDeadline" timestamp without time zone,
    "onSceneAt" timestamp without time zone,
    "careAt" timestamp without time zone,
    "completedAt" timestamp without time zone,
    "progress" double precision NOT NULL DEFAULT 0,
    "arrivalSource" text,
    "stalled" boolean NOT NULL DEFAULT false,
    "note" text
);

-- Indexes
CREATE INDEX "dispatch_incident_idx" ON "dispatch" USING btree ("incidentId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "incident" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "title" text NOT NULL,
    "eventType" text NOT NULL,
    "family" text NOT NULL,
    "severity" text NOT NULL,
    "state" text NOT NULL,
    "zoneCode" text NOT NULL,
    "locationDetail" text,
    "primaryCameraCode" text,
    "trackId" text,
    "source" text NOT NULL,
    "confidence" double precision NOT NULL,
    "corroborated" boolean NOT NULL DEFAULT false,
    "observability" text NOT NULL DEFAULT 'full'::text,
    "consequence" text NOT NULL,
    "policyCode" text,
    "reasoning" json NOT NULL,
    "negativeEvidence" json NOT NULL,
    "nextAction" text,
    "parentIncidentId" bigint,
    "escalationLevel" bigint NOT NULL DEFAULT 0,
    "needsHumanReview" boolean NOT NULL DEFAULT false,
    "ownerName" text,
    "hospitalNotified" boolean NOT NULL DEFAULT false,
    "hospitalReady" boolean NOT NULL DEFAULT false,
    "reporterUserId" bigint,
    "scenarioRunId" bigint,
    "contextHour" bigint,
    "onsetAt" timestamp without time zone NOT NULL,
    "detectedAt" timestamp without time zone NOT NULL,
    "verifiedAt" timestamp without time zone,
    "dispatchedAt" timestamp without time zone,
    "acknowledgedAt" timestamp without time zone,
    "enRouteAt" timestamp without time zone,
    "onSceneAt" timestamp without time zone,
    "careAt" timestamp without time zone,
    "resolvedAt" timestamp without time zone,
    "dismissedAt" timestamp without time zone,
    "closureNote" text,
    "nextDeadline" timestamp without time zone,
    "nextDeadlineLabel" text,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "incident__code__unique_idx" ON "incident" USING btree ("code");
CREATE INDEX "incident_state_idx" ON "incident" USING btree ("state");
CREATE INDEX "incident_zone_idx" ON "incident" USING btree ("zoneCode");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "responder" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "name" text NOT NULL,
    "type" text NOT NULL,
    "status" text NOT NULL DEFAULT 'available'::text,
    "zoneCode" text NOT NULL,
    "baseZoneCode" text NOT NULL,
    "speedMetersPerMin" bigint NOT NULL,
    "mobilizationSeconds" bigint NOT NULL,
    "capabilities" json NOT NULL,
    "contact" text NOT NULL,
    "activeDispatchId" bigint,
    "statusNote" text
);

-- Indexes
CREATE UNIQUE INDEX "responder__code__unique_idx" ON "responder" USING btree ("code");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "road_segment" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "name" text NOT NULL,
    "fromZone" text NOT NULL,
    "toZone" text NOT NULL,
    "lengthMeters" bigint NOT NULL,
    "status" text NOT NULL DEFAULT 'open'::text,
    "isOutsideCampus" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE UNIQUE INDEX "road_segment__code__unique_idx" ON "road_segment" USING btree ("code");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scenario_run" (
    "id" bigserial PRIMARY KEY,
    "scenarioCode" text NOT NULL,
    "title" text NOT NULL,
    "startedAt" timestamp without time zone NOT NULL,
    "startedBy" text NOT NULL,
    "autopilot" boolean NOT NULL,
    "status" text NOT NULL,
    "stepsTotal" bigint NOT NULL,
    "stepsEmitted" bigint NOT NULL,
    "faults" json NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "sensor_event" (
    "id" bigserial PRIMARY KEY,
    "source" text NOT NULL,
    "eventType" text NOT NULL,
    "zoneCode" text NOT NULL,
    "cameraCode" text,
    "trackId" text,
    "confidence" double precision NOT NULL,
    "detail" text,
    "locationDetail" text,
    "observedAt" timestamp without time zone NOT NULL,
    "receivedAt" timestamp without time zone NOT NULL,
    "incidentId" bigint,
    "outcome" text,
    "contextHour" bigint,
    "scenarioRunId" bigint,
    "reporterUserId" bigint
);

-- Indexes
CREATE INDEX "sensor_event_incident_idx" ON "sensor_event" USING btree ("incidentId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "stress_scenario" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "name" text NOT NULL,
    "description" text NOT NULL,
    "zoneCode" text NOT NULL,
    "eventType" text NOT NULL,
    "hour" bigint NOT NULL,
    "failures" json NOT NULL,
    "builtIn" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE UNIQUE INDEX "stress_scenario__code__unique_idx" ON "stress_scenario" USING btree ("code");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "stress_test_run" (
    "id" bigserial PRIMARY KEY,
    "scenarioCode" text NOT NULL,
    "scenarioName" text NOT NULL,
    "ranAt" timestamp without time zone NOT NULL,
    "ranBy" text NOT NULL,
    "verdict" text NOT NULL,
    "predictedSeconds" bigint NOT NULL,
    "slaSeconds" bigint NOT NULL,
    "policyCode" text,
    "stages" json NOT NULL,
    "responderPlan" json NOT NULL,
    "findings" json NOT NULL,
    "fixes" json NOT NULL,
    "verdictAfterFix" text,
    "predictedAfterFixSeconds" bigint,
    "planAfterFix" json NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "timeline_entry" (
    "id" bigserial PRIMARY KEY,
    "incidentId" bigint NOT NULL,
    "at" timestamp without time zone NOT NULL,
    "kind" text NOT NULL,
    "actor" text NOT NULL,
    "message" text NOT NULL,
    "sensitive" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE INDEX "timeline_incident_idx" ON "timeline_entry" USING btree ("incidentId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "zone" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "name" text NOT NULL,
    "type" text NOT NULL,
    "x" double precision NOT NULL,
    "y" double precision NOT NULL,
    "description" text,
    "isOpen" boolean NOT NULL DEFAULT true,
    "emergencyOverride" boolean NOT NULL DEFAULT false,
    "isRestricted" boolean NOT NULL DEFAULT false,
    "privacySensitive" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE UNIQUE INDEX "zone__code__unique_idx" ON "zone" USING btree ("code");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "zone_policy" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "name" text NOT NULL,
    "zoneType" text,
    "family" text NOT NULL,
    "startHour" bigint,
    "endHour" bigint,
    "severity" text NOT NULL,
    "minConfidence" double precision NOT NULL,
    "requireCorroboration" boolean NOT NULL,
    "autoDispatch" boolean NOT NULL,
    "notifyHospital" boolean NOT NULL,
    "responderTypes" json NOT NULL,
    "fallbackTypes" json NOT NULL,
    "verifySlaSeconds" bigint NOT NULL,
    "ackSlaSeconds" bigint NOT NULL,
    "arrivalSlaSeconds" bigint NOT NULL,
    "careSlaSeconds" bigint NOT NULL,
    "instructions" json NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "zone_policy__code__unique_idx" ON "zone_policy" USING btree ("code");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    "expiration" timestamp without time zone,
    "byteData" bytea NOT NULL,
    "verified" boolean NOT NULL,
    "contentType" text,
    "cacheControl" text,
    "contentDisposition" text,
    "contentEncoding" text,
    "customMetadata" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" USING btree ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" USING btree ("expiration");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_cloud_storage_direct_download" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL,
    "downloadFileName" text,
    "contentType" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_download_auth_key" ON "serverpod_cloud_storage_direct_download" USING btree ("authKey");
CREATE INDEX "serverpod_cloud_storage_direct_download_expiration" ON "serverpod_cloud_storage_direct_download" USING btree ("expiration");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL,
    "maxFileSize" bigint NOT NULL DEFAULT 10485760,
    "contentLength" bigint,
    "preventOverwrite" boolean NOT NULL DEFAULT false,
    "contentType" text,
    "cacheControl" text,
    "contentDisposition" text,
    "contentEncoding" text,
    "customMetadata" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_future_call" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    "identifier" text,
    "scheduling" json
);

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" USING btree ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" USING btree ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" USING btree ("identifier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_future_call_claim" (
    "id" bigserial PRIMARY KEY,
    "futureCallId" bigint,
    "lastHeartbeatTime" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "future_call_unique_idx" ON "serverpod_future_call_claim" USING btree ("futureCallId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" bigint NOT NULL,
    "closing" bigint NOT NULL,
    "idle" bigint NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_health_metric" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId", "order");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_message_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_message_log_sessionLogId_idx" ON "serverpod_message_log" USING btree ("sessionLogId", "order");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_method" (
    "id" bigserial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_migrations" (
    "id" bigserial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_query_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" bigint,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId", "order");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" bigserial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_session_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" bigint,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "userId" text,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_time_idx" ON "serverpod_session_log" USING btree ("time");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_future_call_claim"
    ADD CONSTRAINT "serverpod_future_call_claim_fk_0"
    FOREIGN KEY("futureCallId")
    REFERENCES "serverpod_future_call"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_query_log"
    ADD CONSTRAINT "serverpod_query_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR caregrid
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('caregrid', '20261018074019666', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261018074019666', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
