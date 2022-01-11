CREATE OR REPLACE VIEW nav_pages_to_add AS
WITH g AS (
    SELECT
        p.page_group,
        n.page_id,
        n.parent_id,
        n.order#
    FROM navigation n
    JOIN apex_application_pages p
        ON p.application_id     = n.app_id
        AND p.page_id           = n.page_id
    WHERE n.app_id              = app.get_app_id()
)
SELECT
    p.application_id AS app_id,
    p.page_id,
    --
    (
        SELECT COALESCE(MAX(CASE WHEN g.parent_id IS NULL THEN g.page_id END), MIN(g.page_id)) AS parent_id
        FROM g
        WHERE g.page_group      = p.page_group
    ) AS parent_id,
    --
    p.page_alias,
    p.page_name,
    p.page_title,
    --
    COALESCE((
        SELECT MAX(g.order#) AS order#
        FROM g
        WHERE g.page_group      = p.page_group
            AND g.page_id       < p.page_id
            AND g.parent_id     IN (
                SELECT MAX(g.parent_id) AS parent_id
                FROM g
                WHERE g.page_group      = p.page_group
                    AND g.page_id       < p.page_id
                    AND g.parent_id     IS NOT NULL
            )

    ), CASE WHEN MOD(p.page_id, 100) = 0 THEN p.page_id END) AS order#,
    --
    p.page_css_classes      AS css_class,
    --
    NULL                    AS is_hidden,       -- hide page on default
    'Y'                     AS is_reset,        -- reset page items
    NULL                    AS is_shared,
    --
    p.page_group,
    p.page_id               AS page_link,
    p.authorization_scheme  AS auth_scheme
FROM apex_application_pages p
LEFT JOIN navigation n
    ON n.app_id             = p.application_id
    AND n.page_id           = p.page_id
WHERE p.application_id      = app.get_app_id()
    AND n.page_id           IS NULL;
