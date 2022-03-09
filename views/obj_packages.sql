CREATE OR REPLACE VIEW obj_packages AS
SELECT
    t.package_name,
    --
    CASE
        WHEN REGEXP_LIKE(t.package_name, '^A\d+$')              THEN 'CORE - Application roles...'
        WHEN REGEXP_LIKE(t.package_name, '^S\d+$')              THEN 'CORE - Application settings'
        WHEN t.package_name IN ('APP', 'APP_ACTIONS', 'GEN')    THEN 'CORE'
        END AS package_group,
    --
    NULLIF(COUNT(*) - SUM(CASE WHEN t.is_function IS NOT NULL THEN 1 ELSE 0 END), 0)    AS count_procedures,
    NULLIF(SUM(CASE WHEN t.is_function IS NOT NULL THEN 1 ELSE 0 END), 0)               AS count_functions,
    --
    SUM(t.count_lines)          AS count_lines,
    SUM(t.count_statements)     AS count_statements,
    --
    MAX(o.last_ddl_time)        AS last_ddl_time,
    --
    NULL AS desc_
FROM obj_modules t
JOIN all_objects o
    ON o.owner          = t.owner
    AND o.object_name   = t.package_name
    AND o.object_type   = 'PACKAGE'
GROUP BY t.package_name;
--
COMMENT ON TABLE obj_packages IS 'List of packages';

