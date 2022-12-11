CREATE OR REPLACE PACKAGE constants AS

    -- CORE application alias
    core_alias                  CONSTANT VARCHAR2(30)           := 'CORE';  -- better than hardcode app number
    core_owner                  CONSTANT VARCHAR2(30)           := 'CORE';

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
    length_user                 CONSTANT PLS_INTEGER            := 128;     -- logs.user_id%TYPE
    length_action               CONSTANT PLS_INTEGER            := 64;      -- logs.action_name%TYPE, v_$session.action
    length_module               CONSTANT PLS_INTEGER            := 64;      -- logs.module_name%TYPE
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

    -- proxy and wallet setup
    app_proxy                   CONSTANT VARCHAR2(256)          := '';
    app_wallet                  CONSTANT VARCHAR2(256)          := '';



    --
    -- GENERATED FUNCTIONS
    --

    FUNCTION get_core_alias
    RETURN VARCHAR2
    DETERMINISTIC;

    FUNCTION get_core_owner
    RETURN VARCHAR2
    DETERMINISTIC;

    FUNCTION get_format_date
    RETURN VARCHAR2
    DETERMINISTIC;

    FUNCTION get_format_date_time
    RETURN VARCHAR2
    DETERMINISTIC;

    FUNCTION get_format_date_short
    RETURN VARCHAR2
    DETERMINISTIC;

    FUNCTION get_flag_request
    RETURN logs.flag%TYPE
    DETERMINISTIC;

    FUNCTION get_flag_module
    RETURN logs.flag%TYPE
    DETERMINISTIC;

    FUNCTION get_flag_action
    RETURN logs.flag%TYPE
    DETERMINISTIC;

    FUNCTION get_flag_debug
    RETURN logs.flag%TYPE
    DETERMINISTIC;

    FUNCTION get_flag_result
    RETURN logs.flag%TYPE
    DETERMINISTIC;

    FUNCTION get_flag_warning
    RETURN logs.flag%TYPE
    DETERMINISTIC;

    FUNCTION get_flag_error
    RETURN logs.flag%TYPE
    DETERMINISTIC;

    FUNCTION get_flag_longops
    RETURN logs.flag%TYPE
    DETERMINISTIC;

    FUNCTION get_flag_scheduler
    RETURN logs.flag%TYPE
    DETERMINISTIC;

    FUNCTION get_flag_trigger
    RETURN logs.flag%TYPE
    DETERMINISTIC;

    FUNCTION get_length_user
    RETURN PLS_INTEGER
    DETERMINISTIC;

    FUNCTION get_length_action
    RETURN PLS_INTEGER
    DETERMINISTIC;

    FUNCTION get_length_module
    RETURN PLS_INTEGER
    DETERMINISTIC;

    FUNCTION get_length_arguments
    RETURN PLS_INTEGER
    DETERMINISTIC;

    FUNCTION get_length_payload
    RETURN PLS_INTEGER
    DETERMINISTIC;

    FUNCTION get_track_callstack
    RETURN VARCHAR2
    DETERMINISTIC;

    FUNCTION get_page_item_wild
    RETURN VARCHAR2
    DETERMINISTIC;

    FUNCTION get_page_item_prefix
    RETURN VARCHAR2
    DETERMINISTIC;

    FUNCTION get_logs_table_name
    RETURN VARCHAR2
    DETERMINISTIC;

    FUNCTION get_logs_max_age
    RETURN PLS_INTEGER
    DETERMINISTIC;

    FUNCTION get_settings_package
    RETURN VARCHAR2
    DETERMINISTIC;

    FUNCTION get_settings_prefix
    RETURN VARCHAR2
    DETERMINISTIC;

    FUNCTION get_dml_tables_owner
    RETURN VARCHAR2
    DETERMINISTIC;

    FUNCTION get_dml_tables_prefix
    RETURN VARCHAR2
    DETERMINISTIC;

    FUNCTION get_dml_tables_postfix
    RETURN VARCHAR2
    DETERMINISTIC;

    FUNCTION get_transl_page_name
    RETURN VARCHAR2
    DETERMINISTIC;

    FUNCTION get_transl_page_title
    RETURN VARCHAR2
    DETERMINISTIC;

    FUNCTION get_app_proxy
    RETURN VARCHAR2
    DETERMINISTIC;

    FUNCTION get_app_wallet
    RETURN VARCHAR2
    DETERMINISTIC;

END;
/

