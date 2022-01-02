CREATE OR REPLACE VIEW users_apps AS
SELECT
    a.app_id,
    a.app_name,
    a.description_,
    a.message,
    a.is_visible,
    --
    app.get_page_link (
        in_page_id      => 100,         -- @TODO: might not be correct home page
        in_app_id       => a.app_id
        --in_session_id   =>
    ) AS app_url,
    --
    CASE WHEN a.app_id = app.get_proxy_app_id() THEN 'fa-anchor' END AS app_icon
FROM apps a
WHERE (
        a.is_visible = 'Y'
        OR a.app_id IN (
            SELECT r.app_id
            FROM user_roles r
            WHERE r.user_id = app.get_user_id()
        )
    )
    AND a.is_active = 'Y';
