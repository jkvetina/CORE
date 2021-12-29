CREATE OR REPLACE VIEW settings_overview AS
WITH x AS (
    SELECT
        UPPER('SETT')       AS package_name,        -- app_actions spec
        UPPER('GET_')       AS prefix
    FROM DUAL
),
p AS (
    SELECT p.procedure_name, a.data_type
    FROM user_procedures p
    JOIN user_arguments a
        ON a.package_name   = p.object_name
        AND a.object_name   = p.procedure_name
        AND a.position      = 0
    JOIN x
        ON x.package_name   = p.object_name
),
r AS (
    SELECT
        r.procedure_name,
        COUNT(*)            AS references
    FROM (
        SELECT REPLACE(RTRIM(REGEXP_SUBSTR(UPPER(s.text), x.package_name || '\.' || REPLACE(x.prefix, '_', '\_') || '[^(]*')), x.package_name || '.', '') AS procedure_name
        FROM user_source s
        CROSS JOIN x
        WHERE UPPER(s.text) LIKE '%' || x.package_name || '.' || x.prefix || '%'
    ) r
    GROUP BY r.procedure_name
)
SELECT
    s.ROWID                 AS rid,
    s.setting_group,
    s.setting_name,
    s.setting_value,
    s.setting_context,
    s.is_numeric,
    s.is_date,
    --
    p.procedure_name,
    p.data_type,
    --
    r.references,
    --
    CASE
        WHEN p.procedure_name IS NOT NULL
            AND (
                (p.data_type    = 'VARCHAR2'    AND s.is_numeric IS NULL AND s.is_date IS NULL)
                OR (p.data_type = 'NUMBER'      AND s.is_numeric = 'Y')
                OR (p.data_type = 'DATE'        AND s.is_date = 'Y')
            )
        THEN NULL
        ELSE app.get_icon('fa-warning', 'Rebuild needed')
        END AS action_check,
    --
    s.description_,
    s.updated_by,
    s.updated_at
FROM settings s
CROSS JOIN x
LEFT JOIN p
    ON p.procedure_name     = x.prefix || s.setting_name
LEFT JOIN r
    ON r.procedure_name     = x.prefix || s.setting_name
WHERE s.app_id              = app.get_app_id()
    AND s.setting_context   IS NULL;

