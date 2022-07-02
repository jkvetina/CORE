CREATE OR REPLACE VIEW obj_tables_ref_pages AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_owner()                 AS owner,
        app.get_app_id()                AS app_id,
        app.get_item('$TABLE_NAME')     AS table_name
    FROM DUAL
)
SELECT
    r.page_id,
    r.page_id || ' - ' || p.page_title || ', ' || r.region_name AS page_name,
    r.table_name                                                AS supplemental_info,
    --
    CASE WHEN r.table_name = x.table_name
        THEN r.page_id
        END AS list_badge,
    --
    CASE WHEN r.table_name = x.table_name
        THEN 0
        ELSE ROW_NUMBER() OVER (ORDER BY r.page_id, r.region_name) END AS sort#     ------- order#
FROM apex_application_page_regions r
JOIN apex_application_pages p
    ON p.application_id     = r.application_id
    AND p.page_id           = r.page_id
JOIN x
    ON x.app_id             = r.application_id
WHERE r.query_type_code     = 'TABLE'
    AND (
        r.table_name        = x.table_name
        OR r.table_name     IN (
            SELECT DISTINCT d.name                  AS view_name
            FROM all_dependencies d
            JOIN x
                ON x.owner                          = d.referenced_owner
                AND d.type                          = 'VIEW'
            CONNECT BY NOCYCLE d.referenced_name    = PRIOR d.name
                AND d.referenced_type               = 'VIEW'
            START WITH d.referenced_name            = x.table_name
                AND d.referenced_type               = 'TABLE'
        )
    );

