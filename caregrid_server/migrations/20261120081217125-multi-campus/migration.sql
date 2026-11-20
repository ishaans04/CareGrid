BEGIN;

--
-- Multi-campus tenancy. Hand-written to preserve data: Serverpod's generated
-- plan dropped and recreated every table that gains a required campusId.
-- This produces the same final schema (columns, defaults, indexes, foreign
-- keys) as definition.sql, but keeps existing rows: anything created by the
-- single-campus prototype becomes the Meridian demo campus.
--

--
-- ACTION CREATE TABLE
--
CREATE TABLE "campus" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "name" text NOT NULL,
    "shortName" text NOT NULL,
    "city" text,
    "description" text,
    "utcOffsetMinutes" bigint NOT NULL,
    "incidentPrefix" text NOT NULL,
    "fictional" boolean NOT NULL,
    "attribution" text,
    "affiliationNote" text,
    "originLat" double precision,
    "originLon" double precision,
    "metersPerUnit" double precision NOT NULL,
    "mapWidth" double precision NOT NULL,
    "mapHeight" double precision NOT NULL,
    "mapLayers" text
);

-- Indexes
CREATE UNIQUE INDEX "campus_code_idx" ON "campus" USING btree ("code");

--
-- DATA: existing single-campus rows belong to the Meridian demo campus. The
-- values match MeridianSeed.campus so the seeder recognises the row by code.
--
INSERT INTO "campus" (
    "code", "name", "shortName", "description", "utcOffsetMinutes",
    "incidentPrefix", "fictional", "affiliationNote", "metersPerUnit",
    "mapWidth", "mapHeight")
SELECT
    'meridian', 'Meridian Demo Campus', 'Meridian',
    'Fictional residential reference campus with hostels, a hospital, labs and a perimeter road. Used to rehearse the full response loop.',
    330, 'INC', true,
    'Fictional campus. Any resemblance to a real institution is coincidental.',
    1.5, 1000, 700
WHERE EXISTS (SELECT 1 FROM "zone")
   OR EXISTS (SELECT 1 FROM "incident")
   OR EXISTS (SELECT 1 FROM "app_user")
   OR EXISTS (SELECT 1 FROM "audit_record")
   OR EXISTS (SELECT 1 FROM "zone_policy")
   OR EXISTS (SELECT 1 FROM "responder")
   OR EXISTS (SELECT 1 FROM "stress_test_run")
   OR EXISTS (SELECT 1 FROM "scenario_run");

--
-- ACTION ALTER TABLE: memberships and audit (nullable campus)
--
ALTER TABLE "app_user" ADD COLUMN "campusId" bigint;
UPDATE "app_user" SET "campusId" = (SELECT "id" FROM "campus" WHERE "code" = 'meridian');

ALTER TABLE "audit_record" ADD COLUMN "campusId" bigint;
UPDATE "audit_record" SET "campusId" = (SELECT "id" FROM "campus" WHERE "code" = 'meridian')
WHERE "role" <> 'deployment-operator';
CREATE INDEX "audit_campus_at_idx" ON "audit_record" USING btree ("campusId", "at");

--
-- ACTION ALTER TABLE: campus-scoped operational tables (required campus)
--
ALTER TABLE "zone" ADD COLUMN "campusId" bigint;
UPDATE "zone" SET "campusId" = (SELECT "id" FROM "campus" WHERE "code" = 'meridian');
ALTER TABLE "zone" ALTER COLUMN "campusId" SET NOT NULL;
ALTER TABLE "zone" ADD COLUMN "footprint" json;
ALTER TABLE "zone" ADD COLUMN "levels" bigint;
ALTER TABLE "zone" ADD COLUMN "approximate" boolean NOT NULL DEFAULT false;
ALTER TABLE "zone" ADD COLUMN "source" text;
DROP INDEX "zone__code__unique_idx";
CREATE UNIQUE INDEX "zone_campus_code_idx" ON "zone" USING btree ("campusId", "code");

ALTER TABLE "road_segment" ADD COLUMN "campusId" bigint;
UPDATE "road_segment" SET "campusId" = (SELECT "id" FROM "campus" WHERE "code" = 'meridian');
ALTER TABLE "road_segment" ALTER COLUMN "campusId" SET NOT NULL;
ALTER TABLE "road_segment" ADD COLUMN "path" json;
DROP INDEX "road_segment__code__unique_idx";
CREATE UNIQUE INDEX "road_campus_code_idx" ON "road_segment" USING btree ("campusId", "code");

ALTER TABLE "camera" ADD COLUMN "campusId" bigint;
UPDATE "camera" SET "campusId" = (SELECT "id" FROM "campus" WHERE "code" = 'meridian');
ALTER TABLE "camera" ALTER COLUMN "campusId" SET NOT NULL;
ALTER TABLE "camera" ADD COLUMN "x" double precision;
ALTER TABLE "camera" ADD COLUMN "y" double precision;
ALTER TABLE "camera" ADD COLUMN "rangeMeters" double precision;
DROP INDEX "camera__code__unique_idx";
CREATE UNIQUE INDEX "camera_campus_code_idx" ON "camera" USING btree ("campusId", "code");

ALTER TABLE "responder" ADD COLUMN "campusId" bigint;
UPDATE "responder" SET "campusId" = (SELECT "id" FROM "campus" WHERE "code" = 'meridian');
ALTER TABLE "responder" ALTER COLUMN "campusId" SET NOT NULL;
DROP INDEX "responder__code__unique_idx";
CREATE UNIQUE INDEX "responder_campus_code_idx" ON "responder" USING btree ("campusId", "code");

