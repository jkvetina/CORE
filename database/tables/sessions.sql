--DROP TABLE sessions;
CREATE TABLE sessions (
    app_id                          NUMBER(8,0)     CONSTRAINT nn_sessions_app_id NOT NULL,
    session_id                      INTEGER         CONSTRAINT nn_sessions_session_id NOT NULL,
    user_id                         VARCHAR2(128)   CONSTRAINT nn_sessions_user_id NOT NULL,
    created_at                      DATE            CONSTRAINT nn_sessions_created_at NOT NULL,
    updated_at                      DATE            CONSTRAINT nn_sessions_updated_at NOT NULL,
    --
    CONSTRAINT pk_sessions
        PRIMARY KEY (app_id, session_id),
    --
    CONSTRAINT fk_sessions_app_id
        FOREIGN KEY (app_id)
        REFERENCES apps (app_id),
    --
    CONSTRAINT fk_sessions_users
        FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        DEFERRABLE INITIALLY DEFERRED
);
--
COMMENT ON TABLE sessions IS '[CORE] List of sessions';
--
COMMENT ON COLUMN sessions.app_id               IS 'APEX application ID';
COMMENT ON COLUMN sessions.session_id           IS 'Session ID generated by APEX, used also in LOGS';
COMMENT ON COLUMN sessions.user_id              IS 'User ID';
COMMENT ON COLUMN sessions.created_at           IS 'Time of creation';
COMMENT ON COLUMN sessions.updated_at           IS 'Time of last update';

