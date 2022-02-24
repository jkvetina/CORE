CREATE OR REPLACE VIEW translated_extracts AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()            AS app_id,
        app.get_item('$PAGE_ID')    AS page_id,
        'PAGE_NAME'                 AS page_item_like,
        'REGION_'                   AS region_item_like,
        'HELP_'                     AS help_item_like,
        'BUTTON_'                   AS button_item_like,
        'COLUMN_'                   AS column_item_like,
        'GROUP_'                    AS group_item_like,
        'LABEL_'                    AS field_item_like
    FROM DUAL
)
SELECT
    REGEXP_SUBSTR(t.item_name, '^([^_]+)', 1, 1, NULL, 1) AS item_type,
    --
    t.item_name,
    t.page_id,
    t.value_en
FROM (
    --
    -- PAGE NAME
    --
    SELECT
        x.page_item_like        AS item_name,
        p.page_id,
        --
        REGEXP_REPLACE(REGEXP_REPLACE(p.page_name, '(#fa-[a-z0-9_-]+\s*)'), '[&][[:alnum:]_-]+\.') AS value_en
        --
    FROM apex_application_pages p
    JOIN x
        ON x.app_id             = p.application_id
        AND p.page_id           = NVL(x.page_id, p.page_id)
    WHERE p.page_id             NOT IN (0, 9999, 947)
        AND p.page_name         NOT LIKE '&%.'
    --
    -- REGION HERO
    --
    UNION ALL
    SELECT
        x.region_item_like || COALESCE(r.static_id, p.static_id, TO_CHAR(r.region_id)) AS item_name,
        r.page_id,
        r.region_name AS value_en
        --
    FROM apex_application_page_regions r
    JOIN x
        ON x.app_id             = r.application_id
        AND r.page_id           = NVL(x.page_id, r.page_id)
    LEFT JOIN apex_application_page_regions p
        ON p.application_id     = r.application_id
        AND p.page_id           = r.page_id
        AND p.parent_region_id  = r.parent_region_id
        AND p.template          != r.template
        AND p.region_id         != r.region_id
        AND (p.condition_type   != 'Never' OR p.condition_type IS NULL)
        AND p.display_sequence  = r.display_sequence + 10
    WHERE r.page_id             NOT IN (0, 9999, 947)
        AND r.template          = 'Hero'
        AND r.source_type_code  = 'STATIC_TEXT'
        AND r.region_name       NOT LIKE '&%.'
    --
    -- REGION HERO - HELP TEXT
    --
    UNION ALL
    SELECT
        x.help_item_like || COALESCE(r.static_id, p.static_id, TO_CHAR(r.region_id)) AS item_name,
        r.page_id,
        DBMS_LOB.SUBSTR(r.region_source, 2000) AS value_en
        --
    FROM apex_application_page_regions r
    JOIN x
        ON x.app_id             = r.application_id
        AND r.page_id           = NVL(x.page_id, r.page_id)
    LEFT JOIN apex_application_page_regions p
        ON p.application_id     = r.application_id
        AND p.page_id           = r.page_id
        AND p.parent_region_id  = r.parent_region_id
        AND p.template          != r.template
        AND p.region_id         != r.region_id
        AND (p.condition_type   != 'Never' OR p.condition_type IS NULL)
        AND p.display_sequence  = r.display_sequence + 10
    WHERE r.page_id             NOT IN (0, 9999, 947)
        AND r.template          = 'Hero'
        AND r.source_type_code  = 'STATIC_TEXT'
        AND r.region_source     NOT LIKE '&%.'
        AND r.region_source     IS NOT NULL
    --
    -- BUTTON
    --
    UNION ALL
    SELECT
        x.button_item_like || COALESCE(b.button_static_id, b.button_name) AS item_name,
        b.page_id,
        b.label AS value_en
        --
    FROM apex_application_page_buttons b
    JOIN x
        ON x.app_id             = b.application_id
        AND b.page_id           = NVL(x.page_id, b.page_id)
    WHERE b.page_id             NOT IN (0, 9999, 947)
        AND b.label             NOT LIKE '&%.'
    --
    -- COLUMN
    --
    UNION ALL
    SELECT
        x.column_item_like || RTRIM(c.name, '_') AS item_name,
        c.page_id,
        MIN(c.heading) AS value_en
        --
    FROM apex_appl_page_ig_columns c
    JOIN x
        ON x.app_id             = c.application_id
        AND c.page_id           = NVL(x.page_id, c.page_id)
    WHERE c.page_id             NOT IN (0, 9999, 947)
        AND c.item_type         NOT IN ('NATIVE_HIDDEN')
        AND c.name              NOT LIKE 'APEX$%'
        AND c.heading           NOT LIKE '&%.'
    GROUP BY x.column_item_like, c.page_id, RTRIM(c.name, '_')
    --
    -- COLUMN GROUP
    --
    UNION ALL
    SELECT
        x.group_item_like || REGEXP_REPLACE(REPLACE(UPPER(c.heading), ' ', '_'), '[^A-Z0-9_]+', '') AS item_name,
        c.page_id,
        c.heading AS value_en
        --
    FROM apex_appl_page_ig_col_groups c
    JOIN x
        ON x.app_id             = c.application_id
        AND c.page_id           = NVL(x.page_id, c.page_id)
    WHERE c.page_id             NOT IN (0, 9999, 947)
        AND c.heading           NOT LIKE '&%.'
    --
    -- ITEM/FIELD LABELS
    --
    UNION ALL
    SELECT
        x.field_item_like || REGEXP_REPLACE(i.item_name, '^P\d+_', '') AS item_name,
        i.page_id,
        i.label AS value_en
        --
    FROM apex_application_page_items i
    JOIN x
        ON x.app_id             = i.application_id
        AND i.page_id           = NVL(x.page_id, i.page_id)
    WHERE i.page_id             NOT IN (0, 9999, 947)
        AND i.display_as_code   NOT IN ('NATIVE_HIDDEN')
        AND i.label             NOT LIKE '&%.'
        AND NOT REGEXP_LIKE(i.item_name, '^P\d+_C\d{3}$')   -- pivot columns
) t
CROSS JOIN x
LEFT JOIN translated_items i
    ON i.app_id             = x.app_id
    AND i.page_id           = t.page_id
    AND i.item_name         = t.item_name
LEFT JOIN translated_items g
    ON g.app_id             = x.app_id
    AND g.page_id           = 0
    AND g.item_name         = t.item_name
    AND g.value_en          = t.value_en
WHERE 1 = 1
    AND i.item_name         IS NULL
    AND g.item_name         IS NULL;


