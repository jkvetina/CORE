--DROP TABLE translated_items PURGE;
CREATE TABLE translated_items (
    app_id              NUMBER(4)       CONSTRAINT nn_translated_items_app_id       NOT NULL,
    page_id             NUMBER(6)       CONSTRAINT nn_translated_items_page_id      NOT NULL,
    item_name           VARCHAR2(64)    CONSTRAINT nn_translated_items_name         NOT NULL,
    --
    value_en            VARCHAR2(2000),
    value_cz            VARCHAR2(2000),
    value_sk            VARCHAR2(2000),
    value_pl            VARCHAR2(2000),
    value_hu            VARCHAR2(2000),
    --
    updated_by          VARCHAR2(30),
    updated_at          DATE,
    --
    CONSTRAINT pk_translated_items
        PRIMARY KEY (app_id, page_id, item_name),
    --
    CONSTRAINT fk_translated_items_page_id
        FOREIGN KEY (app_id, page_id)
        REFERENCES navigation (app_id, page_id)
)
STORAGE (BUFFER_POOL KEEP);
--
COMMENT ON TABLE  translated_items             IS '[CORE] Translations for page/app items';
--
COMMENT ON COLUMN translated_items.app_id      IS 'APEX application ID';
COMMENT ON COLUMN translated_items.page_id     IS 'APEX page ID; 0 for page zero or application item';
COMMENT ON COLUMN translated_items.item_name   IS 'Item name (preferrably) to translate';
--
COMMENT ON COLUMN translated_items.value_en    IS 'Translated value';
COMMENT ON COLUMN translated_items.value_cz    IS 'Translated value';
COMMENT ON COLUMN translated_items.value_sk    IS 'Translated value';
COMMENT ON COLUMN translated_items.value_pl    IS 'Translated value';
COMMENT ON COLUMN translated_items.value_hu    IS 'Translated value';

