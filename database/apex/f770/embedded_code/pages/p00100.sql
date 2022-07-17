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
-- Page 100: &ENV_NAME. &APP_NAME.
-- Region: Features [LIST]
-- SQL Query

SELECT 'Custom logging and error handling'      AS name, '' AS url FROM DUAL UNION ALL
SELECT 'Custom user and roles management'       AS name, '' AS url FROM DUAL UNION ALL
SELECT 'Custom navigation'                      AS name, '' AS url FROM DUAL UNION ALL
SELECT 'Universal app setting'                  AS name, '' AS url FROM DUAL UNION ALL
SELECT 'Database and APEX objects reports'      AS name, '' AS url FROM DUAL;


-- ----------------------------------------
-- Page 100: &ENV_NAME. &APP_NAME.
-- Region: About [LIST]
-- SQL Query

SELECT 'Designed to remove boring setup when building new app, just focus on your app' AS name FROM DUAL UNION ALL
SELECT 'Designed for sharing pages and components between apps' AS name FROM DUAL UNION ALL
SELECT 'Designed for sharing objects for multiple projects/apps in same db schema' AS name FROM DUAL UNION ALL
SELECT 'Designed for sharing objects for multiple schemas in same db instance' AS name FROM DUAL UNION ALL
SELECT 'Lower maintance time and effort when something change in shared code' AS name FROM DUAL;



-- ----------------------------------------
-- Page 100: &ENV_NAME. &APP_NAME.
-- Region: Links [LIST]
-- SQL Query

SELECT
    'Blog articles related to project CORE' AS name,
    'http://www.oneoracledeveloper.com/search/label/project_core' AS url
FROM DUAL
UNION ALL
SELECT
    'Blog articles related to better coding practices (APEX Blueprint)' AS name,
    'http://www.oneoracledeveloper.com/search/label/blueprint' AS url
FROM DUAL
UNION ALL
SELECT
    'Project CORE on GitHub' AS name,
    'https://github.com/jkvetina/CORE' AS url
FROM DUAL;



