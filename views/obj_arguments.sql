CREATE OR REPLACE VIEW obj_arguments AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_owner()                             AS owner,
        app.get_item('$PACKAGE_NAME')               AS package_name,
        app.get_item('$MODULE_NAME')                AS module_name,
        app.get_item('$MODULE_TYPE')                AS module_type,     -- @TODO: implement
        app.get_item('$ARGUMENT_NAME')              AS argument_name,
        --
        UPPER(app.get_item('$SEARCH_PACKAGES'))     AS search_packages,
        UPPER(app.get_item('$SEARCH_MODULES'))      AS search_modules
    FROM DUAL
)
SELECT
    a.package_name,
    a.object_name           AS module_name,
    a.overload,
    NULLIF(a.position, 0)   AS position,
    a.argument_name,
    --
    CASE WHEN a.in_out IN ('IN',  'IN_OUT') THEN 'Y' END AS is_in,
    CASE WHEN a.in_out IN ('OUT', 'IN_OUT') THEN 'Y' END AS is_out,
    --
    a.data_type,
    a.data_length,
    a.data_precision,
    NULLIF(a.defaulted, 'N') AS is_default,
    a.default_value,
    --
    ROW_NUMBER() OVER(ORDER BY a.package_name, a.subprogram_id, a.object_name, a.overload, a.position) AS sort#
FROM all_arguments a
JOIN x
    ON a.owner              = x.owner
    AND a.package_name      = NVL(x.package_name, a.package_name)
    AND a.object_name       = NVL(x.module_name, a.object_name)
    AND a.argument_name     = NVL(x.argument_name, a.argument_name)
    --
    AND (a.package_name     LIKE x.search_packages || '%' ESCAPE '\' OR x.search_packages IS NULL)
    AND (a.object_name      LIKE x.search_modules  || '%' ESCAPE '\' OR x.search_modules  IS NULL);

