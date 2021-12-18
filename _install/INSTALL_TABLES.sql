
--
-- TABLES
--
@../tables/apps.sql
@../tables/users.sql
@../tables/roles.sql
@../tables/user_roles.sql
--
@../tables/events.sql
@../tables/logs_events.sql
@../tables/logs_setup.sql
@../tables/logs.sql
--
@../tables/navigation.sql
@../tables/sessions.sql

--
-- DATA
--
INSERT INTO apps (app_id, app_name, is_active, updated_by, updated_at)
VALUES (
    770,
    'CORE',
    'Y',
    USER,
    SYSDATE
);
COMMIT;

--
-- SEQUENCES
--
@../sequences/log_id.sql

--
-- VIEWS
--
@../views/nav_pages_to_add.sql
@../views/nav_pages_to_remove.sql

--
-- PACKAGES
--
@../packages/app.spec.sql
@../packages/app.sql

--
-- PROCEDURES
--
@../procedures/recompile.sql
@../procedures/process_dml_errors.sql


