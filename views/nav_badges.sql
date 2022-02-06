CREATE OR REPLACE VIEW nav_badges AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()            AS app_id,
        app.is_developer_y()        AS is_developer
    FROM DUAL
)
SELECT                              -- today errors on dashboard
    900                             AS page_id,
    ' '                             AS page_alias,
    TO_CHAR(NULLIF(COUNT(*), 0))    AS badge
FROM logs l
JOIN x
    ON x.app_id             = l.app_id
    AND x.is_developer      = 'Y'
    AND l.created_at        >= TRUNC(SYSDATE)
    AND l.flag              = 'E'
--
UNION ALL
SELECT                              -- today users
    915 AS page_id,
    ' ' AS page_alias,
    --
    TO_CHAR(NULLIF(COUNT(DISTINCT s.user_id), 0)) AS badge
FROM sessions s
JOIN x
    ON x.app_id             = s.app_id
    AND x.is_developer      = 'Y'
    AND s.created_at        >= TRUNC(SYSDATE)
--
UNION ALL
SELECT                              -- today events
    940 AS page_id,
    ' ' AS page_alias,
    --
    TO_CHAR(NULLIF(COUNT(*), 0)) AS badge
FROM log_events l
JOIN x
    ON x.app_id             = l.app_id
    AND x.is_developer      = 'Y'
    AND l.created_at        >= TRUNC(SYSDATE)
--
UNION ALL
SELECT                              -- pages to add/remove
    910 AS page_id,
    ' ' AS page_alias,
    --
    TO_CHAR(NULLIF(COUNT(*), 0)) AS badge
FROM nav_overview n
JOIN x
    ON x.app_id             = n.app_id
    AND x.is_developer      = 'Y'
    AND n.action            IS NOT NULL
--
UNION ALL
SELECT                              -- pages to add/remove
    970 AS page_id,
    ' ' AS page_alias,
    --
    TO_CHAR(NULLIF(COUNT(*), 0)) AS badge
FROM settings s
JOIN x
    ON x.app_id             = s.app_id
    AND x.is_developer      = 'Y'
    AND s.updated_at        >= TRUNC(SYSDATE)
--
UNION ALL
SELECT                              -- running jobs
    905 AS page_id,
    ' ' AS page_alias,
    --
    TO_CHAR(NULLIF(COUNT(*), 0))    AS badge
FROM user_scheduler_running_jobs j
--
UNION ALL
SELECT                              -- invalid objects
    950 AS page_id,
    ' ' AS page_alias,
    --
    TO_CHAR(NULLIF(COUNT(*), 0))    AS badge
FROM user_objects o
WHERE o.status              != 'VALID';
--
COMMENT ON TABLE  nav_badges                IS '[CORE - DASHBOARD] View with current badges in top menu';
--
COMMENT ON COLUMN nav_badges.page_id        IS 'Page ID with badge';
COMMENT ON COLUMN nav_badges.page_alias     IS 'Page alias when page has no ID and need badge';
COMMENT ON COLUMN nav_badges.badge          IS 'Badge value (string)';

