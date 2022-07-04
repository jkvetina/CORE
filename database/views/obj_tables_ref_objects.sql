CREATE OR REPLACE FORCE VIEW obj_tables_ref_objects AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_owner()                 AS owner,
        app.get_app_id()                AS app_id,
        app.get_item('$TABLE_NAME')     AS table_name
    FROM DUAL
)
SELECT
    '<span style="margin-left: 2rem;">' || d.name || '</SPAN>'      AS ref_name,
    LISTAGG(d.type, ', ') WITHIN GROUP (ORDER BY d.type)            AS ref_type,
    --
    app_actions.get_object_link(REPLACE(MIN(d.type), ' BODY', ''), d.name) AS ref_link
FROM all_dependencies d
JOIN x
    ON x.owner          = d.referenced_owner
    AND x.table_name    = d.referenced_name
GROUP BY d.name;
--
COMMENT ON TABLE obj_tables_ref_objects IS '';

