CREATE OR REPLACE VIEW sessions_overview AS
WITH s AS (
    SELECT
        s.*,
        app.get_item('$PAGE_ID')    AS page_id,
        TRUNC(s.created_at)         AS today
    FROM sessions s
    WHERE s.app_id          = app.get_app_id()
        AND (s.session_id   = app.get_item('$SESSION_ID')   OR app.get_item('$SESSION_ID')  IS NULL)
        AND (s.user_id      = app.get_item('$USER_ID')      OR app.get_item('$USER_ID')     IS NULL)
        --
        AND s.created_at    >= COALESCE(app.get_date_item('$TODAY'), TRUNC(SYSDATE))
        AND s.created_at    < COALESCE(app.get_date_item('$TODAY'), TRUNC(SYSDATE)) + 1
),
l AS (
    SELECT
        l.session_id,
        COUNT(*)                                                    AS count_logs,
        NULLIF(SUM(CASE WHEN l.flag = 'A' THEN 1 ELSE 0 END), 0)    AS count_requests,
        NULLIF(SUM(CASE WHEN l.flag = 'E' THEN 1 ELSE 0 END), 0)    AS count_errors
    FROM logs l
    JOIN s
        ON l.created_at     >= s.today
        AND l.created_at    < s.today + 1
        AND s.app_id        = l.app_id
    GROUP BY l.session_id
),
b AS (
    SELECT
        l.session_id,
        COUNT(*)            AS count_business
    FROM logs_events l
    JOIN s
        ON l.created_at     >= s.today
        AND l.created_at    < s.today + 1
        AND s.app_id        = l.app_id
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
    b.count_business,
    --
    s.created_at,
    s.updated_at,
    --
    app.get_duration(s.updated_at - s.created_at)           AS duration,
    app.get_icon('fa-trash-o', 'Delete session and logs')   AS action_delete
FROM s
LEFT JOIN l ON l.session_id = s.session_id
LEFT JOIN b ON b.session_id = s.session_id;

