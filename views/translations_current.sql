CREATE OR REPLACE VIEW translations_current AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()        AS app_id,
        app.get_page_id()       AS page_id,
        app.get_user_lang()     AS lang_id
    FROM DUAL
)
SELECT
    t.page_id,
    t.item_name,
    i.item_name                 AS page_item_name,
    a.item_name                 AS app_item_name
FROM translated_items t
JOIN x
    ON x.app_id                 = t.app_id
    AND (x.page_id              = t.page_id OR t.page_id = 0)
LEFT JOIN apex_application_page_items i
    ON i.application_id         = t.app_id
    AND i.page_id               = t.page_id
    AND i.item_name             = REGEXP_REPLACE(t.item_name, '^([A-Z]+)[_]', '\1' || t.page_id || '_')
LEFT JOIN apex_application_items a
    ON a.application_id         = t.app_id
    AND a.item_name             = t.item_name;

