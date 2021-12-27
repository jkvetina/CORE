CREATE OR REPLACE VIEW scheduler_history AS
WITH x AS (
    SELECT
        app.get_app_id()                AS app_id,
        app.get_date_item('G_TODAY')    AS today
    FROM users u
    WHERE u.user_id     = app.get_user_id()
)
SELECT
    MAX(d.log_id)       AS log_id,
    d.job_name,
    --
    NULLIF(SUM(CASE WHEN d.status = 'SUCCEEDED'  THEN 1 ELSE 0 END), 0) AS count_succeeded,
    NULLIF(SUM(CASE WHEN d.status != 'SUCCEEDED' THEN 1 ELSE 0 END), 0) AS count_failed,
    --
    MAX(d.errors)       AS error_desc,
    --
    MIN(CAST(d.actual_start_date AS DATE))          AS first_run,
    NULLIF(MAX(CAST(d.actual_start_date AS DATE)),
        MIN(CAST(d.actual_start_date AS DATE)))     AS last_run,
    --
    NULL                AS avg_run_duration,
    NULL                AS avg_cpu_used
    --
FROM user_scheduler_job_run_details d
JOIN x
    ON d.actual_start_date      >= x.today
    AND d.actual_start_date     < x.today + 1
GROUP BY d.job_name;

