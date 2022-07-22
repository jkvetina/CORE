CREATE OR REPLACE PACKAGE BODY constants AS

    FUNCTION get_core_alias
    RETURN VARCHAR2
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.core_alias;
    END;



    FUNCTION get_core_owner
    RETURN VARCHAR2
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.core_owner;
    END;



    FUNCTION get_format_date
    RETURN VARCHAR2
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.format_date;
    END;



    FUNCTION get_format_date_time
    RETURN VARCHAR2
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.format_date_time;
    END;



    FUNCTION get_format_date_short
    RETURN VARCHAR2
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.format_date_short;
    END;



    FUNCTION get_flag_request
    RETURN logs.flag%TYPE
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.flag_request;
    END;



    FUNCTION get_flag_module
    RETURN logs.flag%TYPE
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.flag_module;
    END;



    FUNCTION get_flag_action
    RETURN logs.flag%TYPE
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.flag_action;
    END;



    FUNCTION get_flag_debug
    RETURN logs.flag%TYPE
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.flag_debug;
    END;



    FUNCTION get_flag_result
    RETURN logs.flag%TYPE
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.flag_result;
    END;



    FUNCTION get_flag_warning
    RETURN logs.flag%TYPE
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.flag_warning;
    END;



    FUNCTION get_flag_error
    RETURN logs.flag%TYPE
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.flag_error;
    END;



    FUNCTION get_flag_longops
    RETURN logs.flag%TYPE
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.flag_longops;
    END;



    FUNCTION get_flag_scheduler
    RETURN logs.flag%TYPE
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.flag_scheduler;
    END;



    FUNCTION get_flag_trigger
    RETURN logs.flag%TYPE
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.flag_trigger;
    END;



    FUNCTION get_length_user
    RETURN PLS_INTEGER
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.length_user;
    END;



    FUNCTION get_length_action
    RETURN PLS_INTEGER
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.length_action;
    END;



    FUNCTION get_length_module
    RETURN PLS_INTEGER
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.length_module;
    END;



    FUNCTION get_length_arguments
    RETURN PLS_INTEGER
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.length_arguments;
    END;



    FUNCTION get_length_payload
    RETURN PLS_INTEGER
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.length_payload;
    END;



    FUNCTION get_track_callstack
    RETURN VARCHAR2
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.track_callstack;
    END;



    FUNCTION get_page_item_wild
    RETURN VARCHAR2
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.page_item_wild;
    END;



    FUNCTION get_page_item_prefix
    RETURN VARCHAR2
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.page_item_prefix;
    END;



    FUNCTION get_logs_table_name
    RETURN VARCHAR2
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.logs_table_name;
    END;



    FUNCTION get_logs_max_age
    RETURN PLS_INTEGER
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.logs_max_age;
    END;



    FUNCTION get_settings_package
    RETURN VARCHAR2
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.settings_package;
    END;



    FUNCTION get_settings_prefix
    RETURN VARCHAR2
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.settings_prefix;
    END;



    FUNCTION get_dml_tables_owner
    RETURN VARCHAR2
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.dml_tables_owner;
    END;



    FUNCTION get_dml_tables_prefix
    RETURN VARCHAR2
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.dml_tables_prefix;
    END;



    FUNCTION get_dml_tables_postfix
    RETURN VARCHAR2
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.dml_tables_postfix;
    END;



    FUNCTION get_transl_page_name
    RETURN VARCHAR2
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.transl_page_name;
    END;



    FUNCTION get_transl_page_title
    RETURN VARCHAR2
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.transl_page_title;
    END;



    FUNCTION get_app_proxy
    RETURN VARCHAR2
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.app_proxy;
    END;



    FUNCTION get_app_wallet
    RETURN VARCHAR2
    DETERMINISTIC
    AS
        PRAGMA UDF;
    BEGIN
        RETURN constants.app_wallet;
    END;

END;
/

