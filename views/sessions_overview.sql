CREATE OR REPLACE VIEW sessions_overview AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()                        AS app_id,
        app.get_number_item('$SESSION_ID')      AS session_id,
        app.get_item('$USER_ID')                AS user_id,
        app.get_date_item('G_TODAY')            AS today
    FROM DUAL
),
s AS (
    SELECT
        s.*,
        TRUNC(s.created_at)         AS today
    FROM sessions s
    JOIN x
        ON s.app_id         = x.app_id
        AND (s.session_id   = x.session_id  OR x.session_id IS NULL)
        AND (s.user_id      = x.user_id     OR x.user_id    IS NULL)
        AND s.created_at    >= x.today
        AND s.created_at    < x.today + 1
    WHERE s.user_id         NOT IN ('NOBODY')
),
l AS (
    SELECT
        l.session_id,
        COUNT(*)                                                    AS count_logs,
        NULLIF(SUM(CASE WHEN l.flag = 'P' THEN 1 ELSE 0 END), 0)    AS count_requests,
        NULLIF(SUM(CASE WHEN l.flag = 'E' THEN 1 ELSE 0 END), 0)    AS count_errors
    FROM logs l
    JOIN s
        ON l.created_at     >= s.today
        AND l.created_at    < s.today + 1
        AND s.app_id        = l.app_id
        AND s.session_id    = l.session_id
    GROUP BY l.session_id
),
b AS (
    SELECT
        l.session_id,
        COUNT(*)            AS count_events
    FROM log_events l
    JOIN s
        ON l.created_at     >= s.today
        AND l.created_at    < s.today + 1
        AND s.app_id        = l.app_id
        AND s.session_id    = l.session_id
    GROUP BY l.session_id
)
SELECT
    s.app_id,
    s.session_id,
    s.user_id,
    --
    l.count_requests,
    l.count_logs,
    l.count_errors,
    b.count_events,
    --
    s.created_at,
    s.updated_at,
    --
    app.get_duration(s.updated_at - s.created_at)           AS duration,
    app.get_icon('fa-trash-o', 'Delete session and logs')   AS action_delete
FROM s
LEFT JOIN l ON l.session_id = s.session_id
LEFT JOIN b ON b.session_id = s.session_id;
--
COMMENT ON TABLE sessions_overview IS '[CORE - DASHBOARD] Sessions';

