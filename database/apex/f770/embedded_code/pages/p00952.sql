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
-- Page 952: #fa-table-play &PAGE_NAME.
-- Process: INIT_DEFAULTS
-- PL/SQL Code

-- get trigger status
FOR c IN (
    SELECT t.status
    FROM user_triggers t
    WHERE t.trigger_name = app.get_item('$TRIGGER')
) LOOP
    app.set_item('$STATUS', c.status);
END LOOP;


-- ----------------------------------------
-- Page 952: #fa-table-play &PAGE_NAME.
-- Process: ACTION_DISABLE_TRIGGER
-- PL/SQL Code

app.log_action('DISABLE_TRIGGER', app.get_item('$TRIGGER'));
--
EXECUTE IMMEDIATE
    'ALTER TRIGGER ' || app.get_item('$TRIGGER') || ' DISABLE';


-- ----------------------------------------
-- Page 952: #fa-table-play &PAGE_NAME.
-- Process: ACTION_ENABLE_TRIGGER
-- PL/SQL Code

app.log_action('ENABLE_TRIGGER', app.get_item('$TRIGGER'));
--
EXECUTE IMMEDIATE
    'ALTER TRIGGER ' || app.get_item('$TRIGGER') || ' ENABLE';


