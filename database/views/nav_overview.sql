CREATE OR REPLACE FORCE VIEW nav_overview AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_page_id()           AS page_id,
        app.get_app_id()            AS app_id,
        app.get_core_app_id()       AS core_app_id
    FROM DUAL
)
SELECT
    n.app_id,
    n.page_id,
    n.parent_id,
    n.order#,
    m.page_group,
    m.page_alias,
    --
    CASE WHEN m.depth IS NOT NULL
        THEN REPLACE(LTRIM(RPAD('-', m.depth * 4), '-'), ' ', '&' || 'nbsp; ') ||
            app.get_page_name (
                in_app_id       => m.app_id,
                in_page_id      => m.page_id,
                in_name         => m.page_name
            )
        END AS page_name,
    --
    app.get_page_title (
        in_app_id       => m.app_id,
        in_page_id      => m.page_id,
        in_title        => m.page_title
    ) AS page_title,
    --
    m.css_class,
    m.page_template,
    n.is_hidden,
    n.is_reset,
    n.is_shared,
    m.is_modal,
    m.is_javascript,
    m.javascript,
    m.auth_scheme,
    --
    CASE WHEN r.page_id IS NULL THEN m.page_url END AS page_url,
    --
    m.comments,
    m.sort_order,
    --
    'UD' AS allow_changes,  -- U = update, D = delete
    --
    CASE
        WHEN r.page_id IS NOT NULL
            THEN app.get_icon('fa-minus-square', 'Remove record from Navigation table')
        END AS action,
    --
    app.get_page_url (
        in_page_id          => 910,
        in_app_id           => x.core_app_id,
        in_names            => 'P' || TO_CHAR(910) || '_REMOVE_PAGE',
        in_values           => TO_CHAR(m.page_id)
    ) AS action_url
FROM navigation n
CROSS JOIN x
LEFT JOIN nav_overview_mvw m
    ON m.app_id             = n.app_id
    AND m.page_id           = n.page_id
LEFT JOIN nav_pages_to_remove r
    ON r.page_id            = n.page_id
WHERE (
        n.app_id            = x.app_id
        OR (
            n.is_shared     = 'Y'
            AND n.page_id   NOT IN (
                -- pages from active apps takes priority
                SELECT n.page_id
                FROM navigation n
                WHERE n.app_id      = x.app_id
            )
        )
    )
    AND (n.app_id, n.page_id) NOT IN (
        SELECT
            x.core_app_id   AS app_id,
            947             AS page_id
        FROM x
    )
--
UNION ALL
SELECT
    n.app_id,
    n.page_id,
    n.parent_id,
    n.order#,
    NVL(t.page_root, n.page_id) || ' ' || n.page_group AS page_group,
    n.page_alias,
    --
    n.page_name,
    n.page_title,
    n.css_class,
    n.page_template,
    --
    n.is_hidden,
    n.is_reset,
    n.is_shared,
    --
    CASE WHEN n.page_mode = 'Normal'    THEN NULL ELSE 'Y' END  AS is_modal,
    CASE WHEN t.javascript IS NOT NULL  THEN 'Y' END            AS is_javascript,
    t.javascript,
    --
    CASE WHEN n.auth_scheme LIKE '%MUST_NOT_BE_PUBLIC_USER%'
        THEN app.get_icon('fa-check-square', 'MUST_NOT_BE_PUBLIC_USER')
        ELSE n.auth_scheme
        END AS auth_scheme,
    --
    CASE
        WHEN t.javascript_target IS NOT NULL
            THEN t.javascript_target
            --
        ELSE app.get_page_url (
            in_page_id      => n.page_id,
            in_app_id       => n.app_id
        )
        END AS page_url,
    --
    n.comments,
    --
    NULL AS allow_changes,  -- no changes allowed
    --
    NVL(t.page_root, n.page_id) || '.' || TO_CHAR(10000 + (
        SELECT NVL(MAX(z.r#), 0) AS nearest_r#
        FROM nav_overview_mvw z
        WHERE z.app_id          = n.app_id
            AND z.page_group    = n.page_group
            AND z.order#        = n.order#
    )) || '.' || NVL(n.order#, n.page_id) AS sort_order,
    --
    app.get_icon('fa-plus-square', 'Create record in Navigation table') AS action,
    --
    app.get_page_url (
        in_page_id         => 910,
        in_app_id          => app.get_core_app_id(),
        in_names           => 'P' || TO_CHAR(910) || '_ADD_PAGE',
        in_values          => TO_CHAR(n.page_id)
    ) AS action_url
FROM nav_pages_to_add n
JOIN x
    ON x.app_id             = n.app_id
JOIN apps a
    ON a.app_id             = n.app_id
LEFT JOIN nav_overview_mvw t
    ON t.app_id             = n.app_id
    AND t.page_id           = n.parent_id;
--
COMMENT ON TABLE nav_overview IS '[CORE - DASHBOARD] Enriched navigation overview used also for menu rendering';
--
COMMENT ON COLUMN nav_overview.app_id           IS 'Application id';
COMMENT ON COLUMN nav_overview.page_id          IS 'Page id';
COMMENT ON COLUMN nav_overview.parent_id        IS 'Parent page id to build a hierarchy, adjustable by the user/admin';
COMMENT ON COLUMN nav_overview.order#           IS 'Order of the siblings, adjustable by the user/admin';
COMMENT ON COLUMN nav_overview.page_group       IS 'Page group from APEX page specification; sorted';
COMMENT ON COLUMN nav_overview.page_alias       IS 'Page alis from APEX page specification';
COMMENT ON COLUMN nav_overview.page_name        IS 'Page name from APEX page specification';
COMMENT ON COLUMN nav_overview.page_title       IS 'Page title from APEX page specification';
COMMENT ON COLUMN nav_overview.css_class        IS 'CSS class from APEX page specification';
COMMENT ON COLUMN nav_overview.page_template    IS 'Type of template used on page';
COMMENT ON COLUMN nav_overview.is_hidden        IS 'Flag for hiding item in menu; Y = hide, NULL = show';
COMMENT ON COLUMN nav_overview.is_reset         IS 'Flag for reset/clear page items; Y = clear, NULL = keep;';
COMMENT ON COLUMN nav_overview.is_shared        IS 'Flag for sharing record with other apps';
COMMENT ON COLUMN nav_overview.is_modal         IS 'Flag for modal dialogs';
COMMENT ON COLUMN nav_overview.is_javascript    IS 'Flag for JavaScript as the target';
COMMENT ON COLUMN nav_overview.auth_scheme      IS 'Auth scheme from APEX page specification';
COMMENT ON COLUMN nav_overview.page_url         IS 'Page url to use as redirection target';
COMMENT ON COLUMN nav_overview.sort_order       IS 'Calculated path to show rows in correct order';
COMMENT ON COLUMN nav_overview.allow_changes    IS 'APEX column to allow edit/delete only some rows';
COMMENT ON COLUMN nav_overview.action           IS 'Action icon (add/remove page)';
COMMENT ON COLUMN nav_overview.action_url       IS 'Action url target to use icon as link';

