CREATE TABLE mail_subscriptions (
    app_id                          NUMBER(4,0)     CONSTRAINT nn_mail_subscriptions_app_id NOT NULL,
    event_id                        VARCHAR2(30)    CONSTRAINT nn_mail_subscriptions_event_id NOT NULL,
    role_id                         VARCHAR2(30)    CONSTRAINT nn_mail_subscriptions_role_id NOT NULL,
    schedule_id                     VARCHAR2(30)    CONSTRAINT nn_mail_subscriptions_schedule_id NOT NULL,
    template_id                     VARCHAR2(30)    CONSTRAINT nn_mail_subscriptions_template_id NOT NULL,
    eval_function                   VARCHAR2(64),
    is_active                       CHAR(1),
    processed_log_id                NUMBER,
    processed_at                    DATE,
    updated_by                      VARCHAR2(30),
    updated_at                      DATE,
    --
    CONSTRAINT ch_mail_subscriptions_is_active
        CHECK (is_active = 'Y' OR is_active IS NULL),
    --
    CONSTRAINT pk_mail_subscriptions
        PRIMARY KEY (app_id, event_id, role_id, schedule_id)
    --
    CONSTRAINT fk_mail_subscriptions_event_id
        FOREIGN KEY (app_id, event_id)
        REFERENCES events (app_id, event_id),
    --
    CONSTRAINT fk_mail_subscriptions_role_id
        FOREIGN KEY (app_id, role_id)
        REFERENCES roles (app_id, role_id),
    --
    CONSTRAINT fk_mail_subscriptions_schedule_id
        FOREIGN KEY (app_id, schedule_id)
        REFERENCES mail_schedules (app_id, schedule_id)
);
--
COMMENT ON TABLE mail_subscriptions IS '[CORE] Subscriptions to events based on user roles';
--
COMMENT ON COLUMN mail_subscriptions.app_id             IS 'APEX application ID';
COMMENT ON COLUMN mail_subscriptions.event_id           IS 'Event id';
COMMENT ON COLUMN mail_subscriptions.role_id            IS 'Role id receiving subscribed content';
COMMENT ON COLUMN mail_subscriptions.schedule_id        IS 'Schedule for timing the notification';
COMMENT ON COLUMN mail_subscriptions.template_id        IS 'Template used for notification';
COMMENT ON COLUMN mail_subscriptions.eval_function      IS 'Function to evaluate if to really send notification (and to whom)';
COMMENT ON COLUMN mail_subscriptions.is_active          IS 'Flag to disable tracking';
COMMENT ON COLUMN mail_subscriptions.processed_log_id   IS 'Last log_events.log_id to mark processed logs';
COMMENT ON COLUMN mail_subscriptions.processed_at       IS 'Last processing date (also for interval checks)';

