CREATE OR REPLACE VIEW scheduler_details AS
WITH x AS (
    SELECT
        app.get_app_id()                AS app_id,
        app.get_date_item('G_TODAY')    AS today
    FROM users u
    WHERE u.user_id     = app.get_user_id()
)
SELECT
    d.log_id,
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
FROM user_scheduler_job_run_details d
JOIN x
    ON d.actual_start_date      >= x.today
    AND d.actual_start_date     < x.today + 1;

