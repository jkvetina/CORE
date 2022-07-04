CREATE TABLE setting_contexts (
    app_id                          NUMBER(4,0)     CONSTRAINT nn_setting_contexts_app_id NOT NULL,
    context_id                      VARCHAR2(64)    CONSTRAINT nn_setting_contexts_name NOT NULL,
    context_name                    VARCHAR2(64),
    description_                    VARCHAR2(1000),
    order#                          NUMBER(4,0),
    updated_by                      VARCHAR2(30),
    updated_at                      DATE,
    --
    CONSTRAINT uq_setting_contexts
        UNIQUE (app_id, context_id)
    --
    CONSTRAINT fk_setting_contexts_app_id
        FOREIGN KEY (app_id)
        REFERENCES apps (app_id)
);
--
COMMENT ON TABLE setting_contexts IS '[CORE] List of contexts for settings overrides';
--
COMMENT ON COLUMN setting_contexts.app_id           IS 'Application ID';
COMMENT ON COLUMN setting_contexts.context_id       IS 'To allow multiple values depending on context value';
COMMENT ON COLUMN setting_contexts.context_name     IS 'Friendly name';
COMMENT ON COLUMN setting_contexts.description_     IS 'Description';
COMMENT ON COLUMN setting_contexts.order#           IS 'Order for sorting purposes';

