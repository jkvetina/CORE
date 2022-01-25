CREATE OR REPLACE VIEW users_apps AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()            AS app_id,
        app.get_core_app_id()       AS core_app_id,
        app.get_user_id()           AS user_id,
        app.is_developer_y()        AS is_developer
    FROM DUAL
),
p AS (
    SELECT
        a.application_id            AS app_id,
        a.application_name          AS app_name,
        a.alias                     AS app_alias,
        a.application_group         AS app_group,
        a.owner                     AS app_schema,
        a.version                   AS app_version,
        --
        app.get_app_homepage(a.application_id) AS app_homepage,
        --
        app.get_page_link (
            in_page_id      => app.get_app_homepage(a.application_id),
            in_app_id       => a.application_id,
            in_session_id   => CASE WHEN a.application_id = x.core_app_id THEN 0 END
        ) AS app_url,
        --
        a.pages                                 AS count_pages,
        NULLIF(a.application_items, 0)          AS count_items,
        NULLIF(a.application_processes, 0)      AS count_processes,
        NULLIF(a.application_computations, 0)   AS count_computations,
        NULLIF(a.application_settings, 0)       AS count_settings,
        NULLIF(a.build_options, 0)              AS count_build_options,
        NULLIF(a.lists_of_values, 0)            AS count_lov,
        NULLIF(a.authorization_schemes, 0)      AS count_auth_schemes,
        NULLIF(a.web_services, 0)               AS count_ws,
        NULLIF(a.translation_messages, 0)       AS count_messages,
        --
        CASE WHEN a.error_handling_function IS NOT NULL     THEN 'Y' END AS is_error_function,
        CASE WHEN a.db_session_init_code    IS NOT NULL     THEN 'Y' END AS is_session_init,
        CASE WHEN a.db_session_cleanup_code IS NOT NULL     THEN 'Y' END AS is_session_cleanup,
        CASE WHEN a.session_state_protection = 'Enabled'    THEN 'Y' END AS is_session_protected,
        CASE WHEN a.rejoin_existing_sessions = 'Enabled'    THEN 'Y' END AS is_rejoin_sessions,
        CASE WHEN a.deep_linking             = 'Enabled'    THEN 'Y' END AS is_deep_linking,
        --
        CASE
            WHEN a.availability_status LIKE 'Available%'        THEN NULL
            WHEN a.availability_status LIKE 'Restricted Access' THEN NULL
            ELSE 'Y'
            END AS is_offline,
        --
        --documentation_banner ?
        a.global_notification,
        a.unavailable_text,
        a.authentication_scheme,
        a.last_updated_on
    FROM apex_applications a
    CROSS JOIN x
)
SELECT
    CASE WHEN p.app_id IS NULL
        THEN app.get_icon('fa-minus-square', 'Remove application from the list')
        END AS action,
    --
    CASE WHEN p.app_id IS NULL
        THEN app.get_page_link(922,
            in_names        => 'P922_ACTION,P922_APP_ID',
            in_values       => 'REMOVE,' || TO_CHAR(a.app_id)
        ) END AS action_url,
    --
    a.app_id,
    p.app_name,
    p.app_alias,
    p.app_group,
    p.app_schema,
    p.app_version,
    p.app_homepage,
    p.app_url,
    --
    a.description_,
    --
    p.count_pages,
    p.count_items,
    p.count_processes,
    p.count_computations,
    p.count_settings,
    p.count_build_options,
    p.count_lov,
    p.count_auth_schemes,
    p.count_ws,
    p.count_messages,
    --
    p.is_error_function,
    p.is_session_init,
    p.is_session_cleanup,
    p.is_session_protected,
    p.is_rejoin_sessions,
    p.is_deep_linking,
    --
    p.is_offline,
    a.is_visible,
    --
    CASE WHEN
        p.app_schema                IS NOT NULL
        AND (
            a.is_visible            = 'Y'
            OR a.app_id IN (
                SELECT r.app_id
                FROM user_roles r
                WHERE r.user_id     = x.user_id
            )
        )
        AND (
            x.is_developer          = 'Y'
            OR a.app_id             != x.core_app_id
        )
        THEN 'Y' END AS is_available,
    --
    p.global_notification,
    p.unavailable_text,
    p.authentication_scheme,
    p.last_updated_on
FROM apps a
CROSS JOIN x
LEFT JOIN p
    ON p.app_id = a.app_id
UNION ALL
--
SELECT
    CASE WHEN a.app_id IS NULL
        THEN app.get_icon('fa-plus-square', 'Add application to the list')
        END AS action,
    --
    CASE WHEN a.app_id IS NULL
        THEN app.get_page_link(922,
            in_names        => 'P922_ACTION,P922_APP_ID',
            in_values       => 'ADD,' || TO_CHAR(p.app_id)
        ) END AS action_url,
    --
    p.app_id,
    p.app_name,
    p.app_alias,
    p.app_group,
    p.app_schema,
    p.app_version,
    p.app_homepage,
    p.app_url,
    --
    a.description_,
    --
    p.count_pages,
    p.count_items,
    p.count_processes,
    p.count_computations,
    p.count_settings,
    p.count_build_options,
    p.count_lov,
    p.count_auth_schemes,
    p.count_ws,
    p.count_messages,
    --
    p.is_error_function,
    p.is_session_init,
    p.is_session_cleanup,
    p.is_session_protected,
    p.is_rejoin_sessions,
    p.is_deep_linking,
    --
    p.is_offline,
    a.is_visible,
    --
    CASE WHEN
        p.app_schema                IS NOT NULL
        AND (
            a.is_visible            = 'Y'
            OR a.app_id IN (
                SELECT r.app_id
                FROM user_roles r
                WHERE r.user_id     = x.user_id
            )
        )
        AND (
            x.is_developer          = 'Y'
            OR a.app_id             != x.core_app_id
        )
        THEN 'Y' END AS is_available,
    --
    p.global_notification,
    p.unavailable_text,
    p.authentication_scheme,
    p.last_updated_on
FROM p
CROSS JOIN x
LEFT JOIN apps a
    ON a.app_id         = p.app_id
WHERE a.app_id          IS NULL;
--
COMMENT ON TABLE users_apps IS '[CORE - DASHBOARD] Applications';

