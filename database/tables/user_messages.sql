CREATE TABLE user_messages (
    app_id                          NUMBER(4,0)     CONSTRAINT nn_user_messages_app_id NOT NULL,
    user_id                         VARCHAR2(30)    CONSTRAINT nn_user_messages_user_id NOT NULL,
    message_id                      INTEGER         CONSTRAINT nn_user_messages_message_id NOT NULL,
    message_type                    VARCHAR2(16),
    message_payload                 VARCHAR2(2000),
    session_id                      INTEGER,
    created_by                      VARCHAR2(30),
    created_at                      DATE,
    delivered_at                    DATE,
    --
    CONSTRAINT pk_user_messages
        PRIMARY KEY (app_id, user_id, message_id)
    --
    CONSTRAINT fk_user_messages_app_id
        FOREIGN KEY (app_id)
        REFERENCES apps (app_id),
    --
    CONSTRAINT fk_user_messages_user_id
        FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        DEFERRABLE INITIALLY DEFERRED
);
--
COMMENT ON TABLE user_messages IS '[CORE] Messages for users';
--
COMMENT ON COLUMN user_messages.app_id              IS 'APEX application ID';
COMMENT ON COLUMN user_messages.user_id             IS 'User ID from USERS table';
COMMENT ON COLUMN user_messages.message_id          IS 'Message id';
COMMENT ON COLUMN user_messages.message_type        IS 'Message type';
COMMENT ON COLUMN user_messages.message_payload     IS 'Message itself';
COMMENT ON COLUMN user_messages.session_id          IS 'Session id';
COMMENT ON COLUMN user_messages.delivered_at        IS 'Stamp of delivery';

