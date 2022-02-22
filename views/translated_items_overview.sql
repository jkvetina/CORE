CREATE OR REPLACE VIEW translated_items_overview AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()        AS app_id
    FROM DUAL
)
SELECT
    t.page_id           AS out_page_id,
    t.item_name         AS out_item_name,
    t.page_id,
    t.item_name,
    --
    REGEXP_SUBSTR(REGEXP_REPLACE(t.item_name, '^T[_]'), '^([^_]+)', 1, 1, NULL, 1) AS item_type,
    --
    CASE WHEN i.item_name IS NOT NULL THEN 'Y' END AS is_page_item,
    CASE WHEN a.item_name IS NOT NULL THEN 'Y' END AS is_app_item,
    --
    t.value_en,
    t.value_cz,
    t.value_sk,
    t.value_pl,
    t.value_hu
FROM translated_items t
JOIN x
    ON x.app_id             = t.app_id
LEFT JOIN apex_application_page_items i
    ON i.application_id     = t.app_id
    AND i.page_id           IN (947, t.page_id)
    AND i.item_name         = t.item_name
LEFT JOIN apex_application_items a
    ON a.application_id     = t.app_id
    AND a.item_name         = t.item_name;
--
COMMENT ON TABLE  translated_items_overview     IS '[CORE - DASHBOARD] Use page/app items to translate application';

