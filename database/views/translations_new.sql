CREATE OR REPLACE FORCE VIEW translations_new AS
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
        AND t.is_translated     IS NULL
)
SELECT
    t.item_type,
    t.item_name,
    t.page_id,
    t.value_en,
    --
    '<a href="#" onclick="copy_to_clipboard(''&' || t.item_name ||
        CASE WHEN t.item_name LIKE 'HELP\_%' ESCAPE '\' THEN '!RAW' END ||
        '.''); return false;">' || app.get_icon('fa-copy') || '</a>' AS action_copy
FROM t
UNION ALL
--
SELECT
    REGEXP_SUBSTR(t.item_name, '^([^_]+)', 1, 1, NULL, 1) AS item_type,
    --
    i.item_name,
    i.page_id,
    i.value_en,
    --
    '<a href="#" onclick="copy_to_clipboard(''&' || t.item_name ||
        CASE WHEN t.item_name LIKE 'HELP\_%' ESCAPE '\' THEN '!RAW' END ||
        '.''); return false;">' || app.get_icon('fa-copy') || '</a>' AS action_copy
FROM translated_items i
JOIN t
    ON t.app_id         = i.app_id
    AND t.item_name     = i.item_name
WHERE i.page_id         != t.page_id  --= 0
    AND i.item_name     NOT IN ('PAGE_NAME');
--
COMMENT ON TABLE translations_new IS '';

