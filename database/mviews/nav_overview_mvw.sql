-- DROP MATERIALIZED VIEW nav_overview_mvw;
CREATE MATERIALIZED VIEW nav_overview_mvw
BUILD DEFERRED
REFRESH COMPLETE ON DEMAND
AS
WITH t AS (
    SELECT /*+ MATERIALIZE */
        ROWNUM AS r#,   -- to keep hierarchy sorted
        t.*
    FROM (
        SELECT
            n.app_id,
            n.page_id,
            n.order#,
            --
            REPLACE(p.page_name,  '&' || 'APP_NAME.', a.application_name) AS page_name,
            REPLACE(p.page_title, '&' || 'APP_NAME.', a.application_name) AS page_title,
            --
            p.page_alias,
            p.page_group,
            p.authorization_scheme,
            p.page_css_classes,
            p.page_mode,
            p.page_template,
            p.page_comment      AS comments,
            --
            '#'                 AS javascript_target,
            i.item_source       AS javascript,
            --
            LEVEL - 1                                   AS depth,
            CONNECT_BY_ROOT NVL(n.order#, n.page_id)    AS page_root
        FROM navigation n
        JOIN apps a
            ON a.app_id                 = n.app_id
        LEFT JOIN apex_application_pages p
            ON p.application_id         = n.app_id
            AND p.page_id               = n.page_id
        LEFT JOIN apex_applications a
            ON a.application_id         = p.application_id
        LEFT JOIN apex_application_page_items i
            ON i.application_id         = n.app_id
            AND i.item_name             = 'P' || TO_CHAR(n.page_id) || '_JAVASCRIPT_TARGET'
        CONNECT BY n.parent_id          = PRIOR n.page_id
            AND n.app_id                = PRIOR n.app_id
        START WITH n.parent_id          IS NULL
        ORDER SIBLINGS BY n.app_id, n.order#, n.page_id
    ) t
)
SELECT
    n.app_id,
    n.page_id,
    n.parent_id,
    n.order#,
    t.r#,
    --
    t.page_root,
    t.page_root || ' ' || COALESCE (
        t.page_group,
        (
            SELECT t.page_group
            FROM t
            WHERE t.app_id      = n.app_id
                AND t.page_id   = n.parent_id
        )
    ) AS page_group,
    --
    t.page_alias,
    t.depth,
    t.page_name,
    t.page_title,
    t.page_css_classes AS css_class,
    t.page_template,
    --
    n.is_hidden,
    n.is_reset,
    n.is_shared,
    --
    CASE WHEN t.page_mode = 'Normal'    THEN NULL ELSE 'Y' END  AS is_modal,
    CASE WHEN t.javascript IS NOT NULL  THEN 'Y' END            AS is_javascript,
    t.javascript,
    t.javascript_target,
    --
    CASE
        WHEN t.authorization_scheme LIKE '%MUST_NOT_BE_PUBLIC_USER%'
            THEN app.get_icon('fa-check-square', 'MUST_NOT_BE_PUBLIC_USER')
            --
        WHEN t.authorization_scheme IS NULL AND n.page_id NOT IN (0, 9999)
            THEN app.get_icon('fa-warning', 'Auth scheme is missing')
            --
        ELSE app_actions.get_html_a(app.get_page_url (
            in_page_id      => 920,
            in_app_id       => n.app_id,
            in_names        => 'P920_AUTH_SCHEME',
            in_values       => t.authorization_scheme
        ), t.authorization_scheme)
        END AS auth_scheme,
    --
    CASE
        WHEN t.javascript_target IS NOT NULL
            THEN t.javascript_target
            --
        WHEN n.page_id > 0
            THEN app.get_page_url (
                in_page_id      => n.page_id,
                in_app_id       => n.app_id,
                in_session_id   => CASE WHEN n.page_id = 9999 THEN 0 END
            )
            END AS page_url,
    --
    t.comments,
    --
    'UD' AS allow_changes,  -- U = update, D = delete
    --
    t.page_root || '.' || TO_CHAR(10000 + t.r#) || '.' || NVL(t.order#, t.page_id) || '.' || n.page_id AS sort_order
FROM navigation n
JOIN apps a
    ON a.app_id             = n.app_id
LEFT JOIN t
    ON t.app_id             = n.app_id
    AND t.page_id           = n.page_id
WHERE (n.app_id, n.page_id) NOT IN (
    SELECT
        app.get_core_app_id()   AS app_id,
        947                     AS page_id
    FROM DUAL
);

