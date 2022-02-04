CREATE OR REPLACE VIEW translations_overview AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()                AS app_id,
        app.get_translation_prefix()    AS item_prefix
    FROM DUAL
),
m AS (
    SELECT
        t.app_id,
        t.page_id,
        t.name,
        --
        NVL(i.item_name, a.item_name) AS item_name,
        --
        t.value_en,
        t.value_cz,
        t.value_sk,
        t.value_pl,
        t.value_hu,
        --
        t.name                  AS name_old,
        t.page_id               AS page_id_old
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
    LEFT JOIN apex_application_items a
        ON a.application_id     = t.app_id
        AND a.item_name         = x.item_prefix || '_' || t.name
        AND i.item_name         IS NULL
)
SELECT
    m.app_id,
    m.page_id,
    m.name,
    m.item_name,
    --
    m.value_en,
    m.value_cz,
    m.value_sk,
    m.value_pl,
    m.value_hu,
    --
    m.name_old,
    m.page_id_old
FROM m
UNION ALL
--
SELECT
    i.application_id,
    i.page_id,
    --
    REGEXP_REPLACE(i.item_name, '^' || x.item_prefix || '\d*_', '') AS name,
    i.item_name,
    --
    NULL,   -- 5 languages
    NULL,
    NULL,
    NULL,
    NULL,
    --
    REGEXP_REPLACE(i.item_name, '^' || x.item_prefix || '\d*_', '') AS name_old,
    i.page_id                                                       AS page_id_old
FROM apex_application_page_items i
JOIN x
    ON x.app_id             = i.application_id
    AND i.item_name         LIKE x.item_prefix || i.page_id || '%'
LEFT JOIN m
    ON m.app_id             = i.application_id
    AND m.page_id           = i.page_id
    AND m.item_name         = i.item_name
WHERE m.name                IS NULL
    AND i.item_name         NOT LIKE x.item_prefix || '0\_%' ESCAPE '\'
UNION ALL
--
SELECT
    i.application_id,
    0 AS page_id,
    --
    REGEXP_REPLACE(i.item_name, '^' || x.item_prefix || '\d*_', '') AS name,
    i.item_name,
    --
    NULL,   -- 5 languages
    NULL,
    NULL,
    NULL,
    NULL,
    --
    REGEXP_REPLACE(i.item_name, '^' || x.item_prefix || '\d*_', '') AS name_old,
    0                                                               AS page_id_old
FROM apex_application_items i
JOIN x
    ON x.app_id             = i.application_id
    AND i.item_name         LIKE x.item_prefix || '\_%' ESCAPE '\'
LEFT JOIN m
    ON m.app_id             = i.application_id
    AND m.page_id           = 0
    AND m.item_name         = i.item_name
WHERE m.name                IS NULL;
--
COMMENT ON TABLE  translations_overview     IS '[CORE - DASHBOARD] Use page/app items to translate application';

