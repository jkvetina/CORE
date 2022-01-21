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
    NULLIF(r.items, 0)          AS items,
    NULLIF(r.buttons, 0)        AS buttons,
    --
    CASE WHEN r.condition_type_code IS NOT NULL THEN 'Y' END AS condition_type,
    --
    r.authorization_scheme,
    r.display_sequence,
    r.query_type_code,
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
        THEN 'Y'
        END AS is_correct_setup
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
WHERE r.application_id          = x.app_id
    AND r.parent_region_id      IS NULL
    AND (x.page_id              = p.page_id OR x.page_id IS NULL)
    AND (x.auth_scheme          = r.authorization_scheme OR x.auth_scheme IS NULL);
--
COMMENT ON TABLE nav_regions IS '[CORE - DASHBOARD] Regions on page/s';

