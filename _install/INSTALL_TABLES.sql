
--
-- TABLES
--
@../tables/apps.sql
@../tables/users.sql
@../tables/roles.sql
@../tables/user_roles.sql
--
@../tables/events.sql
@../tables/log_events.sql
@../tables/logs.sql
@../tables/logs_setup.sql
--
@../tables/navigation.sql
@../tables/sessions.sql
--
@../tables/settings.sql
@../tables/setting_contexts.sql
@../tables/user_source_views.sql

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
-- PACKAGES
--
@../packages/app.spec.sql
@../packages/app_actions.spec.sql

--
-- VIEWS
--
@../views/roles_overview.sql
@../views/roles_auth_schemes.sql
@../views/roles_cards.sql
--
@../views/users_overview.sql
@../views/users_chart.sql
--
@../views/sessions_overview.sql
@../views/sessions_chart.sql
--
@../views/settings_overview.sql
--
@../views/dashboard_overview.sql
@../views/logs_overview.sql
@../views/logs_tree.sql
--
@../views/nav_pages_to_add.sql
@../views/nav_pages_to_remove.sql
@../views/nav_overview.sql
@../views/nav_badges.sql
@../views/nav_top.sql
--
@../views/events_chart.sql
--
@../views/grants_objects.sql
@../views/grants_privileges.sql
--
@../views/scheduler_details.sql
@../views/scheduler_planned.sql
@../views/scheduler_running.sql

--
-- PROCEDURES
--
@../procedures/recompile.sql
--@../procedures/process_dml_errors.sql

--
-- PACKAGES
--
@../packages/app.sql
@../packages/app_actions.sql

--
-- TRIGGERS
--
@../triggers/events__.sql
@../triggers/roles__.sql
@../triggers/setting_contexts__.sql
@../triggers/settings__.sql
@../triggers/user_roles__.sql
@../triggers/users__.sql

--
-- JOBS
--
@../jobs/purge_old_logs.sql



--
--
--
EXEC recompile;

