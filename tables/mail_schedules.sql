--DROP TABLE mail_subscriptions PURGE;
--DROP TABLE mail_schedules PURGE;
CREATE TABLE mail_schedules (
    app_id              NUMBER(4)       CONSTRAINT nn_mail_schedules_app_id         NOT NULL,
    schedule_id         VARCHAR2(30)    CONSTRAINT nn_mail_schedules_schedule_id    NOT NULL,
    schedule_group      VARCHAR2(64),
    description_        VARCHAR2(256),
    --
    schedule_month      VARCHAR2(128),
    schedule_day        VARCHAR2(128),
    schedule_weekday    VARCHAR2(128),
    schedule_hour       VARCHAR2(128),
    schedule_minute     VARCHAR2(128),
    schedule_interval   VARCHAR2(128),
    --
    updated_by          VARCHAR2(30),
    updated_at          DATE,
    --
    CONSTRAINT pk_mail_schedules
        PRIMARY KEY (app_id, schedule_id),
    --
    CONSTRAINT ch_mail_schedules_month
        CHECK (REGEXP_LIKE(schedule_month,      '^(\d+,?\s*)+$') OR schedule_month IS NULL),
    --
    CONSTRAINT ch_mail_schedules_day
        CHECK (REGEXP_LIKE(schedule_day,        '^(\d+,?\s*)+$') OR schedule_day IS NULL),
    --
    CONSTRAINT ch_mail_schedules_weekday
        CHECK (REGEXP_LIKE(schedule_weekday,    '^(\d+,?\s*)+|(\d+[-]\d+)$') OR schedule_weekday IS NULL),
    --
    CONSTRAINT ch_mail_schedules_hour
        CHECK (REGEXP_LIKE(schedule_hour,       '^(\d+,?\s*)+|(\d+[-]\d,?\s*)+$') OR schedule_hour IS NULL),
    --
    CONSTRAINT ch_mail_schedules_minute
        CHECK (REGEXP_LIKE(schedule_minute,     '^(\d+,?\s*)+$') OR schedule_minute IS NULL),
    --
    CONSTRAINT ch_mail_schedules_interval
        CHECK (REGEXP_LIKE(schedule_interval,   '^(\d+)$') OR schedule_interval IS NULL)
);
--
COMMENT ON TABLE  mail_schedules                        IS '[CORE] mail_schedules...';
--
COMMENT ON COLUMN mail_schedules.app_id                 IS 'APEX application ID';
COMMENT ON COLUMN mail_schedules.schedule_id            IS 'Schedule id';
COMMENT ON COLUMN mail_schedules.schedule_group         IS 'Group for better visibility';
COMMENT ON COLUMN mail_schedules.description_           IS 'Description';
COMMENT ON COLUMN mail_schedules.schedule_month         IS 'Send at specific month, 1..12 for months, separate values with comma';
COMMENT ON COLUMN mail_schedules.schedule_weekday       IS 'Send at specific day in a week, 1..7 (MON..SUN), 1-5 possible';
COMMENT ON COLUMN mail_schedules.schedule_day           IS 'Send at specific day of the month, 1..31';
COMMENT ON COLUMN mail_schedules.schedule_hour          IS 'Send at specific hour, 00..23, 8-17 is possible';
COMMENT ON COLUMN mail_schedules.schedule_minute        IS 'Send at specific minute in an hour, 00..59';
COMMENT ON COLUMN mail_schedules.schedule_interval      IS 'Send every 1..30 minutes, schedule_minute is ignored';

