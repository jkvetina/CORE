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
-- Page 961: #fa-file-code-o &PAGE_NAME.
-- Process: INIT_DEFAULTS
-- PL/SQL Code

:P961_SHOW_PROCEDURE    := CASE WHEN :P961_PACKAGE_NAME IS NOT NULL THEN 'Y' END;
:P961_SHOW_VIEW         := CASE WHEN :P961_VIEW_NAME    IS NOT NULL THEN 'Y' END;
:P961_SHOW_TRIGGER      := CASE WHEN :P961_TRIGGER_NAME IS NOT NULL THEN 'Y' END;
--
:P961_CLOB_SOURCE       := '';
:P961_CLOB_CALLER       := '';
:P961_CLOB_HANDLER      := '';


-- ----------------------------------------
-- Page 961: #fa-file-code-o &PAGE_NAME.
-- Process: INIT_SOURCE_TRIGGER
-- PL/SQL Code

-- prepare procedure for copy paste
:P961_CLOB_SOURCE := 'CREATE OR REPLACE ';
--
FOR c IN (
    SELECT t.text
    FROM user_source t
    WHERE t.name        = :P961_TRIGGER_NAME
        AND t.type      = 'TRIGGER'
    ORDER BY t.line
) LOOP
    :P961_CLOB_SOURCE := :P961_CLOB_SOURCE || c.text;
END LOOP;


-- ----------------------------------------
-- Page 961: #fa-file-code-o &PAGE_NAME.
-- Process: INIT_SOURCE_HANDLER
-- PL/SQL Code

DECLARE
    v_message       VARCHAR2(200);
    v_status        INTEGER             := 0;
BEGIN
    DBMS_OUTPUT.ENABLE;
    gen.create_handler (
        in_table_name       => :P961_VIEW_NAME,
        in_target_table     => :P961_VIEW_NAME
    );
    --
    LOOP
        EXIT WHEN v_status = 1;
        DBMS_OUTPUT.GET_LINE(v_message, v_status);
        --
        IF (v_status = 0) THEN
            :P961_CLOB_HANDLER := :P961_CLOB_HANDLER || v_message || CHR(10);
        END IF;
    END LOOP;
END;


-- ----------------------------------------
-- Page 961: #fa-file-code-o &PAGE_NAME.
-- Process: INIT_SOURCE_PROC
-- PL/SQL Code

-- prepare procedure for copy paste
FOR c IN (
    SELECT t.text
    FROM user_source t
    WHERE t.name        = :P961_PACKAGE_NAME
        AND t.type      = 'PACKAGE BODY'
        AND t.line      BETWEEN :P961_LINE_START AND :P961_LINE_END
    ORDER BY t.line
) LOOP
    :P961_CLOB_SOURCE := :P961_CLOB_SOURCE || c.text;
END LOOP;


-- ----------------------------------------
-- Page 961: #fa-file-code-o &PAGE_NAME.
-- Process: INIT_SOURCE_VIEW
-- PL/SQL Code

-- prepare view for copy paste
FOR c IN (
    SELECT t.text
    FROM obj_views_source t
    WHERE t.owner       = app.get_owner()
        AND t.name      = :P961_VIEW_NAME
    ORDER BY t.line
) LOOP
    :P961_CLOB_SOURCE := :P961_CLOB_SOURCE || c.text || CHR(10);
END LOOP;
--
:P961_CLOB_SOURCE := RTRIM(:P961_CLOB_SOURCE, CHR(10)) || ';' || CHR(10);


-- ----------------------------------------
-- Page 961: #fa-file-code-o &PAGE_NAME.
-- Process: INIT_SOURCE_CALLER
-- PL/SQL Code

DECLARE
    v_message       VARCHAR2(200);
    v_status        INTEGER             := 0;
BEGIN
    DBMS_OUTPUT.ENABLE;
    gen.call_handler (
        in_procedure_name   => :P961_PACKAGE_NAME || '.' || :P961_MODULE_NAME,
        in_app_id           => 0,
        in_page_id          => 0
    );
    --
    LOOP
        EXIT WHEN v_status = 1;
        DBMS_OUTPUT.GET_LINE(v_message, v_status);
        --
        IF (v_status = 0) THEN
            :P961_CLOB_CALLER := :P961_CLOB_CALLER || v_message || CHR(10);
        END IF;
    END LOOP;
END;


