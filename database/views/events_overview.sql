CREATE OR REPLACE FORCE VIEW events_overview AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()                        AS app_id,
        app.get_item('$EVENT_ID')               AS event_id,
        app.get_item('$USER_ID')                AS user_id,
        TRUNC(app.get_date_item('G_TODAY'))     AS today
    FROM DUAL
),
l AS (
    SELECT
        l.event_id,
        COUNT(*)            AS count_events
    FROM x
    JOIN log_events l
        ON l.app_id         = x.app_id
        AND l.created_at    >= x.today
        AND l.created_at    < x.today + 1
        AND l.event_id      = NVL(x.event_id, l.event_id)
        AND l.user_id       = NVL(x.user_id, l.user_id)
    GROUP BY l.event_id
)
SELECT
    e.event_id,
    e.event_name,
    e.event_group,
    e.description_,
    e.is_active,
    --
    l.count_events
FROM events e
JOIN x
    ON x.app_id             = e.app_id
    AND (x.event_id         = e.event_id OR x.event_id IS NULL)
LEFT JOIN l
    ON l.event_id           = e.event_id;
--
COMMENT ON TABLE events_overview IS '[CORE - DASHBOARD] Events overview';

