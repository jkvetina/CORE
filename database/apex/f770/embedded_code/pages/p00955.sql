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
-- Page 955: #fa-table-heart &PAGE_NAME.
-- Process: INIT_DEFAULTS
-- PL/SQL Code

:P955_SHOW_SEARCH               := NULL;
--
IF (:P955_SEARCH_VIEWS          IS NOT NULL
    OR :P955_SEARCH_COLUMNS     IS NOT NULL
    OR :P955_SEARCH_SOURCE      IS NOT NULL
) THEN
    :P955_SHOW_SEARCH           := 'Y';
    :P955_VIEW_NAME             := NULL;
END IF;
--
:P955_SEARCH_VIEWS := NVL(:P955_SEARCH_VIEWS, :P955_VIEW_NAME);

-- make button HOT, sometimes
--:P955_REFRESH_HOT := 't-Button--hot';
NULL;


-- ----------------------------------------
-- Page 955: #fa-table-heart &PAGE_NAME.
-- Process: REBUILD_SOURCE
-- PL/SQL Code

app.log_action('REBUILD_SOURCE');
--
app.rebuild_obj_views_source();


