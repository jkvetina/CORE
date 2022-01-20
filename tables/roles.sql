--DROP TABLE roles PURGE;
CREATE TABLE roles (
    app_id              NUMBER(4)       CONSTRAINT nn_roles_app_id      NOT NULL,
    role_id             VARCHAR2(30)    CONSTRAINT nn_roles_role_id     NOT NULL,
    role_name           VARCHAR2(64),
    role_group          VARCHAR2(64),
    --
    description_        VARCHAR2(1000),
    is_active           CHAR(1),
    order#              NUMBER(4),
    --
    updated_by          VARCHAR2(30),
    updated_at          DATE,
    --
    CONSTRAINT pk_roles
        PRIMARY KEY (app_id, role_id),
    --
    CONSTRAINT fk_roles_app_id
        FOREIGN KEY (app_id)
        REFERENCES apps (app_id),
    --
    CONSTRAINT ch_roles_is_active
        CHECK (is_active = 'Y' OR is_active IS NULL)
)
STORAGE (BUFFER_POOL KEEP);
--
COMMENT ON TABLE  roles                     IS '[CORE] List of roles';
--
COMMENT ON COLUMN roles.app_id              IS 'Application ID';
COMMENT ON COLUMN roles.role_id             IS 'Role ID';
COMMENT ON COLUMN roles.role_name           IS 'Role name';
COMMENT ON COLUMN roles.role_group          IS 'Role group just for grouping set in APEX';
COMMENT ON COLUMN roles.description_        IS 'Description';
COMMENT ON COLUMN roles.is_active           IS 'Flag to disable role';
COMMENT ON COLUMN roles.order#              IS 'Roles order in any form of list/report';

