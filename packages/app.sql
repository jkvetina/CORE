CREATE OR REPLACE PACKAGE BODY app AS

    recent_log_id               logs.log_id%TYPE;       -- for events
    recent_request_id           logs.log_id%TYPE;       -- for tracking APEX requests
    recent_tree_id              logs.log_id%TYPE;       -- for logs_tree view
    --
    map_tree                    app.arr_map_tree;

    -- arrays to specify adhoc requests
    log_whitelist               app.arr_log_setup := app.arr_log_setup();
    log_blacklist               app.arr_log_setup := app.arr_log_setup();

    -- possible exception when parsing call stack
    BAD_DEPTH EXCEPTION;
    PRAGMA EXCEPTION_INIT(BAD_DEPTH, -64610);

    --
    raise_error_procedure       CONSTANT logs.module_name%TYPE := 'APP.RAISE_ERROR';





    FUNCTION get_app_id
    RETURN sessions.app_id%TYPE
    AS
    BEGIN
        RETURN COALESCE(APEX_APPLICATION.G_FLOW_ID, 0);
    END;



    FUNCTION get_user_id
    RETURN users.user_id%TYPE
    AS
    BEGIN
        RETURN COALESCE (
            APEX_APPLICATION.G_USER,
            SYS_CONTEXT('USERENV', 'SESSION_USER'),
            USER
        );
    END;



    FUNCTION get_user_id (
        in_user_login           users.user_login%TYPE
    )
    RETURN users.user_id%TYPE
    AS
        out_user_id             users.user_id%TYPE;
        is_valid                CHAR;
    BEGIN
        -- find existing record based on user_login
        SELECT u.user_id INTO out_user_id
        FROM users u
        WHERE (u.user_login = in_user_login OR u.user_id = in_user_login);
        --
        RETURN out_user_id;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- try to shorten login if possible
        out_user_id := LTRIM(RTRIM(
            CONVERT(
                CASE WHEN NVL(INSTR(in_user_login, '@'), 0) > 0
                    THEN LOWER(in_user_login)                       -- emails lowercased
                    ELSE UPPER(in_user_login) END,                  -- otherwise uppercased
                'US7ASCII')                                         -- strip special chars
        ));

        -- recheck for possible conflict
        BEGIN
            SELECT 'Y' INTO is_valid
            FROM users u
            WHERE u.user_id = out_user_id;
            --
            RETURN NULL;  -- login not available
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN out_user_id;
        END;
    END;



    PROCEDURE set_user_id
    ACCESSIBLE BY (
        PACKAGE app,
        PACKAGE app_ut
    )
    AS
        v_user_id       users.user_id%TYPE;
    BEGIN
        v_user_id       := app.get_user_id(in_user_login => app.get_user_id());  -- convert user_login to user_id

        -- set session things
        DBMS_SESSION.SET_IDENTIFIER(v_user_id);                 -- USERENV.CLIENT_IDENTIFIER
        DBMS_APPLICATION_INFO.SET_CLIENT_INFO(v_user_id);       -- CLIENT_INFO, v$

        -- overwrite current user in APEX
        APEX_CUSTOM_AUTH.SET_USER (
            p_user => v_user_id
        );

        -- set session language
        -- @TODO: APEX_UTIL.GET_SESSION_LANG = app.get_user_lang();
        --
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
    END;



    FUNCTION get_user_name (
        in_user_id              users.user_id%TYPE          := NULL
    )
    RETURN users.user_name%TYPE
    AS
        out_name                users.user_name%TYPE;
    BEGIN
        SELECT u.user_name INTO out_name
        FROM users u
        WHERE u.user_id = COALESCE(in_user_id, app.get_user_id());
        --
        RETURN out_name;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



    FUNCTION get_user_login (
        in_user_id              users.user_id%TYPE          := NULL
    )
    RETURN users.user_login%TYPE
    AS
        out_user_login          users.user_login%TYPE;
    BEGIN
        SELECT u.user_login INTO out_user_login
        FROM users u
        WHERE u.user_id = COALESCE(in_user_id, app.get_user_id());
        --
        RETURN out_user_login;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



    FUNCTION get_user_lang
    RETURN users.lang_id%TYPE
    AS
        out_lang                users.lang_id%TYPE;
    BEGIN
        SELECT u.lang_id INTO out_lang
        FROM users u
        WHERE u.user_id = app.get_user_id();
        --
        RETURN out_lang;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



    FUNCTION is_developer (
        in_user                 users.user_login%TYPE       := NULL
    )
    RETURN BOOLEAN
    AS
        is_valid                CHAR;
    BEGIN
        WITH u AS (
            SELECT app.get_user_id() AS user_id FROM DUAL UNION ALL
            SELECT app.get_user_login()         FROM DUAL UNION ALL
            SELECT in_user                      FROM DUAL
        )
        SELECT 'Y' INTO is_valid
        FROM apex_workspace_developers d
        JOIN apex_applications a
            ON a.workspace                  = d.workspace_name
        JOIN u
            ON UPPER(u.user_id)             IN (UPPER(d.user_name), UPPER(d.email))
        WHERE a.application_id              = app.get_app_id()
            AND d.is_application_developer  = 'Yes'
            AND d.account_locked            = 'No'
            AND ROWNUM                      = 1;
        --
        RETURN TRUE;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
    END;



    FUNCTION is_developer_y (
        in_user                 users.user_login%TYPE       := NULL
    )
    RETURN CHAR
    AS
    BEGIN
        RETURN CASE WHEN app.is_developer(in_user) THEN 'Y' END;
    END;



    FUNCTION is_debug_on
    RETURN BOOLEAN
    AS
    BEGIN
        RETURN APEX_APPLICATION.G_DEBUG;
    END;



    PROCEDURE create_session
    AS
        PRAGMA AUTONOMOUS_TRANSACTION;
        --
        v_is_active             users.is_active%TYPE;
        v_user_login            users.user_login%TYPE;
        rec                     sessions%ROWTYPE;
    BEGIN
        app.log_module();
        --
        v_user_login            := app.get_user_id();
        --
        rec.app_id              := app.get_app_id();
        rec.user_id             := v_user_login;
        rec.session_id          := app.get_session_id();
        rec.created_at          := SYSDATE;
        rec.updated_at          := rec.created_at;

        -- this procedure is starting point in APEX after successful authentication
        -- prevent sessions for anonymous (unlogged) users
        IF (UPPER(rec.user_id) IN (USER, app.anonymous_user, 'ORDS_PUBLIC_USER', 'APEX_PUBLIC_USER') OR NVL(rec.app_id, 0) = 0) THEN
            RETURN;
        END IF;

        -- check app availability
        IF NOT app.is_developer() THEN
            BEGIN
                SELECT 'Y' INTO v_is_active
                FROM apps a
                WHERE a.app_id          = rec.app_id
                    AND a.is_active     = 'Y';
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                app.raise_error('APPLICATION_OFFLINE');
            END;
        END IF;

        -- adjust user_id in APEX, init session
        DBMS_SESSION.CLEAR_IDENTIFIER();
        DBMS_APPLICATION_INFO.SET_MODULE (
            module_name => NULL,
            action_name => NULL
        );
        --
        app.init();                             -- init setup, maps...
        app.set_user_id();                      -- convert user_login to user_id
        rec.user_id := app.get_user_id();       -- update needed

        -- store log_id of the request for further reuse
        recent_request_id := app.log_request();

        -- call app specific code (to create new user for example)
        app.call_custom_procedure (
            in_arg1     => v_user_login,
            in_arg2     => rec.user_id
        );

        -- check user
        BEGIN
            SELECT u.user_id, u.is_active INTO rec.user_id, v_is_active
            FROM users u
            WHERE u.user_id = app.get_user_id();
            --
            IF v_is_active IS NULL THEN
                app.raise_error('ACCOUNT_DISABLED');
            END IF;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            app.raise_error('INVALID_USER');
        END;

        -- update session record, prevent app_id and user_id hijacking
        UPDATE sessions s
        SET s.updated_at        = SYSDATE
        WHERE s.app_id          = rec.app_id
            AND s.session_id    = rec.session_id
            AND s.user_id       = rec.user_id
        RETURNING s.created_at INTO rec.created_at;
        --
        IF SQL%ROWCOUNT = 0 THEN
            BEGIN
                INSERT INTO sessions VALUES rec;
            EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                app.raise_error('DUPE_SESSION');  -- redirect to logout/login page
            END;
        ELSIF TRUNC(rec.created_at) < TRUNC(rec.updated_at) THEN
            -- avoid sessions spanning thru multiple days
            FOR c IN (
                SELECT s.session_id
                FROM sessions s
                WHERE s.app_id          = rec.app_id
                    AND s.session_id    = rec.session_id
            ) LOOP
                app.log_warning('FORCED_SESSION');
                --
                COMMIT;
                --
                APEX_UTIL.REDIRECT_URL(APEX_PAGE.GET_URL(p_session => 0));  -- force new login
            END LOOP;
        END IF;
        --
        app.log_success();
        --
        COMMIT;
    EXCEPTION
    WHEN app.app_exception THEN
        ROLLBACK;
        RAISE;
    WHEN APEX_APPLICATION.E_STOP_APEX_ENGINE THEN
        COMMIT;
    WHEN OTHERS THEN
        ROLLBACK;
        app.raise_error();
    END;



    PROCEDURE create_session (
        in_user_id              sessions.user_id%TYPE,
        in_app_id               sessions.app_id%TYPE,
        in_items                VARCHAR2                := NULL
    ) AS
        PRAGMA AUTONOMOUS_TRANSACTION;
        --
        v_workspace_id          apex_applications.workspace%TYPE;
    BEGIN
        app.log_module(
            in_args => app.get_json_object (
                'in_user_id',       in_user_id,
                'in_app_id',        in_app_id,
                'in_items',         in_items
            )
        );

        -- create session from SQL Developer (not from APEX)
        BEGIN
            IF (in_user_id != app.get_user_id() OR in_app_id != app.get_app_id()) THEN
                RAISE NO_DATA_FOUND;
            END IF;

            -- use existing session if possible
            APEX_SESSION.ATTACH (
                p_app_id        => app.get_app_id(),
                p_page_id       => 0,
                p_session_id    => app.get_session_id()
            );
        EXCEPTION
        WHEN OTHERS THEN
            -- find and setup workspace
            SELECT a.workspace INTO v_workspace_id
            FROM apex_applications a
            WHERE a.application_id = in_app_id;
            --
            APEX_UTIL.SET_WORKSPACE (
                p_workspace => v_workspace_id
            );
            APEX_UTIL.SET_SECURITY_GROUP_ID (
                p_security_group_id => APEX_UTIL.FIND_SECURITY_GROUP_ID(p_workspace => v_workspace_id)
            );
            APEX_UTIL.SET_USERNAME (
                p_userid    => APEX_UTIL.GET_USER_ID(in_user_id),
                p_username  => in_user_id
            );

            -- create APEX session
            BEGIN
                APEX_SESSION.CREATE_SESSION (
                    p_app_id    => in_app_id,
                    p_page_id   => 0,
                    p_username  => in_user_id
                );
            EXCEPTION
            WHEN OTHERS THEN
                app.raise_error('INVALID_APP', app.get_json_list(in_app_id, in_user_id));
            END;
        END;

        -- continue with standard process as from APEX
        app.create_session();
        --
        IF in_items IS NOT NULL THEN
            app.apply_items(in_items);
        END IF;
        --
        app.log_success(recent_request_id);
        --
        COMMIT;
    EXCEPTION
    WHEN app.app_exception THEN
        ROLLBACK;
        RAISE;
    WHEN APEX_APPLICATION.E_STOP_APEX_ENGINE THEN
        COMMIT;
    WHEN OTHERS THEN
        ROLLBACK;
        app.raise_error();
    END;



    PROCEDURE exit_session
    AS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        -- call app specific code
        app.call_custom_procedure();

        DBMS_SESSION.CLEAR_IDENTIFIER();
        --DBMS_SESSION.CLEAR_ALL_CONTEXT(namespace);
        --DBMS_SESSION.RESET_PACKAGE;  -- avoid ORA-04068 exception
        --
        DBMS_APPLICATION_INFO.SET_MODULE (
            module_name     => NULL,
            action_name     => NULL
        );
        --
        COMMIT;
    EXCEPTION
    WHEN app.app_exception THEN
        ROLLBACK;
        RAISE;
    WHEN OTHERS THEN
        ROLLBACK;
        app.raise_error();
    END;



    PROCEDURE delete_session (
        in_session_id           sessions.session_id%TYPE
    ) AS
        v_log_id                logs.log_id%TYPE;
        v_rows_to_delete        app.arr_logs_log_id;
    BEGIN
        v_log_id := app.log_module();
        --
        SELECT l.log_id
        BULK COLLECT INTO v_rows_to_delete
        FROM logs l
        WHERE l.session_id      = in_session_id;
        --
        IF v_rows_to_delete.FIRST IS NOT NULL THEN
            FOR i IN v_rows_to_delete.FIRST .. v_rows_to_delete.LAST LOOP
                CONTINUE WHEN v_rows_to_delete(i) = v_log_id;
                --
                DELETE FROM logs_events     WHERE log_parent    = v_rows_to_delete(i);
                DELETE FROM logs            WHERE log_id        = v_rows_to_delete(i);
            END LOOP;
        END IF;
        --
        IF in_session_id != app.get_session_id() THEN
            DELETE FROM sessions s
            WHERE s.session_id = in_session_id;
            --
            -- may throw ORA-20987: APEX - Your session has ended
            -- not even others handler can capture this
            --APEX_SESSION.DELETE_SESSION(in_session_id);
            --
            -- @TODO: maybe schedule/dettach this as a job
            --
        END IF;
        --
        app.log_success();
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
    END;



    PROCEDURE set_session (
        in_module_name          logs.module_name%TYPE,
        in_action_name          logs.action_name%TYPE,
        in_log_id               logs.log_id%TYPE            := NULL
    ) AS
        v_action_name           logs.action_name%TYPE;
    BEGIN
        v_action_name := SUBSTR(TO_CHAR(NVL(recent_request_id, 0)) || '|' || TO_CHAR(in_log_id) || '|' || in_action_name, 1, app.length_action);
        --
        IF in_module_name IS NOT NULL THEN
            DBMS_APPLICATION_INFO.SET_MODULE(in_module_name, v_action_name);    -- USERENV.MODULE, USERENV.ACTION
        END IF;
        --
        IF in_action_name IS NOT NULL THEN
            DBMS_APPLICATION_INFO.SET_ACTION(v_action_name);                    -- USERENV.ACTION
        END IF;
    END;



    FUNCTION get_session_id
    RETURN sessions.session_id%TYPE
    AS
    BEGIN
        RETURN SYS_CONTEXT('APEX$SESSION', 'APP_SESSION');  -- APEX.G_INSTANCE
    END;



    FUNCTION get_client_id (
        in_user_id              sessions.user_id%TYPE       := NULL
    )
    RETURN VARCHAR2 AS          -- mimic APEX client_id
    BEGIN
        RETURN
            COALESCE(in_user_id, app.get_user_id()) || ':' ||
            COALESCE(app.get_session_id(), SYS_CONTEXT('USERENV', 'SESSIONID')
        );
    END;



    FUNCTION get_page_id
    RETURN navigation.page_id%TYPE
    AS
    BEGIN
        RETURN APEX_APPLICATION.G_FLOW_STEP_ID;
    END;



    FUNCTION get_page_group (
        in_page_id              navigation.page_id%TYPE     := NULL,
        in_app_id               navigation.app_id%TYPE      := NULL
    )
    RETURN apex_application_pages.page_group%TYPE
    AS
        out_name                apex_application_pages.page_group%TYPE;
    BEGIN
        SELECT p.page_group INTO out_name
        FROM apex_application_pages p
        WHERE p.application_id      = COALESCE(in_app_id, app.get_app_id())
            AND p.page_id           = COALESCE(in_page_id, app.get_page_id());
        --
        RETURN out_name;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



    FUNCTION get_page_root (
        in_page_id              navigation.page_id%TYPE     := NULL,
        in_app_id               navigation.app_id%TYPE      := NULL
    )
    RETURN navigation.page_id%TYPE
    AS
        out_id                  apex_application_pages.page_id%TYPE;
    BEGIN
        SELECT REGEXP_SUBSTR(MAX(SYS_CONNECT_BY_PATH(n.page_id, '/')), '[0-9]+$') INTO out_id
        FROM navigation n
        WHERE n.app_id          = COALESCE(in_app_id, app.get_app_id())
        CONNECT BY n.app_id     = PRIOR n.app_id
            AND n.page_id       = PRIOR n.parent_id
        START WITH n.page_id    = COALESCE(in_page_id, app.get_page_id());
        --
        RETURN out_id;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



    FUNCTION get_page_name (
        in_page_id              navigation.page_id%TYPE     := NULL,
        in_app_id               navigation.app_id%TYPE      := NULL,
        in_name                 VARCHAR2                    := NULL
    )
    RETURN VARCHAR2
    AS
        out_name                apex_application_pages.page_name%TYPE       := in_name;
        out_search              apex_application_pages.page_name%TYPE;
    BEGIN
        IF in_name IS NULL THEN
            SELECT p.page_group INTO out_name
            FROM apex_application_pages p
            WHERE p.application_id      = COALESCE(in_app_id, app.get_app_id())
                AND p.page_id           = COALESCE(in_page_id, app.get_page_id());
        END IF;

        -- transform icons
        FOR i IN 1 .. NVL(REGEXP_COUNT(out_name, '(#fa-)'), 0) LOOP
            out_search  := REGEXP_SUBSTR(out_name, '(#fa-[[:alnum:]+_-]+\s*)+');
            out_name    := REPLACE(
                out_name,
                out_search,
                ' &' || 'nbsp; <span class="fa' || REPLACE(REPLACE(out_search, '#fa-', '+'), '+', ' fa-') || '"></span> &' || 'nbsp; '
            );
        END LOOP;

        -- custom name conversion
        out_name := NVL(app.call_custom_function(NULL, out_name), out_name);
        --
        RETURN REGEXP_REPLACE(out_name, '((^\s*&' || 'nbsp;\s*)|(\s*&' || 'nbsp;\s*$))', '');  -- trim hard spaces
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



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
    RETURN VARCHAR2
    AS
        out_page_id             navigation.page_id%TYPE     := COALESCE(in_page_id, app.get_page_id());
        out_names               VARCHAR2(32767)             := in_names;
        out_values              VARCHAR2(32767)             := in_values;
    BEGIN
        -- autofill missing values
        IF in_names IS NOT NULL AND in_values IS NULL THEN
            FOR c IN (
                SELECT item_name
                FROM (
                    SELECT DISTINCT REGEXP_SUBSTR(in_names, '[^,]+', 1, LEVEL) AS item_name, LEVEL AS order#
                    FROM DUAL
                    CONNECT BY LEVEL <= REGEXP_COUNT(in_names, ',') + 1
                )
                ORDER BY order# DESC
            ) LOOP
                out_values := app.get_item(c.item_name) || ',' || out_values;
            END LOOP;
        END IF;

