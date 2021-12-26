CREATE OR REPLACE VIEW users_overview AS
WITH x AS (
    SELECT
        app.get_app_id()    AS app_id,
        app.get_user_id()   AS user_id,
        --
        TRUNC(NVL(app.get_date_item('G_TODAY'), SYSDATE))                       AS today,
        CAST(TRUNC(NVL(app.get_date_item('G_TODAY'), SYSDATE)) AS TIMESTAMP)    AS today_ts
    FROM users u
    WHERE u.user_id         = app.get_user_id()
),
s AS (
    SELECT
        s.user_id,
        COUNT(*)            AS count_sessions
    FROM sessions s
    JOIN x
        ON x.app_id         = s.app_id
        AND s.created_at    >= x.today
        AND s.created_at    < x.today + 1
    GROUP BY s.user_id
),
l AS (
    SELECT
        l.user_id,
        SUM(CASE WHEN l.flag = 'A' THEN 1 ELSE 0 END)   AS count_pages,
        COUNT(*)                                        AS count_logs,
        SUM(CASE WHEN l.flag = 'E' THEN 1 ELSE 0 END)   AS count_errors
    FROM logs l
    JOIN x
        ON x.app_id         = l.app_id
        AND l.created_at    >= x.today_ts
        AND l.created_at    < x.today_ts + 1
    GROUP BY l.user_id
),
r AS (
    SELECT
        r.user_id,
        NULLIF(COUNT(*), 0) AS count_roles
    FROM user_roles r
    JOIN x
        ON x.app_id         = r.app_id
    GROUP BY r.user_id
),
b AS (
    SELECT
        l.user_id,
        COUNT(*)            AS count_events
    FROM logs_events l
    JOIN x
        ON x.app_id         = l.app_id
        AND l.created_at    >= x.today_ts
        AND l.created_at    < x.today_ts + 1
    GROUP BY l.user_id
)
SELECT
    u.user_id,
    u.user_login,
    u.user_name,
    u.lang_id,
    u.is_active,
    --
    CASE
        WHEN (app.is_developer_y(u.user_id) = 'Y' OR app.is_developer_y(u.user_login) = 'Y')
            THEN 'Y'
        END AS is_dev,
    --
    s.count_sessions,
    l.count_pages,
    l.count_logs,
    l.count_errors,
    b.count_events,
    r.count_roles,
    --
    u.updated_by,
    u.updated_at
FROM users u
LEFT JOIN s ON s.user_id = u.user_id
LEFT JOIN l ON l.user_id = u.user_id
LEFT JOIN r ON r.user_id = u.user_id
LEFT JOIN b ON b.user_id = u.user_id
WHERE u.user_id = NVL(app.get_item('$USER_ID'), u.user_id)
    AND (
        u.user_id IN (
            SELECT r.user_id
            FROM user_roles r
            WHERE r.role_id = app.get_item('$ROLE_ID')
        )
        OR app.get_item('$ROLE_ID') IS NULL
    );

