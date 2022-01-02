CREATE OR REPLACE TRIGGER apps__
FOR UPDATE OR INSERT OR DELETE ON apps
COMPOUND TRIGGER

    in_table_name           CONSTANT user_tables.table_name%TYPE := 'APPS';
    --
    curr_log_id             logs.log_id%TYPE;
    curr_event_id           log_events.log_id%TYPE;
    curr_updated_by         apps.updated_by%TYPE;
    curr_updated_at         apps.updated_at%TYPE;
    --
    rows_inserted           PLS_INTEGER := 0;
    rows_updated            PLS_INTEGER := 0;
    rows_deleted            PLS_INTEGER := 0;
    --
    deleted_app_id          apps.app_id%TYPE;
    --
    last_rowid              ROWID;



    BEFORE STATEMENT IS
    BEGIN
        curr_log_id         := app.log_trigger(in_table_name);
        curr_updated_by     := app.get_user_id();
        curr_updated_at     := SYSDATE;
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error('TRIGGER_FAILED', in_table_name);
    END BEFORE STATEMENT;



    BEFORE EACH ROW IS
    BEGIN
        IF NOT DELETING THEN
            :NEW.updated_by := curr_updated_by;
            :NEW.updated_at := curr_updated_at;
        END IF;
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error('TRIGGER_FAILED', in_table_name);
    END BEFORE EACH ROW;



    AFTER EACH ROW IS
        new_json    VARCHAR2(32767);
        old_json    VARCHAR2(32767);
    BEGIN
        IF INSERTING THEN
            rows_inserted       := rows_inserted + 1;
            last_rowid          := :NEW.ROWID;
        ELSIF UPDATING THEN
            rows_updated        := rows_updated + 1;
            last_rowid          := :OLD.ROWID;
        ELSIF DELETING THEN
            rows_deleted        := rows_deleted + 1;
            last_rowid          := :OLD.ROWID;
            --
            IF app.is_developer() THEN
                deleted_app_id := :OLD.app_id;
            END IF;
        END IF;
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error('TRIGGER_FAILED', in_table_name);
    END AFTER EACH ROW;



    AFTER STATEMENT IS
    BEGIN
        app.log_success (
            in_log_id               => curr_log_id,
            in_rows_inserted        => rows_inserted,
            in_rows_updated         => rows_updated,
            in_rows_deleted         => rows_deleted,
            in_last_rowid           => last_rowid
        );
        --
        IF rows_deleted > 0 AND deleted_app_id IS NOT NULL THEN
            DELETE FROM logs t
            WHERE t.app_id = deleted_app_id;
            --
            DELETE FROM logs_blacklist t
            WHERE t.app_id = deleted_app_id;
            --
            DELETE FROM log_events t
            WHERE t.app_id = deleted_app_id;
            --
            DELETE FROM events t
            WHERE t.app_id = deleted_app_id;
            --
            DELETE FROM sessions t
            WHERE t.app_id = deleted_app_id;
            --
            DELETE FROM navigation t
            WHERE t.app_id = deleted_app_id;
            --
            DELETE FROM user_roles t
            WHERE t.app_id = deleted_app_id;
            --
            DELETE FROM roles t
            WHERE t.app_id = deleted_app_id;
            --
            DELETE FROM setting_contexts t
            WHERE t.app_id = deleted_app_id;
            --
            DELETE FROM settings t
            WHERE t.app_id = deleted_app_id;
        END IF;
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error('TRIGGER_FAILED', in_table_name);
    END AFTER STATEMENT;

END;
/
