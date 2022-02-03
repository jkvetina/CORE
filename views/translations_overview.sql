CREATE OR REPLACE VIEW translations_overview AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()    AS app_id,
        'T'                 AS item_prefix
    FROM DUAL
),
m AS (
    SELECT
        t.app_id,
        t.page_id,
        t.name,
        t.name                  AS name_old,
        t.page_id               AS page_id_old,
        --
        CASE WHEN i.page_id IS NULL
            THEN app.get_icon('fa-warning', 'Item ' || x.item_prefix || NULLIF(t.page_id, 0) || '_' || t.name || ' is missing on page ' || t.page_id)
            END AS action_check,
        --
        t.value_en,
        t.value_cz,
        t.value_sk,
        t.value_pl,
        t.value_hu,
        --
        i.item_name
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
)
SELECT
    m.app_id,
    m.page_id,
    m.name,
    m.name_old,
    m.page_id_old,
    m.action_check,
    --
    m.value_en,
    m.value_cz,
    m.value_sk,
    m.value_pl,
    m.value_hu,
    --
    m.item_name
FROM m
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
    --
    app.get_icon('fa-arrow-right', 'Translation for the item is missing') AS action_check,
    --
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    --
    i.item_name
FROM apex_application_page_items i
JOIN x
    ON x.app_id             = i.application_id
    AND i.item_name         LIKE x.item_prefix || '%'
LEFT JOIN m
    ON m.app_id             = i.application_id
    AND m.page_id           = i.page_id
    AND m.item_name         = i.item_name
WHERE m.name                IS NULL;
--
COMMENT ON TABLE  translations_overview     IS '[CORE - DASHBOARD] Use page/app items to translate application';

