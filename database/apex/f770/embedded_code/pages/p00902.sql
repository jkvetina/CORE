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
-- Page 902: &PAGE_NAME. &P902_LOG_ID.
-- Process: INIT_DEFAULTS
-- PL/SQL Code

app.log_action('INIT_DEFAULTS');
--
IF :P902_LOG_ID IS NOT NULL THEN
    app.set_log_tree_id(app.get_log_root(:P902_LOG_ID));
END IF;


-- ----------------------------------------
-- Page 902: &PAGE_NAME. &P902_LOG_ID.
-- Process: GET_ACTION_NAME
-- PL/SQL Code

app.log_action('GET_ACTION_NAME', APEX_APPLICATION.G_X01);
--
FOR c IN (
    SELECT l.action_name AS line
    FROM logs l
    WHERE l.log_id = APEX_APPLICATION.G_X01
) LOOP
    htp.p(c.line);
END LOOP;


-- ----------------------------------------
-- Page 902: &PAGE_NAME. &P902_LOG_ID.
-- Process: GET_ARGUMENTS
-- PL/SQL Code

app.log_action('GET_ARGUMENTS', APEX_APPLICATION.G_X01);
--
DECLARE
    out_line        logs.arguments%TYPE;
    v_envelope      VARCHAR2(32767);
    v_inside        VARCHAR2(32767);
BEGIN
    SELECT l.arguments INTO out_line
    FROM logs l
    WHERE l.log_id = APEX_APPLICATION.G_X01;
    --
    IF 1 = 1 THEN
        v_envelope  := REGEXP_REPLACE(out_line, '"{\\".*\\"}"', '^|^');
        v_inside    := REPLACE(REGEXP_SUBSTR(out_line, '"{\\"(.*)\\"}"', 1, 1, NULL, 1), '\"', '"');
        out_line    := REPLACE(v_envelope, '^|^', '{"' || v_inside || '"}');
    END IF;
    --
    IF out_line LIKE '{"%}' OR out_line LIKE '[%]' THEN
        SELECT JSON_QUERY(out_line, '$' RETURNING VARCHAR2(4000) PRETTY) INTO out_line
        FROM DUAL;
    END IF;
    --
    htp.p(REPLACE(out_line, CHR(10), '<br />'));
EXCEPTION
WHEN NO_DATA_FOUND THEN
    NULL;
END;


-- ----------------------------------------
-- Page 902: &PAGE_NAME. &P902_LOG_ID.
-- Process: GET_PAYLOAD
-- PL/SQL Code

app.log_action('GET_PAYLOAD', APEX_APPLICATION.G_X01);
--
FOR c IN (
    SELECT l.payload AS line
    FROM logs l
    WHERE l.log_id = APEX_APPLICATION.G_X01
) LOOP
    c.line := REGEXP_REPLACE(c.line, '\s.*SQL.*\.EXEC.*\]', '.');
    c.line := REGEXP_REPLACE(c.line, '\s%.*EXEC.*\]', '.');
    c.line := REGEXP_REPLACE(c.line, '\s%_PROCESS.*\]', '.');
    c.line := REGEXP_REPLACE(c.line, '\s%_ERROR.*\]', '.');
    c.line := REGEXP_REPLACE(c.line, '\s%_SECURITY.*\]', '.');
    c.line := REGEXP_REPLACE(c.line, '\sHTMLDB*\]', '.');
    --
    htp.p(REPLACE(c.line, CHR(10), '<br />'));
END LOOP;


