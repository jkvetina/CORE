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
-- Page 990: &APP_USER.
-- Action: NATIVE_EXECUTE_PLSQL_CODE
-- PL/SQL Code

app.log_action('SWITCH_APP', :P990_SWITCH_APP);
--
UPDATE sessions s
SET s.updated_at        = SYSDATE
WHERE s.app_id          = :P990_SWITCH_APP
    AND s.session_id    = app.get_session_id();


-- ----------------------------------------
-- Page 990: &APP_USER.
-- Process: MESSAGES
-- PL/SQL Code

--:P0_MESSAGE_SUCCESS := 'SUCCESS_MSG';
--:P0_MESSAGE_ERROR := 'ERROR_MSG';
--
--:P0_MESSAGE_ALERT := 'ALERT_MSG';
--:P0_MESSAGE_CALLBACK := 'console.log("CALLING_SOMETHING", "LOG_ID", 123)';
--
NULL;


-- ----------------------------------------
-- Page 990: &APP_USER.
-- Process: INIT_FORM
-- PL/SQL Code

app.log_action('INIT_FORM');
--
/*
FOR c IN (
    SELECT u.*, ROWID AS rid
    FROM users u
    WHERE u.user_id = app.get_user_id()
) LOOP
    app.set_item('$USER_ID',    c.user_id);
    app.set_item('$USER_LOGIN', c.user_login);
    app.set_item('$USER_NAME',  c.user_name);
    app.set_item('$LANG_ID',    c.lang_id);
    app.set_item('$ROWID',      c.rid);
END LOOP;
*/
SELECT
    u.user_id,
    u.user_login,
    u.user_name,
    u.lang_id,
    u.is_active,
    ROWID
INTO
    :P990_USER_ID,
    :P990_USER_LOGIN,
    :P990_USER_NAME,
    :P990_LANG_ID,
    :P990_IS_ACTIVE,
    :P990_ROWID
FROM users u
WHERE u.user_id = app.get_user_id();


