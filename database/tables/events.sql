CREATE TABLE events (
    app_id                          NUMBER(4,0)     CONSTRAINT nn_events_app_id NOT NULL,
    event_id                        VARCHAR2(30)    CONSTRAINT nn_events_event_id NOT NULL,
    event_name                      VARCHAR2(64),
    event_group                     VARCHAR2(64),
    description_                    VARCHAR2(1000),
    is_active                       CHAR(1),
    updated_by                      VARCHAR2(30)    DEFAULT NULL,
    updated_at                      DATE,
    --
    CONSTRAINT ch_events_is_active
        CHECK (is_active = 'Y' OR is_active IS NULL),
    --
    CONSTRAINT pk_events
        PRIMARY KEY (app_id, event_id),
    --
    CONSTRAINT fk_events_app_id
        FOREIGN KEY (app_id)
        REFERENCES apps (app_id)
);
--
COMMENT ON TABLE events IS '[CORE] List of events interesting for business';
--
COMMENT ON COLUMN events.app_id         IS 'APEX application ID';
COMMENT ON COLUMN events.event_id       IS 'Event id';
COMMENT ON COLUMN events.event_name     IS 'Event name';
COMMENT ON COLUMN events.event_group    IS 'Event group just for grouping set in APEX';
COMMENT ON COLUMN events.description_   IS 'Human friendly event description';
COMMENT ON COLUMN events.is_active      IS 'Flag to disable tracking';

