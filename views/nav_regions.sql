CREATE OR REPLACE VIEW nav_regions AS
WITH x AS (
    SELECT
        app.get_item('$PAGE_ID')        AS page_id,
        app.get_item('$AUTH_SCHEME')    AS auth_scheme,
        a.app_id
    FROM users u
    JOIN apps a
        ON a.app_id         = app.get_app_id()
    WHERE u.user_id         = app.get_user_id()
),
c AS (
    SELECT
        r.region_id,
        c.table_name,
        --c.data_length, c.nullable
        c.column_name || '|' ||
            CASE REGEXP_REPLACE(c.data_type, '\(\d+\)', '')
                WHEN 'CHAR'                     THEN 'VARCHAR2'
                WHEN 'INTERVAL DAY TO SECOND'   THEN 'INTERVAL_D2S'
                WHEN 'TIMESTAMP WITH TIME ZONE' THEN 'TIMESTAMP_TZ'
                ELSE REGEXP_REPLACE(c.data_type, '\(\d+\)', '')
                END AS column_desc
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
        c.source_expression || '|' || c.data_type AS column_desc
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
        MAX(CASE
            WHEN c.table_name IS NULL THEN app.get_icon('fa-warning')
            WHEN b.table_name IS NULL THEN app.get_icon('fa-warning')
            END) AS fix_sync,
        --
        LISTAGG(CASE
            WHEN c.table_name IS NULL THEN 'Removed '   || b.column_desc
            WHEN b.table_name IS NULL THEN 'Added '     || c.column_desc
            END, ', ') WITHIN GROUP (ORDER BY b.column_desc, c.column_desc) AS fix_sync_title
    FROM b
    FULL JOIN c
        ON c.region_id              = b.region_id
        AND c.table_name            = b.table_name
        AND c.column_desc           = b.column_desc
    WHERE NVL(c.column_desc, '-')   != NVL(b.column_desc, '-')
    GROUP BY NVL(c.region_id, b.region_id), NVL(c.table_name, b.table_name)
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
    CASE WHEN g.edit_operations LIKE '%i%' THEN 'Y' END AS is_ins_allowed,
    CASE WHEN g.edit_operations LIKE '%u%' THEN 'Y' END AS is_upd_allowed,
    CASE WHEN g.edit_operations LIKE '%d%' THEN 'Y' END AS is_del_allowed,
    --
    CASE
        WHEN g.add_row_if_empty         = 'Yes'
            AND g.select_first_row      = 'No'
            AND g.pagination_type       = 'Page'
            AND g.show_total_row_count  = 'Yes'
            AND g.toolbar_buttons       = 'SEARCH_COLUMN:SEARCH_FIELD:ACTIONS_MENU:SAVE'
            --
            AND REGEXP_REPLACE(g.javascript_code, '\s+', ' ') LIKE 'function(config) { return unified_ig_toolbar(config%'
        THEN NULL
        ELSE app.get_icon('fa-warning')
        END AS fix_setup,
    --
    d.fix_sync,
    d.fix_sync_title,
    --
    --
    NULLIF(r.items, 0)          AS items,
    NULLIF(r.buttons, 0)        AS buttons,
    --
    CASE WHEN r.condition_type_code IS NOT NULL THEN 'Y' END AS condition_type,
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
    ON d.region_id = r.region_id
WHERE r.application_id          = x.app_id
    AND r.parent_region_id      IS NULL
    AND (x.page_id              = p.page_id OR x.page_id IS NULL)
    AND (x.auth_scheme          = r.authorization_scheme OR x.auth_scheme IS NULL);
--
COMMENT ON TABLE nav_regions IS '[CORE - DASHBOARD] Regions on page/s';

