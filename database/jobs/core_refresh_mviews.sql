DECLARE
    in_job_name             CONSTANT VARCHAR2(30)   := 'CORE_REFRESH_MVIEWS';
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
        job_action          => 'app.refresh_mviews',
        start_date          => SYSDATE,
        repeat_interval     => 'FREQ=DAILY; BYHOUR=0; BYMINUTE=2',  -- 00:02
        enabled             => FALSE,
        comments            => 'Refresh all existing materialized views'
    );
    --
    DBMS_SCHEDULER.SET_ATTRIBUTE(in_job_name, 'JOB_PRIORITY', 3);  -- normal priority
    DBMS_SCHEDULER.ENABLE(in_job_name);
    COMMIT;
    --
    IF in_run_immediatelly THEN
        DBMS_SCHEDULER.RUN_JOB(in_job_name);
        COMMIT;
    END IF;
END;
/

