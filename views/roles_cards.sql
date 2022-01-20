CREATE OR REPLACE VIEW roles_cards AS
WITH x AS (
    SELECT
        u.user_id,
        app.get_app_id()        AS app_id,
        app.is_developer_y()    AS is_developer
    FROM users u
    WHERE u.user_id = app.get_user_id()
)
SELECT
    r.role_id,
    r.role_name,
    r.description_,
    r.is_active,
    --
    COUNT(p.page_id)            AS count_pages
FROM (
    SELECT
        r.app_id,
        r.role_id,
        r.role_name,
        r.description_,
        r.is_active,
        --
        ROW_NUMBER() OVER(ORDER BY r.role_group NULLS LAST, r.order# NULLS LAST, r.role_id) AS sort#
    FROM roles r
    JOIN user_roles u
        ON u.app_id             = r.app_id
        AND u.role_id           = r.role_id
    JOIN x
        ON x.app_id             = u.app_id
        AND x.user_id           = u.user_id
    UNION ALL
    SELECT
        x.app_id,
        'IS_DEVELOPER'          AS role_id,
        'Developer'             AS role_name,
        '',
        'Y'                     AS is_active,
        0                       AS sort#
    FROM x
    WHERE x.is_developer        = 'Y'
) r
LEFT JOIN navigation n
    ON n.app_id                 = r.app_id
LEFT JOIN apex_application_pages p
    ON p.application_id         = n.app_id
    AND p.page_id               = n.page_id
    AND p.authorization_scheme  = r.role_id
GROUP BY
    r.role_id,
    r.role_name,
    r.description_,
    r.is_active,
    r.sort#
ORDER BY r.sort#;
--
COMMENT ON TABLE roles_cards IS '[CORE - DASHBOARD] Roles as cards for current user';

