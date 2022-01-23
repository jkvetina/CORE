CREATE OR REPLACE PACKAGE app AS

    /**
     * This package is part of the APP CORE project under MIT licence.
     * https://github.com/jkvetina/#core
     *
     * Copyright (c) Jan Kvetina, 2021
     *
     *                                                      (R)
     *                      ---                  ---
     *                    #@@@@@@              &@@@@@@
     *                    @@@@@@@@     .@      @@@@@@@@
     *          -----      @@@@@@    @@@@@@,   @@@@@@@      -----
     *       &@@@@@@@@@@@    @@@   &@@@@@@@@@.  @@@@   .@@@@@@@@@@@#
     *           @@@@@@@@@@@   @  @@@@@@@@@@@@@  @   @@@@@@@@@@@
     *             \@@@@@@@@@@   @@@@@@@@@@@@@@@   @@@@@@@@@@
     *               @@@@@@@@@   @@@@@@@@@@@@@@@  &@@@@@@@@
     *                 @@@@@@@(  @@@@@@@@@@@@@@@  @@@@@@@@
     *                  @@@@@@(  @@@@@@@@@@@@@@,  @@@@@@@
     *                  .@@@@@,   @@@@@@@@@@@@@   @@@@@@
     *                   @@@@@@  *@@@@@@@@@@@@@   @@@@@@
     *                   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.
     *                    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
     *                    @@@@@@@@@@@@@@@@@@@@@@@@@@@@
     *                     .@@@@@@@@@@@@@@@@@@@@@@@@@
     *                       .@@@@@@@@@@@@@@@@@@@@@
     *                            jankvetina.cz
     *                               -------
     *
     */

    schema_owner                CONSTANT VARCHAR2(30)           := 'CORE';
    schema_apex                 CONSTANT VARCHAR2(30)           := 'APEX_210100';
    --
    core_app_id                 CONSTANT sessions.app_id%TYPE   := 770;  -- for sharing pages between apps

    -- code for app exception
    app_exception_code          CONSTANT PLS_INTEGER            := -20000;
    app_exception               EXCEPTION;
    --
    PRAGMA EXCEPTION_INIT(app_exception, app_exception_code);   -- as a side effect this will disable listing constants in tree on the left

    -- internal date formats
    format_date                 CONSTANT VARCHAR2(30)           := 'YYYY-MM-DD';
    format_date_time            CONSTANT VARCHAR2(30)           := 'YYYY-MM-DD HH24:MI:SS';
    format_date_short           CONSTANT VARCHAR2(30)           := 'YYYY-MM-DD HH24:MI';

    -- anonymous user used on login pages in APEX
    anonymous_user              CONSTANT VARCHAR2(30)           := 'NOBODY';  -- ORDS_PUBLIC_USER, APEX_APP.G_PUBLIC

    -- flags
    flag_request                CONSTANT logs.flag%TYPE         := 'P';     -- APEX request (page rendering, form processing)
    flag_module                 CONSTANT logs.flag%TYPE         := 'M';     -- start of any module (procedure/function)
    flag_action                 CONSTANT logs.flag%TYPE         := 'A';     -- start of any APEX action
    flag_debug                  CONSTANT logs.flag%TYPE         := 'D';     -- debug
    flag_result                 CONSTANT logs.flag%TYPE         := 'R';     -- result of procedure for debugging purposes
    flag_warning                CONSTANT logs.flag%TYPE         := 'W';     -- warning
    flag_error                  CONSTANT logs.flag%TYPE         := 'E';     -- error
    flag_longops                CONSTANT logs.flag%TYPE         := 'L';     -- longops operation
    flag_scheduler              CONSTANT logs.flag%TYPE         := 'S';     -- scheduler planned
    flag_trigger                CONSTANT logs.flag%TYPE         := 'G';     -- called from trigger

    -- specify maximum length for trim
    length_user                 CONSTANT PLS_INTEGER            := 30;      -- logs.user_id%TYPE
    length_action               CONSTANT PLS_INTEGER            := 32;      -- logs.action_name%TYPE
    length_module               CONSTANT PLS_INTEGER            := 48;      -- logs.module_name%TYPE
    length_arguments            CONSTANT PLS_INTEGER            := 2000;    -- logs.arguments%TYPE
    length_payload              CONSTANT PLS_INTEGER            := 4000;    -- logs.payload%TYPE

    -- append callstack for these flags
    track_callstack             CONSTANT VARCHAR2(30)           := flag_error || flag_warning || flag_module || flag_request || flag_trigger;

    -- transform $NAME to P500_NAME if current page_id = 500
    page_item_wild              CONSTANT VARCHAR2(4)            := '$';
    page_item_prefix            CONSTANT VARCHAR2(4)            := 'P';

    -- name of AUTH package
    auth_package                CONSTANT VARCHAR2(30)           := 'AUTH';
    auth_page_id_arg            CONSTANT VARCHAR2(30)           := 'IN_PAGE_ID';

    -- error log table name and max age fo records
    logs_table_name             CONSTANT VARCHAR2(30)           := 'LOGS';      -- used in purge_old
    logs_max_age                CONSTANT PLS_INTEGER            := 7;           -- max logs age in days

    -- arrays to specify adhoc requests
    TYPE arr_log_setup          IS VARRAY(100) OF logs_blacklist%ROWTYPE;

    -- list/array of log_id
    TYPE arr_logs_log_id IS
        TABLE OF logs.log_id%TYPE
        INDEX BY PLS_INTEGER;

    -- array to hold recent log_id based on callstack_hash
    TYPE arr_map_tree IS
        TABLE OF logs.log_id%TYPE
        INDEX BY VARCHAR2(40);







    -- ### User section
    --

    --
    -- Returns APEX application id (for proxy app)
    --
    FUNCTION get_app_id
    RETURN sessions.app_id%TYPE;



    --
    -- When using multiple apps in same workspace/schema return the real application id
    --
    FUNCTION get_real_app_id
    RETURN sessions.app_id%TYPE;



    --
    --
    --
    FUNCTION get_core_app_id
    RETURN sessions.app_id%TYPE;



    --
    -- Returns current user id (APEX, SYS_CONTEXT, DB...)
    --
    FUNCTION get_user_id
    RETURN users.user_id%TYPE;



    --
    -- Convert user_login to user_id
    --
    FUNCTION get_user_id (
        in_user_login           users.user_login%TYPE
    )
    RETURN users.user_id%TYPE;



    --
    -- Set (shorten) user_id after authentification
    --
    PROCEDURE set_user_id
    ACCESSIBLE BY (
        PACKAGE app,
        PACKAGE app_ut
    );



    --
    -- Get user name
    --
    FUNCTION get_user_name (
        in_user_id              users.user_id%TYPE          := NULL
    )
    RETURN users.user_name%TYPE;



    --
    -- Get user login
    --
    FUNCTION get_user_login (
        in_user_id              users.user_id%TYPE          := NULL
    )
    RETURN users.user_login%TYPE;



    --
    -- Get user language
    --
    FUNCTION get_user_lang
    RETURN users.lang_id%TYPE;



    --
    --
    --
    FUNCTION is_active_user (
        in_user_id              users.user_id%TYPE          := NULL
    )
    RETURN BOOLEAN;



    --
    --
    --
    FUNCTION is_active_user_y (
        in_user_id              users.user_id%TYPE          := NULL
    )
    RETURN CHAR;



    --
    -- Check if current/requested user is APEX developer
    --
    FUNCTION is_developer (
        in_user                 users.user_login%TYPE       := NULL
    )
    RETURN BOOLEAN;



    --
    -- Same but usable in SQL
    --
    FUNCTION is_developer_y (
        in_user                 users.user_login%TYPE       := NULL
    )
    RETURN CHAR;



    --
    -- Check if DEBUG is on
    --
    FUNCTION is_debug_on
    RETURN BOOLEAN;



    --
    -- Return current owner (because APEX dont like using USER)
    --
    FUNCTION get_owner (
        in_app_id               apps.app_id%TYPE            := NULL
    )
    RETURN apex_applications.owner%TYPE;







    -- ### Session management
    --

    --
    -- Create session from APEX
    --
    PROCEDURE create_session;



    --
    -- Create session outside of APEX (from console, trigger, job...)
    --
    PROCEDURE create_session (
        in_user_id              sessions.user_id%TYPE,
        in_app_id               sessions.app_id%TYPE,
        in_page_id              navigation.page_id%TYPE     := NULL,
        in_session_id           sessions.session_id%TYPE    := NULL,
        in_items                VARCHAR2                    := NULL
    );



    --
    -- Clear session at the end
    --
    PROCEDURE exit_session;



    --
    -- Delete logs for requested session
    --
    PROCEDURE delete_session (
        in_session_id           sessions.session_id%TYPE
    );



    --
    -- Update DBMS_SESSION and DBMS_APPLICATION_INFO with current module and action
    --
    PROCEDURE set_session (
        in_module_name          logs.module_name%TYPE,
        in_action_name          logs.action_name%TYPE,
        in_log_id               logs.log_id%TYPE            := NULL
    );



    --
    -- Returns APEX session id
    --
    FUNCTION get_session_id
    RETURN sessions.session_id%TYPE;



    --
    -- Returns client_id for DBMS_SESSION
    --
    FUNCTION get_client_id (
        in_user_id              sessions.user_id%TYPE       := NULL
    )
    RETURN VARCHAR2;



    --
    -- Get env name
    --
    FUNCTION get_env_name
    RETURN VARCHAR2;



    --
    -- Get role name
    --
    FUNCTION get_role_name (
        in_role_id              roles.role_id%TYPE
    )
    RETURN roles.role_name%TYPE;







    -- ### Pages and requests
    --

    --
    -- Returns APEX page id
    --
    FUNCTION get_page_id
    RETURN navigation.page_id%TYPE;



    --
    -- Returns APEX page group name for requested or current page
    --
    FUNCTION get_page_group (
        in_page_id              navigation.page_id%TYPE     := NULL,
        in_app_id               navigation.app_id%TYPE      := NULL
    )
    RETURN apex_application_pages.page_group%TYPE;



    --
    -- Returns root page ID for requested or current page
    --
    FUNCTION get_page_root (
        in_page_id              navigation.page_id%TYPE     := NULL,
        in_app_id               navigation.app_id%TYPE      := NULL
    )
    RETURN navigation.page_id%TYPE;



    --
    -- Returns parent page ID for requested or current page
    --
    FUNCTION get_page_parent (
        in_page_id              navigation.page_id%TYPE     := NULL,
        in_app_id               navigation.app_id%TYPE      := NULL
    )
    RETURN navigation.page_id%TYPE;



    --
    -- Get page name from APEX dictionary
    --
    FUNCTION get_page_name (
        in_page_id              navigation.page_id%TYPE     := NULL,
        in_app_id               navigation.app_id%TYPE      := NULL,
        in_name                 VARCHAR2                    := NULL
    )
    RETURN VARCHAR2;



    --
    -- Get link to page with items
    --
    FUNCTION get_page_link (
        in_page_id              navigation.page_id%TYPE     := NULL,
        in_app_id               navigation.app_id%TYPE      := NULL,
        in_names                VARCHAR2                    := NULL,
        in_values               VARCHAR2                    := NULL,
        in_overload             VARCHAR2                    := NULL,    -- JSON object to overload passed items/values
        in_transform            BOOLEAN                     := FALSE,   -- to pass all page items to new page
        in_reset                BOOLEAN                     := TRUE,    -- reset page items
        in_session_id           sessions.session_id%TYPE    := NULL
    )
    RETURN VARCHAR2;



    --
    -- Returns requested URL
    --
    FUNCTION get_request_url
    RETURN VARCHAR2;



    --
    -- Returns request (APEX button) name
    --
    FUNCTION get_request
    RETURN VARCHAR2;



    --
    -- Get icon as a <span>
    --
    FUNCTION get_icon (
        in_name                 VARCHAR2,
        in_title                VARCHAR2    := NULL
    )
    RETURN VARCHAR2;







    -- ### Navigation
    --

    --
    -- Check if user have permissions to access the page
    --
    FUNCTION is_page_available (
        in_page_id              navigation.page_id%TYPE,
        in_app_id               navigation.app_id%TYPE          := NULL
    )
    RETURN CHAR;



    --
    -- Check if page should be visible in navigation
    --
    FUNCTION is_page_visible (
        in_page_id              navigation.page_id%TYPE,
        in_app_id               navigation.app_id%TYPE          := NULL
    )
    RETURN CHAR;



    --
    -- Redirect to page and set items if needed
    --
    PROCEDURE redirect (
        in_page_id              NUMBER          := NULL,
        in_names                VARCHAR2        := NULL,
        in_values               VARCHAR2        := NULL,
        in_overload             VARCHAR2        := NULL,    -- JSON object to overload passed items/values
        in_transform            BOOLEAN         := FALSE,   -- to pass all page items to new page
        in_reset                BOOLEAN         := TRUE     -- reset page items
    );







    -- ### Functions to work with APEX items
    --

    --
    -- Get name of item and check if it is valid
    --
    FUNCTION get_item_name (
        in_name                 VARCHAR2
    )
    RETURN VARCHAR2;



    --
    -- Get (global and page) item
    --
    FUNCTION get_item (
        in_name                 VARCHAR2,
        in_raise                BOOLEAN         := FALSE
    )
    RETURN VARCHAR2;



    --
    -- Get item as NUMBER type
    --
    FUNCTION get_number_item (
        in_name                 VARCHAR2,
        in_raise                BOOLEAN         := FALSE
    )
    RETURN NUMBER;



    --
    -- Get item as DATE type
    --
    FUNCTION get_date_item (
        in_name                 VARCHAR2,
        in_format               VARCHAR2        := NULL,
        in_raise                BOOLEAN         := FALSE
    )
    RETURN DATE;



    --
    -- Convert various date formats passed by APEX when submitting forms
    --
    FUNCTION get_date (
        in_value                VARCHAR2,
        in_format               VARCHAR2        := NULL
    )
    RETURN DATE;



    --
    --
    --
    FUNCTION get_date (
        in_date                 DATE            := NULL,
        in_format               VARCHAR2        := NULL
    )
    RETURN VARCHAR2;



    --
    --
    --
    FUNCTION get_date_time (
        in_date                 DATE            := NULL,
        in_format               VARCHAR2        := NULL
    )
    RETURN VARCHAR2;



    --
    -- Convert date or timestamp into time bucket
    --
    FUNCTION get_time_bucket (
        in_date                 DATE,
        in_interval             NUMBER
    )
    RETURN NUMBER
    RESULT_CACHE;



    --
    -- Convert interval to human readable form
    --
    FUNCTION get_duration (
        in_interval             INTERVAL DAY TO SECOND
    )
    RETURN VARCHAR2;



    --
    -- Convert interval to human readable form
    --
    FUNCTION get_duration (
        in_interval             NUMBER
    )
    RETURN VARCHAR2;



    --
    -- Calculate human readable difference within two timestamps
    --
    FUNCTION get_duration (
        in_start                TIMESTAMP,
        in_end                  TIMESTAMP       := NULL
    )
    RETURN VARCHAR2;



    --
    -- Set item
    --
    PROCEDURE set_item (
        in_name                 VARCHAR2,
        in_value                VARCHAR2        := NULL,
        in_raise                BOOLEAN         := TRUE
    );



    --
    -- Set item from DATE type
    --
    PROCEDURE set_date_item (
        in_name                 VARCHAR2,
        in_value                DATE,
        in_raise                BOOLEAN         := TRUE
    );



    --
    -- Clear page items except items passed in url
    --
    PROCEDURE clear_items;



    --
    -- Get items for selected/current page as JSON object
    --
    FUNCTION get_page_items (
        in_page_id              logs.page_id%TYPE       := NULL,
        in_filter               logs.arguments%TYPE     := '%'
    )
    RETURN VARCHAR2;



    --
    -- Get global (app) items as JSON object
    --
    FUNCTION get_global_items (
        in_filter               logs.arguments%TYPE     := '%'
    )
    RETURN VARCHAR2;



    --
    -- Apply values from JSON object keys to items
    --
    PROCEDURE apply_items (
        in_items                VARCHAR2
    );







    -- ### Logging
    --

    --
    -- Convert passed arguments to JSON list/array
    --
    FUNCTION get_json_list (
        in_arg1                 VARCHAR2    := NULL,
        in_arg2                 VARCHAR2    := NULL,
        in_arg3                 VARCHAR2    := NULL,
        in_arg4                 VARCHAR2    := NULL,
        in_arg5                 VARCHAR2    := NULL,
        in_arg6                 VARCHAR2    := NULL,
        in_arg7                 VARCHAR2    := NULL,
        in_arg8                 VARCHAR2    := NULL
    )
    RETURN VARCHAR2;



    --
    -- Convert passed arguments to JSON object as key/value pairs
    --
    FUNCTION get_json_object (
        in_name1                VARCHAR2    := NULL,
        in_value1               VARCHAR2    := NULL,
        in_name2                VARCHAR2    := NULL,
        in_value2               VARCHAR2    := NULL,
        in_name3                VARCHAR2    := NULL,
        in_value3               VARCHAR2    := NULL,
        in_name4                VARCHAR2    := NULL,
        in_value4               VARCHAR2    := NULL,
        in_name5                VARCHAR2    := NULL,
        in_value5               VARCHAR2    := NULL,
        in_name6                VARCHAR2    := NULL,
        in_value6               VARCHAR2    := NULL,
        in_name7                VARCHAR2    := NULL,
        in_value7               VARCHAR2    := NULL,
        in_name8                VARCHAR2    := NULL,
        in_value8               VARCHAR2    := NULL
    )
    RETURN VARCHAR2;



    --
    -- Main function called from APEX VPD init to track page requests
    -- Returned log_id is used as a parent for all subsequent calls
    --
    FUNCTION log_request
    RETURN logs.log_id%TYPE;



    --
    -- Function called at the very start of every procedure or function
    --
    FUNCTION log_module (
        in_arg1                 logs.arguments%TYPE     := NULL,
        in_arg2                 logs.arguments%TYPE     := NULL,
        in_arg3                 logs.arguments%TYPE     := NULL,
        in_arg4                 logs.arguments%TYPE     := NULL,
        in_arg5                 logs.arguments%TYPE     := NULL,
        in_arg6                 logs.arguments%TYPE     := NULL,
        in_arg7                 logs.arguments%TYPE     := NULL,
        in_arg8                 logs.arguments%TYPE     := NULL,
        --
        in_parent_id            logs.log_parent%TYPE    := NULL,
        in_payload              logs.payload%TYPE       := NULL
    )
    RETURN logs.log_id%TYPE;



    --
    -- ^
    --
    PROCEDURE log_module (
        in_arg1                 logs.arguments%TYPE     := NULL,
        in_arg2                 logs.arguments%TYPE     := NULL,
        in_arg3                 logs.arguments%TYPE     := NULL,
        in_arg4                 logs.arguments%TYPE     := NULL,
        in_arg5                 logs.arguments%TYPE     := NULL,
        in_arg6                 logs.arguments%TYPE     := NULL,
        in_arg7                 logs.arguments%TYPE     := NULL,
        in_arg8                 logs.arguments%TYPE     := NULL,
        --
        in_parent_id            logs.log_parent%TYPE    := NULL,
        in_payload              logs.payload%TYPE       := NULL
    );



    --
    -- Same as log_module function but args are stored as JSON object
    --
    FUNCTION log_module_json (
        in_name1                logs.arguments%TYPE     := NULL,        in_value1   logs.arguments%TYPE     := NULL,
        in_name2                logs.arguments%TYPE     := NULL,        in_value2   logs.arguments%TYPE     := NULL,
        in_name3                logs.arguments%TYPE     := NULL,        in_value3   logs.arguments%TYPE     := NULL,
        in_name4                logs.arguments%TYPE     := NULL,        in_value4   logs.arguments%TYPE     := NULL,
        in_name5                logs.arguments%TYPE     := NULL,        in_value5   logs.arguments%TYPE     := NULL,
        in_name6                logs.arguments%TYPE     := NULL,        in_value6   logs.arguments%TYPE     := NULL,
        in_name7                logs.arguments%TYPE     := NULL,        in_value7   logs.arguments%TYPE     := NULL,
        in_name8                logs.arguments%TYPE     := NULL,        in_value8   logs.arguments%TYPE     := NULL,
        --
        in_parent_id            logs.log_parent%TYPE    := NULL,
        in_payload              logs.payload%TYPE       := NULL
    )
    RETURN logs.log_id%TYPE;



    --
    -- ^
    --
    PROCEDURE log_module_json (
        in_name1                logs.arguments%TYPE     := NULL,        in_value1   logs.arguments%TYPE     := NULL,
        in_name2                logs.arguments%TYPE     := NULL,        in_value2   logs.arguments%TYPE     := NULL,
        in_name3                logs.arguments%TYPE     := NULL,        in_value3   logs.arguments%TYPE     := NULL,
        in_name4                logs.arguments%TYPE     := NULL,        in_value4   logs.arguments%TYPE     := NULL,
        in_name5                logs.arguments%TYPE     := NULL,        in_value5   logs.arguments%TYPE     := NULL,
        in_name6                logs.arguments%TYPE     := NULL,        in_value6   logs.arguments%TYPE     := NULL,
        in_name7                logs.arguments%TYPE     := NULL,        in_value7   logs.arguments%TYPE     := NULL,
        in_name8                logs.arguments%TYPE     := NULL,        in_value8   logs.arguments%TYPE     := NULL,
        --
        in_parent_id            logs.log_parent%TYPE    := NULL,
        in_payload              logs.payload%TYPE       := NULL
    );



    --
    -- Same as log_module but with action_name, designated for APEX calls
    --
    FUNCTION log_action (
        in_action_name          logs.action_name%TYPE,
        --
        in_arg1                 logs.arguments%TYPE     := NULL,
        in_arg2                 logs.arguments%TYPE     := NULL,
        in_arg3                 logs.arguments%TYPE     := NULL,
        in_arg4                 logs.arguments%TYPE     := NULL,
        in_arg5                 logs.arguments%TYPE     := NULL,
        in_arg6                 logs.arguments%TYPE     := NULL,
        in_arg7                 logs.arguments%TYPE     := NULL,
        in_arg8                 logs.arguments%TYPE     := NULL,
        --
        in_parent_id            logs.log_parent%TYPE    := NULL,
        in_payload              logs.payload%TYPE       := NULL
    )
    RETURN logs.log_id%TYPE;



    --
    -- ^
    --
    PROCEDURE log_action (
        in_action_name          logs.action_name%TYPE,
        --
        in_arg1                 logs.arguments%TYPE     := NULL,
        in_arg2                 logs.arguments%TYPE     := NULL,
        in_arg3                 logs.arguments%TYPE     := NULL,
        in_arg4                 logs.arguments%TYPE     := NULL,
        in_arg5                 logs.arguments%TYPE     := NULL,
        in_arg6                 logs.arguments%TYPE     := NULL,
        in_arg7                 logs.arguments%TYPE     := NULL,
        in_arg8                 logs.arguments%TYPE     := NULL,
        --
        in_parent_id            logs.log_parent%TYPE    := NULL,
        in_payload              logs.payload%TYPE       := NULL
    );



    --
    -- Store record in log with D flag
    --
    PROCEDURE log_debug (
        in_arg1                 logs.arguments%TYPE     := NULL,
        in_arg2                 logs.arguments%TYPE     := NULL,
        in_arg3                 logs.arguments%TYPE     := NULL,
        in_arg4                 logs.arguments%TYPE     := NULL,
        in_arg5                 logs.arguments%TYPE     := NULL,
        in_arg6                 logs.arguments%TYPE     := NULL,
        in_arg7                 logs.arguments%TYPE     := NULL,
        in_arg8                 logs.arguments%TYPE     := NULL,
        --
        in_parent_id            logs.log_parent%TYPE    := NULL,
        in_payload              logs.payload%TYPE       := NULL
    );



    --
    -- Store record in log with R flag
    --
    PROCEDURE log_result (
        in_arg1                 logs.arguments%TYPE     := NULL,
        in_arg2                 logs.arguments%TYPE     := NULL,
        in_arg3                 logs.arguments%TYPE     := NULL,
        in_arg4                 logs.arguments%TYPE     := NULL,
        in_arg5                 logs.arguments%TYPE     := NULL,
        in_arg6                 logs.arguments%TYPE     := NULL,
        in_arg7                 logs.arguments%TYPE     := NULL,
        in_arg8                 logs.arguments%TYPE     := NULL,
        --
        in_parent_id            logs.log_parent%TYPE    := NULL,
        in_payload              logs.payload%TYPE       := NULL
    );



    --
    -- Store record in log with W flag; pass action_name
    --
    PROCEDURE log_warning (
        in_action_name          logs.action_name%TYPE,
        --
        in_arg1                 logs.arguments%TYPE     := NULL,
        in_arg2                 logs.arguments%TYPE     := NULL,
        in_arg3                 logs.arguments%TYPE     := NULL,
        in_arg4                 logs.arguments%TYPE     := NULL,
        in_arg5                 logs.arguments%TYPE     := NULL,
        in_arg6                 logs.arguments%TYPE     := NULL,
        in_arg7                 logs.arguments%TYPE     := NULL,
        in_arg8                 logs.arguments%TYPE     := NULL,
        --
        in_parent_id            logs.log_parent%TYPE    := NULL,
        in_payload              logs.payload%TYPE       := NULL
    );



    --
    -- Store record in log with E flag; pass action_name
    --
    FUNCTION log_error (
        in_action_name          logs.action_name%TYPE   := NULL,
        --
        in_arg1                 logs.arguments%TYPE     := NULL,
        in_arg2                 logs.arguments%TYPE     := NULL,
        in_arg3                 logs.arguments%TYPE     := NULL,
        in_arg4                 logs.arguments%TYPE     := NULL,
        in_arg5                 logs.arguments%TYPE     := NULL,
        in_arg6                 logs.arguments%TYPE     := NULL,
        in_arg7                 logs.arguments%TYPE     := NULL,
        in_arg8                 logs.arguments%TYPE     := NULL,
        --
        in_parent_id            logs.log_parent%TYPE    := NULL,
        in_payload              logs.payload%TYPE       := NULL
    )
    RETURN logs.log_id%TYPE;



    --
    -- ^
    --
    PROCEDURE log_error (
        in_action_name          logs.action_name%TYPE   := NULL,
        --
        in_arg1                 logs.arguments%TYPE     := NULL,
        in_arg2                 logs.arguments%TYPE     := NULL,
        in_arg3                 logs.arguments%TYPE     := NULL,
        in_arg4                 logs.arguments%TYPE     := NULL,
        in_arg5                 logs.arguments%TYPE     := NULL,
        in_arg6                 logs.arguments%TYPE     := NULL,
        in_arg7                 logs.arguments%TYPE     := NULL,
        in_arg8                 logs.arguments%TYPE     := NULL,
        --
        in_parent_id            logs.log_parent%TYPE    := NULL,
        in_payload              logs.payload%TYPE       := NULL
    );



    --
    -- Update logs.timer for current/requested record
    --
    PROCEDURE log_success (
        in_log_id               logs.log_id%TYPE        := NULL,
        in_action_name          logs.action_name%TYPE   := NULL,
        in_payload              logs.payload%TYPE       := NULL
    );



    --
    -- Update logs.arguments for triggers so we can have module line with results
    --
    PROCEDURE log_success (
        in_log_id               logs.log_id%TYPE,
        in_rows_inserted        NUMBER,
        in_rows_updated         NUMBER,
        in_rows_deleted         NUMBER,
        in_last_rowid           VARCHAR2                := NULL,
        in_payload              logs.payload%TYPE       := NULL
    );



    --
    -- Same as log_module but designated for triggers
    --
    FUNCTION log_trigger (
        in_action_name          logs.action_name%TYPE   := NULL,
        --
        in_arg1                 logs.arguments%TYPE     := NULL,
        in_arg2                 logs.arguments%TYPE     := NULL,
        in_arg3                 logs.arguments%TYPE     := NULL,
        in_arg4                 logs.arguments%TYPE     := NULL,
        in_arg5                 logs.arguments%TYPE     := NULL,
        in_arg6                 logs.arguments%TYPE     := NULL,
        in_arg7                 logs.arguments%TYPE     := NULL,
        in_arg8                 logs.arguments%TYPE     := NULL,
        --
        in_parent_id            logs.log_parent%TYPE    := NULL,
        in_payload              logs.payload%TYPE       := NULL
    )
    RETURN logs.log_id%TYPE;



    --
    -- Update/track progress for LONGOPS
    --
    PROCEDURE log_progress (
        in_action_name          logs.action_name%TYPE           := NULL,
        in_progress             NUMBER                          := NULL,  -- percentage (1 = 100%)
        in_note                 VARCHAR2                        := NULL,
        in_parent_id            logs.log_id%TYPE                := NULL
    );



    --
    -- Log business event
    --
    FUNCTION log_event (
        in_event_id             log_events.event_id%TYPE,
        in_event_value          log_events.event_value%TYPE     := NULL,
        in_parent_id            logs.log_parent%TYPE            := NULL
    )
    RETURN log_events.log_id%TYPE;



    --
    -- Log business event
    --
    PROCEDURE log_event (
        in_event_id             log_events.event_id%TYPE,
        in_event_value          log_events.event_value%TYPE     := NULL
    );



    --
    -- Link one time scheduled jobs to specific log record (user)
    --
    PROCEDURE log_scheduler (
        in_log_id               logs.log_id%TYPE,
        in_job_name             VARCHAR2
    );



    --
    -- Proper way how to schedule one time jobs
    --
    PROCEDURE create_one_time_job (
        in_job_name         VARCHAR2,
        in_statement        VARCHAR2            := NULL,
        in_comments         VARCHAR2            := NULL,
        in_priority         PLS_INTEGER         := NULL
    );



    --
    -- Internal function which creates records in logs table; returns assigned log_id
    --
    FUNCTION log__ (
        in_flag                 logs.flag%TYPE,
        in_module_name          logs.module_name%TYPE       := NULL,
        in_module_line          logs.module_line%TYPE       := NULL,
        in_action_name          logs.action_name%TYPE       := NULL,
        in_arguments            logs.arguments%TYPE         := NULL,
        in_payload              logs.payload%TYPE           := NULL,
        in_parent_id            logs.log_parent%TYPE        := NULL,
        in_app_id               logs.app_id%TYPE            := NULL,
        in_page_id              logs.page_id%TYPE           := NULL,
        in_user_id              logs.user_id%TYPE           := NULL,
        in_session_id           logs.session_id%TYPE        := NULL
    )
    RETURN logs.log_id%TYPE;



    --
    -- Check if we log current record or not
    --
    FUNCTION is_blacklisted (
        in_row                  logs%ROWTYPE
    )
    RETURN BOOLEAN;



    --
    -- Log error and RAISE app exception action_name|log_id; pass error_name for user in action
    --
    PROCEDURE raise_error (
        in_action_name          logs.action_name%TYPE   := NULL,
        --
        in_arg1                 logs.arguments%TYPE     := NULL,
        in_arg2                 logs.arguments%TYPE     := NULL,
        in_arg3                 logs.arguments%TYPE     := NULL,
        in_arg4                 logs.arguments%TYPE     := NULL,
        in_arg5                 logs.arguments%TYPE     := NULL,
        in_arg6                 logs.arguments%TYPE     := NULL,
        in_arg7                 logs.arguments%TYPE     := NULL,
        in_arg8                 logs.arguments%TYPE     := NULL,
        --
        in_payload              logs.payload%TYPE       := NULL,
        in_rollback             BOOLEAN                 := FALSE
    );



    --
    -- Handling errors from/in APEX
    --
    FUNCTION handle_apex_error (
        p_error                 APEX_ERROR.T_ERROR
    )
    RETURN APEX_ERROR.T_ERROR_RESULT;



    --
    -- Purge old records from logs table
    --
    PROCEDURE purge_logs (
        in_age                  PLS_INTEGER         := NULL
    );



    --
    -- Purge specific log with all children
    --
    PROCEDURE purge_logs (
        in_log_id               logs.log_id%TYPE
    );



    --
    -- Purge specific day
    --
    PROCEDURE purge_logs (
        in_date                 DATE
    );



    --
    -- Returns procedure name which called this function with possible offset
    --
    FUNCTION get_caller_name (
        in_offset               PLS_INTEGER     := NULL
    )
    RETURN logs.module_name%TYPE;



    --
    -- Returns procedure line which called this function with possible offset
    --
    FUNCTION get_caller_line (
        in_offset               PLS_INTEGER     := NULL
    )
    RETURN logs.module_line%TYPE;



    --
    -- Hashing function (internal use)
    --
    FUNCTION get_hash (
        in_payload      VARCHAR2
    )
    RETURN VARCHAR2
    RESULT_CACHE;



    --
    -- Returns clean call stack
    --
    FUNCTION get_call_stack (
        in_offset               PLS_INTEGER     := NULL,
        in_skip_others          BOOLEAN         := FALSE,
        in_line_numbers         BOOLEAN         := TRUE,
        in_splitter             VARCHAR2        := CHR(10)
    )
    RETURN logs.payload%TYPE;



    --
    -- Returns error stack
    --
    FUNCTION get_error_stack
    RETURN logs.payload%TYPE;



    --
    -- Remove some not interesting calls from call/error stacks
    --
    FUNCTION get_shorter_stack (
        in_stack                VARCHAR2
    )
    RETURN VARCHAR2;



    --
    -- Finds and returns root log_id for passed log_id
    --
    FUNCTION get_log_root (
        in_log_id               logs.log_id%TYPE        := NULL
    )
    RETURN logs.log_id%TYPE;



    --
    -- Returns log_id generated by current page request
    --
    FUNCTION get_log_request_id
    RETURN logs.log_id%TYPE;



    --
    -- Returns log_id used by LOGS_TREE view
    --
    FUNCTION get_log_tree_id
    RETURN logs.log_id%TYPE;



    --
    -- Set log_id for LOGS_TREE view
    --
    PROCEDURE set_log_tree_id (
        in_log_id               logs.log_id%TYPE
    );







    -- ### Custom wrappers
    --

    --
    -- Call custom procedures to keep app specific changes out of this package
    --
    PROCEDURE call_custom_procedure (
        in_name                 VARCHAR2 := NULL,
        in_arg1                 VARCHAR2 := NULL,
        in_arg2                 VARCHAR2 := NULL,
        in_arg3                 VARCHAR2 := NULL,
        in_arg4                 VARCHAR2 := NULL
    );



    --
    -- Call custom function to keep app specific changes out of this package
    --
    FUNCTION call_custom_function (
        in_name                 VARCHAR2 := NULL,
        in_arg1                 VARCHAR2 := NULL,
        in_arg2                 VARCHAR2 := NULL,
        in_arg3                 VARCHAR2 := NULL,
        in_arg4                 VARCHAR2 := NULL
    )
    RETURN VARCHAR2;







    -- ### INIT
    --

    --
    -- Reload settings and clear callstack maps
    --
    PROCEDURE init;

END;
/
