CREATE OR REPLACE VIEW roles_auth_schemes AS
SELECT
    MAX(r.role_id)                          AS role_id,
    MAX(r.role_group)                       AS role_group,
    --
    a.authorization_scheme_name             AS auth_scheme,
    NULL                                    AS auth_scheme_icon,
    --
    MAX(LTRIM(s.object_name || '.' || s.procedure_name, '.')) AS auth_procedure,
    --
    CASE
        WHEN MAX(s.procedure_name) IS NULL AND a.authorization_scheme_name NOT IN ('NOBODY')
            THEN 'fa fa-warning'
        END AS auth_procedure_icon,

    MAX(a.attribute_01)                     AS auth_source_code,
    --
    NULLIF(COUNT(DISTINCT p.page_id), 0)    AS count_pages,
    NULLIF(COUNT(DISTINCT g.region_id), 0)  AS count_regions,
    NULLIF(COUNT(DISTINCT u.user_id), 0)    AS count_users,
    --
    MAX(CASE WHEN a.caching = 'Once per session'    THEN 'Y' END)   AS cache_session,
    MAX(CASE WHEN a.caching = 'Once per page view'  THEN 'Y' END)   AS cache_page_view,
    MAX(CASE WHEN a.caching = 'BY_COMPONENT'        THEN 'Y' END)   AS cache_component,
    MAX(CASE WHEN a.caching = 'NOCACHE'             THEN 'Y' END)   AS cache_no,
    --
    MAX(a.error_message)                                            AS error_message,
    TO_CHAR(MAX(r.order#)) || a.authorization_scheme_name           AS sort#
FROM apex_application_authorization a
LEFT JOIN apex_application_pages p
    ON p.application_id                 = a.application_id
    AND p.authorization_scheme          = a.authorization_scheme_name
LEFT JOIN apex_application_page_regions g
    ON g.application_id                 = a.application_id
    AND g.authorization_scheme          = a.authorization_scheme_name
LEFT JOIN roles r
    ON r.role_id                        = a.authorization_scheme_name
LEFT JOIN user_roles u
    ON u.app_id                         = a.application_id
    AND u.role_id                       = r.role_id
LEFT JOIN user_procedures s
    ON s.procedure_name                 = a.authorization_scheme_name
    AND UPPER(a.attribute_01)           LIKE '%' || s.object_name || '.' || s.procedure_name || '%'
WHERE a.application_id                  = app.get_app_id()
GROUP BY a.authorization_scheme_name
UNION ALL
--
SELECT
    r.role_id,
    r.role_group,
    --
    NULL                                AS auth_scheme,
    'fa fa-warning'                     AS auth_scheme_icon,
    NULL                                AS auth_procedure,
    'fa fa-warning'                     AS auth_procedure_icon,
    NULL                                AS auth_source_code,
    NULL                                AS count_pages,
    NULL                                AS count_regions,
    u.count_users                       AS count_users,
    NULL                                AS cache_session,
    NULL                                AS cache_page_view,
    NULL                                AS cache_component,
    NULL                                AS cache_no,
    NULL                                AS error_message,
    TO_CHAR(r.order#) || r.role_id      AS sort#
FROM roles r
LEFT JOIN apex_application_authorization a
    ON a.application_id                 = r.app_id
    AND a.authorization_scheme_name     = r.role_id
LEFT JOIN (
    SELECT
        u.role_id,
        COUNT(*)        AS count_users
    FROM user_roles u
    WHERE u.app_id      = app.get_app_id()
    GROUP BY u.role_id
) u
    ON u.role_id                        = r.role_id
WHERE r.app_id                          = app.get_app_id()
    AND a.authorization_scheme_name     IS NULL;

