CREATE OR REPLACE VIEW logs_overview AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()                        AS app_id,
        app.get_number_item('$RECENT_LOG_ID')   AS recent_log_id,
        app.get_item('$FLAG')                   AS flag,
        app.get_number_item('$PAGE_ID')         AS page_id,
        app.get_item('$USER_ID')                AS user_id,
        app.get_number_item('$SESSION_ID')      AS session_id,
        app.get_item('$MODULE_NAME')            AS module_name,
        app.get_item('$ACTION_NAME')            AS action_name,
        app.get_date_item('G_TODAY')            AS today
    FROM DUAL
),
p AS (
    SELECT /*+ MATERIALIZE */
        p.page_id,
        NULLIF(p.page_group || ' - ', ' - ') || p.page_title AS page_title
    FROM apex_application_pages p
    JOIN x
        ON x.app_id     = p.application_id
)
SELECT
    l.log_id,
    l.log_parent,
    l.app_id,
    l.page_id,
    l.user_id,
    l.flag,
    l.action_name,
    l.module_name,
    l.module_line,
    l.module_timer,
    l.arguments,
    l.payload,
    l.session_id,
    l.created_at,
    --
    p.page_title
FROM logs l
JOIN x
    ON l.created_at     >= x.today
    AND l.created_at    < x.today + 1
    AND l.app_id        IN (x.app_id, 0)
    AND l.log_id        > NVL(x.recent_log_id, 0)
    AND l.flag          = NVL(x.flag, l.flag)
    AND l.page_id       = NVL(x.page_id, l.page_id)
    AND l.user_id       = NVL(x.user_id, l.user_id)
    AND l.session_id    = NVL(x.session_id, l.session_id)
    AND (l.module_name  = NVL(x.module_name, l.module_name) OR (l.module_name IS NULL AND x.module_name IS NULL))
    AND (l.action_name  = NVL(x.action_name, l.action_name) OR (l.action_name IS NULL AND x.action_name IS NULL))
LEFT JOIN p
    ON p.page_id        = l.page_id;
--
COMMENT ON TABLE logs_overview IS '[CORE - DASHBOARD] Logs';

