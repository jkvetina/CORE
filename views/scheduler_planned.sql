CREATE OR REPLACE VIEW scheduler_planned AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_owner()             AS owner,
        app.get_item('$JOB_NAME')   AS job_name
    FROM DUAL
)
SELECT
    j.job_name,
    j.job_type,
    j.job_priority,
    j.job_action,
    j.number_of_arguments           AS job_args,
    j.repeat_interval,
    --
    NULLIF(j.run_count, 0)          AS run_count,
    NULLIF(j.failure_count, 0)      AS failure_count,
    NULLIF(j.retry_count, 0)        AS retry_count,
    --
    j.next_run_date,
    j.last_start_date,
    --
    app.get_duration(j.last_run_duration) AS last_run_duration,
    --
    CASE WHEN j.auto_drop = 'TRUE'                          THEN 'Y' END AS is_autodrop,
    CASE WHEN j.state = 'SCHEDULED' AND j.enabled = 'TRUE'  THEN 'Y' END AS is_enabled,
    --
    j.comments
FROM all_scheduler_jobs j
JOIN x
    ON x.owner          = j.owner
    AND j.job_name      = NVL(x.job_name, j.job_name);
--
COMMENT ON TABLE scheduler_planned IS '[CORE - DASHBOARD] Planned jobs';

