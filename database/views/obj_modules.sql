CREATE OR REPLACE FORCE VIEW obj_modules AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_owner()                             AS owner,
        app.get_item('$PACKAGE_NAME')               AS package_name,
        app.get_item('$MODULE_NAME')                AS module_name,
        app.get_item('$MODULE_TYPE')                AS module_type,
        app.get_item('$ARGUMENT_NAME')              AS argument_name,
        --
        UPPER(app.get_item('$SEARCH_PACKAGES'))     AS search_packages,
        UPPER(app.get_item('$SEARCH_MODULES'))      AS search_modules,
        UPPER(app.get_item('$SEARCH_ARGUMENTS'))    AS search_arguments,
        LOWER(app.get_item('$SEARCH_SOURCE'))       AS search_source
    FROM DUAL
),
t AS (
    SELECT /*+ MATERIALIZE */
        t.*,
        x.argument_name,
        x.search_arguments,
        x.search_source
    FROM obj_modules_mvw t
    JOIN x
        ON x.owner              = t.owner
        AND t.package_name      = NVL(x.package_name, t.package_name)
        AND t.module_name       = NVL(x.module_name, t.module_name)
        --AND SUBSTR(t.module_type, 1, 1)     = NVL(x.module_type, SUBSTR(t.module_type, 1, 1))
        --
        AND (t.package_name LIKE x.search_packages || '%' ESCAPE '\'    OR x.search_packages    IS NULL)
        AND (t.module_name  LIKE x.search_modules  || '%' ESCAPE '\'    OR x.search_modules     IS NULL)
),
a AS (
    SELECT /*+ MATERIALIZE */
        t.package_name,
        t.module_name,
        t.subprogram_id
    FROM t
    JOIN all_arguments a
        ON a.owner              = t.owner
        AND a.package_name      = t.package_name
        AND a.object_name       = t.module_name
        AND a.subprogram_id     = t.subprogram_id
        AND a.argument_name     LIKE t.search_arguments || '%' ESCAPE '\'
        AND (a.argument_name    = t.argument_name OR t.argument_name IS NULL)
    GROUP BY t.package_name, t.module_name, t.subprogram_id
),
s AS (
    SELECT /*+ MATERIALIZE */
        t.package_name,
        t.module_name,
        t.subprogram_id
    FROM t
    JOIN all_source s
        ON s.owner      = t.owner
        AND s.name      = t.package_name
        AND s.line      BETWEEN t.body_start AND t.body_end
        AND s.text      LIKE '%' || t.search_source  || '%' ESCAPE '\'
)
SELECT
    t.owner,
    t.package_name,
    t.module_name,
    t.subprogram_id,
    t.overload,
    t.group_name,
    t.is_function,
    t.is_private,
    t.is_autonomous,
    t.is_cached,
    t.is_definer,
    t.args_in,
    t.args_out,
    t.spec_start,
    t.spec_end,
    t.spec_lines,
    t.body_start,
    t.body_end,
    t.count_lines,
    t.count_statements,
    t.comment_
FROM t
WHERE (
        (t.package_name, t.module_name, t.subprogram_id) IN (
            SELECT a.package_name, a.module_name, a.subprogram_id
            FROM a
        )
        OR (
            t.argument_name         IS NULL
            AND t.search_arguments  IS NULL
        )
    )
    AND (
        (t.package_name, t.module_name, t.subprogram_id) IN (
            SELECT s.package_name, s.module_name, s.subprogram_id
            FROM s
        )
        OR (
            t.search_source IS NULL
        )
    );
--
COMMENT ON TABLE obj_modules                    IS 'Find package modules (procedures and functions) and their boundaries (start-end lines)';
--
COMMENT ON COLUMN obj_modules.package_name      IS 'Package name';
COMMENT ON COLUMN obj_modules.module_name       IS 'Module name';
COMMENT ON COLUMN obj_modules.group_name        IS 'Group name to have similar modules grouped together';
COMMENT ON COLUMN obj_modules.overload          IS 'Overload ID';
COMMENT ON COLUMN obj_modules.is_function       IS 'Module type (function)';
COMMENT ON COLUMN obj_modules.is_private        IS 'Flag for private procedures';
COMMENT ON COLUMN obj_modules.is_autonomous     IS 'Contains autonomous transaction';
COMMENT ON COLUMN obj_modules.is_cached         IS 'Has RESULT_CACHE activated';
COMMENT ON COLUMN obj_modules.is_definer        IS 'Auth as definer';
COMMENT ON COLUMN obj_modules.args_in           IS 'Number of IN arguments';
COMMENT ON COLUMN obj_modules.args_out          IS 'Number of OUT arguments';
COMMENT ON COLUMN obj_modules.spec_start        IS 'Module start in specification';
COMMENT ON COLUMN obj_modules.spec_end          IS 'Module end in specification';
COMMENT ON COLUMN obj_modules.spec_lines        IS 'Lines in specification';
COMMENT ON COLUMN obj_modules.body_start        IS 'Module start in body';
COMMENT ON COLUMN obj_modules.body_end          IS 'Module end in body';
COMMENT ON COLUMN obj_modules.count_lines       IS 'Lines in body';
COMMENT ON COLUMN obj_modules.comment_          IS 'Description from package spec';

