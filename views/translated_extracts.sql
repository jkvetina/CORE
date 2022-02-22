CREATE OR REPLACE VIEW translated_extracts AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()    AS app_id,
        'PAGE_NAME'         AS page_name,
        'REGION_%'          AS region_name,
        'BUTTON_%'          AS button_name
    FROM DUAL
)
SELECT
    REGEXP_SUBSTR(REGEXP_REPLACE(t.item_name, '^T[_]'), '^([^_]+)', 1, 1, NULL, 1) AS item_type,
    --
    t.item_name,
    t.page_id,
    t.value_en,
    t.field_static_id,
    t.field_replacement
FROM (
    SELECT
        x.page_name             AS item_name,
        p.page_id,
        --
        REGEXP_REPLACE(REGEXP_REPLACE(p.page_name, '(#fa-[a-z0-9_-]+\s*)'), '[&][[:alnum:]_-]+\.') AS value_en,
        --
        p.page_alias AS field_static_id,
        --
        NULL AS field_replacement
    FROM apex_application_pages p
    JOIN x
        ON x.app_id             = p.application_id
    LEFT JOIN translated_items t
        ON t.app_id             = p.application_id
        AND t.page_id           = p.page_id
        AND t.item_name         = x.page_name
    WHERE p.page_id             NOT IN (0, 9999, 947)
        AND p.page_name         NOT LIKE '%&' || x.page_name || '.%'
        AND p.page_name         NOT LIKE '&%.'
        AND t.item_name         IS NULL
) t;

