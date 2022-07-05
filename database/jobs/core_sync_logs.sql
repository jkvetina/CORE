DECLARE
    in_job_name             CONSTANT VARCHAR2(30)   := 'CORE_SYNC_LOGS';
    in_run_immediatelly     CONSTANT BOOLEAN        := FALSE;
BEGIN
    BEGIN
        DBMS_SCHEDULER.DROP_JOB(in_job_name, TRUE);
    EXCEPTION
    WHEN OTHERS THEN
        NULL;
    END;
    --
    DBMS_SCHEDULER.CREATE_JOB (
        job_name            => in_job_name,
        job_type            => 'STORED_PROCEDURE',
        job_action          => 'app.sync_logs',
        number_of_arguments => 1,
        start_date          => SYSDATE,
        repeat_interval     => 'FREQ=MINUTELY;INTERVAL=1',
        enabled             => FALSE,
        auto_drop           => TRUE,
        comments            => 'Sync SCHEDULER results and DML errors to LOGS table'
    );
    --
    DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE(in_job_name, argument_position => 1, argument_value => .0416666666666666666666666666666666666667);
    --
    DBMS_SCHEDULER.SET_ATTRIBUTE(in_job_name, 'JOB_PRIORITY', 5);
    DBMS_SCHEDULER.ENABLE(in_job_name);
    COMMIT;
    --
    IF in_run_immediatelly THEN
        DBMS_SCHEDULER.RUN_JOB(in_job_name);
        COMMIT;
    END IF;
END;
/


