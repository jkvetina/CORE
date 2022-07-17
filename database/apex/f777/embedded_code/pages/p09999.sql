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
-- Page 9999: #fa-coffee
-- Region: Language Selector
-- PL/SQL Code

apex_lang.emit_language_selector_list;

-- ----------------------------------------
-- Page 9999: #fa-coffee
-- Process: Login
-- PL/SQL Code

apex_authentication.login(
    p_username => :P9999_USERNAME,
    p_password => :P9999_PASSWORD );

-- ----------------------------------------
-- Page 9999: #fa-coffee
-- Process: Set Username Cookie
-- PL/SQL Code

apex_authentication.send_login_username_cookie (
    p_username => lower(:P9999_USERNAME),
    p_consent  => :P9999_REMEMBER = 'Y' );

-- ----------------------------------------
-- Page 9999: #fa-coffee
-- Process: Get Username Cookie
-- PL/SQL Code

:P9999_USERNAME := apex_authentication.get_login_username_cookie;
:P9999_REMEMBER := case when :P9999_USERNAME is not null then 'Y' end;

-- ----------------------------------------
-- Page 9999: #fa-coffee
-- Process: DELETE_SESSION
-- PL/SQL Code

NULL;

