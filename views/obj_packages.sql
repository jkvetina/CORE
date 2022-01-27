CREATE OR REPLACE VIEW obj_packages AS
WITH s AS (
    SELECT
        s.name                  AS package_name,
        COUNT(s.line)           AS count_lines
    FROM user_source s
    JOIN (
        SELECT m.package_name
        FROM obj_modules m
        GROUP BY m.package_name
    ) m
        ON m.package_name       = s.name
    WHERE s.type                = 'PACKAGE BODY'
    GROUP BY s.name
),
f AS (
    SELECT
        a.package_name,
        SUM(CASE WHEN a.position = 0 THEN 1 ELSE 0 END) AS count_functions
    FROM s
    LEFT JOIN user_arguments a
        ON a.package_name       = s.package_name
    GROUP BY a.package_name
)
SELECT
    p.object_name               AS package_name,
    --
    COUNT(p.procedure_name) - MIN(f.count_functions) AS count_procedures,
    --
    MIN(f.count_functions)      AS count_functions,
    MAX(s.count_lines)          AS count_lines,
    MAX(o.last_ddl_time)        AS last_ddl_time,
    --
    -- @TODO: dependencies?
    --
    NULL                        AS desc_        -- @TODO: get from specification
FROM user_objects o
JOIN user_procedures p
    ON p.object_name            = o.object_name
    AND o.object_type           = 'PACKAGE'
JOIN s
    ON s.package_name           = p.object_name
JOIN f
    ON f.package_name           = p.object_name
GROUP BY p.object_name;
--
COMMENT ON TABLE obj_packages IS 'List of packages';

