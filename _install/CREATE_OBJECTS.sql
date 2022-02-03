
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
@../tables/logs_blacklist.sql
--
@../tables/navigation.sql
@../tables/sessions.sql
--
@../tables/settings.sql
@../tables/setting_contexts.sql
@../tables/user_source_views.sql

--
-- SEQUENCES
--
@../sequences/log_id.sql

--
-- PACKAGES
--
@../packages/app.spec.sql
@../packages/app_actions.spec.sql
@../packages/a770.spec.sql

--
-- VIEWS
--
@../views/roles_overview.sql
@../views/roles_auth_schemes.sql
@../views/roles_cards.sql
--
@../views/users_overview.sql
@../views/users_apps.sql
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
@../views/nav_regions.sql
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
@../packages/a770.sql

--
-- TRIGGERS
--
@../triggers/apps__.sql
@../triggers/events__.sql
@../triggers/logs_blacklist__.sql
@../triggers/navigation__.sql
@../triggers/roles__.sql
@../triggers/setting_contexts__.sql
@../triggers/settings__.sql
@../triggers/user_roles__.sql
@../triggers/users__.sql

--
--
--
EXEC recompile;

--
-- JOBS
--
@../jobs/purge_old_logs.sql



--
-- SEED DATA
--
INSERT INTO apps (app_id, app_name, is_active, updated_by, updated_at)
VALUES (
    770,
    'CORE',
    'Y',
    USER,
    SYSDATE
);
--
COMMIT;

INSERT INTO roles (app_id, role_id, role_name, is_active)
VALUES (
    770,
    'IS_ADMINISTRATOR',
    'Administrator',
    'Y'
);
--
COMMIT;

--
-- NAVIGATION
--
SET DEFINE OFF;
DELETE FROM navigation;
--
INSERT INTO navigation (app_id, page_id, parent_id, order#)
SELECT 770, 0,      NULL,   599     FROM DUAL UNION ALL
SELECT 770, 100,    NULL,   100     FROM DUAL UNION ALL
SELECT 770, 990,    NULL,   990     FROM DUAL UNION ALL
SELECT 770, 995,    990,    NULL    FROM DUAL UNION ALL
SELECT 770, 9999,   NULL,   999     FROM DUAL UNION ALL
--
SELECT 770, 900,    NULL,   900     FROM DUAL UNION ALL
SELECT 770, 901,    900,    10      FROM DUAL UNION ALL
SELECT 770, 902,    901,    10      FROM DUAL UNION ALL
SELECT 770, 925,    900,    15      FROM DUAL UNION ALL
SELECT 770, 915,    900,    20      FROM DUAL UNION ALL
SELECT 770, 920,    900,    25      FROM DUAL UNION ALL
SELECT 770, 905,    900,    30      FROM DUAL UNION ALL
SELECT 770, 940,    900,    35      FROM DUAL UNION ALL
SELECT 770, 910,    900,    40      FROM DUAL UNION ALL
SELECT 770, 945,    900,    45      FROM DUAL UNION ALL
SELECT 770, 970,    900,    50      FROM DUAL;
--
UPDATE navigation n
SET n.is_reset  = CASE WHEN n.page_id > 0 THEN 'Y' END,
    n.is_shared = CASE WHEN n.page_id >= 900 AND n.page_id < 9999 THEN 'Y' END;
--
COMMIT;

--
-- settings
--



