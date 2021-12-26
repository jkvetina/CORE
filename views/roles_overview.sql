CREATE OR REPLACE VIEW roles_overview AS
SELECT
    r.app_id,
    --
    u.count_users,
    --
    r.role_id,
    r.role_name,
    r.role_group,
    r.description_,
    r.is_active,
    r.order#,
    r.updated_by,
    r.updated_at
FROM roles r
LEFT JOIN (
    SELECT
        u.role_id,
        COUNT(*)        AS count_users
    FROM user_roles u
    WHERE u.app_id      = app.get_app_id()
    GROUP BY u.role_id
) u
    ON u.role_id        = r.role_id
WHERE r.app_id          = app.get_app_id();

