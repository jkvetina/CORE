CREATE OR REPLACE VIEW grants_objects AS
SELECT
    r.privilege,
    r.role,
    NULL                AS user_id,
    r.owner,
    r.table_name        AS object_name,
    NULL                AS object_type,
    --
    CASE WHEN r.inherited = 'YES'   THEN 'Y' END AS is_inherited,
    CASE WHEN r.grantable = 'YES'   THEN 'Y' END AS is_grantable,
    --
    NULL                AS grantor
FROM role_tab_privs r
UNION ALL
--
SELECT
    u.privilege,
    NULL                AS role,
    u.grantee           AS user_id,
    u.owner,
    u.table_name        AS object_name,
    u.type              AS object_type,
    --
    CASE WHEN u.inherited = 'YES'   THEN 'Y' END AS is_inherited,
    CASE WHEN u.grantable = 'YES'   THEN 'Y' END AS is_grantable,
    --
    u.grantor
FROM user_tab_privs u;
--
COMMENT ON TABLE grants_objects IS '[CORE - DASHBOARD] Grants';

