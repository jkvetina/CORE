CREATE OR REPLACE VIEW users_apps AS
WITH p AS (
    SELECT
        a.application_id        AS app_id,
        a.alias                 AS app_alias,
        a.application_group     AS app_group,
        a.owner                 AS app_schema,
        a.application_name      AS app_name,
        a.version               AS app_version,
        a.authentication_scheme,
        a.last_updated_on,
        a.pages                 AS count_pages,
        --
        COALESCE(p.page_id, TO_NUMBER(REGEXP_SUBSTR(a.home_link, ':(\d+):&' || 'SESSION\.', 1, 1, NULL, 1))) AS page_id,
        --
        CASE
            WHEN a.availability_status LIKE 'Available%'        THEN NULL
            WHEN a.availability_status LIKE 'Restricted Access' THEN NULL
            ELSE 'Y'
            END AS is_offline
    FROM apex_applications a
    LEFT JOIN apex_application_pages p
        ON p.application_id     = a.application_id
        AND a.home_link         LIKE '%:' || p.page_alias || ':%'
)
SELECT
    a.app_id,
    NVL(p.app_name, a.app_name) AS app_name,
    p.app_alias,
    p.app_group,
    p.app_schema,
    --
    CASE WHEN p.page_id IS NOT NULL
        THEN app.get_page_link (
            in_page_id      => p.page_id,
            in_app_id       => a.app_id,
            in_session_id   => CASE WHEN a.app_id = app.get_core_app_id() THEN 0 END
        ) END AS app_url,
    --
    p.app_version,
    p.authentication_scheme,
    p.last_updated_on,
    p.count_pages,
    --
    a.is_active,
    a.is_visible,
    --
    CASE WHEN
        p.app_schema                IS NOT NULL
        AND (
            a.is_visible            = 'Y'
            OR a.app_id IN (
                SELECT r.app_id
                FROM user_roles r
                WHERE r.user_id     = app.get_user_id()
            )
        )
        AND (
            app.is_developer_y()    = 'Y'
            OR a.app_id             != app.get_core_app_id()
        )
        THEN 'Y' END AS is_available,
    --
    p.is_offline,
    a.description_,
    a.message,
    NULL                AS action,
    a.app_id            AS action_id
FROM apps a
LEFT JOIN p
    ON p.app_id = a.app_id
UNION ALL
--
SELECT
    p.app_id,
    p.app_name,
    p.app_alias,
    p.app_group,
    p.app_schema,
    --
    app.get_page_link (
        in_page_id      => p.page_id,
        in_app_id       => p.app_id
    ) AS app_url,
    --
    p.app_version,
    p.authentication_scheme,
    p.last_updated_on,
    p.count_pages,
    --
    NULL AS is_active,
    NULL AS is_visible,
    NULL AS is_available,
    p.is_offline,
    --
    NULL AS description_,
    NULL AS message,
    --
    app.get_icon('fa-plus-square', 'Create new record') AS action,
    p.app_id                                            AS action_id
FROM p
LEFT JOIN apps a
    ON a.app_id         = p.app_id
WHERE a.app_id          IS NULL;

