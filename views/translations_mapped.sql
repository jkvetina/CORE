CREATE OR REPLACE VIEW translations_mapped AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()                AS app_id,
        app.get_page_id()               AS page_id,
        app.get_user_lang()             AS lang_id,
        app.get_translation_prefix()    AS item_prefix
    FROM DUAL
)
SELECT t.name, i.item_name
FROM translations t
JOIN x
    ON x.app_id             = t.app_id
    AND x.page_id           IN (0, x.page_id)
JOIN apex_application_page_items i
    ON i.application_id     = x.app_id
    AND i.page_id           = x.page_id
    AND (
            (i.page_id > 0 AND i.item_name = x.item_prefix || i.page_id || '_' || t.name)
        OR  (i.page_id = 0 AND i.item_name = x.item_prefix || '_' || t.name)
    )
GROUP BY t.name, i.item_name
UNION
--
SELECT t.name, i.item_name
FROM translations t
JOIN x
    ON x.app_id             = t.app_id
JOIN apex_application_items i
    ON i.application_id     = t.app_id
    AND i.item_name         = x.item_prefix || '_' || t.name
GROUP BY t.name, i.item_name;
--
COMMENT ON TABLE  translations_mapped       IS '[CORE - DASHBOARD] Translations for startup process';

