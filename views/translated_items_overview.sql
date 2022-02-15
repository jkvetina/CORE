CREATE OR REPLACE VIEW translated_items_overview AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()                AS app_id,
        app.get_translation_prefix()    AS item_prefix
    FROM DUAL
),
t AS (
    SELECT t.*
    FROM translated_items t
    JOIN x
        ON x.app_id             = t.app_id
),
p AS (
    SELECT t.item_name
    FROM t
    JOIN apex_application_page_items i
        ON i.application_id     = t.app_id
        AND i.page_id           = TO_NUMBER(REGEXP_SUBSTR(t.item_name, '\d+'))
        AND i.item_name         = t.item_name
),
a AS (
    SELECT t.item_name
    FROM t
    JOIN apex_application_items a
        ON a.application_id     = t.app_id
        AND a.item_name         = t.item_name
)
SELECT
    t.item_name     AS out_item_name,
    t.item_name,
    --
    CASE SUBSTR(t.item_name, 1, 1)
        WHEN 'H' THEN 'HEADER'
        WHEN 'B' THEN 'BUTTON'
        WHEN 'C' THEN 'COLUMN'
        WHEN 'L' THEN 'LABEL'
        END AS item_type,
    --
    CASE WHEN p.item_name IS NOT NULL THEN 'Y' END AS is_page_item,
    CASE WHEN a.item_name IS NOT NULL THEN 'Y' END AS is_app_item,
    --
    t.value_en,
    t.value_cz,
    t.value_sk,
    t.value_pl,
    t.value_hu
FROM t
LEFT JOIN p ON p.item_name = t.item_name
LEFT JOIN a ON a.item_name = t.item_name;
--
COMMENT ON TABLE  translated_items_overview     IS '[CORE - DASHBOARD] Use page/app items to translate application';

