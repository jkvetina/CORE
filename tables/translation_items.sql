--DROP TABLE translation_items PURGE;
CREATE TABLE translation_items (
    app_id              NUMBER(4)       CONSTRAINT nn_translation_items_app_id      NOT NULL,
    page_id             NUMBER(6)       CONSTRAINT nn_translation_items_page_id     NOT NULL,
    name                VARCHAR2(64)    CONSTRAINT nn_translation_items_name        NOT NULL,
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
    CONSTRAINT pk_translation_items
        PRIMARY KEY (app_id, page_id, name),
    --
    CONSTRAINT fk_translation_items_page_id
        FOREIGN KEY (app_id, page_id)
        REFERENCES navigation (app_id, page_id)
)
STORAGE (BUFFER_POOL KEEP);
--
COMMENT ON TABLE  translation_items              IS '[CORE] List of translation_items';
--
COMMENT ON COLUMN translation_items.app_id       IS 'APEX application ID';
COMMENT ON COLUMN translation_items.page_id      IS 'APEX page ID, 0 for fallback, otherwise priority on page';
COMMENT ON COLUMN translation_items.name         IS 'Item name (preferrably) to translate';
--
COMMENT ON COLUMN translation_items.value_en     IS 'Translated value';
COMMENT ON COLUMN translation_items.value_cz     IS 'Translated value';
COMMENT ON COLUMN translation_items.value_sk     IS 'Translated value';
COMMENT ON COLUMN translation_items.value_pl     IS 'Translated value';
COMMENT ON COLUMN translation_items.value_hu     IS 'Translated value';

