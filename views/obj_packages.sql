CREATE OR REPLACE VIEW obj_packages AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_owner()         AS owner
    FROM DUAL
),
s AS (
    SELECT /*+ MATERIALIZE */
        s.owner,
        s.name                  AS package_name,
        COUNT(s.line)           AS count_lines
    FROM all_source s
    JOIN x
        ON x.owner              = s.owner
        AND s.type              = 'PACKAGE BODY'
    JOIN obj_modules m
        ON m.package_name       = s.name
    GROUP BY s.owner, s.name
),
f AS (
    SELECT /*+ MATERIALIZE */
        a.package_name,
        SUM(CASE WHEN a.position = 0 THEN 1 ELSE 0 END) AS count_functions
    FROM s
    LEFT JOIN all_arguments a
        ON a.owner              = s.owner
        AND a.package_name      = s.package_name
    GROUP BY a.package_name
)
SELECT
    p.object_name               AS package_name,
    --
    CASE
        WHEN REGEXP_LIKE(p.object_name, '^A\d+$')           THEN 'CORE - Application roles...'
        WHEN REGEXP_LIKE(p.object_name, '^S\d+$')           THEN 'CORE - Application settings'
        WHEN p.object_name IN ('APP', 'APP_ACTIONS', 'GEN') THEN 'CORE'
        END AS package_group,
    --
    NULLIF(COUNT(p.procedure_name) - MIN(f.count_functions), 0) AS count_procedures,
    --
    NULLIF(MIN(f.count_functions), 0)   AS count_functions,
    MAX(s.count_lines)                  AS count_lines,
    MAX(o.last_ddl_time)                AS last_ddl_time,
    --
    -- @TODO: dependencies?
    -- @TODO: references?
    --
    NULL                        AS desc_        -- @TODO: get from specification
FROM all_objects o
JOIN all_procedures p
    ON p.owner                  = o.owner
    AND p.object_name           = o.object_name
JOIN s
    ON s.owner                  = p.owner
    AND s.package_name          = p.object_name
JOIN f
    ON f.package_name           = p.object_name
WHERE o.owner                   = s.owner
    AND o.object_type           = 'PACKAGE'
GROUP BY p.object_name;
--
COMMENT ON TABLE obj_packages IS 'List of packages';

