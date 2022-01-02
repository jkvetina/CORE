CREATE OR REPLACE VIEW users_apps AS
WITH p AS (
    SELECT
        a.application_id        AS app_id,
        a.alias                 AS app_alias,
        a.application_group     AS app_group,
        a.owner                 AS app_schema,
        a.authentication_scheme,
        a.last_updated_on,
        a.pages                 AS count_pages,
        p.page_id
    FROM apex_applications a
    JOIN apex_application_pages p
        ON p.application_id     = a.application_id
        AND a.home_link         LIKE '%:' || p.page_alias || ':%'
)
SELECT
    a.app_id,
    a.app_name,
    p.app_alias,
    p.app_group,
    p.app_schema,
    --
    app.get_page_link (
        in_page_id      => p.page_id,
        in_app_id       => a.app_id
    ) AS app_url,
    --
    p.authentication_scheme,
    p.last_updated_on,
    p.count_pages,
    --
    a.is_active,
    a.is_visible,
    --
    CASE WHEN (
        a.is_visible    = 'Y'
        OR a.app_id IN (
            SELECT r.app_id
            FROM user_roles r
            WHERE r.user_id = app.get_user_id()
        )
    ) THEN 'Y' END AS is_available,
    --
    a.description_,
    a.message
FROM apps a
JOIN p
    ON p.app_id         = a.app_id
WHERE a.app_id          != app.get_core_app_id();
