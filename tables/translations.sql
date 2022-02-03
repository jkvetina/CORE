--DROP TABLE translations PURGE;
CREATE TABLE translations (
    app_id              NUMBER(4)       CONSTRAINT nn_translations_app_id       NOT NULL,
    page_id             NUMBER(6)       CONSTRAINT nn_translations_page_id      NOT NULL,
    name                VARCHAR2(64)    CONSTRAINT nn_translations_name         NOT NULL,
    --
    value_en            VARCHAR2(256),
    value_cz            VARCHAR2(256),
    value_sk            VARCHAR2(256),
    value_pl            VARCHAR2(256),
    value_hu            VARCHAR2(256),
    --
    CONSTRAINT pk_translations
        PRIMARY KEY (app_id, page_id, name),
    --
    CONSTRAINT fk_translations_page_id
        FOREIGN KEY (app_id, page_id)
        REFERENCES navigation (app_id, page_id)
)
STORAGE (BUFFER_POOL KEEP);
--
COMMENT ON TABLE  translations              IS '[CORE] List of translations';
--
COMMENT ON COLUMN translations.app_id       IS 'APEX application ID';
COMMENT ON COLUMN translations.page_id      IS 'APEX page ID, 0 for fallback, otherwise priority on page';
COMMENT ON COLUMN translations.name         IS 'Item name (preferrably) to translate';
--
COMMENT ON COLUMN translations.value_en     IS 'Translated value';
COMMENT ON COLUMN translations.value_cz     IS 'Translated value';
COMMENT ON COLUMN translations.value_sk     IS 'Translated value';
COMMENT ON COLUMN translations.value_pl     IS 'Translated value';
COMMENT ON COLUMN translations.value_hu     IS 'Translated value';

