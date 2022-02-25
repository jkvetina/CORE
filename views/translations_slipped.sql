CREATE OR REPLACE VIEW translations_slipped AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()    AS app_id
    FROM DUAL
)
SELECT
    t.item_type,
    LTRIM(RTRIM(REGEXP_REPLACE(t.value_en, '[!][A-Z]+\.$', '.'), '.'), '&') AS item_name,
    t.page_id,
    NULL AS value_en
FROM translations_extracts t
CROSS JOIN x
LEFT JOIN translated_items i
    ON i.app_id             = x.app_id
    AND i.page_id           IN (0, t.page_id)
    AND i.item_name         = LTRIM(RTRIM(REGEXP_REPLACE(t.value_en, '[!][A-Z]+\.$', '.'), '.'), '&')
WHERE t.is_translated       IS NOT NULL
    AND i.item_name         IS NULL
    AND NOT REGEXP_LIKE(t.value_en, '^(&' || 'P\d+[_]C\d+\.)$')
    AND NOT REGEXP_LIKE(t.value_en, '^(&' || 'G[_])');

