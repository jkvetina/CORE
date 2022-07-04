CREATE OR REPLACE FORCE VIEW translated_items_overview AS
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
    t.value_en,
    t.value_cz,
    t.value_sk,
    t.value_pl,
    t.value_hu,
    --
    '<a href="#" onclick="copy_to_clipboard(''&' || t.item_name ||
        CASE WHEN t.item_name LIKE 'HELP\_%' ESCAPE '\' THEN '!RAW' END ||
        '.''); return false;">' || app.get_icon('fa-copy') || '</a>' AS action_copy
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
COMMENT ON TABLE translated_items_overview IS '[CORE - DASHBOARD] Use page/app items to translate application';

