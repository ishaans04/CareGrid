BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "incident" ADD COLUMN "revision" bigint NOT NULL DEFAULT 0;

--
-- MIGRATION VERSION FOR caregrid
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('caregrid', '20261120074107802-incident-revision', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261120074107802-incident-revision', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
