CREATE OR REPLACE FORCE VIEW translations_extracts AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()    AS app_id,
        'PAGE_NAME'         AS page_item_like,
        'REGION_'           AS region_item_like,
        'HELP_'             AS help_item_like,
        'BUTTON_'           AS button_item_like,
        'COLUMN_'           AS column_item_like,
        'GROUP_'            AS group_item_like,
        'LABEL_'            AS field_item_like,
        'CHART_'            AS chart_item_like
    FROM DUAL
)
SELECT
    REGEXP_SUBSTR(t.item_name, '^([^_]+)', 1, 1, NULL, 1) AS item_type,
    --
    t.item_name,
    t.page_id,
    t.value_en,
    --
    CASE WHEN t.value_en LIKE '&%.' THEN 'Y' END AS is_translated
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
    WHERE p.page_id             NOT IN (0, 9999, 947)
    --
    -- REGION HERO
    --
    UNION ALL
    SELECT
        x.region_item_like || COALESCE(r.static_id, p.static_id, '?') AS item_name,
        r.page_id,
        r.region_name AS value_en
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
    WHERE r.page_id             NOT IN (0, 9999, 947)
        AND r.template          = 'Hero'
        AND r.source_type_code  = 'STATIC_TEXT'
    --
    -- REGION HERO - HELP TEXT
    --
    UNION ALL
    SELECT
        x.help_item_like || COALESCE(r.static_id, p.static_id, '?') AS item_name,
        r.page_id,
        DBMS_LOB.SUBSTR(r.region_source, 2000) AS value_en
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
    WHERE r.page_id             NOT IN (0, 9999, 947)
        AND r.template          = 'Hero'
        AND r.source_type_code  = 'STATIC_TEXT'
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
    WHERE b.page_id             NOT IN (0, 9999, 947)
    --
    -- COLUMN
    --
    UNION ALL
    SELECT
        REPLACE(REPLACE(x.column_item_like || RTRIM(c.name, '_'), '#'), '$') AS item_name,
        c.page_id,
        MIN(c.heading) AS value_en
        --
    FROM apex_appl_page_ig_columns c
    JOIN x
        ON x.app_id             = c.application_id
    WHERE c.page_id             NOT IN (0, 9999, 947)
        AND c.item_type         NOT IN ('NATIVE_HIDDEN')
        AND c.name              NOT LIKE 'APEX$%'
    GROUP BY x.column_item_like, c.page_id, RTRIM(c.name, '_')
    --
    -- COLUMN GROUP
    --
    UNION ALL
    SELECT
        x.group_item_like || REGEXP_REPLACE(REPLACE(REGEXP_REPLACE(UPPER(c.heading), '^(&' || x.group_item_like || ')', '&'), ' ', '_'), '[^A-Z0-9_]+', '') AS item_name,
        c.page_id,
        c.heading AS value_en
        --
    FROM apex_appl_page_ig_col_groups c
    JOIN x
        ON x.app_id             = c.application_id
    WHERE c.page_id             NOT IN (0, 9999, 947)
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
    WHERE i.page_id             NOT IN (0, 9999, 947)
        AND i.display_as_code   NOT IN ('NATIVE_HIDDEN')
        AND NOT REGEXP_LIKE(i.item_name, '^P\d+_C\d{3}$')   -- pivot columns
    --
    -- CHART SERIES
    --
    UNION ALL
    SELECT
        x.chart_item_like || REGEXP_REPLACE(REPLACE(UPPER(c.series_name), ' ', '_'), '[^A-Z0-9_]+', '') AS item_name,
        c.page_id,
        MIN(c.series_name) AS value_en
        --
    FROM apex_application_page_chart_s c
    JOIN x
        ON x.app_id             = c.application_id
    WHERE c.page_id             NOT IN (0, 9999, 947)
    GROUP BY x.chart_item_like, c.page_id, c.series_name
) t;

