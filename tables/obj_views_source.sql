--DROP TABLE obj_views_source;
CREATE TABLE obj_views_source (
    owner       VARCHAR2(30)        CONSTRAINT nn_obj_views_source_owner    NOT NULL,
    name        VARCHAR2(30)        CONSTRAINT nn_obj_views_source_name     NOT NULL,
    line        NUMBER(10)          CONSTRAINT nn_obj_views_source_line     NOT NULL,
    text        VARCHAR2(2000),
    --
    CONSTRAINT pk_obj_views_source
        PRIMARY KEY (owner, name, line)
);
--
COMMENT ON TABLE  obj_views_source          IS '[CORE] User views source converted to lines';
--
COMMENT ON COLUMN obj_views_source.owner    IS 'View owner';
COMMENT ON COLUMN obj_views_source.name     IS 'View name';
COMMENT ON COLUMN obj_views_source.line     IS 'Line number';
COMMENT ON COLUMN obj_views_source.text     IS 'Line content';

