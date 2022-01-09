CREATE OR REPLACE VIEW sessions_chart AS
WITH x AS (
    SELECT
        app.get_app_id()                AS app_id,
        app.get_item('$USER_ID')        AS user_id,
        app.get_date_item('G_TODAY')    AS today,
        10                              AS buckets
    FROM users u
    WHERE u.user_id = app.get_user_id()
),
z AS (
    SELECT
        x.app_id,
        x.user_id,
        x.today,
        x.buckets,
        --
        LEVEL                                                                   AS bucket_id,
        TRUNC(SYSDATE) + NUMTODSINTERVAL((LEVEL - 1) * x.buckets, 'MINUTE')     AS start_at,
        TRUNC(SYSDATE) + NUMTODSINTERVAL( LEVEL      * x.buckets, 'MINUTE')     AS end_at
    FROM x
    CONNECT BY LEVEL <= (1440 / x.buckets)
)
SELECT
    z.bucket_id,
    TO_CHAR(z.start_at, 'HH24:MI')                              AS chart_label,
    NULLIF(COUNT(DISTINCT l.session_id), 0)                     AS count_sessions,
    NULLIF(COUNT(DISTINCT l.user_id), 0)                        AS count_users,
    NULLIF(COUNT(DISTINCT l.page_id), 0)                        AS count_pages,
    NULLIF(SUM(CASE WHEN l.flag = 'P' THEN 1 ELSE 0 END), 0)    AS count_requests,   -- app.flag_request
    NULLIF(SUM(CASE WHEN o.flag = 'P' THEN 1 ELSE 0 END), 0)    AS count_others
FROM z
LEFT JOIN logs l
    ON l.created_at     >= z.today
    AND l.created_at    < z.today + 1
    AND (l.user_id      = z.user_id OR z.user_id IS NULL)
    AND l.app_id        = z.app_id
    AND z.bucket_id     = app.get_time_bucket(l.created_at, z.buckets)
LEFT JOIN logs o
    ON o.created_at     >= z.today
    AND o.created_at    < z.today + 1
    AND o.app_id        != z.app_id
    AND z.bucket_id     = app.get_time_bucket(o.created_at, z.buckets)
    AND o.user_id       = z.user_id
GROUP BY z.bucket_id, TO_CHAR(z.start_at, 'HH24:MI');

