CREATE TABLE roles_e$ (
    ora_err_number$                 NUMBER,
    ora_err_mesg$                   VARCHAR2(2000),
    ora_err_rowid$                  UROWID(4000),
    ora_err_optyp$                  VARCHAR2(2),
    ora_err_tag$                    VARCHAR2(2000),
    app_id                          VARCHAR2(4000),
    role_id                         VARCHAR2(32767),
    role_name                       VARCHAR2(32767),
    role_group                      VARCHAR2(32767),
    description_                    VARCHAR2(32767),
    is_active                       VARCHAR2(32767),
    order#                          VARCHAR2(4000),
    updated_by                      VARCHAR2(32767),
    updated_at                      VARCHAR2(4000)
);
--
COMMENT ON TABLE roles_e$ IS 'DML Error Logging table for "CORE"."ROLES"';

