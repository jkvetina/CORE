CREATE OR REPLACE VIEW nav_overview AS
WITH t AS (
    SELECT
        n.page_id,
        p.page_name,
        p.page_title,
        p.page_alias,
        p.page_group,
        p.authorization_scheme,
        p.page_css_classes,
        LEVEL - 1                                                                           AS depth,
        SYS_CONNECT_BY_PATH(NVL(TO_CHAR(n.order#), 'Z') || '.' || TO_CHAR(n.page_id), '/')  AS order#,
        CONNECT_BY_ROOT NVL(n.order#, FLOOR(n.page_id / 10))                                AS page_root
    FROM navigation n
    LEFT JOIN apex_application_pages p
        ON p.application_id         = n.app_id
        AND p.page_id               = n.page_id
    WHERE n.app_id                  = app.get_app_id()
    CONNECT BY n.parent_id          = PRIOR n.page_id
        AND n.app_id                = PRIOR n.app_id
    START WITH n.parent_id          IS NULL
)
SELECT
    CASE
        WHEN r.page_id IS NOT NULL
            THEN app.get_icon('fa-minus-square', 'Remove record from Navigation table')
        END AS action,
    --
    app.get_page_link (
        in_page_id         => app.get_page_id(),
        in_app_id          => n.app_id,
        in_names           => 'P' || TO_CHAR(app.get_page_id()) || '_ACTION,P' || TO_CHAR(app.get_page_id()) || '_PAGE',
        in_values          => 'REMOVE,' || TO_CHAR(n.page_id)
    ) AS action_url,
    --
    n.app_id,
    n.page_id,
    n.parent_id,
    n.order#,
    --
    COALESCE(t.page_group, (SELECT page_group FROM t WHERE t.page_id = n.parent_id)) AS page_group,
    --
    t.page_root                     AS group#,
    --
    t.page_alias,
    REPLACE(LTRIM(RPAD('-', t.depth * 4), '-'), ' ', '&' || 'nbsp; ') || app.get_page_name(in_name => t.page_name) AS page_name,
    t.page_title,
    t.page_css_classes              AS css_class,
    --
    n.is_hidden,
    n.is_reset,
    --
    CASE WHEN t.authorization_scheme LIKE '%MUST_NOT_BE_PUBLIC_USER%'
        THEN app.get_icon('fa-check-square', 'MUST_NOT_BE_PUBLIC_USER')
        ELSE t.authorization_scheme
        END AS auth_scheme,
    --
    CASE WHEN n.page_id > 0 AND r.page_id IS NULL
        THEN app.get_page_link(n.page_id, in_session_id => CASE WHEN n.page_id = 9999 THEN 0 END)
        END AS page_url,
    --
    'UD'                            AS allow_changes,  -- U = update, D = delete
    t.order#                        AS sort_order
FROM navigation n
LEFT JOIN t
    ON t.page_id                    = n.page_id
LEFT JOIN nav_pages_to_remove r
    ON r.page_id                    = n.page_id
--
UNION ALL
SELECT
    app.get_icon('fa-plus-square', 'Create record in Navigation table') AS action,
    --
    app.get_page_link (
        in_page_id         => app.get_page_id(),
        in_app_id          => n.app_id,
        in_names           => 'P' || TO_CHAR(app.get_page_id()) || '_ACTION,P' || TO_CHAR(app.get_page_id()) || '_PAGE',
        in_values          => 'ADD,' || TO_CHAR(n.page_id)
    ) AS action_url,
    --
    n.app_id,
    n.page_id,
    n.parent_id,
    n.order#,
    --
    n.page_group,
    COALESCE(n.order#, FLOOR(t.page_root / 10)) AS group#,
    --
    n.page_alias,
    CASE WHEN n.parent_id IS NOT NULL THEN REPLACE(LTRIM(RPAD('-', 4), '-'), ' ', '&' || 'nbsp; ') END || app.get_page_name(in_name => n.page_name) AS page_name,
    n.page_title,
    n.css_class,
    --
    'Y'                     AS is_hidden,
    'Y'                     AS is_reset,
    --
    CASE WHEN n.auth_scheme LIKE '%MUST_NOT_BE_PUBLIC_USER%'
        THEN app.get_icon('fa-check-square', 'MUST_NOT_BE_PUBLIC_USER')
        ELSE n.auth_scheme
        END AS auth_scheme,
    --
    app.get_page_link(n.page_id)                        AS page_url,
    NULL                                                AS allow_changes,  -- no changes allowed
    TO_CHAR(t.order#) || '/Z.' || TO_CHAR(n.page_id)    AS sort_order
FROM nav_pages_to_add n
LEFT JOIN t
    ON t.page_id                    = n.parent_id;
--
COMMENT ON TABLE nav_overview IS 'Enriched navigation overview used also for menu rendering';
--
COMMENT ON COLUMN nav_overview.action           IS 'Action icon (add/remove page)';
COMMENT ON COLUMN nav_overview.action_url       IS 'Action url target to use icon as link';
COMMENT ON COLUMN nav_overview.app_id           IS 'Application id';
COMMENT ON COLUMN nav_overview.page_id          IS 'Page id';
COMMENT ON COLUMN nav_overview.parent_id        IS 'Parent page id to build a hierarchy, adjustable by the user/admin';
COMMENT ON COLUMN nav_overview.order#           IS 'Order of the siblings, adjustable by the user/admin';
COMMENT ON COLUMN nav_overview.page_group       IS 'Page group from APEX page specification';
COMMENT ON COLUMN nav_overview.group#           IS 'Group number derived as (page_id / 10) if order# is empty';
COMMENT ON COLUMN nav_overview.page_alias       IS 'Page alis from APEX page specification';
COMMENT ON COLUMN nav_overview.page_name        IS 'Page name from APEX page specification';
COMMENT ON COLUMN nav_overview.page_title       IS 'Page title from APEX page specification';
COMMENT ON COLUMN nav_overview.css_class        IS 'CSS class from APEX page specification';
COMMENT ON COLUMN nav_overview.is_hidden        IS 'Flag for hiding item in menu; Y = hide, NULL = show';
COMMENT ON COLUMN nav_overview.is_reset         IS 'Flag for reset/clear page items; Y = clear, NULL = keep;';
COMMENT ON COLUMN nav_overview.auth_scheme      IS 'Auth scheme from APEX page specification';
COMMENT ON COLUMN nav_overview.page_url         IS 'Page url to use as redirection target';
COMMENT ON COLUMN nav_overview.allow_changes    IS 'APEX column to allow edit/delete only some rows';
COMMENT ON COLUMN nav_overview.sort_order       IS 'Calculated path to show rows in correct order';

