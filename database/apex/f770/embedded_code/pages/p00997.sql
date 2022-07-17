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
-- Page 997: #fa-users-chat Chat with Support
-- Process: AJAX_SEND_MESSAGE
-- PL/SQL Code

app_actions.send_message (
    in_user_id      => app.get_user_id(),
    in_message      => APEX_APPLICATION.G_X01,
    in_type         => 'CHAT',
    in_session_id   => app.get_session_id()
);
--
:P997_MESSAGE := NULL;


-- ----------------------------------------
-- Page 997: #fa-users-chat Chat with Support
-- Process: AJAX_SEND_RESPONSE
-- PL/SQL Code

app.log_action('AJAX_SEND_RESPONSE', APEX_APPLICATION.G_X01);
app_actions.send_message (
    in_app_id       => app.get_number_item('P997_APP_ID'),
    in_user_id      => app.get_item('P997_USER_ID'),
    in_session_id   => app.get_number_item('P997_SESSION_ID'),
    in_message      => APEX_APPLICATION.G_X01,
    in_type         => 'CHAT'
);
--
:P997_RESPONSE := NULL;


-- ----------------------------------------
-- Page 997: #fa-users-chat Chat with Support
-- Process: INIT_DEFAULTS
-- PL/SQL Code

:P997_APP_ID        := COALESCE(:P997_APP_ID,       app.get_app_id());
:P997_USER_ID       := COALESCE(:P997_USER_ID,      app.get_user_id());
:P997_SESSION_ID    := COALESCE(:P997_SESSION_ID,   app.get_session_id());


