DECLARE
    in_job_name             CONSTANT VARCHAR2(30)   := 'CORE_PURGE_LOGS';
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
        job_action          => 'app.purge_logs',
        number_of_arguments => 0,
        start_date          => SYSDATE,
        repeat_interval     => 'FREQ=DAILY; BYHOUR=2; BYMINUTE=0',
        enabled             => FALSE,
        auto_drop           => TRUE,
        comments            => 'Purge old records from LOGS table and related tables'
    );
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


