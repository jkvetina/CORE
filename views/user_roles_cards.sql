CREATE OR REPLACE VIEW user_roles_cards AS
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
    WHERE u.app_id              = app.get_app_id()
        AND u.user_id           = app.get_user_id()
    UNION ALL
    SELECT
        app.get_app_id()        AS app_id,
        'IS_DEVELOPER'          AS role_id,
        'Developer'             AS role_name,
        'Basically a God',
        'Y'                     AS is_active,
        0                       AS sort#
    FROM DUAL
    WHERE app.is_developer_y()  = 'Y'
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

