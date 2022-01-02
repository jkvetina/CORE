CREATE OR REPLACE VIEW nav_overview AS
WITH x AS (
    SELECT
        app.get_item('$PAGE_ID')    AS filter_page_id,
        app.get_page_id()           AS page_id,
        app.get_app_id()            AS app_id,
        app.get_core_app_id()       AS core_app_id
    FROM users u
    WHERE u.user_id = app.get_user_id()
),
t AS (
    SELECT
        n.app_id,
        n.page_id,
        --
        REPLACE(p.page_name,  '&' || 'APP_NAME.', a.application_name) AS page_name,
        REPLACE(p.page_title, '&' || 'APP_NAME.', a.application_name) AS page_title,
        --
        p.page_alias,
        p.page_group,
        p.authorization_scheme,
        p.page_css_classes,
        --
        LEVEL - 1                                   AS depth,
        CONNECT_BY_ROOT NVL(n.order#, n.page_id)    AS page_root
    FROM navigation n
    CROSS JOIN x
    LEFT JOIN apex_application_pages p
        ON p.application_id         = n.app_id
        AND p.page_id               = n.page_id
    LEFT JOIN apex_applications a
        ON a.application_id = p.application_id
    WHERE n.app_id                  IN (x.app_id, x.core_app_id)
    CONNECT BY n.parent_id          = PRIOR n.page_id
        AND n.app_id                = PRIOR n.app_id
    START WITH n.parent_id          IS NULL
)
SELECT
    n.app_id,
    n.page_id,
    n.parent_id,
    n.order#,
    t.page_root || ' ' || COALESCE(t.page_group, (SELECT page_group FROM t WHERE t.page_id = n.parent_id)) AS page_group,
    t.page_alias,
    --
    CASE WHEN r.page_id IS NULL
        THEN REPLACE(LTRIM(RPAD('-', t.depth * 4), '-'), ' ', '&' || 'nbsp; ') ||
            app.get_page_name (
                in_app_id       => n.app_id,
                in_page_id      => n.page_id,
                in_name         => t.page_name
            )
        END AS page_name,
    --
    t.page_title,
    t.page_css_classes AS css_class,
    --
    n.is_hidden,
    n.is_reset,
    n.is_shared,
    --
    CASE WHEN t.authorization_scheme LIKE '%MUST_NOT_BE_PUBLIC_USER%'
        THEN app.get_icon('fa-check-square', 'MUST_NOT_BE_PUBLIC_USER')
        ELSE t.authorization_scheme
        END AS auth_scheme,
    --
    CASE WHEN n.page_id > 0 AND r.page_id IS NULL
        THEN app.get_page_link (
            in_page_id      => n.page_id,
            in_app_id       => n.app_id,
            in_session_id   => CASE WHEN n.page_id = 9999 THEN 0 END
        )
        END AS page_url,
    --
    'UD'                                                                AS allow_changes,  -- U = update, D = delete
    --
    t.page_root || '.' || t.depth || '.' || NVL(n.order#, n.page_id)    AS sort_order,
    --
    CASE
        WHEN r.page_id IS NOT NULL
            THEN app.get_icon('fa-minus-square', 'Remove record from Navigation table')
        END AS action,
    --
    app.get_page_link (
        in_page_id          => x.page_id,
        in_app_id           => x.core_app_id,
        in_names            => 'P' || TO_CHAR(x.page_id) || '_REMOVE_PAGE',
        in_values           => TO_CHAR(n.page_id)
    ) AS action_url
FROM navigation n
CROSS JOIN x
LEFT JOIN t
    ON t.app_id             = n.app_id
    AND t.page_id           = n.page_id
LEFT JOIN nav_pages_to_remove r
    ON r.page_id            = n.page_id
WHERE (x.filter_page_id     = n.page_id OR x.filter_page_id IS NULL)
    AND (
        n.app_id            = x.app_id
        OR (
            n.app_id        = x.core_app_id
            AND n.is_shared = 'Y'
            AND n.page_id   NOT IN (
                -- if page from CORE has same page number in current app, then skip it
                SELECT n.page_id
                FROM navigation n
                WHERE n.app_id      = x.app_id
            )
        )
    )
--
UNION ALL
SELECT
    n.app_id,
    n.page_id,
    n.parent_id,
    n.order#,
    t.page_root || ' ' || n.page_group AS page_group,
    n.page_alias,
    --
    CASE WHEN n.parent_id IS NOT NULL
        THEN REPLACE(LTRIM(RPAD('-', 4), '-'), ' ', '&' || 'nbsp; ')
        END || app.get_page_name(in_app_id => n.app_id, in_page_id => n.page_id, in_name => n.page_name) AS page_name,
    --
    n.page_title,
    n.css_class,
    --
    n.is_hidden,
    n.is_reset,
    n.is_shared,
    --
    CASE WHEN n.auth_scheme LIKE '%MUST_NOT_BE_PUBLIC_USER%'
        THEN app.get_icon('fa-check-square', 'MUST_NOT_BE_PUBLIC_USER')
        ELSE n.auth_scheme
        END AS auth_scheme,
    --
    app.get_page_link (
        in_page_id      => n.page_id,
        in_app_id       => n.app_id
    ) AS page_url,
    --
    NULL                                                                    AS allow_changes,  -- no changes allowed
    --
    t.page_root || '.' || (t.depth + 1) || '.' || NVL(n.order#, n.page_id)  AS sort_order,
    --
    app.get_icon('fa-plus-square', 'Create record in Navigation table') AS action,
    --
    app.get_page_link (
        in_page_id         => x.page_id,
        in_app_id          => x.core_app_id,
        in_names           => 'P' || TO_CHAR(x.page_id) || '_ADD_PAGE',
        in_values          => TO_CHAR(n.page_id)
    ) AS action_url
FROM nav_pages_to_add n
CROSS JOIN x
LEFT JOIN t
    ON t.app_id             = n.app_id
    AND t.page_id           = n.parent_id
WHERE (x.filter_page_id     = n.page_id OR x.filter_page_id IS NULL);
--
COMMENT ON TABLE nav_overview                   IS 'Enriched navigation overview used also for menu rendering';
--
COMMENT ON COLUMN nav_overview.action           IS 'Action icon (add/remove page)';
COMMENT ON COLUMN nav_overview.action_url       IS 'Action url target to use icon as link';
COMMENT ON COLUMN nav_overview.app_id           IS 'Application id';
COMMENT ON COLUMN nav_overview.page_id          IS 'Page id';
COMMENT ON COLUMN nav_overview.parent_id        IS 'Parent page id to build a hierarchy, adjustable by the user/admin';
COMMENT ON COLUMN nav_overview.order#           IS 'Order of the siblings, adjustable by the user/admin';
COMMENT ON COLUMN nav_overview.page_group       IS 'Page group from APEX page specification; sorted';
COMMENT ON COLUMN nav_overview.page_alias       IS 'Page alis from APEX page specification';
COMMENT ON COLUMN nav_overview.page_name        IS 'Page name from APEX page specification';
COMMENT ON COLUMN nav_overview.page_title       IS 'Page title from APEX page specification';
COMMENT ON COLUMN nav_overview.css_class        IS 'CSS class from APEX page specification';
COMMENT ON COLUMN nav_overview.is_hidden        IS 'Flag for hiding item in menu; Y = hide, NULL = show';
COMMENT ON COLUMN nav_overview.is_reset         IS 'Flag for reset/clear page items; Y = clear, NULL = keep;';
COMMENT ON COLUMN nav_overview.is_shared        IS 'Flag for sharing record with other apps';
COMMENT ON COLUMN nav_overview.auth_scheme      IS 'Auth scheme from APEX page specification';
COMMENT ON COLUMN nav_overview.page_url         IS 'Page url to use as redirection target';
COMMENT ON COLUMN nav_overview.allow_changes    IS 'APEX column to allow edit/delete only some rows';
COMMENT ON COLUMN nav_overview.sort_order       IS 'Calculated path to show rows in correct order';

