CREATE OR REPLACE VIEW user_messages_chats AS
SELECT
    m.app_id,
    m.user_id,
    m.session_id,
    --
    COUNT(*)                        AS count_messages,
    COUNT(DISTINCT m.created_by)    AS count_users,
    --
    MIN(m.created_at) AS start_at,
    MAX(m.created_at) AS end_at
FROM user_messages m
WHERE m.message_type    = 'CHAT'
GROUP BY m.app_id, m.user_id, m.session_id
;
