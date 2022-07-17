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
-- Page 0: Global Page
-- Region: App/Global Items [DATA]
-- SQL Query

SELECT
    CASE
        WHEN (REGEXP_LIKE(app.get_request_url(), '[:,]' || i.item_name || '[,:]')
            OR REGEXP_LIKE(app.get_request_url(), '[\?&' || ']' || LOWER(i.item_name) || '[=&' || ']')
        )
        THEN '<b>' || i.item_name || '</b>'
        ELSE i.item_name
        END AS item_name,
    i.item_value
FROM (
    SELECT
        i.item_name,
        app.get_item(i.item_name) AS item_value
    FROM apex_application_items i
    WHERE i.application_id  = app.get_app_id()
) i
ORDER BY i.item_name;


-- ----------------------------------------
-- Page 0: Global Page
-- Region: SYS_CONTEXT [DATA]
-- SQL Query

SELECT
    x.namespace || '.' || x.attribute AS name,
    x.value
FROM session_context x
ORDER BY 1;


-- ----------------------------------------
-- Page 0: Global Page
-- Region: Page Items [DATA]
-- SQL Query

SELECT
    CASE
        WHEN (REGEXP_LIKE(app.get_request_url(), '[:,]' || i.item_name || '[,:]')
            OR REGEXP_LIKE(app.get_request_url(), '[\?&' || ']' || LOWER(i.item_name) || '[=&' || ']')
        )
        THEN '<b>' || i.item_name || '</b>'
        ELSE i.item_name
        END AS item_name,
    app.get_item(i.item_name)       AS item_value
FROM apex_application_page_items i
WHERE i.application_id              = app.get_app_id()
    AND i.page_id                   = app.get_page_id()
ORDER BY i.item_name;


-- ----------------------------------------
-- Page 0: Global Page
-- Region: CGI [DATA]
-- SQL Query

WITH t AS (
    SELECT
        'QUERY_STRING,AUTHORIZATION,DAD_NAME,DOC_ACCESS_PATH,DOCUMENT_TABLE,' ||
        'HTTP_ACCEPT,HTTP_ACCEPT_ENCODING,HTTP_ACCEPT_CHARSET,HTTP_ACCEPT_LANGUAGE,' ||
        'HTTP_COOKIE,HTTP_HOST,HTTP_PRAGMA,HTTP_REFERER,HTTP_USER_AGENT,' ||
        'PATH_ALIAS,PATH_INFO,REMOTE_ADDR,REMOTE_HOST,REMOTE_USER,' ||
        'REQUEST_CHARSET,REQUEST_IANA_CHARSET,REQUEST_METHOD,REQUEST_PROTOCOL,' ||
        'SCRIPT_NAME,SCRIPT_PREFIX,SERVER_NAME,SERVER_PORT,SERVER_PROTOCOL' AS str
    FROM DUAL
)
SELECT
    REGEXP_SUBSTR(str, '[^,]+', 1, LEVEL) AS name,
    REGEXP_REPLACE(OWA_UTIL.GET_CGI_ENV(REGEXP_SUBSTR(str, '[^,]+', 1, LEVEL)), '([;)])', '\1'
) AS value
FROM t
CONNECT BY LEVEL <= REGEXP_COUNT(str, ',')
ORDER BY 1;


-- ----------------------------------------
-- Page 0: Global Page
-- Region: NLS [DATA]
-- SQL Query

SELECT
    n.parameter,
    n.value
FROM nls_session_parameters n
ORDER BY 1;


-- ----------------------------------------
-- Page 0: Global Page
-- Region: USERENV [DATA]
-- SQL Query

WITH t AS (
    SELECT
        'CLIENT_IDENTIFIER,CLIENT_INFO,ACTION,MODULE,' ||
        'CURRENT_SCHEMA,CURRENT_USER,CURRENT_EDITION_ID,CURRENT_EDITION_NAME,' ||
        'OS_USER,POLICY_INVOKER,' ||
        'SESSION_USER,SESSIONID,SID,SESSION_EDITION_ID,SESSION_EDITION_NAME,' ||
        'AUTHENTICATED_IDENTITY,AUTHENTICATION_DATA,AUTHENTICATION_METHOD,IDENTIFICATION_TYPE,' ||
        'ENTERPRISE_IDENTITY,PROXY_ENTERPRISE_IDENTITY,PROXY_USER,' ||
        'GLOBAL_CONTEXT_MEMORY,GLOBAL_UID,' ||
        'AUDITED_CURSORID,ENTRYID,STATEMENTID,CURRENT_SQL,CURRENT_BIND,' ||
        'HOST,SERVER_HOST,SERVICE_NAME,IP_ADDRESS,' ||
        'DB_DOMAIN,DB_NAME,DB_UNIQUE_NAME,DBLINK_INFO,DATABASE_ROLE,ISDBA,' ||
        'INSTANCE,INSTANCE_NAME,NETWORK_PROTOCOL,' ||
        'LANG,LANGUAGE,' || --,NLS_TERRITORY,NLS_CURRENCY,NLS_SORT,NLS_DATE_FORMAT,NLS_DATE_LANGUAGE,NLS_CALENDAR,' ||
        'BG_JOB_ID,FG_JOB_ID' AS str
    FROM DUAL
)
SELECT
    t.name,
    t.value
FROM (
    SELECT
        REGEXP_SUBSTR(str, '[^,]+', 1, LEVEL) AS name,
        SYS_CONTEXT('USERENV', REGEXP_SUBSTR(str, '[^,]+', 1, LEVEL)) AS value
    FROM t
    CONNECT BY LEVEL <= REGEXP_COUNT(str, ',')
) t
WHERE t.value IS NOT NULL
ORDER BY 1;

-- ----------------------------------------
-- Page 0: Global Page
-- Region: Page Translations [DATA]
-- SQL Query

SELECT
    CASE
        WHEN (REGEXP_LIKE(app.get_request_url(), '[:,]' || i.item_name || '[,:]')
            OR REGEXP_LIKE(app.get_request_url(), '[\?&' || ']' || LOWER(i.item_name) || '[=&' || ']')
        )
        THEN '<b>' || i.item_name || '</b>'
        ELSE i.item_name
        END AS item_name,
    i.item_value
FROM (
    SELECT
        t.item_name,
        app.get_item(t.item_name) AS item_value
    FROM translations_current t
) i
ORDER BY i.item_name;


-- ----------------------------------------
-- Page 0: Global Page
-- Region: Page Items [DATA]
-- SQL Query

SELECT
    CASE
        WHEN (REGEXP_LIKE(app.get_request_url(), '[:,]' || i.item_name || '[,:]')
            OR REGEXP_LIKE(app.get_request_url(), '[\?&' || ']' || LOWER(i.item_name) || '[=&' || ']')
        )
        THEN '<b>' || i.item_name || '</b>'
        ELSE i.item_name
        END AS item_name,
    app.get_item(i.item_name)       AS item_value
FROM apex_application_page_items i
WHERE i.application_id      = app.get_app_id()
    AND i.page_id           = 0
    AND i.item_name         NOT IN ('P0_NAVIGATION', 'P0_REQUEST_LOG')
ORDER BY 1;


