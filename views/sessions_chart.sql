CREATE OR REPLACE VIEW sessions_chart AS
WITH t AS (
    SELECT
        NVL(d.user_id, LOWER(l.apex_user))  AS user_id,
        l.application_id                    AS app_id,
        l.application_name                  AS app_name,            -- NULL for APEX Builder
        l.page_id,
        l.page_name,
        SUBSTR(l.page_view_type, 1, 1)      AS request_type,
        l.page_view_type,
        l.request_value,
        l.view_timestamp                    AS requested_at
    FROM apex_workspace_activity_log l
    JOIN apex_workspaces w
        ON w.workspace_id                   = l.workspace_id
    JOIN apex_applications a
        ON a.workspace                      = w.workspace
        AND a.application_id                = l.application_id
    LEFT JOIN (
        SELECT
            UPPER(d.user_name)              AS user_name,
            LOWER(d.email)                  AS user_id
        FROM apex_workspace_developers d
        WHERE d.is_application_developer    = 'Yes'
            AND d.account_locked            = 'No'
    ) d
        ON d.user_name                      = l.apex_user
    WHERE a.application_id                  = NVL(app.get_app_id(), a.application_id)
        AND l.page_view_type                IN ('Rendering', 'Processing', 'Ajax')
        AND l.apex_user                     NOT IN ('nobody')
        AND l.view_timestamp                >= TRUNC(app.get_date_item('G_TODAY'))
        AND l.view_timestamp                < TRUNC(app.get_date_item('G_TODAY')) + 1
),
z AS (
    SELECT
        LEVEL                                                           AS bucket_id,
        TRUNC(SYSDATE) + NUMTODSINTERVAL((LEVEL - 1) * 10, 'MINUTE')    AS start_at,
        TRUNC(SYSDATE) + NUMTODSINTERVAL( LEVEL      * 10, 'MINUTE')    AS end_at
    FROM DUAL
    CONNECT BY LEVEL <= (1440 / 10)
)
SELECT
    z.bucket_id,
    TO_CHAR(z.start_at, 'HH24:MI') AS chart_label,
    --
    NULLIF(COUNT(DISTINCT t.user_id), 0)                                        AS count_users,
    NULLIF(COUNT(DISTINCT t.page_id), 0)                                        AS count_pages,
    --
    NULLIF(SUM(CASE WHEN t.app_id = app.get_app_id() THEN 1 ELSE 0 END), 0)     AS count_requests,
    NULLIF(SUM(CASE WHEN t.app_id IS NOT NULL AND t.app_name IS NULL THEN 1 ELSE 0 END), 0)     AS count_others,
    --
    NULL AS count_events
FROM z
LEFT JOIN t
    ON app.get_time_bucket(t.requested_at, 10) = z.bucket_id
GROUP BY z.bucket_id, TO_CHAR(z.start_at, 'HH24:MI');

