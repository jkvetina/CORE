CREATE OR REPLACE VIEW nav_overview AS
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
    n.page_group,
    n.page_alias,
    n.page_name,
    n.page_title,
    n.css_class,
    n.page_template,
    n.is_hidden,
    n.is_reset,
    n.is_shared,
    n.is_modal,
    n.is_javascript,
    n.javascript,
    n.auth_scheme,
    n.page_url,
    n.comments,
    n.allow_changes,
    n.sort_order,
    n.action,
    n.action_url
FROM nav_overview_mvw n
CROSS JOIN x
WHERE (
    n.app_id                = x.app_id
    OR (
        n.is_shared         = 'Y'
        AND n.page_id       NOT IN (
            -- pages from active apps takes priority
            SELECT n.page_id
            FROM navigation n
            WHERE n.app_id      = x.app_id
        )
    )
);
--
COMMENT ON TABLE  nav_overview                  IS '[CORE - DASHBOARD] Enriched navigation overview used also for menu rendering';
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
COMMENT ON COLUMN nav_overview.page_template    IS 'Type of template used on page';
COMMENT ON COLUMN nav_overview.css_class        IS 'CSS class from APEX page specification';
COMMENT ON COLUMN nav_overview.is_hidden        IS 'Flag for hiding item in menu; Y = hide, NULL = show';
COMMENT ON COLUMN nav_overview.is_reset         IS 'Flag for reset/clear page items; Y = clear, NULL = keep;';
COMMENT ON COLUMN nav_overview.is_shared        IS 'Flag for sharing record with other apps';
COMMENT ON COLUMN nav_overview.is_modal         IS 'Flag for modal dialogs';
COMMENT ON COLUMN nav_overview.is_javascript    IS 'Flag for JavaScript as the target';
COMMENT ON COLUMN nav_overview.auth_scheme      IS 'Auth scheme from APEX page specification';
COMMENT ON COLUMN nav_overview.page_url         IS 'Page url to use as redirection target';
COMMENT ON COLUMN nav_overview.allow_changes    IS 'APEX column to allow edit/delete only some rows';
COMMENT ON COLUMN nav_overview.sort_order       IS 'Calculated path to show rows in correct order';

