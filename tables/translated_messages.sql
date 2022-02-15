--DROP TABLE translated_messages PURGE;
CREATE TABLE translated_messages (
    app_id              NUMBER(4)       CONSTRAINT nn_translated_messages_app_id    NOT NULL,
    message             VARCHAR2(64)    CONSTRAINT nn_translated_messages_message   NOT NULL,
    --
    value_en            VARCHAR2(256),
    value_cz            VARCHAR2(256),
    value_sk            VARCHAR2(256),
    value_pl            VARCHAR2(256),
    value_hu            VARCHAR2(256),
    --
    updated_by          VARCHAR2(30),
    updated_at          DATE,
    --
    CONSTRAINT pk_translated_messages
        PRIMARY KEY (app_id, message)
)
STORAGE (BUFFER_POOL KEEP);
--
COMMENT ON TABLE  translated_messages              IS '[CORE] List of translated messages/notifications';
--
COMMENT ON COLUMN translated_messages.app_id       IS 'APEX application ID';
COMMENT ON COLUMN translated_messages.message      IS 'Message to translate';
--
COMMENT ON COLUMN translated_messages.value_en     IS 'Translated value';
COMMENT ON COLUMN translated_messages.value_cz     IS 'Translated value';
COMMENT ON COLUMN translated_messages.value_sk     IS 'Translated value';
COMMENT ON COLUMN translated_messages.value_pl     IS 'Translated value';
COMMENT ON COLUMN translated_messages.value_hu     IS 'Translated value';

