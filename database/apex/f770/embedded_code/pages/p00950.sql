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
-- Page 950: #fa-database
-- Region: Invalid Objects (procedures)
-- SQL Query

SELECT
    o.object_type AS divider,
    '<span style="margin-left: 2rem;">' || o.object_name || '</span>' AS object_name,
    app_actions.get_object_link(o.object_type, o.object_name) AS object_link
FROM user_objects o
WHERE o.status != 'VALID'
    AND o.object_type IN ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION')
ORDER BY o.object_type, o.object_name;


-- ----------------------------------------
-- Page 950: #fa-database
-- Process: INIT_DEFAULTS
-- PL/SQL Code

-- hot button
SELECT NVL(MAX('t-Button--hot'), ' ') INTO :P950_RECOMPILE_HOT
FROM user_objects o
WHERE o.status != 'VALID';

-- change schema
:P950_SCHEMA := COALESCE(:P950_SCHEMA, app.get_owner());
--
app.set_owner(:P950_SCHEMA);


-- ----------------------------------------
-- Page 950: #fa-database
-- Process: ACTION_RECOMPILE
-- PL/SQL Code

app.log_action('RECOMPILE');
--
recompile();
--
app.log_success();


-- ----------------------------------------
-- Page 950: #fa-database
-- Process: ACTION_RECOMPILE_FORCE
-- PL/SQL Code

app.log_action('RECOMPILE_FORCE');
--
recompile();  -- to reuse settings
--
DBMS_UTILITY.COMPILE_SCHEMA (
    schema      => '#OWNER#',
    compile_all => TRUE
);
--
app.log_success();


-- ----------------------------------------
-- Page 950: #fa-database
-- Region: Database Objects [GEN]
-- PL/SQL Code

-- since badge list doesnt support links...
htp.p('<ul class="t-BadgeList t-BadgeList--large t-BadgeList--dash t-BadgeList--cols t-BadgeList--5cols t-Report--hideNoPagination" data-region-id="OBJECTS">');
--
FOR c IN (
    SELECT o.*
    FROM obj_overview o
    ORDER BY 1
) LOOP
    htp.p('<li class="t-BadgeList-item" style="border-bottom: 0;">');
    htp.p(CASE WHEN c.page_link IS NOT NULL THEN '<a href="' || c.page_link || '" style="color: #000;">' END);
    htp.p('<span class="t-BadgeList-wrap u-color">');
    htp.p('<span class="t-BadgeList-label">' || c.object_type || '</span>');
    htp.p('<span class="t-BadgeList-value">' || c.count_objects || '</span>');
    htp.p('</span>' || CASE WHEN c.page_link IS NOT NULL THEN '</a>' END);
    htp.p('</li>');
END LOOP;
--
htp.p('</ul>');


-- ----------------------------------------
-- Page 950: #fa-database
-- Region: Invalid Objects (views)
-- SQL Query

SELECT
    o.object_type AS divider,
    '<span style="margin-left: 2rem;">' || o.object_name || '</span>' AS object_name,
    app_actions.get_object_link(o.object_type, o.object_name) AS object_link
FROM user_objects o
WHERE o.status != 'VALID'
    AND o.object_type IN ('VIEW')
ORDER BY o.object_type, o.object_name;


-- ----------------------------------------
-- Page 950: #fa-database
-- Region: Invalid Objects (others)
-- SQL Query

SELECT
    o.object_type AS divider,
    '<span style="margin-left: 2rem;">' || o.object_name || '</span>' AS object_name,
    app_actions.get_object_link(o.object_type, o.object_name) AS object_link
FROM user_objects o
WHERE o.status != 'VALID'
    AND o.object_type NOT IN ('VIEW', 'PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION')
ORDER BY o.object_type, o.object_name;


