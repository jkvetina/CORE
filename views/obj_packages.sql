CREATE OR REPLACE VIEW obj_packages AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_item('$PACKAGE_NAME') AS package_name
    FROM DUAL
),
s AS (
    SELECT
        s.name              AS package_name,
        COUNT(*)            AS count_lines
    FROM user_source s
    WHERE s.type            = 'PACKAGE BODY'
    GROUP BY s.name
),
f AS (
    SELECT
        a.package_name,
        SUM(CASE WHEN a.position = 0 THEN 1 ELSE 0 END) AS count_functions
    FROM user_arguments a
    GROUP BY a.package_name
)
SELECT
    p.object_name               AS package_name,
    --
    COUNT(p.procedure_name) - MIN(f.count_functions)     AS count_procedures,
    --
    MIN(f.count_functions)      AS count_functions,
    MAX(s.count_lines)          AS count_lines,
    MAX(o.last_ddl_time)        AS last_ddl_time,
    --
    -- dependencies?
    --
    NULL                    AS desc_
FROM user_objects o
CROSS JOIN x
JOIN user_procedures p
    ON p.object_name        = o.object_name
    AND o.object_type       = 'PACKAGE'
JOIN s
    ON s.package_name       = p.object_name
LEFT JOIN f
    ON f.package_name       = p.object_name
WHERE o.object_name         = NVL(x.package_name, o.object_name)
GROUP BY p.object_name;

