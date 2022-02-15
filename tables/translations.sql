--DROP TABLE translations PURGE;
CREATE TABLE translations (
    app_id              NUMBER(4)       CONSTRAINT nn_translations_app_id   NOT NULL,
    name                VARCHAR2(64)    CONSTRAINT nn_translations_name     NOT NULL,
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
    CONSTRAINT pk_translations
        PRIMARY KEY (app_id, name)
)
STORAGE (BUFFER_POOL KEEP);
--
COMMENT ON TABLE  translations              IS '[CORE] List of translations';
--
COMMENT ON COLUMN translations.app_id       IS 'APEX application ID';
COMMENT ON COLUMN translations.name         IS 'Message to translate';
--
COMMENT ON COLUMN translations.value_en     IS 'Translated value';
COMMENT ON COLUMN translations.value_cz     IS 'Translated value';
COMMENT ON COLUMN translations.value_sk     IS 'Translated value';
COMMENT ON COLUMN translations.value_pl     IS 'Translated value';
COMMENT ON COLUMN translations.value_hu     IS 'Translated value';

