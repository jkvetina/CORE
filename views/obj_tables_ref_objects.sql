CREATE OR REPLACE VIEW obj_tables_ref_objects AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()                    AS app_id,
        app.get_owner()                     AS owner_,
        app.get_item('$TABLE_NAME')         AS table_name
    FROM DUAL
)
SELECT
    '<span style="margin-left: 2rem;">' || d.name || '</SPAN>'      AS ref_name,
    LISTAGG(d.type, ', ') WITHIN GROUP (ORDER BY d.type)            AS ref_type,
    --
    CASE REPLACE(MIN(d.type), ' BODY', '')
        WHEN 'TRIGGER'      THEN app.get_page_link(952, in_names => 'P952_TRIGGER_NAME',    in_values => d.name)
        WHEN 'VIEW'         THEN app.get_page_link(955, in_names => 'P955_VIEW_NAME',       in_values => d.name)
        WHEN 'PACKAGE'      THEN app.get_page_link(960, in_names => 'P960_PACKAGE_NAME',    in_values => d.name)
        ELSE NULL
        END AS ref_link
FROM user_dependencies d
JOIN x
    ON x.owner_         = d.referenced_owner
    AND x.table_name    = d.referenced_name
GROUP BY d.name;

