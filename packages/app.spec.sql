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

    -- CORE application alias
    core_alias                  CONSTANT VARCHAR2(30)           := 'CORE';  -- better than hardcode app number
    core_owner                  CONSTANT VARCHAR2(30)           := 'CORE';

    -- code for app exception
    app_exception_code          CONSTANT PLS_INTEGER            := -20000;
    app_exception               EXCEPTION;
    --
    PRAGMA EXCEPTION_INIT(app_exception, app_exception_code);   -- as a side effect this will disable listing constants in tree on the left

    -- internal date formats
    format_date                 CONSTANT VARCHAR2(30)           := 'YYYY-MM-DD';
    format_date_time            CONSTANT VARCHAR2(30)           := 'YYYY-MM-DD HH24:MI:SS';
    format_date_short           CONSTANT VARCHAR2(30)           := 'YYYY-MM-DD HH24:MI';

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

    -- error log table name and max age fo records
    logs_table_name             CONSTANT VARCHAR2(30)           := 'LOGS';      -- used in purge_old
    logs_max_age                CONSTANT PLS_INTEGER            := 7;           -- max logs age in days

    -- settings
    settings_package            CONSTANT VARCHAR2(30)           := 'S';         -- S### (app_id)
    settings_prefix             CONSTANT VARCHAR2(30)           := 'GET_';

    -- owner of DML error tables
    dml_tables_owner            CONSTANT VARCHAR2(30)           := NULL;        -- NULL = same as current owner
    dml_tables_prefix           CONSTANT VARCHAR2(30)           := '';          -- ERR$
    dml_tables_postfix          CONSTANT VARCHAR2(30)           := '_E$';

    -- translations
    transl_page_name            CONSTANT VARCHAR2(30)           := 'PAGE_NAME';
    transl_page_title           CONSTANT VARCHAR2(30)           := 'PAGE_TITLE';

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
    -- Return app_id for CORE application
    --
    FUNCTION get_core_app_id
    RETURN sessions.app_id%TYPE
    RESULT_CACHE;



    --
    -- Get CORE owner/schema
    --
    FUNCTION get_core_owner
    RETURN apex_applications.owner%TYPE;



    --
    -- Return current schema owner (because APEX dont like using USER)
    --
    FUNCTION get_owner (
        in_app_id               apps.app_id%TYPE
    )
    RETURN apex_applications.owner%TYPE
    RESULT_CACHE;



    --
    -- Get current owner/schema
    --
    FUNCTION get_owner
    RETURN apex_applications.owner%TYPE;



    --
    -- Set current owner/schema
    --
    PROCEDURE set_owner (
        in_owner                apex_applications.owner%TYPE
    );



    --
    -- Get home page (number) for selected/current application
    --
    FUNCTION get_app_homepage (
        in_app_id               apps.app_id%TYPE            := NULL
    )
    RETURN NUMBER;



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
    -- Translate page/app item
    --
    FUNCTION get_translated_item (
        in_name                 VARCHAR2,
        in_page_id              navigation.page_id%TYPE     := NULL,
        in_app_id               navigation.app_id%TYPE      := NULL,
        in_lang                 users.lang_id%TYPE          := NULL,
        in_exact_match          BOOLEAN                     := FALSE
    )
    RETURN VARCHAR2;



    --
    -- Translate message
    --
    FUNCTION get_translated_message (
        in_name                 VARCHAR2,
        in_app_id               navigation.app_id%TYPE      := NULL,
        in_lang                 users.lang_id%TYPE          := NULL
    )
    RETURN VARCHAR2;



    --
    -- Auth function to check if users account is active
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
    -- Option to change DEBUG mode
    --
    PROCEDURE set_debug (
        in_status               BOOLEAN                     := TRUE
    );



    --
    -- Get value from Settings table
    --
    FUNCTION get_setting (
        in_name                 settings.setting_name%TYPE,
        in_context              settings.setting_context%TYPE       := NULL
    )
    RETURN settings.setting_value%TYPE;



    --
    -- Get settings package name
    --
    FUNCTION get_settings_package
    RETURN VARCHAR2;



    --
    -- Get settings function prefix
    --
    FUNCTION get_settings_prefix
    RETURN VARCHAR2;







    -- ### Session management
    --

    --
    -- Create session from APEX
    --
    PROCEDURE create_session (
        in_init_map             BOOLEAN                     := TRUE
    );



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
    -- Get page title from APEX dictionary
    --
    FUNCTION get_page_title (
        in_page_id              navigation.page_id%TYPE     := NULL,
        in_app_id               navigation.app_id%TYPE      := NULL,
        in_title                VARCHAR2                    := NULL
    )
    RETURN VARCHAR2;



    --
    -- Get link to page with items
    --
    FUNCTION get_page_url (
        in_page_id              navigation.page_id%TYPE     := NULL,
        in_names                VARCHAR2                    := NULL,
        in_values               VARCHAR2                    := NULL,
        in_overload             VARCHAR2                    := NULL,    -- JSON object to overload passed items/values
        in_transform            BOOLEAN                     := FALSE,   -- to pass all page items to new page
        in_reset                BOOLEAN                     := TRUE,    -- reset page items
        in_session_id           sessions.session_id%TYPE    := NULL,
        in_app_id               navigation.app_id%TYPE      := NULL
    )
    RETURN VARCHAR2;



    --
    -- Returns requested URL
    --
    FUNCTION get_request_url (
        in_arguments_only       BOOLEAN                     := FALSE
    )
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
        in_app_id               navigation.app_id%TYPE
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
        in_name                 apex_application_page_items.item_name%TYPE,
        in_page_id              apex_application_page_items.page_id%TYPE            := NULL,
        in_app_id               apex_application_page_items.application_id%TYPE     := NULL
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



    --
    -- Get items used in a view on region (grid/report) to filter its content
    --
    FUNCTION get_region_filters (
        in_region_id            apex_application_page_regions.static_id%TYPE,
        in_page_id              apex_application_page_regions.page_id%TYPE          := NULL,
        in_app_id               apex_application_page_regions.application_id%TYPE   := NULL
    )
    RETURN VARCHAR2;







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
        in_name01               logs.arguments%TYPE := NULL,            in_value01  logs.arguments%TYPE := NULL,
        in_name02               logs.arguments%TYPE := NULL,            in_value02  logs.arguments%TYPE := NULL,
        in_name03               logs.arguments%TYPE := NULL,            in_value03  logs.arguments%TYPE := NULL,
        in_name04               logs.arguments%TYPE := NULL,            in_value04  logs.arguments%TYPE := NULL,
        in_name05               logs.arguments%TYPE := NULL,            in_value05  logs.arguments%TYPE := NULL,
        in_name06               logs.arguments%TYPE := NULL,            in_value06  logs.arguments%TYPE := NULL,
        in_name07               logs.arguments%TYPE := NULL,            in_value07  logs.arguments%TYPE := NULL,
        in_name08               logs.arguments%TYPE := NULL,            in_value08  logs.arguments%TYPE := NULL,
        in_name09               logs.arguments%TYPE := NULL,            in_value09  logs.arguments%TYPE := NULL,
        in_name10               logs.arguments%TYPE := NULL,            in_value10  logs.arguments%TYPE := NULL,
        in_name11               logs.arguments%TYPE := NULL,            in_value11  logs.arguments%TYPE := NULL,
        in_name12               logs.arguments%TYPE := NULL,            in_value12  logs.arguments%TYPE := NULL,
        in_name13               logs.arguments%TYPE := NULL,            in_value13  logs.arguments%TYPE := NULL,
        in_name14               logs.arguments%TYPE := NULL,            in_value14  logs.arguments%TYPE := NULL,
        in_name15               logs.arguments%TYPE := NULL,            in_value15  logs.arguments%TYPE := NULL,
        in_name16               logs.arguments%TYPE := NULL,            in_value16  logs.arguments%TYPE := NULL,
        in_name17               logs.arguments%TYPE := NULL,            in_value17  logs.arguments%TYPE := NULL,
        in_name18               logs.arguments%TYPE := NULL,            in_value18  logs.arguments%TYPE := NULL,
        in_name19               logs.arguments%TYPE := NULL,            in_value19  logs.arguments%TYPE := NULL,
        in_name20               logs.arguments%TYPE := NULL,            in_value20  logs.arguments%TYPE := NULL
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
        in_name01               logs.arguments%TYPE     := NULL,        in_value01  logs.arguments%TYPE     := NULL,
        in_name02               logs.arguments%TYPE     := NULL,        in_value02  logs.arguments%TYPE     := NULL,
        in_name03               logs.arguments%TYPE     := NULL,        in_value03  logs.arguments%TYPE     := NULL,
        in_name04               logs.arguments%TYPE     := NULL,        in_value04  logs.arguments%TYPE     := NULL,
        in_name05               logs.arguments%TYPE     := NULL,        in_value05  logs.arguments%TYPE     := NULL,
        in_name06               logs.arguments%TYPE     := NULL,        in_value06  logs.arguments%TYPE     := NULL,
        in_name07               logs.arguments%TYPE     := NULL,        in_value07  logs.arguments%TYPE     := NULL,
        in_name08               logs.arguments%TYPE     := NULL,        in_value08  logs.arguments%TYPE     := NULL,
        in_name09               logs.arguments%TYPE     := NULL,        in_value09  logs.arguments%TYPE     := NULL,
        in_name10               logs.arguments%TYPE     := NULL,        in_value10  logs.arguments%TYPE     := NULL,
        in_name11               logs.arguments%TYPE     := NULL,        in_value11  logs.arguments%TYPE     := NULL,
        in_name12               logs.arguments%TYPE     := NULL,        in_value12  logs.arguments%TYPE     := NULL,
        in_name13               logs.arguments%TYPE     := NULL,        in_value13  logs.arguments%TYPE     := NULL,
        in_name14               logs.arguments%TYPE     := NULL,        in_value14  logs.arguments%TYPE     := NULL,
        in_name15               logs.arguments%TYPE     := NULL,        in_value15  logs.arguments%TYPE     := NULL,
        in_name16               logs.arguments%TYPE     := NULL,        in_value16  logs.arguments%TYPE     := NULL,
        in_name17               logs.arguments%TYPE     := NULL,        in_value17  logs.arguments%TYPE     := NULL,
        in_name18               logs.arguments%TYPE     := NULL,        in_value18  logs.arguments%TYPE     := NULL,
        in_name19               logs.arguments%TYPE     := NULL,        in_value19  logs.arguments%TYPE     := NULL,
        in_name20               logs.arguments%TYPE     := NULL,        in_value20  logs.arguments%TYPE     := NULL,
        --
        in_parent_id            logs.log_parent%TYPE    := NULL,
        in_payload              logs.payload%TYPE       := NULL
    )
    RETURN logs.log_id%TYPE;



    --
    -- ^
    --
    PROCEDURE log_module_json (
        in_name01               logs.arguments%TYPE     := NULL,        in_value01  logs.arguments%TYPE     := NULL,
        in_name02               logs.arguments%TYPE     := NULL,        in_value02  logs.arguments%TYPE     := NULL,
        in_name03               logs.arguments%TYPE     := NULL,        in_value03  logs.arguments%TYPE     := NULL,
        in_name04               logs.arguments%TYPE     := NULL,        in_value04  logs.arguments%TYPE     := NULL,
        in_name05               logs.arguments%TYPE     := NULL,        in_value05  logs.arguments%TYPE     := NULL,
        in_name06               logs.arguments%TYPE     := NULL,        in_value06  logs.arguments%TYPE     := NULL,
        in_name07               logs.arguments%TYPE     := NULL,        in_value07  logs.arguments%TYPE     := NULL,
        in_name08               logs.arguments%TYPE     := NULL,        in_value08  logs.arguments%TYPE     := NULL,
        in_name09               logs.arguments%TYPE     := NULL,        in_value09  logs.arguments%TYPE     := NULL,
        in_name10               logs.arguments%TYPE     := NULL,        in_value10  logs.arguments%TYPE     := NULL,
        in_name11               logs.arguments%TYPE     := NULL,        in_value11  logs.arguments%TYPE     := NULL,
        in_name12               logs.arguments%TYPE     := NULL,        in_value12  logs.arguments%TYPE     := NULL,
        in_name13               logs.arguments%TYPE     := NULL,        in_value13  logs.arguments%TYPE     := NULL,
        in_name14               logs.arguments%TYPE     := NULL,        in_value14  logs.arguments%TYPE     := NULL,
        in_name15               logs.arguments%TYPE     := NULL,        in_value15  logs.arguments%TYPE     := NULL,
        in_name16               logs.arguments%TYPE     := NULL,        in_value16  logs.arguments%TYPE     := NULL,
        in_name17               logs.arguments%TYPE     := NULL,        in_value17  logs.arguments%TYPE     := NULL,
        in_name18               logs.arguments%TYPE     := NULL,        in_value18  logs.arguments%TYPE     := NULL,
        in_name19               logs.arguments%TYPE     := NULL,        in_value19  logs.arguments%TYPE     := NULL,
        in_name20               logs.arguments%TYPE     := NULL,        in_value20  logs.arguments%TYPE     := NULL,
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
    -- Proper/single way how to schedule one time jobs
    --
    PROCEDURE create_job (
        in_job_name             VARCHAR2,
        in_statement            VARCHAR2,
        in_user_id              sessions.user_id%TYPE       := NULL,
        in_app_id               sessions.app_id%TYPE        := NULL,
        in_session_id           sessions.session_id%TYPE    := NULL,
        in_priority             PLS_INTEGER                 := NULL,
        in_start_date           DATE                        := NULL,
        in_enabled              BOOLEAN                     := TRUE,
        in_autodrop             BOOLEAN                     := TRUE,
        in_comments             VARCHAR2                    := NULL
    );



    --
    -- Sync scheduler results and DML errors into LOGS table
    --
    PROCEDURE sync_logs (
        in_interval             NUMBER := NULL
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
        in_flag                 logs.flag%TYPE,
        in_module_name          logs.module_name%TYPE,
        in_action_name          logs.action_name%TYPE
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



    --
    -- Get flag from flag_name
    --
    FUNCTION get_flag (
        in_flag_name            VARCHAR2
    )
    RETURN logs.flag%TYPE
    RESULT_CACHE;



    --
    -- Send UTF_8 email with compressed attachements
    --
    PROCEDURE send_mail (
        in_to                   VARCHAR2,
        in_subject              VARCHAR2,
        in_body                 CLOB,
        in_cc                   VARCHAR2        := NULL,
        in_bcc                  VARCHAR2        := NULL,
        in_from                 VARCHAR2        := NULL,
        in_attach_name          VARCHAR2        := NULL,
        in_attach_mime          VARCHAR2        := NULL,
        in_attach_data          CLOB            := NULL,
        in_compress             BOOLEAN         := FALSE
    );



    --
    -- Convert CLOB to BLOB
    --
    FUNCTION clob_to_blob (
        in_clob CLOB
    )
    RETURN BLOB;







    -- ### DML Error Handling
    --

    --
    -- Drop DML error tables matching filter
    --
    PROCEDURE drop_dml_table (
        in_table_name           logs.module_name%TYPE
    );



    --
    -- Recreates DML error tables matching filter
    --
    PROCEDURE create_dml_table (
        in_table_name           logs.module_name%TYPE
    );



    --
    -- Maps existing DML errors to proper row in LOGS table
    --
    PROCEDURE process_dml_errors (
        in_table_name           user_tables.table_name%TYPE := NULL
    );



    --
    -- Get DML error table name
    --
    FUNCTION get_dml_table (
        in_table_name           logs.module_name%TYPE,
        in_owner                CHAR                    := NULL,
        in_existing_only        BOOLEAN                 := FALSE
    )
    RETURN VARCHAR2;



    --
    -- Get DML error table owner
    --
    FUNCTION get_dml_owner
    RETURN VARCHAR2;



    --
    -- Creates MERGE query for selected _E$ table and row
    --
    FUNCTION get_dml_query (
        in_log_id               logs.log_id%TYPE,
        in_table_name           logs.module_name%TYPE,
        in_table_rowid          VARCHAR2,
        in_operation            CHAR  -- [I|U|D]
    )
    RETURN VARCHAR2;



    --
    -- Convert LONG to VARCHAR2
    --
    FUNCTION get_long_string (
        in_table_name           VARCHAR2,
        in_column_name          VARCHAR2,
        in_where_col1_name      VARCHAR2,
        in_where_val1           VARCHAR2,
        in_where_col2_name      VARCHAR2    := NULL,
        in_where_val2           VARCHAR2    := NULL,
        in_owner                VARCHAR2    := NULL
    )
    RETURN VARCHAR2;



    --
    -- Rebuild source lines for views
    --
    PROCEDURE rebuild_obj_views_source (
        in_owner                apex_applications.owner%TYPE    := NULL
    );



    --
    -- Rebuild package containing function matching Settings table
    --
    PROCEDURE rebuild_settings;







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
    PROCEDURE init_map;

END;
/
