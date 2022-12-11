CREATE TABLE source_lines (
    owner                           VARCHAR2(30)    CONSTRAINT nn_source_lines_owner NOT NULL,
    name                            VARCHAR2(30)    CONSTRAINT nn_source_lines_name NOT NULL,
    line                            NUMBER(10,0)    CONSTRAINT nn_source_lines_line NOT NULL,
    text                            VARCHAR2(2000),
    --
    CONSTRAINT pk_source_lines
        PRIMARY KEY (owner, name, line)
);
--
COMMENT ON TABLE source_lines IS '[CORE] User views source converted to lines';
--
COMMENT ON COLUMN source_lines.owner   IS 'View owner';
COMMENT ON COLUMN source_lines.name    IS 'View name';
COMMENT ON COLUMN source_lines.line    IS 'Line number';
COMMENT ON COLUMN source_lines.text    IS 'Line content';

