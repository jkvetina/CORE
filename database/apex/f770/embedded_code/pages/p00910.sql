-- --------------------------------------------------------------------------------
-- 
-- Oracle APEX source export file
-- 
-- The contents of this file are intended for review and analysis purposes only.
-- Developers must use the Application Builder to make modifications to an
-- application. Changes to this file will not be reflected in the application.
-- 
-- --------------------------------------------------------------------------------

-- ----------------------------------------
-- Page 910: #fa-map-signs &PAGE_NAME.
-- Action: NATIVE_EXECUTE_PLSQL_CODE
-- PL/SQL Code

app.log_action('PUBLISH_CHANGES');
--
app_actions.refresh_nav_views();
--
app.log_success();


-- ----------------------------------------
-- Page 910: #fa-map-signs &PAGE_NAME.
-- Process: INIT_DEFAULTS
-- PL/SQL Code

SELECT NVL(MAX('t-Button--hot'), ' ') INTO :P910_AUTO_UPDATE_HOT
FROM nav_overview n
WHERE n.action IS NOT NULL;

--
:P910_MESSAGE_MVW := app.get_translated_message('MVW_SCHEDULED');


-- ----------------------------------------
-- Page 910: #fa-map-signs &PAGE_NAME.
-- Process: INIT_ADD_FILTER
-- PL/SQL Code

app.log_action('ADD_FILTER');
--
DECLARE
    in_static_id            CONSTANT VARCHAR2(30)   := 'NAVIGATION';
    in_column_name          CONSTANT VARCHAR2(30)   := 'AUTH_SCHEME';
    in_filter_value         CONSTANT VARCHAR2(30)   := app.get_item('$' || in_column_name);
    in_operator             CONSTANT VARCHAR2(30)   := 'EQ';
    --
    region_id               apex_application_page_regions.region_id%TYPE;
BEGIN
    -- convert static_id to region_id
    SELECT region_id INTO region_id
    FROM apex_application_page_regions
    WHERE application_id    = app.get_app_id()
        AND page_id         = app.get_page_id()
        AND static_id       = in_static_id;
    --
    APEX_IG.RESET_REPORT (
        p_page_id           => app.get_page_id(),
        p_region_id         => region_id,
        p_report_id         => NULL
    );
    --
    IF in_filter_value IS NOT NULL THEN
        APEX_IG.ADD_FILTER (
            p_page_id           => app.get_page_id(),
            p_region_id         => region_id,
            p_column_name       => in_column_name,
            p_filter_value      => in_filter_value,
            p_operator_abbr     => in_operator,
            p_is_case_sensitive => FALSE,
            p_report_id         => NULL
        );
    END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN
    NULL;
END;


-- ----------------------------------------
-- Page 910: #fa-map-signs &PAGE_NAME.
-- Process: ACTION_AUTO_UPDATE
-- PL/SQL Code

app.log_action('AUTO_UPDATE');
--
app_actions.nav_autoupdate();
--
app.log_success();


-- ----------------------------------------
-- Page 910: #fa-map-signs &PAGE_NAME.
-- Process: ACTION_REMOVE_PAGE
-- PL/SQL Code

app.log_action('REMOVE_PAGE');
--
app_actions.nav_remove_pages(:P910_REMOVE_PAGE);


-- ----------------------------------------
-- Page 910: #fa-map-signs &PAGE_NAME.
-- Process: ACTION_ADD_PAGE
-- PL/SQL Code

app.log_action('ADD_PAGE');
--
app_actions.nav_add_pages(:P910_ADD_PAGE);


-- ----------------------------------------
-- Page 910: #fa-map-signs &PAGE_NAME.
-- Process: SAVE_NAVIGATION
-- PL/SQL Code to Insert/Update/Delete

app_actions.save_nav_overview (
    in_action           => :APEX$ROW_STATUS,
    in_app_id           => :APP_ID,
    in_page_id          => :PAGE_ID,
    in_parent_id        => :PARENT_ID,
    in_order#           => :ORDER#,
    in_is_hidden        => :IS_HIDDEN,
    in_is_reset         => :IS_RESET,
    in_is_shared        => :IS_SHARED
);


