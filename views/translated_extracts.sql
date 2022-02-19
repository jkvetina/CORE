CREATE OR REPLACE VIEW translated_extracts AS
--
-- @TODO: seradit podle display_position path (connect by)
--
-- @TODO: MINUS FOR REMOVED ITEMS/PAGES
--
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()    AS app_id,
        'T_PAGE_NAME'       AS page_name,
        'T#_REGION_'        AS region_name,
        'T_BUTTON_'         AS button_name
    FROM DUAL
)
SELECT
    'PAGE_NAME'             AS item_type,
    x.page_name             AS item_name,
    p.page_id,
    --
    app_actions.extract_value(p.page_name) AS value_en,
    --
    app.get_icon('fa-plus-square', 'Add translation') AS action,
    --
    p.page_alias AS field_static_id,
    --
    app_actions.extract_replacement(p.page_name, x.page_name) AS field_replacement
FROM apex_application_pages p
JOIN x
    ON x.app_id             = p.application_id
LEFT JOIN translated_items t
    ON t.app_id             = p.application_id
    AND t.page_id           = p.page_id
    AND t.item_name         = x.page_name
WHERE p.page_id             > 0
    AND p.page_id           < 9999
    AND p.page_name         NOT LIKE '%&' || t.item_name || '.%'
    AND p.page_name         NOT LIKE '&%.'
--
UNION ALL
SELECT
    'REGION_HEADER' AS item_type,
    --
    REPLACE(x.region_name, '#', r.page_id) || COALESCE(r.static_id, p.static_id) AS item_name,
    r.page_id,
    --
    r.region_name AS value_en,
    --
    app.get_icon('fa-plus-square', 'Add translation') AS action,
    --
    COALESCE(r.static_id, p.static_id) AS field_static_id,
    --
    '&' || REPLACE(x.region_name, '#', r.page_id) || COALESCE(r.static_id, p.static_id) || '.' AS field_replacement
    --
FROM apex_application_page_regions r
JOIN x
    ON x.app_id             = r.application_id
LEFT JOIN apex_application_page_regions p
    ON p.application_id     = r.application_id
    AND p.page_id           = r.page_id
    AND p.parent_region_id  = r.parent_region_id
    AND p.template          != r.template
    AND p.region_id         != r.region_id
    AND (p.condition_type   != 'Never' OR p.condition_type IS NULL)
    AND p.display_sequence  = r.display_sequence + 10                   -- @TODO: fix this
WHERE r.page_id             > 0
    AND r.page_id           < 9999
    AND r.template          = 'Hero'
    AND r.source_type_code  = 'STATIC_TEXT'
    AND COALESCE(r.static_id, p.static_id) IS NOT NULL
    AND r.region_name         NOT LIKE '%&' || REPLACE(x.region_name, '#', r.page_id) || COALESCE(r.static_id, p.static_id, ' ?') || '.%'
    AND r.region_name         NOT LIKE '&%.'
--
UNION ALL
SELECT
    'BUTTON' AS item_type,
    --b.button_sequence,
    --
    REPLACE(x.button_name, '#', MIN(r.page_id)) || COALESCE(b.button_static_id, b.button_name) AS item_name,
    --
    CASE
        WHEN MIN(r.page_id) = MAX(r.page_id)
            THEN MIN(r.page_id)
        END AS page_id,
    --
    b.label AS value_en,
    --
    app.get_icon('fa-plus-square', 'Add translation') AS action,
    --
    COALESCE(b.button_static_id, b.button_name) AS field_static_id,
    --
    '&' || REPLACE(x.button_name, '#', MIN(r.page_id)) || COALESCE(b.button_static_id, b.button_name) || '.' AS field_replacement
    --
FROM apex_application_page_regions r
JOIN x
    ON x.app_id             = r.application_id
LEFT JOIN apex_application_page_buttons b
    ON b.application_id     = r.application_id
    AND b.page_id           = r.page_id
    AND b.region_id         = r.region_id
WHERE r.page_id             > 0
    AND r.page_id           < 9999
    AND b.button_name       NOT LIKE '&%.'
GROUP BY x.button_name, b.button_static_id, b.button_name, b.label
;

