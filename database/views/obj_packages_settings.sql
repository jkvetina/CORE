CREATE OR REPLACE FORCE VIEW obj_packages_settings AS
WITH s AS (
    SELECT
        s.name          AS object_name,
        s.type          AS object_type,
        --
        CASE WHEN s.plsql_code_type = 'INTERPRETED'                 THEN 'Y' END AS is_interpreted,
        s.plsql_optimize_level,
        --
        CASE WHEN s.plscope_settings LIKE '%IDENTIFIERS:ALL%'       THEN 'Y' END AS is_scope_identifiers,
        CASE WHEN s.plscope_settings LIKE '%STATEMENTS:ALL%'        THEN 'Y' END AS is_scope_statements,
        --
        CASE WHEN s.plsql_warnings LIKE '%ENABLE:INFORMATIONAL%'    OR s.plsql_warnings LIKE '%ENABLE:ALL%' THEN 'Y' END AS is_warning_informational,
        CASE WHEN s.plsql_warnings LIKE '%ENABLE:PERFORMANCE%'      OR s.plsql_warnings LIKE '%ENABLE:ALL%' THEN 'Y' END AS is_warning_performance,
        CASE WHEN s.plsql_warnings LIKE '%ENABLE:SEVERE%'           OR s.plsql_warnings LIKE '%ENABLE:ALL%' THEN 'Y' END AS is_warning_severe,
        --
        CASE WHEN s.plsql_debug = 'TRUE'                            THEN 'Y' END AS is_plsql_debug,
        CASE WHEN s.nls_length_semantics = 'CHAR'                   THEN 'Y' END AS is_nls_char,
        --
        s.plsql_ccflags
    FROM all_plsql_object_settings s
    WHERE s.owner       = app.get_owner()
        AND s.type      LIKE 'PACKAGE%'
)
SELECT 
    CASE
        WHEN s.is_interpreted           = 'Y'
            AND s.plsql_optimize_level  <= 2
            AND s.is_scope_identifiers  = 'Y'
            AND s.is_scope_statements   = 'Y'
        THEN NULL
        ELSE app.get_icon('fa-warning', 'This package is not available for analysis')
        END AS action_check,
    --
    s.object_name,
    s.object_type,
    --
    s.is_interpreted,
    s.plsql_optimize_level,
    s.is_scope_identifiers,
    s.is_scope_statements,
    s.is_warning_informational,
    s.is_warning_performance,
    s.is_warning_severe,
    s.is_plsql_debug,
    s.is_nls_char,
    s.plsql_ccflags
FROM s
MINUS
SELECT 
    CASE
        WHEN s.is_interpreted           = 'Y'
            AND s.plsql_optimize_level  <= 2
            AND s.is_scope_identifiers  = 'Y'
            AND s.is_scope_statements   = 'Y'
        THEN NULL
        ELSE app.get_icon('fa-warning', 'This package is not available for analysis')
        END AS action_check,
    --
    s.object_name,
    'PACKAGE BODY'              AS object_type,
    --
    s.is_interpreted,
    s.plsql_optimize_level,
    s.is_scope_identifiers,
    s.is_scope_statements,
    s.is_warning_informational,
    s.is_warning_performance,
    s.is_warning_severe,
    s.is_plsql_debug,
    s.is_nls_char,
    s.plsql_ccflags
FROM s
WHERE s.object_type = 'PACKAGE';
--
COMMENT ON TABLE obj_packages_settings IS 'PL/SQL settings related to packages';

