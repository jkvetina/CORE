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
-- Page 901: #fa-bug &PAGE_NAME.
-- Process: INIT_DEFAULTS
-- PL/SQL Code

:P901_IS_TODAY := CASE WHEN NVL(app.get_date_item('G_TODAY'), TRUNC(SYSDATE)) = TRUNC(SYSDATE) THEN 'Y' END;

-- init recent log
IF :P901_IS_TODAY IS NULL THEN
    :P901_CURR_LOG_ID       := NULL;
    :P901_RECENT_LOG_ID     := NULL;
END IF;


-- ----------------------------------------
-- Page 901: #fa-bug &PAGE_NAME.
-- Process: INIT_CURR_LOG_ID
-- PL/SQL Code

-- at the last possible moment before rendering page
IF app.get_date_item('G_TODAY') = TRUNC(SYSDATE) THEN
    SELECT MAX(l.log_id) INTO :P901_CURR_LOG_ID
    FROM logs l
    WHERE l.created_at  >= SYSDATE - 1/24/60
        AND l.app_id    = app.get_app_id();
END IF;


