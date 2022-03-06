--DROP MATERIALIZED VIEW nav_availability_mvw;
CREATE MATERIALIZED VIEW nav_availability_mvw
BUILD DEFERRED
REFRESH ON DEMAND COMPLETE
AS
SELECT
    p.application_id,
    p.page_id,
    MIN(p.authorization_scheme)     AS auth_scheme,
    MIN(f.package_name)             AS package_name,
    MIN(f.object_name)              AS procedure_name,
    MIN(f.pls_type)                 AS data_type,
    MIN(a.argument_name)            AS argument_name            
FROM apex_application_pages p
LEFT JOIN all_procedures s
    ON s.owner                      = app.get_core_owner()
    AND s.object_name               IN ('A' || TO_CHAR(p.application_id), 'APP', 'AUTH')   -- packages
    AND s.procedure_name            = p.authorization_scheme
LEFT JOIN all_arguments f
    ON f.owner                      = s.owner
    AND f.object_name               = s.procedure_name
    AND f.package_name              = s.object_name
    AND f.overload                  IS NULL
    AND f.position                  = 0
    AND f.argument_name             IS NULL
    AND f.in_out                    = 'OUT'
LEFT JOIN all_arguments a
    ON a.owner                      = f.owner
    AND a.object_name               = f.package_name
    AND a.package_name              = f.object_name
    AND a.overload                  IS NULL
    AND a.position                  = 1
    AND a.data_type                 = 'NUMBER'
    AND a.in_out                    = 'IN'
GROUP BY p.application_id, p.page_id;

