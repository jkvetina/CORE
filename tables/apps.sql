--DROP TABLE apps CASCADE CONSTRAINTS;
CREATE TABLE apps (
    app_id              NUMBER(4)       CONSTRAINT nn_apps_app_id NOT NULL,
    --
    description_        VARCHAR2(1000),
    is_visible          CHAR(1),
    --
    updated_by          VARCHAR2(30),
    updated_at          DATE,
    --
    CONSTRAINT pk_apps
        PRIMARY KEY (app_id),
    --
    CONSTRAINT ch_apps_is_visible
        CHECK (is_visible = 'Y' OR is_visible IS NULL)
)
STORAGE (BUFFER_POOL KEEP);
--
COMMENT ON TABLE  apps                  IS '[CORE] List of apps';
--
COMMENT ON COLUMN apps.app_id           IS 'APEX application ID';
COMMENT ON COLUMN apps.description_     IS 'Description, until I know how to edit documentation_banner';
COMMENT ON COLUMN apps.is_visible       IS 'Flag to show app in list of apps even if user dont have role there';

