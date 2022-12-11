CREATE OR REPLACE FORCE VIEW nav_top AS
WITH curr AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()            AS app_id,
        app.get_page_id()           AS page_id,
        app.get_page_parent()       AS parent_id,
        app.get_page_root()         AS page_root,
        app.get_page_group()        AS page_group,
        app.get_user_id()           AS user_id,
        app.get_user_name()         AS user_name,
        app.get_session_id()        AS session_id
    FROM DUAL
)
SELECT
    CASE WHEN n.parent_id IS NULL THEN 1 ELSE 2 END AS lvl,
    --
    CASE
        WHEN n.page_id > 0
            THEN REGEXP_REPLACE(
                REPLACE(
                REPLACE(p.page_name, '&' || 'ENV_NAME.', app.get_env_name() || ' &' || 'nbsp; '),                
                '&' || 'APP_USER.', APEX_ESCAPE.HTML(NVL(curr.user_name, curr.user_id))),
                '^(&' || 'nbsp; )+', '')
        ELSE '</li></ul><ul class="EMPTY"></ul><ul><li style="display: none;">'  -- a trick to split nav menu to left and right
        END AS label,
    --
    CASE
        WHEN (p.javascript IS NOT NULL OR n.page_id = 0)
            THEN '#'
        WHEN n.page_id > 0
            THEN APEX_PAGE.GET_URL (
                p_application   => n.app_id,
                p_page          => NVL(p.page_alias, TO_CHAR(n.page_id)),
                p_clear_cache   => CASE WHEN n.is_reset = 'Y' THEN n.page_id END,
                p_session       => CASE WHEN n.page_id != 9999 THEN curr.session_id ELSE 0 END
            )
        END AS target,
    --
    CASE
        WHEN n.page_id IN (curr.page_id, curr.parent_id, curr.page_root) THEN 'YES'
        END AS is_current_list_entry,
    --
    NULL AS image,
    NULL AS image_attribute,
    NULL AS image_alt_attribute,
    --
    CASE
        WHEN n.page_id > 0
            THEN p.page_group
        END AS attribute01,
    --
    NULL AS attribute02,                        -- prepend link with element
    --
    CASE
        WHEN n.page_id = 0
            THEN 'HIDDEN" style="display: none;'
        END AS attribute03,                     -- a.class
    --
    CASE
        WHEN n.page_id = 9999
            THEN 'Logout'
            ELSE p.page_title
            END AS attribute04,                 -- a.title
    --
    p.javascript AS attribute05,                -- javascript action
    --
    NULL                                        AS attribute06,     -- badge left
    --
    CASE WHEN b.badge IS NOT NULL
        THEN '<span class="BADGE">' || b.badge || '</badge>'
        END AS attribute07,                     -- badge right
    --
    NULL AS attribute08,
    NULL AS attribute09,
    NULL AS attribute10,
    --
    n.r#
FROM nav_source_sorted_mv n
JOIN nav_source_pages_mv p
    ON p.app_id         = n.app_id
    AND p.page_id       = n.page_id
CROSS JOIN curr
LEFT JOIN nav_badges b
    ON b.page_id        = n.page_id
WHERE n.is_hidden       IS NULL
    AND (
        'Y' = nav.is_page_available(p.auth_scheme, p.app_id, p.page_id, p.procedure_name, p.data_type, p.page_argument)
        OR n.page_id IN (0, 9999)
    );
--
COMMENT ON TABLE nav_top IS '[CORE - DASHBOARD] Navigation view used for rendering top menu';
--
COMMENT ON COLUMN nav_top.attribute01   IS '<li class="...">';
COMMENT ON COLUMN nav_top.attribute02   IS '<li>...<a>';
COMMENT ON COLUMN nav_top.attribute03   IS '<a class="..."';
COMMENT ON COLUMN nav_top.attribute04   IS '<a title="..."';
COMMENT ON COLUMN nav_top.attribute05   IS '<a ...>  // javascript onclick';
COMMENT ON COLUMN nav_top.attribute06   IS '<a>... #TEXT</a>';
COMMENT ON COLUMN nav_top.attribute07   IS '<a>#TEXT ...</a>';
COMMENT ON COLUMN nav_top.attribute08   IS '</a>...';

