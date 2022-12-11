--DROP TABLE setting_colors;
CREATE TABLE setting_colors (
    app_id                          NUMBER(8,0)     CONSTRAINT nn_setting_colors_app_id NOT NULL,
    status_id                       VARCHAR2(30)    CONSTRAINT nn_setting_colors_status_id NOT NULL,
    treshold_min                    NUMBER,
    treshold_max                    NUMBER,
    color_code                      VARCHAR2(8),
    updated_by                      VARCHAR2(128),
    updated_at                      DATE,
    --
    CONSTRAINT pk_setting_colors
        PRIMARY KEY (app_id, status_id),
    --
    CONSTRAINT fk_setting_colors_app_id
        FOREIGN KEY (app_id)
        REFERENCES apps (app_id)
);
--
COMMENT ON TABLE setting_colors IS '[CORE] List of colors for settings overrides';

