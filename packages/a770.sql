CREATE OR REPLACE PACKAGE BODY a770 AS

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

END;
/
