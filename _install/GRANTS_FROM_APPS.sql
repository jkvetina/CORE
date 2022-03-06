--
-- EXECUTE FROM NEW SCHEMA
--
CREATE SYNONYM app          FOR core.app;
CREATE SYNONYM app_actions  FOR core.app_actions;
CREATE SYNONYM gen          FOR core.gen;
CREATE SYNONYM recompile    FOR core.recompile;
CREATE SYNONYM nav_top      FOR core.nav_top;



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
                'GRANT SELECT, UPDATE, INSERT, DELETE ON ' || in_owner || '.' || t.object_name || ' TO ' || in_user;
            --
        ELSIF t.object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE') THEN
            EXECUTE IMMEDIATE
                'GRANT EXECUTE ON ' || in_owner || '.' || t.object_name || ' TO ' || in_user;
            --
        ELSIF t.object_type IN ('SEQUENCE') THEN
            EXECUTE IMMEDIATE
                'GRANT SELECT ON ' || in_owner || '.' || t.object_name || ' TO ' || in_user;
        END IF;
    END LOOP;
END;
/

