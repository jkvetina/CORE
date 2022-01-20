--DROP TABLE log_events PURGE;
CREATE TABLE log_events (
    log_id              INTEGER         CONSTRAINT nn_log_events_log_id        NOT NULL,
    log_parent          INTEGER,
    --
    app_id              NUMBER(4)       CONSTRAINT nn_log_events_app_id        NOT NULL,
    page_id             NUMBER(6)       CONSTRAINT nn_log_events_page_id       NOT NULL,
    user_id             VARCHAR2(30)    CONSTRAINT nn_log_events_user_id       NOT NULL,
    session_id          NUMBER          CONSTRAINT nn_log_events_session_id    NOT NULL,
    --
    event_id            VARCHAR2(30)    CONSTRAINT nn_log_events_event_id      NOT NULL,
    event_value         NUMBER,
    --
    created_at          DATE            CONSTRAINT nn_log_events_created_at    NOT NULL,
    --
    CONSTRAINT pk_log_events
        PRIMARY KEY (log_id),
    --
    CONSTRAINT fk_log_events_event_id
        FOREIGN KEY (app_id, event_id)
        REFERENCES events (app_id, event_id),
    --
    CONSTRAINT fk_log_events_users
        FOREIGN KEY (user_id)
        REFERENCES users (user_id)
);
--
ALTER TABLE log_events DISABLE CONSTRAINT fk_log_events_users;
--
COMMENT ON TABLE  log_events                    IS '[CORE] List of business events';
--
COMMENT ON COLUMN log_events.log_id             IS 'Log ID';
COMMENT ON COLUMN log_events.log_parent         IS 'Referenced log_id from LOGS table';
COMMENT ON COLUMN log_events.app_id             IS 'App';
COMMENT ON COLUMN log_events.page_id            IS 'Page';
COMMENT ON COLUMN log_events.user_id            IS 'User';
COMMENT ON COLUMN log_events.session_id         IS 'Session id';
COMMENT ON COLUMN log_events.event_id           IS 'Event code from EVENTS table';
COMMENT ON COLUMN log_events.event_value        IS 'Optional business value';
COMMENT ON COLUMN log_events.created_at         IS 'Datetime of the event';

