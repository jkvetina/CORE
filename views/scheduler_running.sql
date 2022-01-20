CREATE OR REPLACE VIEW scheduler_running AS
SELECT
    j.log_id,
    j.job_name,
    j.job_style,
    j.elapsed_time,
    j.cpu_used,
    j.destination,
    j.session_id,
    j.resource_consumer_group,
    j.credential_name
FROM user_scheduler_running_jobs j;
--
COMMENT ON TABLE scheduler_running IS '[CORE - DASHBOARD] Running jobs';

