-- Run as the database/schema owner against the caregrid database, before the
-- first maintenance migration. PG15+ does not universally grant public CREATE.
-- This grants the explicit staging user, never PUBLIC.
GRANT CONNECT, TEMPORARY ON DATABASE caregrid TO caregrid;
GRANT USAGE, CREATE ON SCHEMA public TO caregrid;

-- Verify while connected as caregrid before migrating:
-- SELECT has_schema_privilege(current_user, 'public', 'USAGE,CREATE');
