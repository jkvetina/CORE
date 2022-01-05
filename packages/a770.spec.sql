CREATE OR REPLACE PACKAGE a770 AS

    FUNCTION is_mod_a_user
    RETURN CHAR;



    FUNCTION is_administrator
    RETURN CHAR;



    PROCEDURE create_user (
        in_user_login           users.user_login%TYPE,
        in_user_id              users.user_id%TYPE
    );



    PROCEDURE create_session (
        in_user_login           users.user_login%TYPE,
        in_user_id              users.user_id%TYPE
    );



    PROCEDURE exit_session;



    FUNCTION get_page_name (
        in_page_name            apex_application_pages.page_name%TYPE
    )
    RETURN VARCHAR2;



    FUNCTION get_env_name
    RETURN VARCHAR2;

END;
/
