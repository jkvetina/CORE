CREATE OR REPLACE PROCEDURE recompile (
    in_name             VARCHAR2        := '%',
    in_type             VARCHAR2        := '%',
    in_level            NUMBER          := 2,
    in_interpreted      BOOLEAN         := TRUE,
    in_identifiers      BOOLEAN         := TRUE,
    in_statements       BOOLEAN         := TRUE,
    in_severe           BOOLEAN         := TRUE,
    in_performance      BOOLEAN         := TRUE,
    in_informational    BOOLEAN         := FALSE,
    in_ccflags          VARCHAR2        := NULL,
    in_force            BOOLEAN         := FALSE
)
AUTHID CURRENT_USER
AS
    in_force_y          CONSTANT CHAR   := CASE WHEN in_force THEN 'Y' END;
    --
    v_code_type         VARCHAR2(32767);
    v_optimize_level    VARCHAR2(32767);
    v_scope             VARCHAR2(32767);
    v_warnings          VARCHAR2(32767);
    v_ccflags           VARCHAR2(32767);
    v_invalids          PLS_INTEGER;
    v_last_type         VARCHAR2(30);
BEGIN
    /**
     * This package is part of the APP CORE project under MIT licence.
     * https://github.com/jkvetina/#core
     *
     * Copyright (c) Jan Kvetina, 2022
     *
     *                                                      (R)
     *                      ---                  ---
     *                    #@@@@@@              &@@@@@@
     *                    @@@@@@@@     .@      @@@@@@@@
     *          -----      @@@@@@    @@@@@@,   @@@@@@@      -----
     *       &@@@@@@@@@@@    @@@   &@@@@@@@@@.  @@@@   .@@@@@@@@@@@#
     *           @@@@@@@@@@@   @  @@@@@@@@@@@@@  @   @@@@@@@@@@@
     *             \@@@@@@@@@@   @@@@@@@@@@@@@@@   @@@@@@@@@@
     *               @@@@@@@@@   @@@@@@@@@@@@@@@  &@@@@@@@@
     *                 @@@@@@@(  @@@@@@@@@@@@@@@  @@@@@@@@
     *                  @@@@@@(  @@@@@@@@@@@@@@,  @@@@@@@
     *                  .@@@@@,   @@@@@@@@@@@@@   @@@@@@
     *                   @@@@@@  *@@@@@@@@@@@@@   @@@@@@
     *                   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.
     *                    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
     *                    @@@@@@@@@@@@@@@@@@@@@@@@@@@@
     *                     .@@@@@@@@@@@@@@@@@@@@@@@@@
     *                       .@@@@@@@@@@@@@@@@@@@@@
     *                            jankvetina.cz
     *                               -------
     *
     */

    -- first recompile invalid and requested objects
    DBMS_OUTPUT.PUT_LINE('--');
    DBMS_OUTPUT.PUT('INVALID: ');
    --
    FOR c IN (
        SELECT o.*
        FROM (
            SELECT o.object_name, o.object_type
            FROM user_objects o
            WHERE o.status              != 'VALID'
                AND o.object_type       NOT IN ('SEQUENCE')
                AND (o.object_type      LIKE in_type ESCAPE '\' OR in_type IS NULL)
                AND (o.object_name      LIKE in_name ESCAPE '\' OR in_name IS NULL)
                AND o.object_name       != $$PLSQL_UNIT         -- not this procedure
            UNION ALL
            SELECT o.object_name, o.object_type
            FROM user_objects o
            WHERE in_force_y            = 'Y'
                AND o.object_type       IN ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION', 'TRIGGER', 'VIEW', 'SYNONYM')
                AND (o.object_type      LIKE in_type ESCAPE '\' OR in_type IS NULL)
                AND (o.object_name      LIKE in_name ESCAPE '\' OR in_name IS NULL)
                AND o.object_name       != $$PLSQL_UNIT         -- not this procedure
        ) o
        ORDER BY CASE o.object_type
            WHEN 'PACKAGE'          THEN 1
            WHEN 'PACKAGE BODY'     THEN 2
            ELSE 3 END
    ) LOOP
        v_scope         := '';
        v_warnings      := '';
        v_ccflags       := '';

        -- allow pl/sql settings changes in force mode
        IF in_force THEN
            -- get and apply ccflags only relevant to current object
            IF in_ccflags IS NOT NULL THEN
                BEGIN
                    SELECT
                        LISTAGG(REGEXP_SUBSTR(in_ccflags, '(' || s.flag_name || ':[^,]+)', 1, 1, NULL, 1), ', ')
                            WITHIN GROUP (ORDER BY s.flag_name)
                    INTO v_ccflags
                    FROM (
                        SELECT DISTINCT REGEXP_SUBSTR(s.text, '[$].*\s[$][$]([A-Z0-9-_]+)\s.*[$]', 1, 1, NULL, 1) AS flag_name
                        FROM user_source s
                        WHERE REGEXP_LIKE(s.text, '[$].*\s[$][$][A-Z0-9-_]+\s.*[$]')
                            AND s.name = c.object_name
                            AND s.type = c.object_type
                    ) s;
                EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_ccflags := NULL;
                END;
            END IF;
            --
            v_scope             := v_scope      || CASE WHEN in_identifiers     THEN 'IDENTIFIERS:ALL, ' END;
            v_scope             := v_scope      || CASE WHEN in_statements      THEN 'STATEMENTS:ALL, ' END;
            v_warnings          := v_warnings   || CASE WHEN in_severe          THEN 'ENABLE:SEVERE, ' END;
            v_warnings          := v_warnings   || CASE WHEN in_performance     THEN 'ENABLE:PERFORMANCE, ' END;
            v_warnings          := v_warnings   || CASE WHEN in_informational   THEN 'ENABLE:INFORMATIONAL, ' END;
            --
            v_code_type         := 'PLSQL_CODE_TYPE = '       || CASE WHEN in_interpreted THEN 'INTERPRETED' ELSE 'NATIVE' END || ' ';
            v_optimize_level    := 'PLSQL_OPTIMIZE_LEVEL = '  || in_level || ' ';
            v_scope             := 'PLSCOPE_SETTINGS = '''    || RTRIM(v_scope, ', ') || ''' ';
            v_warnings          := 'PLSQL_WARNINGS = '''      || REPLACE(RTRIM(v_warnings, ', '), ',', ''', ''') || ''' ';
            v_ccflags           := 'PLSQL_CCFLAGS = '''       || RTRIM(v_ccflags) || ''' ';
        END IF;

        -- recompile object
        BEGIN
            EXECUTE IMMEDIATE
                'ALTER ' || REPLACE(c.object_type, ' BODY', '') || ' ' || c.object_name || ' COMPILE ' ||
                    CASE WHEN c.object_type LIKE '% BODY' THEN ' BODY' END || ' ' ||
                    CASE WHEN c.object_type IN (
                        'PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION', 'TRIGGER'
                    ) THEN
                        v_code_type         ||
                        v_optimize_level    ||
                        v_scope             ||
                        v_warnings          ||
                        v_ccflags           ||
                        'REUSE SETTINGS'
                    END;
            --
            DBMS_OUTPUT.PUT('.');
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT('!');  -- something went wrong
        END;
    END LOOP;

    -- show number of invalid objects
    SELECT COUNT(*) INTO v_invalids
    FROM user_objects o
    WHERE o.status              != 'VALID'
        AND (o.object_type      LIKE in_type ESCAPE '\' OR in_type IS NULL)
        AND (o.object_name      LIKE in_name ESCAPE '\' OR in_name IS NULL)
        AND o.object_name       != $$PLSQL_UNIT;        -- not this procedure
    --
    DBMS_OUTPUT.PUT_LINE(' -> ' || v_invalids);
    DBMS_OUTPUT.PUT_LINE('');

    -- list invalid objects
    IF v_invalids > 0 THEN
        v_last_type := ' ';
        FOR c IN (
            SELECT DISTINCT o.object_type, o.object_name
            FROM user_objects o
            WHERE o.status              != 'VALID'
                AND (o.object_type      LIKE in_type ESCAPE '\' OR in_type IS NULL)
                AND (o.object_name      LIKE in_name ESCAPE '\' OR in_name IS NULL)
                AND o.object_name       != $$PLSQL_UNIT;        -- not this procedure
            ORDER BY o.object_type, o.object_name
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('  ' || LPAD(CASE WHEN c.object_type != v_last_type THEN c.object_type END || ' | ', 20, ' ') || c.object_name);
            --
            v_last_type := c.object_type;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END IF;
END;
/

