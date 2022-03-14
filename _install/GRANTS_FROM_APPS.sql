--
-- EXECUTE FROM NEW SCHEMA
--
CREATE SYNONYM app          FOR core.app;
CREATE SYNONYM app_actions  FOR core.app_actions;
CREATE SYNONYM gen          FOR core.gen;
CREATE SYNONYM recompile    FOR core.recompile;
CREATE SYNONYM nav_top      FOR core.nav_top;
--
CREATE SYNONYM sett         FOR core.s200;
CREATE SYNONYM s200         FOR core.s200;



--
-- GRANT ACCESS TO EXISTING OBJECTS TO CORE
--
SET SERVEROUTPUT ON SIZE 1000000
DECLARE
    in_owner    CONSTANT VARCHAR2(30)   := 'DEMO';
    in_user     CONSTANT VARCHAR2(30)   := 'CORE';
BEGIN
    FOR t IN (
        SELECT object_type, object_name
        FROM all_objects
        WHERE owner         = in_owner
            AND object_type IN ('TABLE', 'VIEW', 'PROCEDURE', 'FUNCTION', 'PACKAGE', 'SEQUENCE')        -- TYPE?
        ORDER BY object_type, object_name
    ) LOOP
        IF t.object_type IN ('TABLE', 'VIEW') THEN
            EXECUTE IMMEDIATE
                APEX_STRING.FORMAT('GRANT SELECT, UPDATE, INSERT, DELETE ON %s.%s TO %s', in_owner, t.object_name, in_user);
            --
        ELSIF t.object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE') THEN
            EXECUTE IMMEDIATE
                APEX_STRING.FORMAT('GRANT EXECUTE ON %s.%s TO %s', in_owner, t.object_name, in_user);
            --
        ELSIF t.object_type IN ('SEQUENCE') THEN
            EXECUTE IMMEDIATE
                APEX_STRING.FORMAT('GRANT SELECT ON %s.%s TO %s', in_owner, t.object_name, in_user);
        END IF;
        --
        IF t.object_type = 'PACKAGE' THEN
            EXECUTE IMMEDIATE
                APEX_STRING.FORMAT('GRANT DEBUG ON %s.%s TO %s', in_owner, t.object_name, in_user);
        END IF;
    END LOOP;
END;
/

