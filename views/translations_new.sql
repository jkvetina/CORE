CREATE OR REPLACE VIEW translations_new AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()            AS app_id,
        app.get_item('$PAGE_ID')    AS page_id
    FROM DUAL
)
SELECT
    t.item_type,
    t.item_name,
    t.page_id,
    t.value_en
FROM translations_extracts t
JOIN x
    ON (x.page_id IN (0, t.page_id) OR x.page_id IS NULL)
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
    AND g.item_name         IS NULL
    AND t.is_translated     IS NULL;

