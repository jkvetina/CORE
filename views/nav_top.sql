CREATE OR REPLACE FORCE VIEW nav_top AS
WITH curr AS (
    SELECT
        app.get_app_id()            AS app_id,
        app.get_page_id()           AS page_id,
        app.get_page_parent()       AS parent_id,
        app.get_page_root()         AS page_root,
        app.get_page_group()        AS page_group,
        app.get_user_id()           AS user_id,
        app.get_user_name()         AS user_name
    FROM users u
    WHERE u.user_id = app.get_user_id()
)
SELECT
    CASE WHEN n.parent_id IS NULL THEN 1 ELSE 2 END AS lvl,
    --
    CASE
        WHEN n.page_id > 0
            THEN REGEXP_REPLACE(REPLACE(n.page_name, '&' || 'APP_USER.', APEX_ESCAPE.HTML(NVL(curr.user_name, curr.user_id))), '^(&' || 'nbsp; )+', '')
        ELSE '</li></ul><ul class="EMPTY"></ul><ul><li style="display: none;">'  -- a trick to split nav menu to left and right
        END AS label,
    --
    CASE
        WHEN n.page_id > 0
            THEN APEX_PAGE.GET_URL (
                p_application   => n.app_id,
                p_page          => NVL(n.page_alias, TO_CHAR(n.page_id)),
                p_clear_cache   => CASE WHEN n.is_reset = 'Y' THEN n.page_id END,
                p_session       => CASE WHEN n.page_id != 9999 THEN app.get_session_id() ELSE 0 END
            )
        ELSE NVL(n.page_url, '#')
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
            THEN n.page_group || ' ' || n.css_class
            ELSE 'HIDDEN'
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
            ELSE n.page_title
            END AS attribute04,                 -- a.title
    --
    NULL AS attribute05,                        -- javascript action
    --
    NULL                                                AS attribute06,     -- badge left
    '<span class="BADGE">' || b.badge || '</badge>'     AS attribute07,     -- badge right
    --
    NULL AS attribute08,
    NULL AS attribute09,
    NULL AS attribute10,
    --
    n.page_group,
    n.sort_order
FROM nav_overview n
CROSS JOIN curr
LEFT JOIN nav_badges b
    ON b.page_id        = n.page_id
WHERE n.action          IS NULL
    AND n.is_hidden     IS NULL;
--
COMMENT ON TABLE nav_top IS 'Main navigation view, column names cant be changed';
--
COMMENT ON COLUMN nav_top.attribute01   IS '<li class="...">';
COMMENT ON COLUMN nav_top.attribute02   IS '<li>...<a>';
COMMENT ON COLUMN nav_top.attribute03   IS '<a class="..."';
COMMENT ON COLUMN nav_top.attribute04   IS '<a title="..."';
COMMENT ON COLUMN nav_top.attribute05   IS '<a ...>  // javascript onclick';
COMMENT ON COLUMN nav_top.attribute06   IS '<a>... #TEXT</a>';
COMMENT ON COLUMN nav_top.attribute07   IS '<a>#TEXT ...</a>';
COMMENT ON COLUMN nav_top.attribute08   IS '</a>...';



-- use this in APEX in Dynamic navigation query
SELECT
    lvl,
    label, 
    target, 
    is_current_list_entry,
    image, 
    image_attribute,
    image_alt_attribute,
    attribute01,
    attribute02,
    attribute03,
    attribute04,
    attribute05,
    attribute06,
    attribute07,
    attribute08,
    attribute09,
    attribute10
FROM nav_top
ORDER BY page_group, sort_order;

