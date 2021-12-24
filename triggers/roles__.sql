CREATE OR REPLACE TRIGGER roles__
FOR UPDATE OR INSERT OR DELETE ON roles
COMPOUND TRIGGER

    in_table_name           CONSTANT user_tables.table_name%TYPE := 'ROLES';
    --
    curr_log_id             logs.log_id%TYPE;
    curr_event_id           logs_events.log_id%TYPE;
    curr_updated_by         roles.updated_by%TYPE;
    curr_updated_at         roles.updated_at%TYPE;
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
            --
            IF UPDATING AND :NEW.role_id != :OLD.role_id THEN
                UPDATE user_roles u
                SET u.role_id       = :NEW.role_id
                WHERE u.app_id      = :OLD.app_id
                    AND u.role_id   = :OLD.role_id;
                --
                curr_event_id := app.log_event('ROLE_ID_CHANGED');
            END IF;
        ELSE
            DELETE FROM user_roles u
            WHERE u.app_id      = :OLD.app_id
                AND u.role_id   = :OLD.role_id;
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
