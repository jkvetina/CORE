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
-- Page 900: #fa-gears
-- Process: ACTION_PURGE_OLD
-- PL/SQL Code

app.log_action('PURGE_OLD');
--
app.purge_logs();


-- ----------------------------------------
-- Page 900: #fa-gears
-- Process: ACTION_SHRINK
-- PL/SQL Code

app.log_action('SHRINK');
--
EXECUTE IMMEDIATE 'ALTER TABLE #OWNER#.logs ENABLE ROW MOVEMENT';
EXECUTE IMMEDIATE 'ALTER TABLE #OWNER#.logs SHRINK SPACE';
EXECUTE IMMEDIATE 'ALTER TABLE #OWNER#.logs DISABLE ROW MOVEMENT';
--
DBMS_STATS.GATHER_TABLE_STATS('#OWNER#', 'LOGS');
EXECUTE IMMEDIATE 'ANALYZE TABLE #OWNER#.logs COMPUTE STATISTICS FOR TABLE';
--
EXECUTE IMMEDIATE 'ALTER TABLE #OWNER#.sessions ENABLE ROW MOVEMENT';
EXECUTE IMMEDIATE 'ALTER TABLE #OWNER#.sessions SHRINK SPACE';
EXECUTE IMMEDIATE 'ALTER TABLE #OWNER#.sessions DISABLE ROW MOVEMENT';
--
DBMS_STATS.GATHER_TABLE_STATS('#OWNER#', 'SESSIONS');
EXECUTE IMMEDIATE 'ANALYZE TABLE #OWNER#.sessions COMPUTE STATISTICS FOR TABLE';


-- ----------------------------------------
-- Page 900: #fa-gears
-- Process: ACTION_PURGE_DAY
-- PL/SQL Code

app.log_action('PURGE_DAY');
--
app.purge_logs(app.get_date(:P900_DELETE));


