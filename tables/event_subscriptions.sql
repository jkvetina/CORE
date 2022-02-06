--DROP TABLE event_subscriptions PURGE;
CREATE TABLE event_subscriptions (
    app_id              NUMBER(4)       CONSTRAINT nn_event_subscriptions_app_id        NOT NULL,
    event_id            VARCHAR2(30)    CONSTRAINT nn_event_subscriptions_event_id      NOT NULL,
    role_id             VARCHAR2(30)    CONSTRAINT nn_event_subscriptions_role_id       NOT NULL,
    --
    schedule_month      VARCHAR2(128),
    schedule_day        VARCHAR2(128),
    schedule_weekday    VARCHAR2(128),
    schedule_hour       VARCHAR2(128),
    schedule_minute     VARCHAR2(128),
    schedule_interval   VARCHAR2(128),
    --
    eval_function       VARCHAR2(64),
    is_active           CHAR(1),
    processed_log_id    NUMBER,
    --
    updated_by          VARCHAR2(30),
    updated_at          DATE,
    --
    CONSTRAINT pk_event_subscriptions
        PRIMARY KEY (app_id, event_id),
    --
    CONSTRAINT fk_event_subscriptions_role_id
        FOREIGN KEY (app_id, role_id)
        REFERENCES roles (app_id, role_id),
    --
    CONSTRAINT ch_event_subscriptions_month
        CHECK (REGEXP_LIKE(schedule_month,      '^(\d+,?\s*)+$') OR schedule_month IS NULL),
    --
    CONSTRAINT ch_event_subscriptions_day
        CHECK (REGEXP_LIKE(schedule_day,        '^(\d+,?\s*)+$') OR schedule_day IS NULL),
    --
    CONSTRAINT ch_event_subscriptions_weekday
        CHECK (REGEXP_LIKE(schedule_weekday,    '^(\d+,?\s*)+|(\d+[-]\d+)$') OR schedule_weekday IS NULL),
    --
    CONSTRAINT ch_event_subscriptions_hour
        CHECK (REGEXP_LIKE(schedule_hour,       '^(\d+,?\s*)+|(\d+[-]\d,?\s*)+$') OR schedule_hour IS NULL),
    --
    CONSTRAINT ch_event_subscriptions_minute
        CHECK (REGEXP_LIKE(schedule_minute,     '^(\d+,?\s*)+$') OR schedule_minute IS NULL),
    --
    CONSTRAINT ch_event_subscriptions_interval
        CHECK (REGEXP_LIKE(schedule_interval,   '^(\d+)$') OR schedule_interval IS NULL),
    --
    CONSTRAINT ch_event_subscriptions_is_active
        CHECK (is_active = 'Y' OR is_active IS NULL)
)
STORAGE (BUFFER_POOL KEEP);
--
COMMENT ON TABLE  event_subscriptions                       IS '[CORE] Subscriptions to events based on user roles';
--
COMMENT ON COLUMN event_subscriptions.app_id                IS 'APEX application ID';
COMMENT ON COLUMN event_subscriptions.event_id              IS 'Event id';
COMMENT ON COLUMN event_subscriptions.role_id               IS 'Role id receiving subscribed content';
COMMENT ON COLUMN event_subscriptions.schedule_month        IS 'Send at specific month, 1..12 for months, separate values with comma';
COMMENT ON COLUMN event_subscriptions.schedule_weekday      IS 'Send at specific day in a week, 1..7 (MON..SUN), 1-5 possible';
COMMENT ON COLUMN event_subscriptions.schedule_day          IS 'Send at specific dau of the month, 1..31';
COMMENT ON COLUMN event_subscriptions.schedule_hour         IS 'Send at specific hour, 00..23, 8-17 is possible';
COMMENT ON COLUMN event_subscriptions.schedule_minute       IS 'Send at specific minute in an hour, 00..59';
COMMENT ON COLUMN event_subscriptions.schedule_interval     IS 'Send every 1..30 minutes, schedule_minute is ignored';
COMMENT ON COLUMN event_subscriptions.eval_function         IS 'Function to evaluate if to really send and to whom';
COMMENT ON COLUMN event_subscriptions.is_active             IS 'Flag to disable tracking';
COMMENT ON COLUMN event_subscriptions.processed_log_id      IS 'Last log_events.log_id to mark processed logs';

