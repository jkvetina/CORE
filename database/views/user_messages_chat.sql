CREATE OR REPLACE FORCE VIEW user_messages_chat AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        COALESCE(app.get_number_item('$APP_ID'),        app.get_app_id())       AS app_id,
        COALESCE(app.get_item('$USER_ID'),              app.get_user_id())      AS user_id,
        COALESCE(app.get_number_item('$SESSION_ID'),    app.get_session_id())   AS session_id
    FROM DUAL
)
SELECT
    --
    -- https://apex.oracle.com/pls/apex/apex_pm/r/ut/comments-report
    --
    NULL AS actions,
    NULL AS attribute_1,
    NULL AS attribute_2,
    NULL AS attribute_3,
    NULL AS attribute_4,
    --
    APEX_UTIL.GET_SINCE(m.created_at) AS comment_date,
    m.message_payload   AS comment_text,
    --
    CASE WHEN m.created_by = m.user_id
        THEN 'RIGHT'
        END AS comment_modifiers,
    --
    CASE WHEN m.created_by = m.user_id
        THEN 'u-color-6'
        ELSE 'u-color-5'
        END AS icon_modifier,
    --
    APEX_STRING.GET_INITIALS(m.created_by) AS user_icon,
    --
    CASE WHEN m.created_by = m.user_id
        THEN NULL
        ELSE m.created_by
        END AS user_name
FROM user_messages m
JOIN x
    ON x.app_id         = m.app_id
    AND x.user_id       = m.user_id
    AND x.session_id    = m.session_id
WHERE m.message_type    = 'CHAT'
ORDER BY m.created_at DESC
FETCH FIRST 20 ROWS ONLY;
--
COMMENT ON TABLE user_messages_chat IS '';

