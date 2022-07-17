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
-- Shared Component
-- Authorization: IS_ACTIVE_USER
-- PL/SQL Function Body

RETURN app.is_active_user();

-- ----------------------------------------
-- Shared Component
-- Authorization: IS_ADMINISTRATOR
-- PL/SQL Function Body

RETURN a770.is_administrator() = 'Y';

-- ----------------------------------------
-- Shared Component
-- Authorization: IS_DEVELOPER
-- PL/SQL Function Body

RETURN app.is_developer();

-- ----------------------------------------
-- Shared Component
-- Authorization: NOBODY
-- PL/SQL Function Body

RETURN FALSE;

