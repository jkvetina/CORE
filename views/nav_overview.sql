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
        SYS_CONNECT_BY_PATH(NVL(TO_CHAR(n.order#), 'Z') || '.' || TO_CHAR(n.page_id), '/')  AS order#
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
    t.page_alias,
    REPLACE(LTRIM(RPAD('-', t.depth * 4), '-'), ' ', '&' || 'nbsp; ') || app.get_page_name(in_name => t.page_name) AS page_name,
    t.page_title,
    --
    n.is_hidden,
    n.is_reset,
    --
    COALESCE(t.page_group, (SELECT page_group FROM t WHERE t.page_id = n.parent_id)) AS page_group,
    --
    t.page_css_classes              AS css_class,
    --
    CASE WHEN t.authorization_scheme LIKE '%MUST_NOT_BE_PUBLIC_USER%'
        THEN app.get_icon('fa-check-square', 'MUST_NOT_BE_PUBLIC_USER')
        ELSE t.authorization_scheme
        END AS auth_scheme,
    --
    CASE WHEN n.is_reset IS NOT NULL
        THEN app.get_icon('fa-check-square', 'Resets page items')
        END AS reset_,
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
    n.page_alias,
    REPLACE(LTRIM(RPAD('-', 4), '-'), ' ', '&' || 'nbsp; ') || app.get_page_name(in_name => n.page_name) AS page_name,
    n.page_title,
    --
    'Y'                     AS is_hidden,
    'Y'                     AS is_reset,
    n.page_group,
    n.css_class,
    --
    CASE WHEN n.auth_scheme LIKE '%MUST_NOT_BE_PUBLIC_USER%'
        THEN app.get_icon('fa-check-square', 'MUST_NOT_BE_PUBLIC_USER')
        ELSE n.auth_scheme
        END AS auth_scheme,
    --
    NULL AS reset_,
    --
    app.get_page_link(n.page_id)                        AS page_url,
    NULL                                                AS allow_changes,  -- no changes allowed
    TO_CHAR(t.order#) || '/Z.' || TO_CHAR(n.page_id)    AS sort_order
FROM nav_pages_to_add n
LEFT JOIN t
    ON t.page_id                    = n.parent_id;
