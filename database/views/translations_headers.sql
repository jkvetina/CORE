CREATE OR REPLACE FORCE VIEW translations_headers AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()    AS app_id,
        'T#_REGION_'        AS region_name
    FROM DUAL
)
SELECT
    r.page_id,
    --
    REPLACE(x.region_name, '#', r.page_id) || COALESCE(r.static_id, p.static_id) AS item_name,
    --
    r.region_name AS value_en,
    --app_actions.extract_value(p.page_name)                      AS value_en,
    --
    app.get_icon('fa-plus-square', 'Add translation') AS action_add_translation,
    --
    -- @TODO: MINUS FOR REMOVED ITEMS/PAGES
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
    AND p.display_sequence  = r.display_sequence + 10
WHERE r.page_id             > 0
    AND r.page_id           < 9999
    AND r.template          = 'Hero'
    AND r.source_type_code  = 'STATIC_TEXT'
    AND NVL(r.static_id, p.static_id) IS NOT NULL
    AND r.region_name         NOT LIKE '%&' || REPLACE(x.region_name, '#', r.page_id) || COALESCE(r.static_id, p.static_id, ' ?') || '.%'
    AND r.region_name         NOT LIKE '&%.';
--
COMMENT ON TABLE translations_headers IS '';

