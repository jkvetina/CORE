
--
-- TABLES
--
@../database/tables/apps.sql
@../database/tables/users.sql
@../database/tables/roles.sql
@../database/tables/user_roles.sql
--
@../database/tables/events.sql
@../database/tables/log_events.sql
@../database/tables/logs.sql
@../database/tables/logs_blacklist.sql
--
@../database/tables/navigation.sql
@../database/tables/sessions.sql
--
@../database/tables/settings.sql
@../database/tables/setting_contexts.sql
@../database/tables/obj_views_source.sql
--
@../database/tables/mail_schedules.sql
@../database/tables/mail_templates.sql
@../database/tables/mail_subscriptions.sql
@../database/tables/mail_queue.sql
--
@../database/tables/user_messages.sql
@../database/tables/translated_items.sql
@../database/tables/translated_messages.sql

--
-- SEQUENCES
--
@../database/sequences/log_id.sql
@../database/sequences/queue_id.sql

--
-- PACKAGES
--
@../database/packages/app.spec.sql
@../database/packages/a770.spec.sql

--
-- VIEWS - IGNORE ERRORS
--
@../database/views/dashboard_overview.sql
@../database/views/events_chart.sql
@../database/views/events_overview.sql
@../database/views/grants_objects.sql
@../database/views/grants_privileges.sql
@../database/views/logs_overview.sql
@../database/views/logs_tree.sql
@../database/views/lov_app_schemas.sql
@../database/views/nav_badges.sql
@../database/views/nav_overview.sql
@../database/views/nav_pages_to_add.sql
@../database/views/nav_pages_to_remove.sql
@../database/views/nav_regions.sql
@../database/views/nav_top.sql
@../database/views/obj_arguments.sql
@../database/views/obj_columns.sql
@../database/views/obj_constraints_fix_dt1.sql
@../database/views/obj_constraints_fix_dt2.sql
@../database/views/obj_constraints.sql
@../database/views/obj_indexes_missing.sql
@../database/views/obj_indexes.sql
@../database/views/obj_modules.sql
@../database/views/obj_overview.sql
@../database/views/obj_packages_settings.sql
@../database/views/obj_packages.sql
@../database/views/obj_partitions.sql
@../database/views/obj_sequences.sql
@../database/views/obj_tables_ref_down.sql
@../database/views/obj_tables_ref_objects.sql
@../database/views/obj_tables_ref_pages.sql
@../database/views/obj_tables_ref_up.sql
@../database/views/obj_tables.sql
@../database/views/obj_triggers.sql
@../database/views/obj_view_columns.sql
@../database/views/obj_views.sql
@../database/views/roles_auth_schemes.sql
@../database/views/roles_cards.sql
@../database/views/roles_overview.sql
@../database/views/scheduler_details.sql
@../database/views/scheduler_planned.sql
@../database/views/scheduler_running.sql
@../database/views/sessions_chart.sql
@../database/views/sessions_overview.sql
@../database/views/sessions_pages.sql
@../database/views/settings_overview.sql
@../database/views/translated_items_overview.sql
@../database/views/translated_messages_overview.sql
@../database/views/translations_current.sql
@../database/views/translations_extracts.sql
@../database/views/translations_new.sql
@../database/views/translations_slipped.sql
@../database/views/translations_unused.sql
@../database/views/user_messages_chat.sql
@../database/views/user_messages_chats.sql
@../database/views/users_apps.sql
@../database/views/users_overview.sql

--
-- PACKAGES
--
@../database/packages/app_actions.spec.sql

--
-- MVIEWS
--
@../database/mviews/nav_availability_mvw.sql
@../database/mviews/nav_overview_mvw.sql
@../database/mviews/obj_modules_mvw.sql

--
-- PROCEDURES
--
@../database/procedures/recompile.sql
--@../database/procedures/process_dml_errors.sql

--
-- PACKAGES
--
@../database/packages/app.sql
@../database/packages/app_actions.sql
@../database/packages/a770.sql

--
-- TRIGGERS
--
@../database/triggers/events__.sql
@../database/triggers/mail_subscriptions__.sql
@../database/triggers/setting_contexts__.sql
@../database/triggers/settings__.sql
@../database/triggers/users__.sql

--
--
--
EXEC recompile;

--
-- JOBS
--
@../database/jobs/core_purge_logs.sql
@../database/jobs/core_sync_logs.sql



--
-- SEED DATA
--
INSERT INTO apps (app_id, description_, is_visible, updated_by, updated_at)
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



--
-- REFRESH ALL MVW
--
BEGIN
    FOR c IN (
        SELECT m.mview_name
        FROM user_mviews m
        ORDER BY 1
    ) LOOP
        DBMS_MVIEW.REFRESH(c.mview_name, 'C', parallelism => 1);
    END LOOP;
END;
/

