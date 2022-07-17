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
-- Page 960: #fa-table-pointer &PAGE_NAME.
-- Process: INIT_DEFAULTS
-- PL/SQL Code

:P960_SHOW_SEARCH               := NULL;
--
IF (:P960_SEARCH_PACKAGES       IS NOT NULL
    OR :P960_SEARCH_MODULES     IS NOT NULL
    OR :P960_SEARCH_ARGUMENTS   IS NOT NULL
    OR :P960_SEARCH_SOURCE      IS NOT NULL
) THEN
    :P960_SHOW_SEARCH           := 'Y';
    :P960_PACKAGE_NAME          := NULL;
END IF;
--
:P960_SEARCH_PACKAGES := NVL(:P960_SEARCH_PACKAGES, :P960_PACKAGE_NAME);


-- ----------------------------------------
-- Page 960: #fa-table-pointer &PAGE_NAME.
-- Process: ACTION_FORCE_RECOMPILE
-- PL/SQL Code

app.log_action('FORCE_RECOMPILE');

-- force recompile packages
FOR c IN (
    SELECT o.object_name
    FROM user_objects o
    WHERE o.object_type     = 'PACKAGE'
        AND o.object_name   NOT IN ('APP')
) LOOP
    recompile (
        in_name         => c.object_name,
        in_force        => TRUE
    );
END LOOP;

-- recompile possible invalid objects
recompile();
--
:P960_FORCE := NULL;


-- ----------------------------------------
-- Page 960: #fa-table-pointer &PAGE_NAME.
-- Process: SAVE_PLSQL_SETTINGS
-- PL/SQL Code to Insert/Update/Delete

recompile (
    in_name             => :OBJECT_NAME,
    in_type             => :OBJECT_TYPE,
    in_level            => :PLSQL_OPTIMIZE_LEVEL,
    in_interpreted      => (:IS_INTERPRETED             = 'Y'),
    in_identifiers      => (:IS_SCOPE_IDENTIFIERS       = 'Y'),
    in_statements       => (:IS_SCOPE_STATEMENTS        = 'Y'),
    in_severe           => (:IS_WARNING_SEVERE          = 'Y'),
    in_performance      => (:IS_WARNING_PERFORMANCE     = 'Y'),
    in_informational    => (:IS_WARNING_INFORMATIONAL   = 'Y'),
    in_ccflags          => :PLSQL_CCFLAGS,
    in_force            => TRUE
);


