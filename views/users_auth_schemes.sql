CREATE OR REPLACE VIEW users_auth_schemes AS
SELECT
    a.authorization_scheme_name         AS auth_scheme,
    MAX(a.attribute_01)                 AS auth_source,
    MAX(s.procedure_name)               AS auth_procedure,
    --
    NULLIF(COUNT(p.page_id), 0)         AS pages,
    NULL                                AS regions,
    --
    MAX(a.error_message)                AS error_message,
    MAX(a.caching)                      AS caching
FROM apex_application_authorization a
LEFT JOIN apex_application_pages p
    ON p.application_id                 = a.application_id
    AND p.authorization_scheme          = a.authorization_scheme_name
LEFT JOIN roles r
    ON 'IS_' || r.role_id               = a.authorization_scheme_name
LEFT JOIN user_procedures s
    ON s.object_name                    = 'AUTH'--get_auth_package()
    AND s.procedure_name                = a.authorization_scheme_name
    AND s.procedure_name                = 'IS_' || r.role_id
WHERE a.application_id                  = app.get_app_id()
GROUP BY a.authorization_scheme_name;


