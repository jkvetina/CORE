CREATE TABLE user_source_views (
    name        VARCHAR2(30)        CONSTRAINT nn_user_source_views_name NOT NULL,
    line        NUMBER(8)           CONSTRAINT nn_user_source_views_line NOT NULL,
    text        VARCHAR2(4000),
    --
    CONSTRAINT pk_user_source_views
        PRIMARY KEY (name, line)
);
--
COMMENT ON TABLE  user_source_views         IS 'User views source converted to lines';
--
COMMENT ON COLUMN user_source_views.name    IS 'View name';
COMMENT ON COLUMN user_source_views.line    IS 'Line number';
COMMENT ON COLUMN user_source_views.text    IS 'Line content';

