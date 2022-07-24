CREATE TABLE users (
    user_id                         VARCHAR2(30)    CONSTRAINT nn_users_user_id NOT NULL,
    user_login                      VARCHAR2(128)   CONSTRAINT nn_users_login NOT NULL,
    user_name                       VARCHAR2(64),
    lang_id                         VARCHAR2(5),
    is_active                       CHAR(1),
    updated_by                      VARCHAR2(30),
    updated_at                      DATE,
    --
    CONSTRAINT ch_users_is_active
        CHECK (is_active = 'Y' OR is_active IS NULL),
    --
    CONSTRAINT pk_users
        PRIMARY KEY (user_id),
    --
    CONSTRAINT uq_users_user_login
        UNIQUE (user_login)
);
--
COMMENT ON TABLE users IS '[CORE] List of users';
--
COMMENT ON COLUMN users.user_id         IS 'User ID used internally (short)';
COMMENT ON COLUMN users.user_login      IS 'User login used for login into the app';
COMMENT ON COLUMN users.user_name       IS 'User name visible in the app';
COMMENT ON COLUMN users.lang_id         IS 'Preferred language';
COMMENT ON COLUMN users.is_active       IS 'Flag to disable user without changing roles';

