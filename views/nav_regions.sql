CREATE OR REPLACE VIEW nav_regions AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()                    AS app_id,
        app.get_number_item('$PAGE_ID')     AS page_id,
        app.get_item('$AUTH_SCHEME')        AS auth_scheme
    FROM DUAL
),
c AS (
    SELECT
        r.region_id,
        c.table_name,
        --c.data_length, c.nullable
        c.column_name,
        --
        CASE REGEXP_REPLACE(c.data_type, '\(\d+\)', '')
            WHEN 'CHAR'                     THEN 'VARCHAR2'
            WHEN 'INTERVAL DAY TO SECOND'   THEN 'INTERVAL_D2S'
            WHEN 'TIMESTAMP WITH TIME ZONE' THEN 'TIMESTAMP_TZ'
            ELSE REGEXP_REPLACE(c.data_type, '\(\d+\)', '')
            END AS data_type
    FROM user_tab_cols c
    JOIN apex_application_page_regions r
        ON r.table_name             = c.table_name
    JOIN x
        ON x.app_id                 = r.application_id
    WHERE r.source_type_code        = 'NATIVE_IG'
        AND r.query_type_code       = 'TABLE'
),
b AS (
    SELECT
        c.region_id,
        r.table_name,
        --c.max_length, c.is_required,
        c.source_expression         AS column_name,
        c.data_type
    FROM apex_appl_page_ig_columns c
    JOIN apex_application_page_regions r
        ON r.application_id         = c.application_id
        AND r.region_id             = c.region_id
    JOIN x
        ON x.app_id                 = r.application_id
    WHERE r.source_type_code        = 'NATIVE_IG'
        AND r.query_type_code       = 'TABLE'
        AND c.source_type_code      = 'DB_COLUMN'
        AND c.data_type             NOT IN ('ROWID')
),
d AS (
    SELECT
        NVL(c.region_id, b.region_id)       AS region_id,
        NVL(c.table_name, b.table_name)     AS table_name,
        --
        LISTAGG(CASE
            WHEN c.table_name IS NULL THEN 'Removed '   || b.column_name || ' (' || b.data_type || ')'
            WHEN b.table_name IS NULL THEN 'Added '     || c.column_name || ' (' || c.data_type || ')'
            ELSE 'Changed ' || b.column_name || ' from ' || b.data_type || ' to ' || c.data_type
            END, CHR(10)) WITHIN GROUP (ORDER BY b.column_name, c.column_name) AS fix_sync
    FROM b
    FULL JOIN c
        ON c.region_id              = b.region_id
        AND c.table_name            = b.table_name
        AND c.column_name           = b.column_name
    WHERE NVL(c.data_type, '-')     != NVL(b.data_type, '-')
    GROUP BY NVL(c.region_id, b.region_id), NVL(c.table_name, b.table_name)
),
da AS (
    SELECT
        d.page_id,
        d.when_region_id            AS region_id,
        COUNT(*)                    AS count_da
    FROM apex_application_page_da d
    JOIN x
        ON x.app_id                 = d.application_id
    GROUP BY d.page_id, d.when_region_id
)
SELECT
    p.page_group || ' ' || r.page_id || ' ' || p.page_title AS page_group,
    r.page_id,
    --r.region_id,
    --
    CASE WHEN r.icon_css_classes IS NOT NULL THEN app.get_icon(r.icon_css_classes) END AS region_icon,
    --
    CASE
        WHEN r.template != 'Hero'
            THEN REPLACE(RPAD(' ', 3), ' ', '&' || 'nbsp; ')
            END || r.region_name AS region_name,
    --
    --r.parent_region_id,
    --r.source_type,
    --r.source_type_code,
    --
    CASE
        WHEN r.source_type_code = 'NATIVE_IG'
            THEN r.source_type
            ELSE r.template
            END AS template,
    --
    CASE
        WHEN r.source_type_code = 'NATIVE_IG' AND r.static_id IS NULL
            THEN app.get_icon('fa-warning')
            ELSE r.static_id
            END AS static_id,
    --
    CASE
        WHEN r.query_type_code = 'SQL'
            THEN app.get_icon('fa-warning')
            ELSE r.table_name
            END AS table_name,
    --
    app.get_page_link (
        in_page_id => CASE
            WHEN t.object_type = 'TABLE' THEN 951
            WHEN t.object_type = 'VIEW'  THEN 955
            END,
        in_names => CASE
            WHEN t.object_type = 'TABLE' THEN 'P951_TABLE_NAME'
            WHEN t.object_type = 'VIEW'  THEN 'P955_VIEW_NAME'
            END,
        in_values => r.table_name
    ) AS table_link,
    --
    CASE
        WHEN r.source_type_code != 'NATIVE_IG'
            THEN NULL
        WHEN NVL(g.add_row_if_empty, 'No')  = 'No'
            AND g.select_first_row          = 'No'
            AND g.pagination_type           = 'Page'
            AND g.show_total_row_count      = 'Yes'
            AND g.toolbar_buttons           = 'SEARCH_COLUMN:SEARCH_FIELD:ACTIONS_MENU:SAVE'
            --
            AND REGEXP_REPLACE(g.javascript_code, '\s+', ' ') LIKE 'function(config) { return unified_ig_toolbar(config%'
        THEN NULL
        ELSE app.get_icon('fa-warning', RTRIM (
                CASE WHEN NVL(g.add_row_if_empty, 'No') = 'No'      THEN NULL ELSE 'ADD_ROW_IF_EMPTY, '     END ||
                CASE WHEN g.select_first_row            = 'No'      THEN NULL ELSE 'SELECT_FIRST_ROW, '     END ||
                CASE WHEN g.pagination_type             = 'Page'    THEN NULL ELSE 'PAGINATION_TYPE, '      END ||
                CASE WHEN g.show_total_row_count        = 'Yes'     THEN NULL ELSE 'SHOW_TOTAL_ROW_COUNT, ' END ||
                --
                CASE WHEN REGEXP_REPLACE(g.javascript_code, '\s+', ' ') LIKE 'function(config) { return unified_ig_toolbar(config%' THEN NULL ELSE 'JAVASCRIPT_CODE' END,
            ', '))
        END AS fix_setup,
    --
    CASE WHEN d.fix_sync IS NOT NULL THEN app.get_icon('fa-warning', d.fix_sync) END AS fix_sync,
    --
    CASE
        WHEN r.source_type_code     != 'NATIVE_IG'
            THEN NULL
        WHEN r.source_type_code     = 'NATIVE_IG'
            AND g.is_editable       = 'No'
            THEN NULL
        WHEN r.source_type_code     = 'NATIVE_IG'
            AND s.process_name      = 'SAVE_' || r.static_id
            AND s.process_type_code = 'NATIVE_IG_DML'
            AND s.attribute_06      = 'N'   -- lock_row
            THEN NULL
        ELSE app.get_icon('fa-warning', RTRIM (
                CASE WHEN r.source_type_code    = 'NATIVE_IG'               THEN NULL ELSE 'SOURCE_TYPE, '  END ||
                CASE WHEN s.process_name        = ' SAVE_' || r.static_id   THEN NULL ELSE 'PROCESS_NAME, ' END ||
                CASE WHEN s.process_type_code   = 'NATIVE_IG_DML'           THEN NULL ELSE 'PROCESS_TYPE, ' END ||
                CASE WHEN s.attribute_06        = 'N'                       THEN NULL ELSE 'LOCK_ROW, '     END,
            ', '))
        END AS fix_handler,
    --
    CASE WHEN g.edit_operations LIKE '%i%' THEN 'Y' END AS is_ins_allowed,
    CASE WHEN g.edit_operations LIKE '%u%' THEN 'Y' END AS is_upd_allowed,
    CASE WHEN g.edit_operations LIKE '%d%' THEN 'Y' END AS is_del_allowed,
    --
    NULLIF(r.items, 0)              AS count_items,
    NULLIF(r.buttons, 0)            AS count_buttons,
    NULLIF(da.count_da, 0)          AS count_da,
    --
    CASE WHEN r.where_clause        IS NOT NULL THEN 'Y' END AS is_where_clause,
    CASE WHEN r.condition_type_code IS NOT NULL THEN 'Y' END AS is_conditional,
    --
    s.attribute_01      AS target_type,
    s.attribute_03      AS target_name,
    --
    CASE
        WHEN r.source_type_code         = 'NATIVE_IG'
            AND s.when_button_pressed   IS NOT NULL
            THEN 'Y' END AS is_grid_button,
    --
    CASE
        WHEN r.source_type_code         = 'NATIVE_IG'
            AND s.condition_type_code   IS NOT NULL     -- s.condition_expression1
            THEN 'Y' END AS is_grid_conditional,
    --
    r.display_sequence,
    r.query_type_code,
    r.authorization_scheme
FROM apex_application_page_regions r
JOIN apex_application_pages p
    ON p.application_id         = r.application_id
    AND p.page_id               = r.page_id
CROSS JOIN x
LEFT JOIN user_objects t
    ON t.object_name            = r.table_name
    AND t.object_type           IN ('TABLE', 'VIEW')
LEFT JOIN apex_appl_page_igs g
    ON g.application_id         = r.application_id
    AND g.region_id             = r.region_id
LEFT JOIN d
    ON d.region_id              = r.region_id
LEFT JOIN apex_application_page_proc s
    ON s.application_id         = g.application_id
    AND s.region_id             = g.region_id
    AND s.process_point_code    = 'AFTER_SUBMIT'
LEFT JOIN da
    ON da.page_id               = r.page_id
    AND da.region_id            = r.region_id
WHERE r.application_id          = x.app_id
    AND r.parent_region_id      IS NULL
    AND (x.page_id              = p.page_id OR x.page_id IS NULL)
    AND (x.auth_scheme          = r.authorization_scheme OR x.auth_scheme IS NULL);
--
COMMENT ON TABLE nav_regions IS '[CORE - DASHBOARD] Regions on page/s';

