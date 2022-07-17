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
-- Page 915: #fa-user-secret &PAGE_NAME.
-- Process: ACTION_DELETE_SESSION
-- PL/SQL Code

app.log_action('DELETE_SESSION', app.get_item('$DELETE'));
--
app.delete_session (
    in_session_id   => app.get_item('$DELETE')
);


