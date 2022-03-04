CREATE OR REPLACE VIEW translations_current AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_real_app_id()   AS app_id,
        app.get_page_id()       AS page_id,
        app.get_user_lang()     AS lang_id
    FROM DUAL
)
SELECT
    t.page_id,
    t.item_name,
    app.get_translated_item(t.item_name, in_app_id => x.app_id) AS item_value
FROM translated_items t
JOIN x
    ON x.app_id                 = t.app_id
    AND (x.page_id              = t.page_id OR t.page_id = 0);

