--DROP TABLE settings PURGE;
CREATE TABLE settings (
    app_id              NUMBER(4)       CONSTRAINT nn_settings_app_id   NOT NULL,
    setting_name        VARCHAR2(30)    CONSTRAINT nn_settings_id       NOT NULL,
    --
    setting_value       VARCHAR2(256),
    setting_context     VARCHAR2(64),
    setting_group       VARCHAR2(64),
    --
    is_numeric          CHAR(1),
    is_date             CHAR(1),
    --
    description_        VARCHAR2(1000),
    --
    updated_by          VARCHAR2(30),
    updated_at          DATE,
    --
    CONSTRAINT uq_settings
        UNIQUE (app_id, setting_name, setting_context),
    --
    CONSTRAINT fk_settings_app_id
        FOREIGN KEY (app_id)
        REFERENCES apps (app_id),
    --
    CONSTRAINT ch_settings_is_active
        CHECK ((is_numeric = 'Y' AND is_date IS NULL) OR is_numeric IS NULL),
    --
    CONSTRAINT ch_settings_is_date
        CHECK ((is_date = 'Y' AND is_numeric IS NULL) OR is_date IS NULL)
)
STORAGE (BUFFER_POOL KEEP);
--
COMMENT ON TABLE  settings                      IS '[CORE] List of settings shared through whole app';
--
COMMENT ON COLUMN settings.app_id               IS 'Application ID';
COMMENT ON COLUMN settings.setting_name         IS 'Setting ID';
COMMENT ON COLUMN settings.setting_value        IS 'Value stored as string';
COMMENT ON COLUMN settings.setting_context      IS 'To allow multiple values depending on context value';
COMMENT ON COLUMN settings.setting_group        IS 'Group just for grouping set in APEX';
COMMENT ON COLUMN settings.is_numeric           IS 'Flag to convert value to number';
COMMENT ON COLUMN settings.is_date              IS 'Flag to convert value to date';
COMMENT ON COLUMN settings.description_         IS 'Description';

