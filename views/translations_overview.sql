CREATE OR REPLACE VIEW translations_overview AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()    AS app_id,
        'T'                 AS item_prefix
    FROM DUAL
)
SELECT
    t.app_id,
    t.page_id,
    t.name,
    t.name                  AS name_old,
    t.page_id               AS page_id_old,
    --
    CASE WHEN i.page_id IS NULL
        THEN app.get_icon('fa-warning', 'Item ' || REPLACE(x.item_prefix || t.page_id || '_', x.item_prefix || '0_', x.item_prefix || '_') || t.name || ' is missing on page ' || t.page_id)
        ELSE '' || i.page_id || i.item_name || i.application_id
        END AS action_check,
    --
    t.value_en,
    t.value_cz,
    t.value_sk,
    t.value_pl,
    t.value_hu
FROM translations t
JOIN x
    ON x.app_id             = t.app_id
LEFT JOIN apex_application_page_items i
    ON i.application_id     = t.app_id
    AND i.page_id           = t.page_id
    AND (
            (i.page_id > 0 AND i.item_name = x.item_prefix || i.page_id || '_' || t.name)
        OR  (i.page_id = 0 AND i.item_name = x.item_prefix || '_' || t.name)
    )
UNION ALL
--
SELECT
    i.application_id,
    i.page_id,
    --
    REGEXP_REPLACE(i.item_name, '^' || x.item_prefix || '\d*_', '') AS name,
    REGEXP_REPLACE(i.item_name, '^' || x.item_prefix || '\d*_', '') AS name_old,
    --
    i.page_id               AS page_id_old,
    NULL                    AS action_check,
    --
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
FROM apex_application_page_items i
JOIN x
    ON x.app_id             = i.application_id
LEFT JOIN translations t
    ON t.app_id             = x.app_id
    AND t.name              = i.item_name
WHERE t.name                IS NULL
    --
    AND REGEXP_LIKE(i.item_name, '^' || x.item_prefix || '(' || i.page_id || ')?_');
--
COMMENT ON TABLE  translations_overview     IS '[CORE - DASHBOARD] Use page/app items to translate application';

