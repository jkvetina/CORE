CREATE OR REPLACE VIEW users_auth_schemes AS
SELECT
    a.authorization_scheme_name         AS auth_scheme,
    MAX(a.attribute_01)                 AS auth_source,
    --
    MAX(LTRIM(s.object_name || '.' || s.procedure_name, '.')) AS auth_procedure,
    --
    NULLIF(COUNT(p.page_id), 0)         AS count_pages,
    NULL                                AS count_regions,
    NULLIF(COUNT(u.user_id), 0)         AS count_users,
    --
    MAX(CASE WHEN a.caching = 'Once per session'    THEN 'Y' END) AS cache_session,
    MAX(CASE WHEN a.caching = 'Once per page view'  THEN 'Y' END) AS cache_page_view,
    MAX(CASE WHEN a.caching = 'BY_COMPONENT'        THEN 'Y' END) AS cache_component,
    MAX(CASE WHEN a.caching = 'NOCACHE'             THEN 'Y' END) AS cache_no,
    --
    MAX(a.error_message)                AS error_message
FROM apex_application_authorization a
LEFT JOIN apex_application_pages p
    ON p.application_id                 = a.application_id
    AND p.authorization_scheme          = a.authorization_scheme_name
LEFT JOIN roles r
    ON r.role_id                        = a.authorization_scheme_name
LEFT JOIN user_roles u
    ON u.app_id                         = a.application_id
    AND u.role_id                       = r.role_id
LEFT JOIN user_procedures s
    ON s.procedure_name                 = a.authorization_scheme_name
    AND UPPER(a.attribute_01)           LIKE '%' || s.object_name || '.' || s.procedure_name || '%'
WHERE a.application_id                  = app.get_app_id()
GROUP BY a.authorization_scheme_name;


