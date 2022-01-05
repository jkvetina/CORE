CREATE OR REPLACE PACKAGE BODY a770 AS

    FUNCTION is_mod_a_user
    RETURN CHAR AS
        is_valid                CHAR;
    BEGIN
        --is_valid := SUBSTR(sett.get_test_a(), 1, 1);

        IF app.is_developer() THEN
            RETURN 'Y';
        END IF;
        --
        SELECT 'Y' INTO is_valid
        FROM user_roles u
        JOIN roles r
            ON r.app_id         = u.app_id
            AND r.role_id       = u.role_id
        WHERE u.app_id          = app.get_app_id()
            AND u.user_id       = app.get_user_id()
            AND u.role_id       = app.get_caller_name()
            AND r.is_active     = 'Y';
        --
        RETURN is_valid;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'N';
    END;



    FUNCTION is_administrator
    RETURN CHAR AS
        is_valid                CHAR;
    BEGIN
        IF app.is_developer() THEN
            RETURN 'Y';
        END IF;
        --
        SELECT 'Y' INTO is_valid
        FROM user_roles u
        JOIN roles r
            ON r.app_id         = u.app_id
            AND r.role_id       = u.role_id
        WHERE u.app_id          = app.get_app_id()
            AND u.user_id       = app.get_user_id()
            AND u.role_id       = app.get_caller_name()
            AND r.is_active     = 'Y';
        --
        RETURN is_valid;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'N';
    END;



    PROCEDURE create_user (
        in_user_login           users.user_login%TYPE,
        in_user_id              users.user_id%TYPE
    ) AS
        PRAGMA AUTONOMOUS_TRANSACTION;
        --
        rec                     users%ROWTYPE;
    BEGIN
        app.log_module_json (
            'user_login',   in_user_login,
            'user_id',      in_user_id
        );
        --
        -- @TODO: app.create_user(rec)
        --
        rec.user_id         := in_user_id;
        rec.user_login      := in_user_login;
        rec.user_name       := NULL;
        rec.is_active       := 'Y';
        rec.updated_by      := app.get_user_id();
        rec.updated_at      := SYSDATE;
        --
        BEGIN
            INSERT INTO users VALUES rec;
        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            NULL;
        END;
        --
        /*
        BEGIN
            INSERT INTO user_roles (user_id, role_id, is_active, updated_by, updated_at)
            VALUES (
                in_user_id,
                'USER',
                'Y',
                in_user_name,
                SYSDATE
            );
        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            NULL;
        END;
        */
        --
        COMMIT;
        --
        app.log_success();
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
    END;



    PROCEDURE create_session (
        in_user_login           users.user_login%TYPE,
        in_user_id              users.user_id%TYPE
    )
    AS
    BEGIN
        --app.log_module();
        --
        IF app.get_page_id() = 9999 THEN    -- only for login page
            a770.create_user (
                in_user_login   => in_user_login,
                in_user_id      => in_user_id
            );
        END IF;
        --
        --app.log_success();
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
    END;



    PROCEDURE exit_session
    AS
    BEGIN
        --app.log_module();
        --
        NULL;
        --
        --app.log_success();
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
    END;

END;
/
