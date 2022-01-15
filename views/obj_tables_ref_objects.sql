CREATE OR REPLACE VIEW obj_tables_ref_objects AS
WITH x AS (
    SELECT
        app.get_app_id()                    AS app_id,
        app.get_item('$TABLE_NAME')         AS table_name
    FROM users u
    WHERE u.user_id = app.get_user_id()
)
SELECT
    d.referenced_name,
    d.referenced_type,
    d.path_
FROM (
    SELECT DISTINCT
        '<span style="margin-left: ' || ((LEVEL - 2) * 2) || 'rem;">' || d.referenced_name   || '</span>' AS referenced_name,
        '<span style="margin-left: ' || ((LEVEL - 2) * 2) || 'rem;">' || d.referenced_type   || '</span>' AS referenced_type,
        --
        SYS_CONNECT_BY_PATH(d.referenced_name, '/') AS path_,
        LEVEL                                       AS level_
    FROM user_dependencies d
    CROSS JOIN x
    WHERE d.referenced_owner        = 'CORE'                -- @TODO: hardcoded user
    CONNECT BY NOCYCLE PRIOR d.name = d.referenced_name
        AND LEVEL                   <= 3                    -- limit depth
    START WITH d.referenced_name    = x.table_name
) d
WHERE d.level_ > 1;

