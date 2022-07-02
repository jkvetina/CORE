CREATE OR REPLACE FORCE VIEW scheduler_details AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_owner()                 AS owner,
        app.get_app_id()                AS app_id,
        app.get_date_item('G_TODAY')    AS today,
        app.get_item('$JOB_NAME')       AS job_name,
        app.get_item('$JOB_STATUS')     AS job_status
    FROM DUAL
),
d AS (
    SELECT /*+ MATERIALIZE */
        REGEXP_SUBSTR(d.job_name, '^([^#]+)#(\d+)$', 1, 1, NULL, 2) AS log_id,
        REGEXP_SUBSTR(d.job_name, '^([^#]+)#(\d+)$', 1, 1, NULL, 1) AS job_group,
        --
        d.log_id                            AS job_log_id,
        d.job_name,
        d.actual_start_date                 AS start_date,
        app.get_duration(d.run_duration)    AS run_duration,
        app.get_duration(d.cpu_used)        AS cpu_used,
        d.status,
        --d.session_id,
        d.error#,
        d.errors                            AS error_desc,
        d.output,
        d.additional_info
    FROM all_scheduler_job_run_details d
    JOIN x
        ON d.owner                  = x.owner
        AND d.actual_start_date     >= x.today
        AND d.actual_start_date     < x.today + 1
        AND d.job_name              = NVL(x.job_name, d.job_name)
        AND d.status                = NVL(x.job_status, d.status)
)
SELECT
    d.log_id,
    d.job_group,
    MAX(d.job_log_id)           AS job_log_id,
    d.job_name,
    MIN(d.start_date)           AS first_date,
    MAX(d.start_date)           AS last_date,
    MAX(d.run_duration)         AS run_duration,
    MAX(d.cpu_used)             AS cpu_used,
    d.status,
    COUNT(d.status)             AS count_status,
    d.error#,
    d.error_desc,
    MIN(d.output)               AS output,
    MIN(d.additional_info)      AS additional_info
FROM d
GROUP BY d.log_id, d.job_group, d.job_name, d.status, d.error#, d.error_desc;
--
COMMENT ON TABLE scheduler_details IS '[CORE - DASHBOARD] Jobs history details';

