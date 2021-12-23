CREATE OR REPLACE VIEW nav_badges AS
WITH x AS (
    SELECT
        app.is_developer_y()        AS is_developer
    FROM users u
    WHERE u.user_id = app.get_user_id()
)
SELECT                              -- today errors on dashboard
    900                             AS page_id,
    ' '                             AS page_alias,
    TO_CHAR(NULLIF(COUNT(*), 0))    AS badge
FROM logs l
JOIN x
    ON x.is_developer       = 'Y'
WHERE l.created_at          >= TRUNC(SYSDATE)
    AND l.flag              = 'E'
--
UNION ALL
SELECT                              -- today users
    902 AS page_id,
    ' ' AS page_alias,
    --
    TO_CHAR(NULLIF(COUNT(DISTINCT s.user_id), 0)) AS badge
FROM sessions s
JOIN x
    ON x.is_developer       = 'Y'
WHERE s.created_at          >= TRUNC(SYSDATE)
--
UNION ALL
SELECT                              -- pages to add/remove
    910 AS page_id,
    ' ' AS page_alias,
    --
    TO_CHAR(NULLIF(COUNT(*), 0))    AS badge
FROM nav_overview n
WHERE n.app_id              = app.get_app_id()
    AND n.action            IS NOT NULL;
--
COMMENT ON TABLE nav_badges                 IS 'View with current badges in top menu';
--
COMMENT ON COLUMN nav_badges.page_id        IS 'Page ID with badge';
COMMENT ON COLUMN nav_badges.page_alias     IS 'Page alias when page has no ID and need badge';
COMMENT ON COLUMN nav_badges.badge          IS 'Badge value (string)';