ALTER TABLE "zone_policy" ADD COLUMN "campusId" bigint;
UPDATE "zone_policy" SET "campusId" = (SELECT "id" FROM "campus" WHERE "code" = 'meridian');
ALTER TABLE "zone_policy" ALTER COLUMN "campusId" SET NOT NULL;
DROP INDEX "zone_policy__code__unique_idx";
CREATE UNIQUE INDEX "policy_campus_code_idx" ON "zone_policy" USING btree ("campusId", "code");

ALTER TABLE "stress_scenario" ADD COLUMN "campusId" bigint;
UPDATE "stress_scenario" SET "campusId" = (SELECT "id" FROM "campus" WHERE "code" = 'meridian');
ALTER TABLE "stress_scenario" ALTER COLUMN "campusId" SET NOT NULL;
DROP INDEX "stress_scenario__code__unique_idx";
CREATE UNIQUE INDEX "stress_scenario_campus_code_idx" ON "stress_scenario" USING btree ("campusId", "code");

ALTER TABLE "stress_test_run" ADD COLUMN "campusId" bigint;
UPDATE "stress_test_run" SET "campusId" = (SELECT "id" FROM "campus" WHERE "code" = 'meridian');
ALTER TABLE "stress_test_run" ALTER COLUMN "campusId" SET NOT NULL;
CREATE INDEX "stress_run_campus_idx" ON "stress_test_run" USING btree ("campusId", "ranAt");

ALTER TABLE "scenario_run" ADD COLUMN "campusId" bigint;
UPDATE "scenario_run" SET "campusId" = (SELECT "id" FROM "campus" WHERE "code" = 'meridian');
ALTER TABLE "scenario_run" ALTER COLUMN "campusId" SET NOT NULL;
CREATE INDEX "scenario_run_campus_idx" ON "scenario_run" USING btree ("campusId", "startedAt");

ALTER TABLE "incident" ADD COLUMN "campusId" bigint;
UPDATE "incident" SET "campusId" = (SELECT "id" FROM "campus" WHERE "code" = 'meridian');
ALTER TABLE "incident" ALTER COLUMN "campusId" SET NOT NULL;
CREATE INDEX "incident_campus_state_idx" ON "incident" USING btree ("campusId", "state");

ALTER TABLE "sensor_event" ADD COLUMN "campusId" bigint;
UPDATE "sensor_event" SET "campusId" = (SELECT "id" FROM "campus" WHERE "code" = 'meridian');
ALTER TABLE "sensor_event" ALTER COLUMN "campusId" SET NOT NULL;
ALTER TABLE "sensor_event" ADD COLUMN "sourceEventId" text;
CREATE UNIQUE INDEX "sensor_event_source_event_idx" ON "sensor_event" USING btree ("campusId", "source", "sourceEventId");
CREATE INDEX "sensor_event_campus_idx" ON "sensor_event" USING btree ("campusId", "receivedAt");

ALTER TABLE "dispatch" ADD COLUMN "campusId" bigint;
UPDATE "dispatch" SET "campusId" = (SELECT "id" FROM "campus" WHERE "code" = 'meridian');
ALTER TABLE "dispatch" ALTER COLUMN "campusId" SET NOT NULL;
CREATE INDEX "dispatch_campus_responder_idx" ON "dispatch" USING btree ("campusId", "responderCode");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "app_user"
    ADD CONSTRAINT "app_user_fk_0"
    FOREIGN KEY("campusId")
    REFERENCES "campus"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "audit_record"
    ADD CONSTRAINT "audit_record_fk_0"
    FOREIGN KEY("campusId")
    REFERENCES "campus"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "camera"
    ADD CONSTRAINT "camera_fk_0"
    FOREIGN KEY("campusId")
    REFERENCES "campus"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "dispatch"
    ADD CONSTRAINT "dispatch_fk_0"
    FOREIGN KEY("campusId")
    REFERENCES "campus"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "incident"
    ADD CONSTRAINT "incident_fk_0"
    FOREIGN KEY("campusId")
    REFERENCES "campus"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "responder"
    ADD CONSTRAINT "responder_fk_0"
    FOREIGN KEY("campusId")
    REFERENCES "campus"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "road_segment"
    ADD CONSTRAINT "road_segment_fk_0"
    FOREIGN KEY("campusId")
    REFERENCES "campus"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "scenario_run"
    ADD CONSTRAINT "scenario_run_fk_0"
    FOREIGN KEY("campusId")
    REFERENCES "campus"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "sensor_event"
    ADD CONSTRAINT "sensor_event_fk_0"
    FOREIGN KEY("campusId")
    REFERENCES "campus"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "stress_scenario"
    ADD CONSTRAINT "stress_scenario_fk_0"
    FOREIGN KEY("campusId")
    REFERENCES "campus"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "stress_test_run"
    ADD CONSTRAINT "stress_test_run_fk_0"
    FOREIGN KEY("campusId")
    REFERENCES "campus"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "zone"
    ADD CONSTRAINT "zone_fk_0"
    FOREIGN KEY("campusId")
    REFERENCES "campus"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "zone_policy"
    ADD CONSTRAINT "zone_policy_fk_0"
    FOREIGN KEY("campusId")
    REFERENCES "campus"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR caregrid
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('caregrid', '20261120081217125-multi-campus', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261120081217125-multi-campus', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
