CREATE OR REPLACE FORCE VIEW user_messages_chats AS
SELECT
    m.app_id,
    m.user_id,
    m.session_id,
    --
    COUNT(*)                        AS count_messages,
    COUNT(DISTINCT m.created_by)    AS count_users,
    --
    MIN(m.created_at)   AS start_at,
    MAX(m.created_at)   AS end_at,
    --
    'OPEN_CHAT'         AS action_open,
    'CLOSE_CHAT'        AS action_close
FROM user_messages m
WHERE m.message_type    = 'CHAT'
GROUP BY m.app_id, m.user_id, m.session_id;
--
COMMENT ON TABLE user_messages_chats IS '';

