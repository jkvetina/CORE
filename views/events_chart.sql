CREATE OR REPLACE VIEW events_chart AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()                        AS app_id,
        app.get_number_item('$EVENT_ID')        AS event_id,
        app.get_item('$USER_ID')                AS user_id,
        TRUNC(app.get_date_item('G_TODAY'))     AS today
    FROM DUAL
),
z AS (
    SELECT
        LEVEL                                                           AS bucket_id,
        TRUNC(SYSDATE) + NUMTODSINTERVAL((LEVEL - 1) * 10, 'MINUTE')    AS start_at,
        TRUNC(SYSDATE) + NUMTODSINTERVAL( LEVEL      * 10, 'MINUTE')    AS end_at
    FROM DUAL
    CONNECT BY LEVEL <= (1440 / 10)
)
SELECT
    z.bucket_id,
    TO_CHAR(z.start_at, 'HH24:MI')              AS chart_label,
    NULLIF(COUNT(e.event_id), 0)                AS count_events
FROM z
CROSS JOIN x
LEFT JOIN log_events e
    ON e.app_id         = x.app_id
    AND e.created_at    >= x.today
    AND e.created_at    < x.today + 1
    AND e.event_id      = NVL(x.event_id, e.event_id)
    AND e.user_id       = NVL(x.user_id, e.user_id)
    AND z.bucket_id     = app.get_time_bucket(e.created_at, 10)
GROUP BY z.bucket_id, TO_CHAR(z.start_at, 'HH24:MI');
--
COMMENT ON TABLE events_chart IS '[CORE - DASHBOARD] Chart for Events';

