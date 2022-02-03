CREATE OR REPLACE VIEW translations_mapped AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()        AS app_id,
        app.get_user_lang()     AS lang_id,
        'T'                     AS item_prefix
    FROM DUAL
)
SELECT
    x.item_prefix || NULLIF(t.page_id, 0) || '_' || t.name AS item_name,
    --
    CASE x.lang_id
        WHEN 'CZ' THEN t.value_cz
        WHEN 'SK' THEN t.value_sk
        WHEN 'PL' THEN t.value_pl
        WHEN 'HU' THEN t.value_hu
        ELSE t.value_en
        END AS item_value
FROM translations t
JOIN x
    ON x.app_id             = t.app_id
JOIN apex_application_page_items i
    ON i.application_id     = t.app_id
    AND i.page_id           = t.page_id
    AND (
            (i.page_id > 0 AND i.item_name = x.item_prefix || i.page_id || '_' || t.name)
        OR  (i.page_id = 0 AND i.item_name = x.item_prefix || '_' || t.name)
    );
--
COMMENT ON TABLE  translations_mapped       IS '[CORE - DASHBOARD] Translations for startup process';

