--DROP TABLE logs_blacklist CASCADE CONSTRAINTS PURGE;
CREATE TABLE logs_blacklist (
    app_id              NUMBER(4)       CONSTRAINT nn_logs_blacklist_app_id     NOT NULL,
    flag                CHAR(1),
    user_id             VARCHAR2(30),
    page_id             NUMBER(6),
    module_like         VARCHAR2(30),
    action_like         VARCHAR2(30),
    --
    updated_by          VARCHAR2(30),
    updated_at          DATE,
    --
    CONSTRAINT uq_logs_blacklist
        UNIQUE (app_id, user_id, page_id, flag, module_like, action_like),
    --
    CONSTRAINT fk_logs_blacklist_app_id
        FOREIGN KEY (app_id)
        REFERENCES apps (app_id),
    --
    CONSTRAINT fk_logs_blacklist_user_id
        FOREIGN KEY (user_id)
        REFERENCES users (user_id)
)
STORAGE (BUFFER_POOL KEEP);
--
COMMENT ON TABLE  logs_blacklist                IS 'Define what logs will or wont be tracked';
--
COMMENT ON COLUMN logs_blacklist.app_id         IS 'App ID';
COMMENT ON COLUMN logs_blacklist.flag           IS 'Flag to differentiate logs, NULL = any flag';
COMMENT ON COLUMN logs_blacklist.page_id        IS 'APEX page ID, NULL = any page';
COMMENT ON COLUMN logs_blacklist.user_id        IS 'User ID, NULL = any user';
COMMENT ON COLUMN logs_blacklist.module_like    IS 'Module name, NULL = any module';
COMMENT ON COLUMN logs_blacklist.action_like    IS 'Action name, NULL = any module';

