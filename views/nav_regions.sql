CREATE OR REPLACE VIEW nav_regions AS
WITH x AS (
    SELECT
        app.get_item('$PAGE_ID')        AS page_id,
        app.get_item('$AUTH_SCHEME')    AS auth_scheme
    FROM users u
    WHERE u.user_id = app.get_user_id()
)
SELECT
    p.page_group || ' ' || r.page_id || ' ' || p.page_title AS page_group,
    r.page_id,
    --r.region_id,
    --
    REPLACE(RPAD(' ', 3 * CASE WHEN r.template = 'Hero' THEN 0 ELSE 1 END), ' ', '&' || 'nbsp; ') ||
        CASE WHEN r.icon_css_classes IS NOT NULL THEN app.get_icon(r.icon_css_classes) || '&' || 'nbsp; ' END || r.region_name
        AS region_name,
    --
    --r.parent_region_id,
    --r.source_type,
    --r.source_type_code,
    --r.query_type_code,
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
    NULLIF(r.items, 0)          AS items,
    NULLIF(r.buttons, 0)        AS buttons,
    --
    CASE WHEN r.condition_type_code IS NOT NULL THEN 'Y' END AS condition_type,
    --
    r.authorization_scheme,
    r.display_sequence
FROM apex_application_page_regions r
JOIN apex_application_pages p
    ON p.application_id         = r.application_id
    AND p.page_id               = r.page_id
CROSS JOIN x
WHERE r.application_id          = app.get_app_id()
    AND (x.page_id              = p.page_id OR x.page_id IS NULL)
    AND (x.auth_scheme          = r.authorization_scheme OR x.auth_scheme IS NULL);

