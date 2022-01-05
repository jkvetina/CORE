SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
--
-- MAKE SURE YOU EXECUTE THIS IN CORRECT SCHEMA
--
BEGIN
    FOR c IN (
        SELECT object_name
        FROM user_objects
        WHERE object_type = 'MATERIALIZED VIEW'
    ) LOOP
        DBMS_OUTPUT.PUT('.');
        DBMS_UTILITY.EXEC_DDL_STATEMENT('DROP MATERIALIZED VIEW "' || c.object_name || '"');
    END LOOP;
    --
    FOR c IN (
        SELECT object_type, object_name
        FROM user_objects
        WHERE object_name NOT IN (
                SELECT object_name FROM RECYCLEBIN
            )
            AND object_type IN (
                'PACKAGE',
                'PACKAGE BODY',
                'VIEW',
                'FUNCTION',
                'PROCEDURE',
                'SEQUENCE',
                'DATABASE LINK'
            )
        ORDER BY
            DECODE(object_type,
                'PACKAGE BODY', 1,
                'PACKAGE', 2,
                'VIEW', 3,
                'FUNCTION', 4,
                'PROCEDURE', 5,
                9
            ), object_name DESC
    ) LOOP
        DBMS_OUTPUT.PUT('.');
        DBMS_UTILITY.EXEC_DDL_STATEMENT('DROP ' || c.object_type || ' "' || c.object_name || '"');
    END LOOP;
    --
    FOR c IN (
        SELECT table_name
        FROM user_tables
        WHERE table_name NOT IN (
            SELECT object_name FROM RECYCLEBIN UNION ALL
            SELECT 'UPLOADS' AS object_name FROM DUAL
        )
    ) LOOP
        DBMS_OUTPUT.PUT('.');
        DBMS_UTILITY.EXEC_DDL_STATEMENT('DROP TABLE "' || c.table_name || '" CASCADE CONSTRAINTS PURGE');
    END LOOP;
    --
    EXECUTE IMMEDIATE 'PURGE RECYCLEBIN';

    -- also drop jobs
    FOR c IN (
        SELECT job_name FROM user_scheduler_jobs
    ) LOOP
        BEGIN
            DBMS_SCHEDULER.STOP_JOB (
                job_name => c.job_name
            );
        EXCEPTION
        WHEN OTHERS THEN
            NULL;
        END;
        --
        DBMS_SCHEDULER.DROP_JOB (
            job_name => c.job_name
        );
    END LOOP;
END;
/


SELECT object_type, object_name
FROM user_objects
WHERE object_type NOT IN ('LOB', 'INDEX');

