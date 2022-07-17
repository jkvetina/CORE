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
-- Page 940: #fa-tags &PAGE_NAME.
-- Region: Events [CHART]
-- SQL Query

SELECT 1
FROM events_chart
WHERE count_events  > 0
    AND ROWNUM      = 1
    AND :P940_SHOW_SUBSCRIPTIONS IS NULL;

