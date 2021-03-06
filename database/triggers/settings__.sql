CREATE OR REPLACE TRIGGER settings__
FOR UPDATE OR INSERT OR DELETE ON settings
COMPOUND TRIGGER

    in_table_name           CONSTANT user_tables.table_name%TYPE := 'SETTINGS';
    --
    curr_log_id             logs.log_id%TYPE;
    curr_updated_by         settings.updated_by%TYPE;
    curr_updated_at         settings.updated_at%TYPE;
    --
    rows_inserted           PLS_INTEGER := 0;
    rows_updated            PLS_INTEGER := 0;
    rows_deleted            PLS_INTEGER := 0;
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

            -- check name
            IF NOT REGEXP_LIKE(:NEW.setting_name, '^[A-Z0-9_]{1,' || TO_CHAR(30 - NVL(LENGTH(constants.get_settings_prefix()), 0)) || '}$') THEN
                app.raise_error('WRONG_NAME', :NEW.setting_name);
            END IF;

            -- check date value
            IF :NEW.is_date = 'Y' THEN
                BEGIN
                    :NEW.setting_value := app.get_date(app.get_date(:NEW.setting_value));
                EXCEPTION
                WHEN OTHERS THEN
                    app.raise_error('WRONG_DATE');
                END;
            END IF;

            -- check numeric value
            IF :NEW.is_numeric = 'Y' THEN
                BEGIN
                    :NEW.setting_value := TO_NUMBER(REPLACE(:NEW.setting_value, ',', '.'));
                EXCEPTION
                WHEN OTHERS THEN
                    app.raise_error('WRONG_NUMBER');
                END;
            END IF;
        END IF;
        --
        app.log_event('SETTINGS_CHANGED');
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
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error('TRIGGER_FAILED', in_table_name);
    END AFTER STATEMENT;

END;
/

