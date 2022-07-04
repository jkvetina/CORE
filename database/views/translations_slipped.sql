CREATE OR REPLACE FORCE VIEW translations_slipped AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()            AS app_id,
        app.get_item('$PAGE_ID')    AS page_id
    FROM DUAL
),
t AS (
    SELECT
        x.app_id,
        t.item_type,
        LTRIM(RTRIM(REGEXP_REPLACE(t.value_en, '[!][A-Z]+\.$', '.'), '.'), '&') AS item_name,
        t.page_id,
        t.value_en
    FROM translations_extracts t
    JOIN x
        ON (x.page_id IN (0, t.page_id) OR x.page_id IS NULL)
    LEFT JOIN translated_items i
        ON i.app_id             = x.app_id
        AND i.page_id           IN (0, t.page_id)
        AND i.item_name         = LTRIM(RTRIM(REGEXP_REPLACE(t.value_en, '[!][A-Z]+\.$', '.'), '.'), '&')
    WHERE t.is_translated       IS NOT NULL
        AND i.item_name         IS NULL
        AND NOT REGEXP_LIKE(t.value_en, '^(&' || 'P\d+[_]C\d+\.)$')
        AND NOT REGEXP_LIKE(t.value_en, '^(&' || 'G[_])')
)
SELECT
    t.item_type,
    t.item_name,
    t.page_id,
    t.value_en
FROM t
LEFT JOIN apex_application_items a
    ON a.application_id     = t.app_id
    AND a.item_name         = t.item_name
LEFT JOIN apex_application_page_items p
    ON p.application_id     = t.app_id
    AND p.page_id           IN (0, 947, t.page_id)
    AND p.item_name         = t.item_name
WHERE a.item_name           IS NULL
    AND p.item_name         IS NULL;
--
COMMENT ON TABLE translations_slipped IS '';

