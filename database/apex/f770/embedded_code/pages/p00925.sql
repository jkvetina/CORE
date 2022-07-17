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
-- Page 925: #fa-map-o &PAGE_NAME.
-- Action: NATIVE_EXECUTE_PLSQL_CODE
-- PL/SQL Code

UPDATE sessions s
SET s.updated_at        = SYSDATE
WHERE s.app_id          = :P925_PROXY
    AND s.session_id    = app.get_session_id();


-- ----------------------------------------
-- Page 925: #fa-map-o &PAGE_NAME.
-- Process: ACTION_PROCESS_CHANGES
-- PL/SQL Code

app.log_action('PROCESS_CHANGES', :P925_ACTION, :P925_APP_ID);
--
IF :P925_ACTION = 'ADD' THEN
    INSERT INTO apps (app_id)
    VALUES (
        :P925_APP_ID
    );
END IF;
--
IF :P925_ACTION = 'REMOVE' THEN
    DELETE FROM apps
    WHERE app_id = :P925_APP_ID;
END IF;
--
:P925_ACTION := NULL;


-- ----------------------------------------
-- Page 925: #fa-map-o &PAGE_NAME.
-- Process: SAVE_APPLICATIONS
-- PL/SQL Code to Insert/Update/Delete

app_actions.save_apps (
    in_action           => :APEX$ROW_STATUS,
    in_app_id           => :APP_ID,
    in_description_     => :DESCRIPTION_,
    in_is_visible       => :IS_VISIBLE
);


-- ----------------------------------------
-- Page 925: #fa-map-o &PAGE_NAME.
-- Action: NATIVE_EXECUTE_PLSQL_CODE
-- PL/SQL Code

app.log_action('SWITCH_APP', :P925_SWITCH_APP);
--
UPDATE sessions s
SET s.updated_at        = SYSDATE
WHERE s.app_id          = :P925_SWITCH_APP
    AND s.session_id    = app.get_session_id();


