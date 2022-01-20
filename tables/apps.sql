--DROP TABLE apps CASCADE CONSTRAINTS;
CREATE TABLE apps (
    app_id              NUMBER(4)       CONSTRAINT nn_apps_app_id NOT NULL,
    app_name            VARCHAR2(32),
    --
    description_        VARCHAR2(1000),
    message             VARCHAR2(256),
    is_active           CHAR(1),
    is_visible          CHAR(1),
    --
    updated_by          VARCHAR2(30),
    updated_at          DATE,
    --
    CONSTRAINT pk_apps
        PRIMARY KEY (app_id),
    --
    CONSTRAINT ch_apps_is_active
        CHECK (is_active = 'Y' OR is_active IS NULL),
    --
    CONSTRAINT ch_apps_is_visible
        CHECK (is_visible = 'Y' OR is_visible IS NULL)
)
STORAGE (BUFFER_POOL KEEP);
--
COMMENT ON TABLE  apps                  IS '[CORE] List of apps';
--
COMMENT ON COLUMN apps.app_id           IS 'APEX application ID';
COMMENT ON COLUMN apps.app_name         IS 'Application name';
COMMENT ON COLUMN apps.description_     IS 'Description';
COMMENT ON COLUMN apps.message          IS 'Announcement to users when taking app for maintenance';
COMMENT ON COLUMN apps.is_active        IS 'Flag to deny access to app to users (not developers)';
COMMENT ON COLUMN apps.is_visible       IS 'Flag to show app in list of apps even if user dont have role there';

