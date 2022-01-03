CREATE OR REPLACE VIEW sessions_chart AS
WITH z AS (
    SELECT
        LEVEL                                                           AS bucket_id,
        TRUNC(SYSDATE) + NUMTODSINTERVAL((LEVEL - 1) * 10, 'MINUTE')    AS start_at,
        TRUNC(SYSDATE) + NUMTODSINTERVAL( LEVEL      * 10, 'MINUTE')    AS end_at
    FROM DUAL
    CONNECT BY LEVEL <= (1440 / 10)
)
SELECT
    z.bucket_id,
    TO_CHAR(z.start_at, 'HH24:MI')                              AS chart_label,
    NULLIF(COUNT(DISTINCT l.session_id), 0)                     AS count_sessions,
    NULLIF(COUNT(DISTINCT l.user_id), 0)                        AS count_users,
    NULLIF(COUNT(DISTINCT l.page_id), 0)                        AS count_pages,
    NULLIF(SUM(CASE WHEN l.flag = 'P' THEN 1 ELSE 0 END), 0)    AS count_requests    -- app.flag_request
FROM z
LEFT JOIN logs l
    ON l.created_at     >= TRUNC(app.get_date_item('G_TODAY'))
    AND l.created_at    < TRUNC(app.get_date_item('G_TODAY')) + 1
    AND l.app_id        = app.get_app_id()
    AND z.bucket_id     = app.get_time_bucket(l.created_at, 10)
GROUP BY z.bucket_id, TO_CHAR(z.start_at, 'HH24:MI');

