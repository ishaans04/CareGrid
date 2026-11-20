BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "app_user" ADD COLUMN "firebaseUid" text;
ALTER TABLE "app_user" ADD COLUMN "disabled" boolean NOT NULL DEFAULT false;
ALTER TABLE "app_user" ADD COLUMN "tokensValidAfter" timestamp without time zone;
CREATE UNIQUE INDEX "app_user_firebase_uid_idx" ON "app_user" USING btree ("firebaseUid");

--
-- MIGRATION VERSION FOR caregrid
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('caregrid', '20261119192626383-firebase-membership', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261119192626383-firebase-membership', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
