CREATE OR REPLACE VIEW sessions_pages AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()                        AS app_id,
        app.get_number_item('$SESSION_ID')      AS session_id,
        app.get_item('$USER_ID')                AS user_id,
        app.get_date_item('G_TODAY')            AS today
    FROM DUAL
),
p AS (
    SELECT
        l.page_id,
        l.user_id,
        TO_NUMBER(SUBSTR(l.module_timer, 1, 2)) * 1440 +
        TO_NUMBER(SUBSTR(l.module_timer, 4, 2)) * 60 +
        TO_NUMBER(SUBSTR(l.module_timer, 7, 2)) + TO_NUMBER('0.' || SUBSTR(l.module_timer, 10, 3)) AS page_timer
    FROM logs l
    JOIN x
        ON x.app_id         = l.app_id
        AND l.created_at    >= x.today
        AND l.created_at    < x.today + 1
        AND l.flag          = 'P'
        AND l.module_timer  IS NOT NULL
        AND (l.session_id   = x.session_id  OR x.session_id IS NULL)
        AND (l.user_id      = x.user_id     OR x.user_id    IS NULL)
),
r AS (
    SELECT
        n.page_id,
        a.page_title,
        COUNT(p.page_timer)                                 AS count_requests,
        COUNT(DISTINCT p.user_id)                           AS count_users,
        ROUND(AVG(p.page_timer), 2)                         AS avg_time,
        ROUND(MAX(p.page_timer), 2)                         AS max_time,
        ROUND(MAX(p.page_timer) - AVG(p.page_timer), 2)     AS diff_time
    FROM navigation n
    LEFT JOIN apex_application_pages a
        ON a.application_id     = n.app_id
        AND a.page_id           = n.page_id
    JOIN x
        ON x.app_id             = n.app_id
    LEFT JOIN p
        ON p.page_id            = n.page_id
    WHERE n.page_id             > 0
        AND n.page_id           < 1000
    GROUP BY n.page_id, a.page_title
)
SELECT
    r.page_id,
    r.page_title,
    r.count_requests,
    r.count_users,
    r.avg_time,
    r.max_time,
    r.diff_time,
    r.page_title || '\nRequests: <b>' || r.count_requests || '</b>'     AS tooltip_requests,
    r.page_title || '\nUsers: <b>' || r.count_users || '</b>'           AS tooltip_users,
    r.page_title || '\nAvg Time: <b>' || r.avg_time || '</b>'           AS tooltip_avg_time,
    r.page_title || '\nMax Time: <b>' || r.max_time || '</b>'           AS tooltip_max_time
FROM r;
--
COMMENT ON TABLE sessions_pages IS '[CORE - DASHBOARD] Pages Performance';

