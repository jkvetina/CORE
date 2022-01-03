CREATE OR REPLACE VIEW settings_overview AS
WITH x AS (
    SELECT
        UPPER('SETT')                   AS package_name,        -- app_actions spec
        UPPER('GET_')                   AS prefix,
        app.get_item('$SETTING_NAME')   AS setting_name,
        app.get_app_id()                AS app_id
    FROM users u
    WHERE u.user_id = app.get_user_id()
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
        t.procedure_name,
        COUNT(*)            AS references
    FROM (
        SELECT REPLACE(RTRIM(REGEXP_SUBSTR(UPPER(s.text), x.package_name || '\.' || REPLACE(x.prefix, '_', '\_') || '[^(]*')), x.package_name || '.', '') AS procedure_name
        FROM user_source s
        CROSS JOIN x
        WHERE UPPER(s.text) LIKE '%' || x.package_name || '.' || x.prefix || '%'
    ) t
    GROUP BY t.procedure_name
),
v AS (
    SELECT
        t.procedure_name,
        COUNT(*)            AS references
    FROM (
        SELECT REPLACE(RTRIM(REGEXP_SUBSTR(UPPER(s.text), x.package_name || '\.' || REPLACE(x.prefix, '_', '\_') || '[^(]*')), x.package_name || '.', '') AS procedure_name
        FROM user_source_views s
        CROSS JOIN x
        WHERE UPPER(s.text) LIKE '%' || x.package_name || '.' || x.prefix || '%'
    ) t
    GROUP BY t.procedure_name
)
SELECT
    s.setting_group,
    s.setting_name,
    s.setting_name          AS setting_name_old,
    s.setting_value,
    s.is_numeric,
    s.is_date,
    --
    p.procedure_name,
    p.data_type,
    --
    r.references            AS references_procedures,
    v.references            AS references_views,
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
JOIN x
    ON x.app_id             = s.app_id
LEFT JOIN p
    ON p.procedure_name     = x.prefix || s.setting_name
LEFT JOIN r
    ON r.procedure_name     = x.prefix || s.setting_name
LEFT JOIN v
    ON v.procedure_name     = x.prefix || s.setting_name
WHERE s.setting_name        = NVL(x.setting_name, s.setting_name)
    AND s.setting_context   IS NULL;

