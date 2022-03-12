--DROP MATERIALIZED VIEW nav_availability_mvw;
CREATE MATERIALIZED VIEW nav_availability_mvw
BUILD DEFERRED
REFRESH ON DEMAND COMPLETE
AS
WITH w AS (
    SELECT /*+ MATERIALIZE */
        a.owner,
        a.application_id
    FROM apex_applications a
    JOIN lov_app_schemas s
        ON s.owner      = a.owner
)
SELECT
    p.application_id,
    p.page_id,
    MIN(p.authorization_scheme) AS auth_scheme,
    --
    MIN(CASE WHEN a.position = 0 THEN a.package_name    END) AS package_name,
    MIN(CASE WHEN a.position = 0 THEN a.object_name     END) AS procedure_name,
    MIN(CASE WHEN a.position = 0 THEN a.pls_type        END) AS data_type,
    MIN(CASE WHEN a.position = 1 THEN a.argument_name   END) AS argument_name
FROM apex_application_pages p
JOIN w
    ON w.application_id             = p.application_id
LEFT JOIN all_procedures s
    ON s.owner                      = w.owner
    AND s.object_name               IN ('A' || TO_CHAR(p.application_id), 'APP', 'AUTH')   -- packages
    AND s.procedure_name            = p.authorization_scheme
LEFT JOIN all_arguments a
    ON a.owner                      = s.owner
    AND a.object_name               = s.procedure_name
    AND a.package_name              = s.object_name
    AND a.overload                  IS NULL
    AND ((
            a.position              = 0
            AND a.argument_name     IS NULL
            AND a.in_out            = 'OUT'
        )
        OR (
            a.position              = 1
            AND a.data_type         = 'NUMBER'
            AND a.in_out            = 'IN'
        )
    )
GROUP BY p.application_id, p.page_id;

