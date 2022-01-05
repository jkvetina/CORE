CREATE OR REPLACE PACKAGE a770 AS

    --
    -- Authorization roles for this app
    --
    FUNCTION is_mod_a_user
    RETURN CHAR;
    --
    FUNCTION is_administrator
    RETURN CHAR;



    --
    -- Create user (or not) on first login
    --
    PROCEDURE create_user (
        in_user_login           users.user_login%TYPE,
        in_user_id              users.user_id%TYPE
    );



    --
    -- Override ffor app.create_session
    --
    PROCEDURE create_session (
        in_user_login           users.user_login%TYPE,
        in_user_id              users.user_id%TYPE
    );



    --
    -- Override for app.exit_session
    --
    PROCEDURE exit_session;



    FUNCTION get_env_name
    RETURN VARCHAR2;

END;
/
