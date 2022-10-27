ALTER SESSION SET CURRENT_SCHEMA = sys;

--
-- PACKAGE
--
GRANT EXECUTE           ON sys.dbms_application_info          TO core;
GRANT EXECUTE           ON sys.dbms_network_acl_admin         TO core;
GRANT EXECUTE           ON sys.dbms_profiler                  TO core;
GRANT EXECUTE           ON sys.dbms_scheduler                 TO core;
GRANT EXECUTE           ON sys.dbms_session                   TO core;
GRANT EXECUTE           ON sys.dbms_trace                     TO core;
GRANT EXECUTE           ON sys.dbms_utility                   TO core;

--
-- VIEW
--
GRANT SELECT            ON sys.dba_network_acls               TO core;
GRANT SELECT            ON sys.dba_network_acl_privileges     TO core;

ALTER SESSION SET CURRENT_SCHEMA = core;

