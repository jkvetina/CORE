--DROP TABLE logs_setup CASCADE CONSTRAINTS PURGE;
CREATE TABLE logs_setup (
    --
    -- @TODO: ??? trigger/proc when new app is created (apps table) to prefill setup...
    --
    app_id              NUMBER(4)       CONSTRAINT nn_logs_setup_app_id         NOT NULL,
    user_id             VARCHAR2(240),
    page_id             NUMBER(6),
    flag                CHAR(1),
    module_like         VARCHAR2(30),
     --
    is_ignored          CHAR(1),
    --
    updated_by          VARCHAR2(30),
    updated_at          DATE,
    --
    CONSTRAINT uq_logs_setup
        UNIQUE (app_id, user_id, page_id, flag, module_like),
    --
    CONSTRAINT fk_logs_setup_app_id
        FOREIGN KEY (app_id)
        REFERENCES apps (app_id),
    --
    CONSTRAINT fk_logs_setup_user_id
        FOREIGN KEY (user_id)
        REFERENCES users (user_id),
    --
    CONSTRAINT ch_logs_setup_is_ignored
        CHECK (is_ignored = 'Y' OR is_ignored IS NULL)
)
STORAGE (BUFFER_POOL KEEP);
--
COMMENT ON TABLE  logs_setup                IS 'Define what logs will or wont be tracked';
--
COMMENT ON COLUMN logs_setup.app_id         IS 'App ID';
COMMENT ON COLUMN logs_setup.page_id        IS 'APEX page ID, NULL = any page';
COMMENT ON COLUMN logs_setup.user_id        IS 'User ID, NULL = any user';
COMMENT ON COLUMN logs_setup.flag           IS 'Flag to differentiate logs, NULL = any flag';
COMMENT ON COLUMN logs_setup.module_like    IS 'Module name, NULL = any module';
COMMENT ON COLUMN logs_setup.is_ignored     IS 'Y = dont store in table';

