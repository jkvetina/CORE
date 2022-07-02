CREATE OR REPLACE VIEW scheduler_running AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_owner()     AS owner
    FROM DUAL
)
SELECT
    REGEXP_SUBSTR(j.job_name, '^([^#]+)#(\d+)$', 1, 1, NULL, 2) AS log_id,
    REGEXP_SUBSTR(j.job_name, '^([^#]+)#(\d+)$', 1, 1, NULL, 1) AS job_group,
    --
    j.log_id        AS job_log_id,
    j.job_name,
    j.job_style,
    --
    app.get_duration(j.elapsed_time)    AS elapsed_time,
    app.get_duration(j.cpu_used)        AS cpu_used,
    --
    j.destination,
    j.session_id,
    j.resource_consumer_group,
    j.credential_name
FROM all_scheduler_running_jobs j
JOIN x
    ON x.owner      = j.owner;
--
COMMENT ON TABLE scheduler_running IS '[CORE - DASHBOARD] Running jobs';

