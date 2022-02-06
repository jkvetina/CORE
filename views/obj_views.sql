CREATE OR REPLACE VIEW obj_views AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()                            AS app_id,
        app.get_core_app_id()                       AS core_app_id,
        app.get_item('$VIEW_NAME')                  AS view_name,
        --
        UPPER(app.get_item('$SEARCH_VIEWS'))        AS search_views,
        UPPER(app.get_item('$SEARCH_COLUMNS'))      AS search_columns,
        LOWER(app.get_item('$SEARCH_SOURCE'))       AS search_source
    FROM DUAL
),
r AS (
    SELECT
        d.name AS view_name,
        --
        NULLIF(SUM(CASE WHEN d.referenced_type IN ('TABLE', 'VIEW') THEN 1 ELSE 0 END), 0) AS count_references,
        --
        LISTAGG(CASE WHEN d.referenced_type = 'TABLE'
            THEN app_actions.get_html_a(app_actions.get_object_link(d.referenced_type, d.referenced_name), d.referenced_name) END, ', ')
            WITHIN GROUP (ORDER BY d.referenced_name)
            AS referenced_tables,
        --
        LISTAGG(CASE WHEN d.referenced_type = 'VIEW'
            THEN app_actions.get_html_a(app_actions.get_object_link(d.referenced_type, d.referenced_name), d.referenced_name) END, ', ')
            WITHIN GROUP (ORDER BY d.referenced_name)
            AS referenced_views
    FROM user_dependencies d
    CROSS JOIN x
    WHERE d.type        = 'VIEW'
        AND d.name      = NVL(x.view_name, d.name)
        AND (d.name     LIKE '%' || x.search_views || '%' ESCAPE '\' OR x.search_views IS NULL)
    GROUP BY d.name
),
u AS (
    SELECT
        d.referenced_name       AS view_name,
        --
        LISTAGG(app_actions.get_html_a(app_actions.get_object_link(d.type, d.name), d.name), ', ')
            WITHIN GROUP (ORDER BY d.name) AS used_in_objects
    FROM user_dependencies d
    WHERE d.referenced_type     = 'VIEW'
    GROUP BY d.referenced_name
),
p AS (
    SELECT
        r.table_name,
        LISTAGG(DISTINCT app_actions.get_html_a(app.get_page_url(910, 'P910_PAGE_ID', r.page_id), r.page_id), ', ')
            WITHIN GROUP (ORDER BY r.page_id) AS used_on_pages
    FROM apex_application_page_regions r
    JOIN x
        ON x.app_id             = r.application_id
    WHERE r.query_type_code     = 'TABLE'
    GROUP BY r.table_name
),
s AS (
    SELECT
        s.name                  AS view_name,
        COUNT(s.line)           AS count_lines,
        --
        MAX(CASE WHEN LOWER(s.text) LIKE '%' || x.search_source || '%' ESCAPE '\' THEN 'Y' END) AS is_found_text
    FROM user_source_views s
    CROSS JOIN x
    GROUP BY s.name
),
v AS (
    SELECT
        v.view_name,
        v.read_only,
        v.bequeath,
        o.last_ddl_time
    FROM user_views v
    JOIN user_objects o
        ON o.object_name        = v.view_name
        AND o.object_type       = 'VIEW'
    CROSS JOIN x
    WHERE v.view_name           = NVL(x.view_name, v.view_name)
        AND (v.view_name        LIKE '%' || x.search_views || '%' ESCAPE '\' OR x.search_views IS NULL)
),
c AS (
    SELECT
        c.table_name            AS view_name,
        COUNT(c.column_name)    AS count_columns,
        --
        LOWER(LISTAGG(c.column_name, ', ') WITHIN GROUP (ORDER BY c.column_id)) AS list_columns,
        --
        MAX(CASE WHEN c.column_name LIKE x.search_columns || '%' ESCAPE '\' THEN 'Y' END) AS is_found_column
    FROM user_tab_cols c
    CROSS JOIN x
    WHERE c.table_name          = NVL(x.view_name, c.table_name)
        AND (c.table_name       LIKE '%' || x.search_views || '%' ESCAPE '\' OR x.search_views IS NULL)
    GROUP BY c.table_name
)
SELECT
    CASE
        WHEN c.comments LIKE '[%]%'
            THEN REGEXP_SUBSTR(c.comments, '^\[([^]]+)\]', 1, 1, NULL, 1)
        ELSE REGEXP_SUBSTR(REGEXP_REPLACE(v.view_name, '^P\d+$', 'PAGE#'), '^[^_]+')
        END ||
        CASE WHEN REGEXP_SUBSTR(REGEXP_REPLACE(v.view_name, '^P\d+$', 'PAGE#'), '^[^_]+') = 'OBJ'
            AND p.used_on_pages IS NOT NULL
            THEN ' - ' || app.get_page_title(REGEXP_REPLACE(p.used_on_pages, '<.*?>', ''), x.core_app_id)
            END AS view_group,
    --
    v.view_name,
    --
    c.count_columns,
    c.list_columns,
    s.count_lines,
    --
    u.used_in_objects,
    p.used_on_pages,
    r.referenced_tables,
    r.referenced_views,
    r.count_references,
    --
    NULLIF(v.read_only, 'N')                                        AS is_readonly,
    CASE WHEN v.bequeath = 'DEFINER' THEN 'Y' END                   AS is_definer,
    LTRIM(RTRIM(REGEXP_REPLACE(c.comments, '^\[[^]]+\]\s*', '')))   AS comments,
    --
    v.last_ddl_time
FROM v
JOIN c
    ON c.view_name              = v.view_name
LEFT JOIN r
    ON r.view_name              = v.view_name
LEFT JOIN u
    ON u.view_name              = v.view_name
LEFT JOIN p
    ON p.table_name             = v.view_name
CROSS JOIN x
LEFT JOIN s
    ON s.view_name              = v.view_name
LEFT JOIN user_tab_comments c
    ON c.table_name             = v.view_name
WHERE (c.is_found_column = 'Y'  OR x.search_columns IS NULL)
    AND (s.is_found_text = 'Y'  OR x.search_source IS NULL);