/*
        -- get page items with not null values
        FOR c IN (
            SELECT
                p.item_name,
                app.get_item(p.item_name)      AS item_value
            FROM apex_application_page_items p
            WHERE p.application_id              = app.get_app_id()
                AND p.page_id                   = COALESCE(in_page_id, app.get_page_id())
                AND app.get_item(p.item_name)  IS NOT NULL
        ) LOOP
            out_names   := out_names  || c.item_name  || ',';
            out_values  := out_values || c.item_value || ',';
        END LOOP;


        -- check existance of reset item on target page
        SELECT MAX(i.item_name) INTO reset_item
        FROM apex_application_page_items i
        WHERE i.application_id  = app.get_app_id()
            AND i.page_id       = out_page_id
            AND i.item_name     = 'P' || out_page_id || '_RESET';

        -- auto add reset item to args if not passed already
        IF reset_item IS NOT NULL AND NVL(INSTR(out_names, reset_item), 0) = 0 THEN
            out_names   := reset_item || ',' || out_names;
            out_values  := 'Y,' || out_values;
        END IF;

*/

        -- generate url
        RETURN APEX_PAGE.GET_URL (
            p_application       => in_app_id,
            p_session           => COALESCE(in_session_id, app.get_session_id()),
            p_page              => out_page_id,
            p_clear_cache       => CASE WHEN in_reset THEN out_page_id END,
            p_items             => out_names,
            p_values            => out_values
            /*
            p_session            IN NUMBER   DEFAULT APEX.G_INSTANCE,
            p_request            IN VARCHAR2 DEFAULT NULL,
            p_debug              IN VARCHAR2 DEFAULT NULL,
            p_clear_cache        IN VARCHAR2 DEFAULT NULL,
            p_items              IN VARCHAR2 DEFAULT NULL,
            p_values             IN VARCHAR2 DEFAULT NULL,
            p_printer_friendly   IN VARCHAR2 DEFAULT NULL,
            p_trace              IN VARCHAR2 DEFAULT NULL,       
            p_triggering_element IN VARCHAR2 DEFAULT 'this',
            p_plain_url          IN BOOLEAN DEFAULT FALSE )
            */
        );
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
    END;



    FUNCTION get_request_url
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN UTL_URL.UNESCAPE(
            OWA_UTIL.GET_CGI_ENV('SCRIPT_NAME') ||
            OWA_UTIL.GET_CGI_ENV('PATH_INFO')   || '?' ||
            OWA_UTIL.GET_CGI_ENV('QUERY_STRING')
        );
    EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
    END;



    FUNCTION get_request
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN APEX_APPLICATION.G_REQUEST;
    END;



    FUNCTION get_icon (
        in_name                 VARCHAR2,
        in_title                VARCHAR2    := NULL
    )
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN '<span class="fa ' || in_name || '" title="' || in_title || '"></span>';
    END;



    FUNCTION is_page_available (
        in_page_id              navigation.page_id%TYPE,
        in_app_id               navigation.app_id%TYPE          := NULL
    )
    RETURN CHAR
    AS
        v_auth_name             apex_application_pages.authorization_scheme%TYPE;
        v_proc_name             user_procedures.procedure_name%TYPE;
        v_arg_name              user_arguments.argument_name%TYPE;
        --
        out_result              CHAR;
        --
        PRAGMA UDF;             -- SQL only
    BEGIN
        BEGIN
            SELECT
                p.authorization_scheme,
                s.procedure_name,
                a.argument_name
            INTO v_auth_name, v_proc_name, v_arg_name
            FROM apex_application_pages p
            LEFT JOIN user_procedures s
                ON s.object_name                = app.auth_package
                AND s.procedure_name            = p.authorization_scheme
            LEFT JOIN user_arguments a
                ON a.object_name                = s.procedure_name
                AND a.package_name              = s.object_name
                AND a.overload                  IS NULL
                AND a.position                  = 1
                AND a.argument_name             = app.auth_page_id_arg
                AND a.data_type                 = 'NUMBER'
                AND a.in_out                    = 'IN'
            WHERE p.application_id              = COALESCE(in_app_id, app.get_app_id())
                AND p.page_id                   = in_page_id
                AND REGEXP_LIKE(p.authorization_scheme_id, '^(\d+)$');  -- user auth schemes only
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Y';  -- show, page has no authorization set
        END;
        --
        IF v_proc_name IS NULL THEN
            app.log_warning('AUTH_PROCEDURE_MISSING', v_auth_name);
            RETURN 'N';  -- hide, auth function is set on page but missing in AUTH package
        END IF;

        -- call function to evaluate access
        IF v_arg_name IS NOT NULL THEN
            -- pass page_id when neeeded
            EXECUTE IMMEDIATE
                'BEGIN :r := ' || app.auth_package || '.' || v_proc_name || '(:page_id); END;'
                USING IN in_page_id, OUT out_result;
        ELSE
            EXECUTE IMMEDIATE
                'BEGIN :r := ' || app.auth_package || '.' || v_proc_name || '; END;'
                USING OUT out_result;
        END IF;
        --
        RETURN NVL(out_result, 'N');
    END;



    FUNCTION is_page_visible (
        in_page_id              navigation.page_id%TYPE,
        in_app_id               navigation.app_id%TYPE          := NULL
    )
    RETURN CHAR
    AS
        is_valid                CHAR;
        --
        PRAGMA UDF;             -- SQL only
    BEGIN
        SELECT 'Y' INTO is_valid
        FROM navigation n
        WHERE n.app_id          = COALESCE(in_app_id, app.get_app_id())
            AND n.page_id       = COALESCE(in_page_id, app.get_page_id())
            AND n.is_hidden     IS NULL;
        --
        RETURN is_valid;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'N';
    END;



    PROCEDURE nav_remove_pages (
        in_page_id              navigation.page_id%TYPE         := NULL
    )
    AS
    BEGIN
        app.log_module(in_page_id);

        -- remove references
        FOR c IN (
            SELECT n.app_id, n.page_id
            FROM navigation n
            JOIN nav_pages_to_remove p
                ON p.page_id        = n.parent_id
                AND n.page_id       = NVL(in_page_id, n.page_id)
            WHERE n.app_id          = app.get_app_id()
        ) LOOP
            app.log_debug('REMOVING_PARENT', c.page_id);
            --
            UPDATE navigation n
            SET n.parent_id         = NULL
            WHERE n.app_id          = c.app_id
                AND n.page_id       = c.page_id;
        END LOOP;

        -- remove rows for pages which dont exists
        FOR c IN (
            SELECT p.page_id
            FROM nav_pages_to_remove p
            WHERE p.page_id         = NVL(in_page_id, p.page_id)
        ) LOOP
            app.log_debug('DELETING', c.page_id);
            --
            DELETE FROM navigation n
            WHERE n.app_id          = app.get_app_id()
                AND n.page_id       = c.page_id;
        END LOOP;
        --
        app.log_success();
    END;



    PROCEDURE nav_add_pages (
        in_page_id              navigation.page_id%TYPE         := NULL
    )
    AS
        rec         navigation%ROWTYPE;
    BEGIN
        app.log_module(in_page_id);

        -- add pages which are present in APEX but missing in Navigation table
        FOR c IN (
            SELECT n.*
            FROM nav_pages_to_add n
            WHERE n.page_id = NVL(in_page_id, n.page_id)
        ) LOOP
            app.log_debug('ADDING', c.page_id);
            --
            rec.app_id      := c.app_id;
            rec.page_id     := c.page_id;
            rec.parent_id   := c.parent_id;
            rec.order#      := c.order#;
            rec.is_hidden   := c.is_hidden;
            rec.is_reset    := c.is_reset;
            --
            INSERT INTO navigation VALUES rec;
        END LOOP;
        --
        app.log_success();
    END;



    PROCEDURE nav_autoupdate
    AS
    BEGIN
        app.log_module();
        --
        app.nav_remove_pages();
        app.nav_add_pages();
        --
        app.log_success();
    END;



    PROCEDURE redirect (
        in_page_id              NUMBER          := NULL,
        in_names                VARCHAR2        := NULL,
        in_values               VARCHAR2        := NULL,
        in_overload             VARCHAR2        := NULL,    -- JSON object to overload passed items/values
        in_transform            BOOLEAN         := FALSE,   -- to pass all page items to new page
        in_reset                BOOLEAN         := TRUE     -- reset page items
    ) AS
        out_target              VARCHAR2(32767);
    BEGIN
        -- commit otherwise anything before redirect will be rolled back
        COMMIT;

        -- check if we are in APEX or not
        HTP.INIT;
        out_target := app.get_page_link (
            in_page_id          => in_page_id,
            in_names            => in_names,
            in_values           => in_values,
            in_overload         => in_overload,
            in_transform        => in_transform,
            in_reset            => in_reset
        );
        --
        app.log_debug('REDIRECT', app.get_json_list(in_page_id, in_names, in_values, out_target));
        --
        APEX_UTIL.REDIRECT_URL(out_target);  -- OWA_UTIL not working on Cloud
        --
        APEX_APPLICATION.STOP_APEX_ENGINE;
        --
        -- EXCEPTION
        -- WHEN APEX_APPLICATION.E_STOP_APEX_ENGINE THEN
        --
    END;



    FUNCTION get_item_name (
        in_name                 VARCHAR2
    )
    RETURN VARCHAR2 AS
    BEGIN
        RETURN REPLACE(in_name, app.page_item_wild, app.page_item_prefix || app.get_page_id() || '_');
    END;



    FUNCTION get_item (
        in_name                 VARCHAR2,
        in_raise                BOOLEAN         := FALSE
    )
    RETURN VARCHAR2
    AS
        v_item_name             apex_application_page_items.item_name%TYPE;
        is_valid                CHAR;
    BEGIN
        v_item_name := app.get_item_name(in_name);

        -- check item existence to avoid hidden errors
        IF in_raise THEN
            BEGIN
                SELECT 'Y' INTO is_valid
                FROM apex_application_page_items p
                WHERE p.application_id      = app.get_app_id()
                    AND p.page_id           = app.get_page_id()
                    AND p.item_name         = v_item_name;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                BEGIN
                    SELECT 'Y' INTO is_valid
                    FROM apex_application_items g
                    WHERE g.application_id      = app.get_app_id()
                        AND g.item_name         = in_name;
                EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    app.raise_error('ITEM_NOT_FOUND', app.get_json_list(in_name));
                END;
            END;
        END IF;
        --
        RETURN APEX_UTIL.GET_SESSION_STATE(v_item_name);
    END;



    FUNCTION get_number_item (
        in_name                 VARCHAR2,
        in_raise                BOOLEAN         := FALSE
    )
    RETURN NUMBER
    AS
    BEGIN
        RETURN TO_NUMBER(app.get_item(in_name, in_raise));
    EXCEPTION
    WHEN OTHERS THEN
        app.raise_error('INVALID_NUMBER', app.get_json_list(in_name, app.get_item(in_name, in_raise)));
    END;



    FUNCTION get_date_item (
        in_name                 VARCHAR2,
        in_format               VARCHAR2        := NULL,
        in_raise                BOOLEAN         := FALSE
    )
    RETURN DATE
    AS
    BEGIN
        RETURN app.get_date(app.get_item(in_name, in_raise), in_format);
    EXCEPTION
    WHEN OTHERS THEN
        app.raise_error('INVALID_DATE', app.get_json_list(in_name, app.get_item(in_name, in_raise), in_format));
    END;



    FUNCTION get_date (
        in_value                VARCHAR2,
        in_format               VARCHAR2        := NULL
    )
    RETURN DATE
    AS
        l_value                 VARCHAR2(30)    := SUBSTR(REPLACE(in_value, 'T', ' '), 1, 30);
    BEGIN
        IF in_format IS NOT NULL THEN
            BEGIN
                RETURN TO_DATE(l_value, in_format);
            EXCEPTION
            WHEN OTHERS THEN
                app.raise_error('INVALID_DATE', app.get_json_list(in_value, in_format));
            END;
        END IF;

        -- try different formats
        BEGIN
            RETURN TO_DATE(l_value, app.format_date_time);          -- YYYY-MM-DD HH24:MI:SS
        EXCEPTION
        WHEN OTHERS THEN
            BEGIN
                RETURN TO_DATE(l_value, app.format_date_short);     -- YYYY-MM-DD HH24:MI
            EXCEPTION
            WHEN OTHERS THEN
                BEGIN
                    RETURN TO_DATE(l_value, app.format_date);       -- YYYY-MM-DD
                EXCEPTION
                WHEN OTHERS THEN
                    app.raise_error('INVALID_DATE', app.get_json_list(in_value, in_format));
                END;
            END;
        END;
    END;



    PROCEDURE set_item (
        in_name                 VARCHAR2,
        in_value                VARCHAR2        := NULL,
        in_raise                BOOLEAN         := TRUE
    )
    AS
    BEGIN
        APEX_UTIL.SET_SESSION_STATE (
            p_name      => app.get_item(in_name, in_raise),
            p_value     => in_value,
            p_commit    => FALSE
        );
    EXCEPTION
    WHEN OTHERS THEN
        app.raise_error('INVALID_ITEM', app.get_json_list(in_name, in_value));
    END;



    PROCEDURE set_date_item (
        in_name                 VARCHAR2,
        in_value                DATE,
        in_raise                BOOLEAN         := TRUE
    )
    AS
    BEGIN
        APEX_UTIL.SET_SESSION_STATE (
            p_name      => app.get_item(in_name, in_raise),
            p_value     => TO_CHAR(in_value, app.format_date_time),
            p_commit    => FALSE
        );
    EXCEPTION
    WHEN OTHERS THEN
        app.raise_error('INVALID_ITEM', app.get_json_list(in_name, in_value));
    END;



    PROCEDURE clear_items
    AS
        req VARCHAR2(32767) := app.get_request_url();
    BEGIN
        -- delete page items one by one, except items passed in url (query string)
        FOR c IN (
            SELECT i.item_name
            FROM apex_application_page_items i
            WHERE i.application_id  = app.get_app_id()
                AND i.page_id       = app.get_page_id()
                AND (
                    NOT REGEXP_LIKE(req, '[:,]' || i.item_name || '[,:]')       -- for legacy
                    AND NOT REGEXP_LIKE(req, LOWER(i.item_name) || '[=&]')      -- for friendly url
                )
        ) LOOP
            app.set_item (
                in_name     => c.item_name,
                in_value    => NULL,
                in_raise    => FALSE
            );
        END LOOP;
    END;



    FUNCTION get_page_items (
        in_page_id              logs.page_id%TYPE       := NULL,
        in_filter               logs.arguments%TYPE     := '%'
    )
    RETURN VARCHAR2
    AS
        out_payload             VARCHAR2(32767);
    BEGIN
        SELECT JSON_OBJECTAGG(t.item_name VALUE APEX_UTIL.GET_SESSION_STATE(t.item_name) ABSENT ON NULL)
        INTO out_payload
        FROM apex_application_page_items t
        WHERE t.application_id  = app.get_app_id()
            AND t.page_id       = COALESCE(in_page_id, app.get_page_id())
            AND t.item_name     LIKE in_filter;
        --
        RETURN out_payload;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



    FUNCTION get_global_items (
        in_filter               logs.arguments%TYPE     := '%'
    )
    RETURN VARCHAR2
    AS
        out_payload             VARCHAR2(32767);
    BEGIN
        SELECT JSON_OBJECTAGG(t.item_name VALUE APEX_UTIL.GET_SESSION_STATE(t.item_name) ABSENT ON NULL)
        INTO out_payload
        FROM apex_application_items t
        WHERE t.application_id  = app.get_app_id()
            AND t.item_name     LIKE in_filter;
        --
        RETURN out_payload;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



    PROCEDURE apply_items (
        in_items                VARCHAR2
    )
    AS
        json_keys               JSON_KEY_LIST;
    BEGIN
        IF in_items IS NULL THEN
            RETURN;
        END IF;
        --
        json_keys := JSON_OBJECT_T(in_items).get_keys();
        --
        FOR i IN 1 .. json_keys.COUNT LOOP
            BEGIN
                app.set_item(json_keys(i), JSON_VALUE(in_items, '$.' || json_keys(i)));
            EXCEPTION
            WHEN OTHERS THEN
                NULL;
            END;
        END LOOP;
    END;



    FUNCTION get_time_bucket (
        in_date                 DATE,
        in_interval             NUMBER
    )
    RETURN NUMBER
    RESULT_CACHE
    AS
        PRAGMA UDF;
    BEGIN
        RETURN FLOOR((in_date - TRUNC(in_date)) * 1440 / in_interval) + 1;
    END;



    FUNCTION get_duration (
        in_interval             INTERVAL DAY TO SECOND
    )
    RETURN VARCHAR2 AS
    BEGIN
        RETURN REGEXP_SUBSTR(in_interval, '(\d{2}:\d{2}:\d{2}\.\d{3})');
    END;



    FUNCTION get_duration (
        in_interval             NUMBER
    )
    RETURN VARCHAR2 AS
    BEGIN
        RETURN TO_CHAR(TRUNC(SYSDATE) + in_interval, 'HH24:MI:SS');
    END;



    FUNCTION get_duration (
        in_start                TIMESTAMP,
        in_end                  TIMESTAMP       := NULL
    )
    RETURN VARCHAR2
    AS
        v_end                   CONSTANT logs.created_at%TYPE := SYSTIMESTAMP;  -- to prevent timezone shift, APEX_UTIL.GET_SESSION_TIME_ZONE
    BEGIN
        RETURN SUBSTR(TO_CHAR(COALESCE(in_end, v_end) - in_start), 12, 12);     -- keep 00:00:00.000
    END;



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
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN NULLIF(REGEXP_REPLACE(
            REGEXP_REPLACE(
                NULLIF(JSON_ARRAY(in_arg1, in_arg2, in_arg3, in_arg4, in_arg5, in_arg6, in_arg7, in_arg8 NULL ON NULL), '[]'),
                '"(\d+)([.,]\d+)?"', '\1\2'  -- convert to numbers if possible
            ),
            '(,null)+\]$', ']'),  -- strip NULLs from the right side
            '[null]');
    END;



    FUNCTION get_json_object (
        in_name1                VARCHAR2    := NULL,        in_value1               VARCHAR2    := NULL,
        in_name2                VARCHAR2    := NULL,        in_value2               VARCHAR2    := NULL,
        in_name3                VARCHAR2    := NULL,        in_value3               VARCHAR2    := NULL,
        in_name4                VARCHAR2    := NULL,        in_value4               VARCHAR2    := NULL,
        in_name5                VARCHAR2    := NULL,        in_value5               VARCHAR2    := NULL,
        in_name6                VARCHAR2    := NULL,        in_value6               VARCHAR2    := NULL,
        in_name7                VARCHAR2    := NULL,        in_value7               VARCHAR2    := NULL,
        in_name8                VARCHAR2    := NULL,        in_value8               VARCHAR2    := NULL
    )
    RETURN VARCHAR2
    AS
        v_obj                   JSON_OBJECT_T;
    BEGIN
        v_obj := JSON_OBJECT_T(JSON_OBJECT (
            CASE WHEN (in_name1 IS NULL OR in_value1 IS NULL) THEN '__' ELSE in_name1 END VALUE in_value1,
            CASE WHEN (in_name2 IS NULL OR in_value2 IS NULL) THEN '__' ELSE in_name2 END VALUE in_value2,
            CASE WHEN (in_name3 IS NULL OR in_value3 IS NULL) THEN '__' ELSE in_name3 END VALUE in_value3,
            CASE WHEN (in_name4 IS NULL OR in_value4 IS NULL) THEN '__' ELSE in_name4 END VALUE in_value4,
            CASE WHEN (in_name5 IS NULL OR in_value5 IS NULL) THEN '__' ELSE in_name5 END VALUE in_value5,
            CASE WHEN (in_name6 IS NULL OR in_value6 IS NULL) THEN '__' ELSE in_name6 END VALUE in_value6,
            CASE WHEN (in_name7 IS NULL OR in_value7 IS NULL) THEN '__' ELSE in_name7 END VALUE in_value7,
            CASE WHEN (in_name8 IS NULL OR in_value8 IS NULL) THEN '__' ELSE in_name8 END VALUE in_value8
        ));
        v_obj.REMOVE('__');
        RETURN v_obj.STRINGIFY;
    END;



    FUNCTION log_request
    RETURN logs.log_id%TYPE
    AS
    BEGIN
        map_tree := arr_map_tree();
        --
        RETURN app.log__ (
            in_flag             => app.flag_request,
            in_action_name      => app.get_request(),
            in_arguments        => app.get_request_url()
        );
    END;



    FUNCTION log_module (
        in_action_name          logs.action_name%TYPE   := NULL,
        in_args                 logs.arguments%TYPE     := NULL
    )
    RETURN logs.log_id%TYPE
    AS
    BEGIN
        RETURN app.log__ (
            in_flag             => app.flag_module,
            in_action_name      => in_action_name,
            in_arguments        => in_args
        );
    END;



    PROCEDURE log_module (
        in_action_name          logs.action_name%TYPE   := NULL,
        in_args                 logs.arguments%TYPE     := NULL
    )
    AS
        curr_id                 logs.log_id%TYPE;
    BEGIN
        curr_id := app.log__ (
            in_flag             => app.flag_module,
            in_action_name      => in_action_name,
            in_arguments        => in_args
        );
    END;



    PROCEDURE log_debug (
        in_action_name          logs.action_name%TYPE   := NULL,
        in_args                 logs.arguments%TYPE     := NULL,
        in_payload              logs.payload%TYPE       := NULL
    )
    AS
        curr_id                 logs.log_id%TYPE;
    BEGIN
        curr_id := app.log__ (
            in_flag             => app.flag_debug,
            in_action_name      => in_action_name,
            in_arguments        => in_args,
            in_payload          => in_payload
        );
    END;



    PROCEDURE log_result (
        in_action_name          logs.action_name%TYPE   := NULL,
        in_args                 logs.arguments%TYPE     := NULL,
        in_payload              logs.payload%TYPE       := NULL
    )
    AS
        curr_id                 logs.log_id%TYPE;
    BEGIN
        curr_id := app.log__ (
            in_flag             => app.flag_result,
            in_action_name      => in_action_name,
            in_arguments        => in_args,
            in_payload          => in_payload
        );
    END;



    PROCEDURE log_warning (
        in_action_name          logs.action_name%TYPE   := NULL,
        in_args                 logs.arguments%TYPE     := NULL
    )
    AS
        curr_id                 logs.log_id%TYPE;
    BEGIN
        curr_id := app.log__ (
            in_flag             => app.flag_warning,
            in_action_name      => in_action_name,
            in_arguments        => in_args
        );
    END;



    FUNCTION log_error (
        in_action_name          logs.action_name%TYPE   := NULL,
        in_args                 logs.arguments%TYPE     := NULL,
        in_payload              logs.payload%TYPE       := NULL
    )
    RETURN logs.log_id%TYPE
    AS
    BEGIN
        RETURN app.log__ (
            in_flag             => app.flag_error,
            in_action_name      => in_action_name,
            in_arguments        => in_args
        );
    END;



    PROCEDURE log_error (
        in_action_name          logs.action_name%TYPE   := NULL,
        in_args                 logs.arguments%TYPE     := NULL,
        in_payload              logs.payload%TYPE       := NULL
    )
    AS
        curr_id                 logs.log_id%TYPE;
    BEGIN
        curr_id := app.log__ (
            in_flag             => app.flag_error,
            in_action_name      => in_action_name,
            in_arguments        => in_args
        );
    END;



    PROCEDURE log_success (
        in_log_id               logs.log_id%TYPE        := NULL,
        in_payload              logs.payload%TYPE       := NULL
    )
    AS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        -- update timer
        UPDATE logs l
        SET l.module_time   = app.get_duration(in_start => l.created_at),
            l.payload       = NVL(in_payload, l.payload)
        WHERE l.log_id      = NVL(in_log_id, recent_log_id);
        --
        COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        app.raise_error();
    END;



    PROCEDURE log_success (
        in_log_id               logs.log_id%TYPE,
        in_rows_inserted        NUMBER,
        in_rows_updated         NUMBER,
        in_rows_deleted         NUMBER,
        in_last_rowid           VARCHAR2                := NULL,
        in_payload              logs.payload%TYPE       := NULL
    ) AS
        PRAGMA AUTONOMOUS_TRANSACTION;
        --
        v_args                  logs.arguments%TYPE;
    BEGIN
        v_args := app.get_json_object (
            'inserted',     NULLIF(in_rows_inserted, 0),
            'updated',      NULLIF(in_rows_updated, 0),
            'deleted',      NULLIF(in_rows_deleted, 0),
            'rowid',        in_last_rowid
        );
        --
        UPDATE logs l
        SET l.arguments     = v_args,
            l.payload       = NVL(in_payload, l.payload),
            l.module_time   = app.get_duration(in_start => l.created_at)
        WHERE l.log_id      = in_log_id;
        --
        COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        app.raise_error();
    END;



    FUNCTION log_trigger (
        in_action_name          logs.action_name%TYPE   := NULL,
        in_args                 logs.arguments%TYPE     := NULL,
        in_payload              logs.payload%TYPE       := NULL
    )
    RETURN logs.log_id%TYPE
    AS
    BEGIN
        RETURN app.log__ (
            in_flag             => app.flag_trigger,
            in_action_name      => in_action_name,
            in_arguments        => in_args
        );
    END;



    PROCEDURE log_progress (
        in_action_name          logs.action_name%TYPE           := NULL,
        in_progress             NUMBER                          := NULL  -- in percent (0-1)
    )
    AS
        PRAGMA AUTONOMOUS_TRANSACTION;
        --
        slno                    BINARY_INTEGER;
        rec                     logs%ROWTYPE;
    BEGIN
        NULL;
        /*
        callstack_hash := app.get_hash();
        IF map_tree.EXISTS(callstack_hash) THEN
            rec.log_parent := map_tree(callstack_hash);
        END IF;
        --
        IF rec.log_parent IS NULL THEN
        END IF;


        -- find longops record
        IF NVL(in_progress, 0) = 0 THEN
            -- first visit
            SELECT l.* INTO rec
            FROM logs l
            WHERE l.log_id      = rec.log_parent;
            --
            rec.log_id          := log_id.NEXTVAL;
            rec.log_parent      := rec.log_id;  -- create fresh child
            rec.flag            := app.flag_longops;
            rec.payload         := DBMS_APPLICATION_INFO.SET_SESSION_LONGOPS_NOHINT;    -- rindex
            --
            INSERT INTO logs
            VALUES rec;
        ELSE
            SELECT l.* INTO rec
            FROM logs l
            WHERE l.log_parent  = rec.log_parent
                AND l.flag      = app.flag_longops;

            -- update progress in log
            UPDATE logs l
            SET l.arguments     = ROUND(NVL(in_progress, 0) * 100, 2) || '%',
                l.payload       = rec.payload,
                l.module_time   = app.get_duration(in_start => rec.created_at)
            WHERE l.log_id      = rec.log_id;
        END IF;

        -- update progress for system views
        DBMS_APPLICATION_INFO.SET_SESSION_LONGOPS (
            rindex          => rec.payload,
            slno            => slno,
            op_name         => rec.module_name,     -- 64 chars
            target_desc     => rec.action_name,     -- 32 chars
            context         => rec.log_id,
            sofar           => LEAST(NVL(in_progress, 0), 1)
            totalwork       => 1,                   -- 1 = 100%
            units           => '%'
        );
*/
        --
        COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        app.raise_error();
    END;



    FUNCTION log_event (
        in_event_id             logs_events.event_id%TYPE,
        in_event_value          logs_events.event_value%TYPE    := NULL,
        in_parent_id            logs.log_parent%TYPE            := NULL
    )
    RETURN logs_events.log_id%TYPE
    AS
        PRAGMA AUTONOMOUS_TRANSACTION;
        --
        rec                     logs_events%ROWTYPE;
    BEGIN
        rec.app_id              := app.get_app_id();
        rec.event_id            := in_event_id;

        -- check if event is active
        BEGIN
            SELECT e.event_id INTO rec.event_id
            FROM events e
            WHERE e.app_id          = rec.app_id
                AND e.event_id      = rec.event_id
                AND e.is_active     = 'Y';
        EXCEPTION
        WHEN NO_DATA_FOUND THEN

            IF app.is_developer() THEN
                -- create event on the fly for developers
                BEGIN
                    INSERT INTO events (app_id, event_id, is_active, updated_by, updated_at)
                    VALUES (
                        rec.app_id,
                        rec.event_id,
                        'Y',
                        app.get_user_id(),
                        SYSDATE
                    );
                EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                    RETURN NULL;  -- must be inactive
                END;
            ELSE
                RETURN NULL;
            END IF;
        END;

        -- store in event table
        rec.log_id          := log_id.NEXTVAL;
        rec.log_parent      := NVL(in_parent_id, recent_log_id);
        rec.page_id         := app.get_page_id();
        rec.user_id         := app.get_user_id();
        rec.session_id      := app.get_session_id();
        rec.event_value     := in_event_value;
        rec.created_at      := SYSDATE;
        --
        INSERT INTO logs_events VALUES rec;
        COMMIT;
        --
        RETURN rec.log_id;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        app.raise_error();
    END;



    PROCEDURE log_event (
        in_event_id             logs_events.event_id%TYPE,
        in_event_value          logs_events.event_value%TYPE    := NULL
    )
    AS
        out_log_id              logs_events.log_id%TYPE;
    BEGIN
        out_log_id := app.log_event (
            in_event_id         => in_event_id,
            in_event_value      => in_event_value
        );
    END;



    --
    -- Log scheduler call and link its logs to this `log_id`
    -- Create and start one time scheduler
    --
    FUNCTION log_scheduler (
        --in_log_id           logs.log_id%TYPE,
        in_job_name             VARCHAR2,                   ------------------     PROCEDURE start_scheduler (
        in_statement            VARCHAR2        := NULL,
        in_comments             VARCHAR2        := NULL,
        in_priority             PLS_INTEGER     := NULL
    )
    RETURN logs.log_id%TYPE
    AS
    BEGIN
        RETURN NULL;
    END;



    --
    -- ^
    --
    PROCEDURE log_scheduler (
        in_log_id               logs.log_id%TYPE
        --in_args ???
    )
    AS
    BEGIN
        NULL;
    END;



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
    RETURN logs.log_id%TYPE
    AS
        PRAGMA AUTONOMOUS_TRANSACTION;
        --
        rec                     logs%ROWTYPE;
        callstack_hash          VARCHAR2(40);
        callstack_depth         PLS_INTEGER                 := 4;
    BEGIN
        -- prepare record
        rec.log_id              := log_id.NEXTVAL;
        rec.log_parent          := COALESCE(in_parent_id,   recent_request_id);
        rec.app_id              := COALESCE(in_app_id,      app.get_app_id());
        rec.page_id             := COALESCE(in_page_id,     app.get_page_id());
        rec.user_id             := COALESCE(in_user_id,     app.get_user_id());
        rec.session_id          := COALESCE(in_session_id,  app.get_session_id());
        rec.flag                := COALESCE(in_flag,        '?');
        --
        rec.module_name         := SUBSTR(COALESCE(in_module_name, app.get_caller_name(callstack_depth)), 1, app.length_module);
        rec.module_line         :=        COALESCE(in_module_line, app.get_caller_line(callstack_depth));
        --
        IF rec.flag = app.flag_error AND rec.module_name = raise_error_procedure THEN
            -- make it more usefull for raised errors, shift by one more
            rec.module_name     := SUBSTR(COALESCE(in_module_name, app.get_caller_name(callstack_depth + 1)), 1, app.length_module);
            rec.module_line     :=        COALESCE(in_module_line, app.get_caller_line(callstack_depth + 1));
        END IF;
        --
        rec.action_name         := SUBSTR(in_action_name,   1, app.length_action);
        rec.arguments           := SUBSTR(in_arguments,     1, app.length_arguments);
        rec.payload             := SUBSTR(in_payload,       1, app.length_payload);
        rec.created_at          := SYSTIMESTAMP;

        -- dont log everything
        IF SQLCODE = 0 AND NOT app.is_log_requested(rec) AND NOT app.is_developer() THEN
            RETURN NULL;
        END IF;

        -- retrieve parent log from map
        IF in_parent_id IS NULL AND rec.flag != app.flag_request THEN
            callstack_hash := app.get_hash(app.get_call_stack (
                in_offset         => callstack_depth + CASE WHEN rec.flag = app.flag_module THEN 1 ELSE 0 END,  -- magic
                in_skip_others    => TRUE,
                in_line_numbers   => FALSE,
                in_splitter       => '|'
            ));
            --
            IF map_tree.EXISTS(callstack_hash) THEN
                rec.log_parent := map_tree(callstack_hash);
            END IF;
        END IF;

        -- save new map record for log hierarchy
        IF rec.flag IN (app.flag_module, app.flag_trigger) THEN
            callstack_hash := app.get_hash(app.get_call_stack (
                in_offset         => callstack_depth,
                in_skip_others    => TRUE,
                in_line_numbers   => FALSE,
                in_splitter       => '|'
            ));
            --
            map_tree(callstack_hash) := rec.log_id;
        END IF;

        -- set session things
        IF rec.flag IN (app.flag_request, app.flag_module) THEN
            recent_log_id := rec.log_id;
            --
            app.set_session (
                in_module_name      => CASE WHEN rec.flag = app.flag_request THEN 'APEX|' || TO_CHAR(rec.app_id) || '|' || TO_CHAR(rec.page_id) ELSE rec.module_name END,
                in_action_name      => rec.action_name,
                in_log_id           => rec.log_id
            );
        END IF;

        -- add call stack
        IF SQLCODE != 0 OR INSTR(app.track_callstack, rec.flag) > 0 OR app.track_callstack = '%' THEN
            rec.payload := SUBSTR(rec.payload || REPLACE(REPLACE(app.get_call_stack(), 'WWV_FLOW', '%'), 'APEX_210100', '%'), 1, app.length_payload);
        END IF;

        -- add error stack
        IF SQLCODE != 0 THEN
            rec.payload := SUBSTR(rec.payload || REPLACE(REPLACE(app.get_error_stack(), 'WWV_FLOW', '%'), 'APEX_210100', '%'), 1, app.length_payload);
        END IF;

        -- print message to console
        IF app.is_developer() THEN
            DBMS_OUTPUT.PUT_LINE(
                rec.log_id || ' ^' || COALESCE(rec.log_parent, 0) || ' [' || rec.flag || ']: ' ||
                --RPAD(' ', (rec.module_depth - 1) * 2, ' ') ||
                rec.module_name || ' [' || rec.module_line || '] ' || rec.action_name ||
                RTRIM(': ' || SUBSTR(rec.arguments, 1, 40), ': ')
            );
        END IF;

        -- finally store record in table
        INSERT INTO logs VALUES rec;
        --
        COMMIT;
        --
        RETURN rec.log_id;
    EXCEPTION
    WHEN OTHERS THEN
        COMMIT;
        --
        DBMS_OUTPUT.PUT_LINE('-- NOT LOGGED ERROR:');
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_CALL_STACK);
        DBMS_OUTPUT.PUT_LINE('-- ^');
        --
        RAISE_APPLICATION_ERROR(app.app_exception_code, 'LOG_FAILED', TRUE);
    END;



    FUNCTION is_log_requested (
        in_row                  logs%ROWTYPE
    )
    RETURN BOOLEAN
    AS
        v_proceed               BOOLEAN := TRUE;
        --
        FUNCTION is_listed (
            in_list             arr_log_setup,
            in_row              logs%ROWTYPE
        )
        RETURN BOOLEAN AS
        BEGIN
            FOR i IN 1 .. in_list.COUNT LOOP
                IF (in_row.module_name  LIKE in_list(i).module_like OR in_list(i).module_like   IS NULL)
                    AND (in_row.flag    = in_list(i).flag           OR in_list(i).flag          IS NULL)
                THEN
                    RETURN TRUE;
                END IF;
            END LOOP;
            --
            RETURN FALSE;
        END;
    BEGIN
        -- check whitelist first
        IF NOT v_proceed THEN
            v_proceed := is_listed (
                in_list     => log_whitelist,
                in_row      => in_row
            );
        END IF;

        -- check blacklist
        IF NOT v_proceed THEN
            IF is_listed (
                in_list     => log_blacklist,
                in_row      => in_row
            ) THEN
                RETURN FALSE;
            END IF;
        END IF;
        --
        RETURN TRUE;
    END;



    PROCEDURE raise_error (
        in_error_name           logs.action_name%TYPE   := NULL,
        in_args                 logs.arguments%TYPE     := NULL,
        in_rollback             BOOLEAN                 := FALSE
    )
    AS
        rec                     logs%ROWTYPE;
    BEGIN
        IF in_rollback THEN
            ROLLBACK;
        END IF;
        --
        rec.action_name := COALESCE(in_error_name, app.get_caller_name(), 'UNEXPECTED_ERROR');
        --
        rec.log_id := app.log_error (
            in_action_name  => rec.action_name,
            in_args         => in_args
        );
        --
        RAISE_APPLICATION_ERROR (
            app.app_exception_code,
            rec.action_name || ' [' || rec.log_id || ']',
            TRUE
        );
    END;



    FUNCTION handle_apex_error (
        p_error                 APEX_ERROR.T_ERROR
    )
    RETURN APEX_ERROR.T_ERROR_RESULT
    AS
        out_result              APEX_ERROR.T_ERROR_RESULT;
        --
        v_log_id                NUMBER;                     -- log_id from your log_error function (returning most likely sequence)
        v_action_name           logs.action_name%TYPE;      -- short error type visible to user
        v_component             logs.action_name%TYPE;      -- to identify source component in your app
    BEGIN
        out_result := APEX_ERROR.INIT_ERROR_RESULT(p_error => p_error);

        -- assign log_id sequence (app specific, probably from sequence)
        IF p_error.ora_sqlcode IN (-1, -2091, -2290, -2291, -2292) THEN
            -- handle constraint violations
            -- ORA-00001: unique constraint violated
            -- ORA-02091: transaction rolled back (can hide a deferred constraint)
            -- ORA-02290: check constraint violated
            -- ORA-02291: integrity constraint violated - parent key not found
            -- ORA-02292: integrity constraint violated - child record found
            v_action_name := 'CONSTRAINT_ERROR|' || APEX_ERROR.EXTRACT_CONSTRAINT_NAME (
                p_error             => p_error,
                p_include_schema    => FALSE
            );
            --
            out_result.message          := v_action_name;
            out_result.display_location := APEX_ERROR.C_INLINE_IN_NOTIFICATION;
            --
        ELSIF p_error.is_internal_error THEN
            v_action_name := 'INTERNAL_ERROR';
        ELSE
            v_action_name := 'UNKNOWN_ERROR';
        END IF;

        -- store incident in your log
        v_component := TO_CHAR(APEX_APPLICATION.G_FLOW_STEP_ID) || '|' || REPLACE(p_error.component.type, 'APEX_APPLICATION_', '') || '|' || p_error.component.name;
        --
        v_log_id := app.log_error (
            in_action_name  => v_action_name,
            in_args         => v_component,
            in_payload      =>
                out_result.message || CHR(10) ||
                APEX_ERROR.GET_FIRST_ORA_ERROR_TEXT(p_error => p_error) || CHR(10) ||
                p_error.ora_sqlerrm || CHR(10) ||
                p_error.error_statement || CHR(10) ||
                p_error.error_backtrace
        );

        -- mark associated page item (when possible)
        IF out_result.page_item_name IS NULL AND out_result.column_alias IS NULL THEN
            APEX_ERROR.AUTO_SET_ASSOCIATED_ITEM (
                p_error         => p_error,
                p_error_result  => out_result
            );
        END IF;

        -- show only the latest error message to common users
        IF (app.is_developer() OR p_error.ora_sqlcode = app.app_exception_code) THEN
            out_result.message := v_action_name || '|' || TO_CHAR(v_log_id) || '<br />' ||
                v_component || '<br />' ||
                out_result.message || '<br />' ||
                APEX_ERROR.GET_FIRST_ORA_ERROR_TEXT(p_error => p_error);
            out_result.additional_info := '';
        ELSIF v_action_name != 'UNKNOWN_ERROR' THEN
            out_result.message          := v_action_name || '|' || TO_CHAR(v_log_id);
            out_result.additional_info  := '';
        ELSE
           out_result.message := REGEXP_REPLACE(out_result.message, '^(ORA' || TO_CHAR(app.app_exception_code) || ': )', '');
        END IF;
        --
        RETURN out_result;
    END;



    PROCEDURE purge_logs (
        in_age                  PLS_INTEGER         := NULL
    )
    AS
        data_exists             PLS_INTEGER;
        --
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        app.log_module(in_age);

        -- purge all
        IF in_age < 0 THEN
            EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || app.logs_table_name || ' CASCADE';
        END IF;

        -- remove old sessions
        DELETE FROM sessions s
        WHERE s.created_at < TRUNC(SYSDATE) - NVL(in_age, app.logs_max_age);

        -- remove old partitions
        FOR c IN (
            SELECT p.table_name, p.partition_name
            FROM user_tab_partitions p,
                -- trick to convert LONG to VARCHAR2 on the fly
                XMLTABLE('/ROWSET/ROW'
                    PASSING (DBMS_XMLGEN.GETXMLTYPE(
                        'SELECT p.high_value'                                       || CHR(10) ||
                        'FROM user_tab_partitions p'                                || CHR(10) ||
                        'WHERE p.table_name = ''' || p.table_name || ''''           || CHR(10) ||
                        '    AND p.partition_name = ''' || p.partition_name || ''''
                    ))
                    COLUMNS high_value VARCHAR2(4000) PATH 'HIGH_VALUE'
                ) h
            WHERE p.table_name = app.logs_table_name
                AND TO_DATE(REGEXP_SUBSTR(h.high_value, '(\d{4}-\d{2}-\d{2})'), 'YYYY-MM-DD') < TRUNC(SYSDATE) - COALESCE(in_age, app.logs_max_age)
        ) LOOP
            -- delete old data in batches
            FOR i IN 1 .. 10 LOOP
                EXECUTE IMMEDIATE
                    'DELETE FROM ' || c.table_name ||
                    ' PARTITION (' || c.partition_name || ') WHERE ROWNUM < 100000';
                --
                COMMIT;  -- to reduce UNDO violations
            END LOOP;

            -- check if data in partition exists
            EXECUTE IMMEDIATE
                'SELECT COUNT(*) FROM ' || c.table_name ||
                ' PARTITION (' || c.partition_name || ') WHERE ROWNUM = 1'
                INTO data_exists;
            --
            IF data_exists = 0 THEN
                EXECUTE IMMEDIATE
                    'ALTER TABLE ' || c.table_name ||
                    ' DROP PARTITION ' || c.partition_name || ' UPDATE GLOBAL INDEXES';
            END IF;
        END LOOP;
        --
        COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        COMMIT;
        app.raise_error();
    END;



    PROCEDURE purge_logs (
        in_log_id               logs.log_id%TYPE
    ) AS
        rows_to_delete          app.arr_logs_log_id;
        --
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        SELECT l.log_id
        BULK COLLECT INTO rows_to_delete
        FROM logs l
        CONNECT BY PRIOR l.log_id   = l.log_parent
        START WITH l.log_id         = in_log_id;
        --
        FORALL i IN rows_to_delete.FIRST .. rows_to_delete.LAST
        DELETE FROM logs
        WHERE log_id = rows_to_delete(i);
        --
        COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        COMMIT;
        app.raise_error();
    END;



    FUNCTION get_caller_name (
        in_offset               PLS_INTEGER     := NULL
    )
    RETURN logs.module_name%TYPE
    AS
    BEGIN
        RETURN SUBSTR(UTL_CALL_STACK.CONCATENATE_SUBPROGRAM(UTL_CALL_STACK.SUBPROGRAM(NVL(in_offset, 2))), 1, app.length_module);
    EXCEPTION
    WHEN BAD_DEPTH THEN
        RETURN NULL;
    END;



    FUNCTION get_caller_line (
        in_offset               PLS_INTEGER     := NULL
    )
    RETURN logs.module_line%TYPE
    AS
    BEGIN
        RETURN UTL_CALL_STACK.UNIT_LINE(NVL(in_offset, 2));
    EXCEPTION
    WHEN BAD_DEPTH THEN
        RETURN NULL;
    END;



    FUNCTION get_hash (
        in_payload      VARCHAR2
    )
    RETURN VARCHAR2
    RESULT_CACHE
    AS
        out_ VARCHAR2(40);
    BEGIN
        -- quick hash alg, shame we need a context switch, compensate with result cache
        SELECT STANDARD_HASH(in_payload) INTO out_
        FROM DUAL;
        --
        RETURN out_;
    END;



    FUNCTION get_call_stack (
        in_offset               PLS_INTEGER     := NULL,
        in_skip_others          BOOLEAN         := FALSE,
        in_line_numbers         BOOLEAN         := TRUE,
        in_splitter             VARCHAR2        := CHR(10)
    )
    RETURN logs.payload%TYPE
    AS
        out_stack       VARCHAR2(32767);
        out_module      logs.module_name%TYPE;
    BEGIN
        -- better version of DBMS_UTILITY.FORMAT_CALL_STACK
        FOR i IN REVERSE NVL(in_offset, 2) .. UTL_CALL_STACK.DYNAMIC_DEPTH LOOP  -- 2 = ignore this function, 3 = ignore caller
            CONTINUE WHEN in_skip_others AND NVL(UTL_CALL_STACK.OWNER(i), '-') != app.schema_owner;
            --
            out_module  := SUBSTR(UTL_CALL_STACK.CONCATENATE_SUBPROGRAM(UTL_CALL_STACK.SUBPROGRAM(i)), 1, app.length_module);
            out_stack   := out_stack || out_module || CASE WHEN in_line_numbers THEN ' [' || TO_CHAR(UTL_CALL_STACK.UNIT_LINE(i)) || ']' END || in_splitter;
        END LOOP;
        --
        RETURN out_stack;
    END;



    FUNCTION get_error_stack
    RETURN logs.payload%TYPE
    AS
        out_stack       VARCHAR2(32767);
    BEGIN
        -- switch NLS to get error message in english
        BEGIN
            DBMS_SESSION.SET_NLS('NLS_LANGUAGE', '''ENGLISH''');
        EXCEPTION
        WHEN OTHERS THEN    -- cant set NLS in triggers
            NULL;
        END;

        -- better version of DBMS_UTILITY.FORMAT_ERROR_STACK, FORMAT_ERROR_BACKTRACE
        FOR i IN REVERSE 1 .. UTL_CALL_STACK.ERROR_DEPTH LOOP
            BEGIN
                out_stack := out_stack ||
                    UTL_CALL_STACK.BACKTRACE_UNIT(i) || ' [' || UTL_CALL_STACK.BACKTRACE_LINE(i) || '] ' ||
                    'ORA-' || LPAD(UTL_CALL_STACK.ERROR_NUMBER(i), 5, '0') || ' ' ||
                    UTL_CALL_STACK.ERROR_MSG(i) || CHR(10);
            EXCEPTION
            WHEN BAD_DEPTH THEN
                NULL;
            END;
        END LOOP;
        --
        RETURN out_stack;
    END;



    FUNCTION get_log_root (
        in_log_id               logs.log_id%TYPE        := NULL
    )
    RETURN logs.log_id%TYPE
    AS
        out_log_id              logs.log_id%TYPE;
    BEGIN
        SELECT MIN(COALESCE(e.log_parent, e.log_id)) INTO out_log_id
        FROM logs e
        CONNECT BY PRIOR e.log_parent = e.log_id
        START WITH e.log_id = COALESCE(in_log_id, recent_log_id);
        --
        RETURN out_log_id;
    END;



    FUNCTION get_log_tree_id
    RETURN logs.log_id%TYPE
    AS
    BEGIN
        RETURN recent_tree_id;
    END;



    PROCEDURE set_log_tree_id (
        in_log_id               logs.log_id%TYPE
    ) AS
    BEGIN
        recent_tree_id := in_log_id;
    END;



    PROCEDURE call_custom_procedure (
        in_name                 VARCHAR2 := NULL,
        in_arg1                 VARCHAR2 := NULL,
        in_arg2                 VARCHAR2 := NULL,
        in_arg3                 VARCHAR2 := NULL,
        in_arg4                 VARCHAR2 := NULL
    ) AS
        v_object_name           VARCHAR2(64);
        v_args                  PLS_INTEGER;
        is_valid                CHAR;
    BEGIN
        -- determice object name from caller (based on current application)
        v_object_name := COALESCE(in_name, 'A' || app.get_app_id() || '.' || REGEXP_REPLACE(app.get_caller_name(3), '([^\.]+\.)', ''));
        --
        app.log_module(in_args => app.get_json_list(v_object_name, in_arg1, in_arg2, in_arg3, in_arg4));

        -- check object existance
        BEGIN
            SELECT 'Y' INTO is_valid
            FROM user_procedures p
            WHERE RTRIM(p.object_name || '.' || p.procedure_name, '.') = UPPER(v_object_name)
                AND p.object_type   IN ('PACKAGE', 'PROCEDURE')
                AND p.overload      IS NULL;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            app.log_warning('PROCEDURE_MISSING');
            RETURN;
        END;

        -- check object arguments
        SELECT COUNT(*) INTO v_args
        FROM user_arguments a
        WHERE RTRIM(a.package_name || '.' || a.object_name, '.') = UPPER(v_object_name)
            AND a.position      > 0
            AND a.in_out        = 'IN';
        --
        BEGIN
            CASE v_args
                WHEN 1 THEN EXECUTE IMMEDIATE 'BEGIN ' || v_object_name || '(:1); END;'             USING in_arg1;
                WHEN 2 THEN EXECUTE IMMEDIATE 'BEGIN ' || v_object_name || '(:1, :2); END;'         USING in_arg1, in_arg2;
                WHEN 3 THEN EXECUTE IMMEDIATE 'BEGIN ' || v_object_name || '(:1, :2, :3); END;'     USING in_arg1, in_arg2, in_arg3;
                WHEN 4 THEN EXECUTE IMMEDIATE 'BEGIN ' || v_object_name || '(:1, :2, :3, :4); END;' USING in_arg1, in_arg2, in_arg3, in_arg4;
                ELSE        EXECUTE IMMEDIATE 'BEGIN ' || v_object_name || '(); END;';
                END CASE;
        EXCEPTION
        WHEN app.app_exception THEN
            RAISE;
        WHEN OTHERS THEN
            app.raise_error('CUSTOM_CODE_FAILED');
        END;
        --
        app.log_success();
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
    END;



    --
    -- @TODO:
    --
    FUNCTION call_custom_function (
        in_name                 VARCHAR2 := NULL,
        in_arg1                 VARCHAR2 := NULL,
        in_arg2                 VARCHAR2 := NULL,
        in_arg3                 VARCHAR2 := NULL,
        in_arg4                 VARCHAR2 := NULL
    )
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN NULL;
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
    END;



    PROCEDURE init
    AS
    BEGIN
        -- clear map for tracking logs hierarchy
        map_tree := arr_map_tree();

        -- load whitelist/blacklist data from logs_tracing table
        -- prepare arrays when session starts
        -- this block is initialized with every APEX request
        -- so user_id and page_id, debug mode wont change until next request
        SELECT t.*
        BULK COLLECT INTO log_whitelist
        FROM logs_setup t
        WHERE t.app_id          = app.get_app_id()
            AND (t.user_id      = app.get_user_id()     OR t.user_id    IS NULL)
            AND (t.page_id      = app.get_page_id()     OR t.page_id    IS NULL)
            AND t.is_ignored    IS NULL;
        --
        SELECT t.*
        BULK COLLECT INTO log_blacklist
        FROM logs_setup t
        WHERE t.app_id          = app.get_app_id()
            AND (t.user_id      = app.get_user_id()     OR t.user_id    IS NULL)
            AND (t.page_id      = app.get_page_id()     OR t.page_id    IS NULL)
            AND t.is_ignored    = 'Y';
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
    END;

END;
/