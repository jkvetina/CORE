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
-- Page 905: #fa-server-play &PAGE_NAME.
-- Process: ACTION_START
-- PL/SQL Code

app.log_action('JOB_START', app.get_item('$JOB_NAME'));
--
DBMS_SCHEDULER.RUN_JOB('#OWNER#.' || app.get_item('$JOB_NAME'));


-- ----------------------------------------
-- Page 905: #fa-server-play &PAGE_NAME.
-- Process: SAVE_PLANNED
-- PL/SQL Code to Insert/Update/Delete

app.log_action('SAVE_PLANNED', :APEX$ROW_STATUS, :JOB_NAME, :IS_ENABLED);

-- enable/disable job
IF :IS_ENABLED = 'Y' THEN
    DBMS_SCHEDULER.ENABLE('#OWNER#."' || :JOB_NAME || '"');
ELSE
    DBMS_SCHEDULER.DISABLE('#OWNER#."' || :JOB_NAME || '"');
END IF;

-- delete job
IF :APEX$ROW_STATUS = 'D' THEN
    BEGIN
        DBMS_SCHEDULER.STOP_JOB('#OWNER#."' || :JOB_NAME || '"');
    EXCEPTION
    WHEN OTHERS THEN
        NULL;
    END;
    --
    DBMS_SCHEDULER.DROP_JOB('#OWNER#."' || :JOB_NAME || '"');
END IF;


-- ----------------------------------------
-- Page 905: #fa-server-play &PAGE_NAME.
-- Process: GET_OUTPUT
-- PL/SQL Code

app.log_action('GET_OUTPUT', APEX_APPLICATION.G_X01);
--
FOR c IN (
    SELECT REPLACE(d.output, CHR(10), '<br>') AS line
    FROM user_scheduler_job_run_details d
    WHERE d.log_id = APEX_APPLICATION.G_X01
) LOOP
    htp.p(c.line);
END LOOP;


-- ----------------------------------------
-- Page 905: #fa-server-play &PAGE_NAME.
-- Process: GET_ADDITIONAL_INFO
-- PL/SQL Code

app.log_action('GET_ADDITIONAL_INFO', APEX_APPLICATION.G_X01);
--
FOR c IN (
    SELECT REPLACE(d.additional_info, CHR(10), '<br>') AS line
    FROM user_scheduler_job_run_details d
    WHERE d.log_id = APEX_APPLICATION.G_X01
) LOOP
    htp.p(c.line);
END LOOP;


-- ----------------------------------------
-- Page 905: #fa-server-play &PAGE_NAME.
-- Process: ACTION_GET_DETAILS
-- PL/SQL Code

app.log_action('GET_DETAILS', app.get_item('$JOB_NAME'));
--
FOR c IN (
    SELECT j.*
    FROM user_scheduler_jobs j
    WHERE j.job_name = app.get_item('$JOB_NAME')
) LOOP
    app.set_item('$IS_ENABLED', c.enabled);
    app.set_item('$DETAIL_TYPE', c.job_style || '<br />' || c.job_type);
    app.set_item('$DETAIL_SOURCE', c.job_action);
    app.set_item('$DETAIL_INTERVAL', c.schedule_type || '<br />' || c.repeat_interval);
END LOOP;


-- ----------------------------------------
-- Page 905: #fa-server-play &PAGE_NAME.
-- Process: ACTION_STOP
-- PL/SQL Code

app.log_action('JOB_STOP', app.get_item('$JOB_NAME'));
--
DBMS_SCHEDULER.STOP_JOB('#OWNER#.' || app.get_item('$JOB_NAME'));


