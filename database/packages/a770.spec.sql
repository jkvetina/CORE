CREATE OR REPLACE PACKAGE a770 AS

    /**
     * If you have an app with id 100 you should rename this package to a100.
     *
     * You should put auth roles specific to your app here.
     * And you can override some procedures from app package here.
     *
     */



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

END;
/

