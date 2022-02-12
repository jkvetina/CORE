--DROP TABLE mail_templates PURGE;
CREATE TABLE mail_templates (
    app_id              NUMBER(4)       CONSTRAINT nn_mail_templates_app_id         NOT NULL,
    template_id         VARCHAR2(30)    CONSTRAINT nn_mail_templates_template_id    NOT NULL,
    lang_id             VARCHAR2(5)     CONSTRAINT nn_mail_templates_lang_id        NOT NULL,
    template_group      VARCHAR2(64),
    description_        VARCHAR2(256),
    process_function    VARCHAR2(64),   -- to generate specific content
    --
    mail_subject        VARCHAR2(256),
    mail_body           CLOB,
    --
    updated_by          VARCHAR2(30),
    updated_at          DATE,
    --
    CONSTRAINT pk_mail_templates
        PRIMARY KEY (app_id, template_id, lang_id)
);
--
COMMENT ON TABLE  mail_templates                    IS '[CORE] E-mail templates';
--
COMMENT ON COLUMN mail_templates.app_id             IS 'APEX application ID';
COMMENT ON COLUMN mail_templates.template_id        IS 'Template id';
COMMENT ON COLUMN mail_templates.lang_id            IS 'Language id';
COMMENT ON COLUMN mail_templates.template_group     IS 'Template group just for better visibility';
COMMENT ON COLUMN mail_templates.description_       IS 'Description of the template';
COMMENT ON COLUMN mail_templates.process_function   IS 'Function to generate customized/complex template';
COMMENT ON COLUMN mail_templates.mail_subject       IS 'E-mail subject';
COMMENT ON COLUMN mail_templates.mail_body          IS 'E-mail body, can be generated by a process_function';

