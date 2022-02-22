CREATE OR REPLACE VIEW translated_extracts AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()    AS app_id,
        'PAGE_NAME'         AS page_name,
        'REGION_'           AS region_name,
        'BUTTON_'           AS button_name
    FROM DUAL
)
SELECT
    REGEXP_SUBSTR(REGEXP_REPLACE(t.item_name, '^T[_]'), '^([^_]+)', 1, 1, NULL, 1) AS item_type,
    --
    t.item_name,
    t.page_id,
    t.value_en,
    t.field_static_id,
    t.field_replacement
FROM (
    SELECT
        x.page_name             AS item_name,
        p.page_id,
        --
        REGEXP_REPLACE(REGEXP_REPLACE(p.page_name, '(#fa-[a-z0-9_-]+\s*)'), '[&][[:alnum:]_-]+\.') AS value_en,
        --
        p.page_alias AS field_static_id,
        --
        '&' || x.page_name || '.' AS field_replacement
        --
    FROM apex_application_pages p
    JOIN x
        ON x.app_id             = p.application_id
    LEFT JOIN translated_items t
        ON t.app_id             = p.application_id
        AND t.page_id           = p.page_id
        AND t.item_name         = x.page_name
    WHERE p.page_id             NOT IN (0, 9999, 947)
        AND p.page_name         NOT LIKE '%&' || x.page_name || '.%'
        AND p.page_name         NOT LIKE '&%.'
        AND t.item_name         IS NULL
    --
    UNION ALL
    SELECT
        x.region_name || COALESCE(r.static_id, p.static_id) AS item_name,
        r.page_id,
        --
        r.region_name AS value_en,
        --
        COALESCE(r.static_id, p.static_id) AS field_static_id,
        --
        '&' || x.region_name || COALESCE(r.static_id, p.static_id) || '.' AS field_replacement
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
    LEFT JOIN translated_items t
        ON t.app_id             = r.application_id
        AND t.page_id           = r.page_id
        AND t.item_name         = x.region_name || COALESCE(r.static_id, p.static_id)
    WHERE r.page_id             NOT IN (0, 9999, 947)
        AND r.template          = 'Hero'
        AND r.source_type_code  = 'STATIC_TEXT'
        AND COALESCE(r.static_id, p.static_id) IS NOT NULL
        AND r.region_name       NOT LIKE '%&' || x.region_name || COALESCE(r.static_id, p.static_id) || '.%'
        AND r.region_name       NOT LIKE '&%.'
        AND t.item_name         IS NULL
    --
    UNION ALL
    SELECT
        x.button_name || COALESCE(b.button_static_id, b.button_name) AS item_name,
        r.page_id,
        --
        b.label AS value_en,
        --
        COALESCE(b.button_static_id, b.button_name) AS field_static_id,
        --
        '&' || x.button_name || COALESCE(b.button_static_id, b.button_name) || '.' AS field_replacement
        --
    FROM apex_application_page_regions r
    JOIN x
        ON x.app_id             = r.application_id
    LEFT JOIN apex_application_page_buttons b
        ON b.application_id     = r.application_id
        AND b.page_id           = r.page_id
        AND b.region_id         = r.region_id
    LEFT JOIN translated_items t
        ON t.app_id             = r.application_id
        AND t.page_id           = r.page_id
        AND t.item_name         = x.button_name || COALESCE(b.button_static_id, b.button_name)
    WHERE r.page_id             NOT IN (0, 9999, 947)
        AND b.button_name       NOT LIKE '&%.'
        AND t.item_name         IS NULL
) t;

