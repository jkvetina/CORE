CREATE OR REPLACE VIEW sessions_chart AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()                        AS app_id,
        app.get_number_item('$SESSION_ID')      AS session_id,
        app.get_item('$USER_ID')                AS user_id,
        app.get_date_item('G_TODAY')            AS today,
        10                                      AS buckets
    FROM DUAL
),
z AS (
    SELECT
        x.app_id,
        x.user_id,
        x.session_id,
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
    TO_CHAR(z.start_at, 'HH24:MI')      AS chart_label,
    --
    NULLIF(COUNT(DISTINCT CASE WHEN l.app_id = z.app_id THEN l.session_id   END), 0)    AS count_sessions,
    NULLIF(COUNT(DISTINCT CASE WHEN l.app_id = z.app_id THEN l.user_id      END), 0)    AS count_users,
    NULLIF(COUNT(DISTINCT CASE WHEN l.app_id = z.app_id THEN l.page_id      END), 0)    AS count_pages,
    --
    NULLIF(SUM(CASE WHEN l.app_id  = z.app_id AND l.flag = 'P' THEN 1 ELSE 0 END), 0)   AS count_requests,   -- app.flag_request
    NULLIF(SUM(CASE WHEN l.app_id != z.app_id AND l.flag = 'P' THEN 1 ELSE 0 END), 0)   AS count_others
FROM z
LEFT JOIN logs l
    ON l.created_at     >= z.today
    AND l.created_at    < z.today + 1
    AND (l.session_id   = z.session_id  OR z.session_id IS NULL)
    AND (l.user_id      = z.user_id     OR z.user_id    IS NULL)
    AND z.bucket_id     = app.get_time_bucket(l.created_at, z.buckets)
    AND l.user_id       NOT IN ('NOBODY')
GROUP BY z.bucket_id, TO_CHAR(z.start_at, 'HH24:MI');
--
COMMENT ON TABLE sessions_chart IS '[CORE - DASHBOARD] Chart for Sessions';

