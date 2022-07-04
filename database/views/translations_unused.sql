CREATE OR REPLACE FORCE VIEW translations_unused AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()            AS app_id,
        app.get_item('$PAGE_ID')    AS page_id
    FROM DUAL
)
SELECT
    REGEXP_SUBSTR(t.item_name, '^([^_]+)', 1, 1, NULL, 1) AS item_type,
    --
    t.item_name,
    t.page_id,
    t.value_en
FROM translated_items t
CROSS JOIN x
LEFT JOIN translations_extracts d
    ON d.page_id        = t.page_id
    AND d.item_name     = t.item_name
WHERE t.app_id          = x.app_id
    AND t.page_id       = NVL(x.page_id, t.page_id)
    AND d.item_name     IS NULL;
--
COMMENT ON TABLE translations_unused IS '';

