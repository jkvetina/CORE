CREATE OR REPLACE VIEW dashboard_overview AS
WITH x AS (
    SELECT
        app.get_app_id()                        AS app_id
    FROM users u
    WHERE u.user_id = app.get_user_id()
),
s AS (
    SELECT
        TRUNC(s.created_at)                     AS today,
        NULLIF(COUNT(s.session_id), 0)          AS count_sessions,
        NULLIF(COUNT(DISTINCT s.user_id), 0)    AS count_users
    FROM sessions s
    JOIN x
        ON x.app_id = s.app_id
    GROUP BY TRUNC(s.created_at)
),
e AS (
    SELECT
        TRUNC(e.created_at)                     AS today,
        NULLIF(COUNT(e.event_id), 0)            AS count_events
    FROM logs_events e
    JOIN x
        ON x.app_id = e.app_id
    GROUP BY TRUNC(e.created_at)
),
l AS (
    SELECT
        TRUNC(l.created_at)                                         AS today,
        NULLIF(SUM(CASE WHEN l.flag = 'A' THEN 1 ELSE 0 END), 0)    AS count_requests,
        NULLIF(SUM(CASE WHEN l.flag = 'M' THEN 1 ELSE 0 END), 0)    AS count_modules,
        NULLIF(SUM(CASE WHEN l.flag = 'D' THEN 1 ELSE 0 END), 0)    AS count_debugs,
        NULLIF(SUM(CASE WHEN l.flag = 'R' THEN 1 ELSE 0 END), 0)    AS count_results,
        NULLIF(SUM(CASE WHEN l.flag = 'W' THEN 1 ELSE 0 END), 0)    AS count_warnings,
        NULLIF(SUM(CASE WHEN l.flag = 'E' THEN 1 ELSE 0 END), 0)    AS count_errors,
        NULLIF(SUM(CASE WHEN l.flag = 'L' THEN 1 ELSE 0 END), 0)    AS count_longops,
        NULLIF(SUM(CASE WHEN l.flag = 'G' THEN 1 ELSE 0 END), 0)    AS count_triggers
    FROM logs l
    JOIN x
        ON x.app_id = l.app_id
    GROUP BY TRUNC(l.created_at)
),
j AS (
    SELECT
        TRUNC(d.actual_start_date)                                  AS today,
        COUNT(d.log_id)                                             AS count_succeeded,
        SUM(CASE WHEN d.status = 'SUCCEEDED' THEN 0 ELSE 1 END)     AS count_failed
    FROM user_scheduler_job_run_details d
    WHERE d.actual_start_date >= TRUNC(SYSDATE) - 7
    GROUP BY TRUNC(d.actual_start_date)
)
--
SELECT
    LPAD(' ', TO_NUMBER(TO_CHAR(l.today, 'YYIW') - 2000)) || TO_CHAR(l.today, 'YYYY-IW') AS week,
    --
    TO_CHAR(l.today, 'YYYY-MM-DD') AS today,
    --
    l.count_requests,
    l.count_modules,
    l.count_debugs,
    l.count_results,
    l.count_warnings,
    l.count_errors,
    l.count_longops,
    l.count_triggers,
    --
    s.count_sessions,
    s.count_users,
    e.count_events,
    --
    NULLIF(j.count_succeeded - j.count_failed, 0)       AS count_succeeded,
    NULLIF(j.count_failed, 0)                           AS count_failed,
    --
    app.get_icon('fa-trash-o', 'Delete related logs')   AS action
FROM l
LEFT JOIN s ON s.today = l.today
LEFT JOIN e ON e.today = l.today
LEFT JOIN j ON j.today = l.today;

