CREATE OR REPLACE PACKAGE BODY app AS

    recent_log_id               logs.log_id%TYPE;       -- for events
    recent_request_id           logs.log_id%TYPE;       -- for tracking APEX requests
    recent_tree_id              logs.log_id%TYPE;       -- for logs_tree view
    --
    map_tree                    app.arr_map_tree;

    -- possible exception when parsing call stack
    BAD_DEPTH EXCEPTION;
    PRAGMA EXCEPTION_INIT(BAD_DEPTH, -64610);

    --
    raise_error_procedure       CONSTANT logs.module_name%TYPE := 'APP.RAISE_ERROR';





    FUNCTION get_app_id
    RETURN sessions.app_id%TYPE
    AS
        out_app_id              sessions.app_id%TYPE;
    BEGIN
        IF APEX_APPLICATION.G_FLOW_ID = app.get_core_app_id() THEN
            SELECT MIN(s.app_id) KEEP (DENSE_RANK FIRST ORDER BY s.updated_at DESC) INTO out_app_id
            FROM sessions s
            WHERE s.session_id  = app.get_session_id()
                AND s.app_id    !=  app.get_core_app_id();
        END IF;
        --
        RETURN COALESCE(out_app_id, APEX_APPLICATION.G_FLOW_ID, 0);
    END;



    FUNCTION get_real_app_id
    RETURN sessions.app_id%TYPE
    AS
    BEGIN
        RETURN COALESCE(APEX_APPLICATION.G_FLOW_ID, 0);
    END;



    FUNCTION get_core_app_id
    RETURN sessions.app_id%TYPE
    RESULT_CACHE
    AS
        out_id                  apex_applications.application_id%TYPE;
    BEGIN
        SELECT a.application_id INTO out_id
        FROM apex_applications a
        WHERE a.alias = app.core_alias;
        --
        RETURN out_id;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        app.raise_error('CORE_MISSING');
    END;



    FUNCTION get_owner (
        in_app_id               apps.app_id%TYPE
    )
    RETURN apex_applications.owner%TYPE
    RESULT_CACHE
    AS
        out_owner               apex_applications.owner%TYPE;
    BEGIN
        SELECT a.owner INTO out_owner
        FROM apex_applications a
        WHERE a.application_id = in_app_id;
        --
        RETURN out_owner;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



    FUNCTION get_app_homepage (
        in_app_id               apps.app_id%TYPE            := NULL
    )
    RETURN NUMBER
    AS
        v_app_id                apps.app_id%TYPE            := COALESCE(in_app_id, app.get_app_id());
        out_page_id             navigation.page_id%TYPE;
    BEGIN
        SELECT TO_NUMBER(REGEXP_SUBSTR(a.home_link, ':(\d+):&' || 'SESSION\.', 1, 1, NULL, 1))
        INTO out_page_id
        FROM apex_applications a
        WHERE a.application_id = v_app_id;
        --
        IF out_page_id IS NULL THEN
            SELECT p.page_id INTO out_page_id
            FROM apex_applications a
            JOIN apex_application_pages p
                ON p.application_id = a.application_id
                AND p.page_alias = REGEXP_SUBSTR(a.home_link, ':([^:]+):&' || 'SESSION\.', 1, 1, NULL, 1)
            WHERE a.application_id = v_app_id;
        END IF;
        --
        RETURN out_page_id;
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
        APEX_UTIL.SET_SESSION_LANG(REPLACE(app.get_user_lang(), 'CZ', 'CS'));
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
        WHERE u.user_id     = app.get_user_id()
            AND u.lang_id   IS NOT NULL;
        --
        RETURN out_lang;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        BEGIN
            RETURN REPLACE(UPPER(SUBSTR(OWA_UTIL.GET_CGI_ENV('HTTP_ACCEPT_LANGUAGE'), 1, 2)), 'CS', 'CZ');
        EXCEPTION
        WHEN OTHERS THEN
            RETURN 'EN';
        END;
    END;



    FUNCTION get_translated_item (
        in_name                 VARCHAR2,
        in_page_id              navigation.page_id%TYPE     := NULL,
        in_app_id               navigation.app_id%TYPE      := NULL,
        in_lang                 users.lang_id%TYPE          := NULL,
        in_exact_match          BOOLEAN                     := FALSE
    )
    RETURN VARCHAR2
    AS
        out_value               translated_items.value_en%TYPE;
        out_default             translated_items.value_en%TYPE;
    BEGIN
        -- how often do you add new languages?
        SELECT
            CASE COALESCE(in_lang, app.get_user_lang(), 'EN')
                WHEN 'CZ' THEN  MIN(t.value_cz) KEEP (DENSE_RANK FIRST ORDER BY t.item_name DESC, t.page_id DESC)
                WHEN 'SK' THEN  MIN(t.value_sk) KEEP (DENSE_RANK FIRST ORDER BY t.item_name DESC, t.page_id DESC)
                WHEN 'PL' THEN  MIN(t.value_pl) KEEP (DENSE_RANK FIRST ORDER BY t.item_name DESC, t.page_id DESC)
                WHEN 'HU' THEN  MIN(t.value_hu) KEEP (DENSE_RANK FIRST ORDER BY t.item_name DESC, t.page_id DESC)
                ELSE            MIN(t.value_en) KEEP (DENSE_RANK FIRST ORDER BY t.item_name DESC, t.page_id DESC) END,
            --
            MIN(t.value_en) KEEP (DENSE_RANK FIRST ORDER BY t.item_name DESC, t.page_id DESC)
        INTO out_value, out_default
        FROM translated_items t
        WHERE t.app_id          = COALESCE(in_app_id, app.get_real_app_id())
            AND t.page_id       IN (0, COALESCE(in_page_id, app.get_page_id()))
            AND t.item_name     = in_name;
        --
        RETURN
            CASE WHEN in_name LIKE 'HELP\_%' ESCAPE '\' THEN '<span class="HELP">' END ||
            COALESCE(out_value, out_default, '{' || in_name || '}') ||
            CASE WHEN in_name LIKE 'HELP\_%' ESCAPE '\' THEN '</span>' END;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



    FUNCTION get_translated_message (
        in_name                 VARCHAR2,
        in_app_id               navigation.app_id%TYPE      := NULL,
        in_lang                 users.lang_id%TYPE          := NULL
    )
    RETURN VARCHAR2
    AS
        out_value               translated_messages.value_en%TYPE;
        out_default             translated_messages.value_en%TYPE;
    BEGIN
        -- how often do you add new languages?
        SELECT
            CASE COALESCE(in_lang, app.get_user_lang(), 'EN')
                WHEN 'CZ' THEN  t.value_cz
                WHEN 'SK' THEN  t.value_sk
                WHEN 'PL' THEN  t.value_pl
                WHEN 'HU' THEN  t.value_hu
                ELSE            t.value_en END,
            --
            t.value_en
        INTO out_value, out_default
        FROM translated_messages t
        WHERE t.app_id          = COALESCE(in_app_id, app.get_app_id())
            AND t.message       = in_name;
        --
        RETURN COALESCE(out_value, out_default, in_name);
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



    FUNCTION is_active_user (
        in_user_id              users.user_id%TYPE          := NULL
    )
    RETURN BOOLEAN
    AS
        is_valid                CHAR;
    BEGIN
        SELECT 'Y' INTO is_valid
        FROM users u
        WHERE u.user_id         = COALESCE(in_user_id, app.get_user_id())
            AND u.is_active     = 'Y';
        --
        RETURN TRUE;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
    END;



    FUNCTION is_active_user_y (
        in_user_id              users.user_id%TYPE          := NULL
    )
    RETURN CHAR
    AS
    BEGIN
        RETURN CASE WHEN app.is_active_user(in_user_id) THEN 'Y' END;
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



    PROCEDURE set_debug (
        in_status               BOOLEAN                     := TRUE
    )
    AS
    BEGIN
        APEX_APPLICATION.G_DEBUG := in_status;
        DBMS_OUTPUT.PUT_LINE('DEBUG: ' || CASE WHEN app.is_debug_on() THEN 'ON' ELSE 'OFF' END);
    END;



    FUNCTION get_setting (
        in_name                 settings.setting_name%TYPE,
        in_context              settings.setting_context%TYPE       := NULL
    )
    RETURN settings.setting_value%TYPE
    AS
        out_value               settings.setting_value%TYPE;
    BEGIN
        SELECT s.setting_value INTO out_value
        FROM settings s
        WHERE s.app_id                  = app.get_app_id()
            AND s.setting_name          = in_name
            AND (s.setting_context      = in_context
                OR (
                    s.setting_context   IS NULL
                    AND in_context      IS NULL
                )
            );
        --
        RETURN out_value;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        BEGIN
            SELECT s.setting_value INTO out_value
            FROM settings s
            JOIN setting_contexts c
                ON c.app_id             = s.app_id
                AND c.context_id        = in_context
            WHERE s.app_id              = app.get_app_id()
                AND s.setting_name      = in_name
                AND s.setting_context   IS NULL;
            --
            RETURN out_value;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
        END;
    END;



    FUNCTION get_settings_package
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN CASE
            WHEN app.get_app_id() > 0
                THEN UPPER(app.settings_package) || app.get_app_id()
            END;
    END;



    FUNCTION get_settings_prefix
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN UPPER(app.settings_prefix);
    END;



    PROCEDURE create_session (
        in_init_map             BOOLEAN                     := TRUE
    )
    AS
        PRAGMA AUTONOMOUS_TRANSACTION;
        --
        v_app_id                apps.app_id%TYPE;
        v_user_login            users.user_login%TYPE;
        v_is_active             users.is_active%TYPE;
        rec                     sessions%ROWTYPE;
    BEGIN
        IF in_init_map THEN
            app.init_map();
        END IF;

        --app.log_module();
        v_user_login            := app.get_user_id();
        --
        rec.app_id              := app.get_app_id();
        rec.user_id             := v_user_login;
        rec.session_id          := app.get_session_id();
        rec.created_at          := SYSDATE;
        rec.updated_at          := rec.created_at;

        -- this procedure is starting point in APEX after successful authentication
        -- prevent sessions for anonymous (unlogged) users
        IF (UPPER(rec.user_id) IN (USER, 'NOBODY', 'ORDS_PUBLIC_USER', 'APEX_PUBLIC_USER') OR NVL(rec.app_id, 0) = 0) THEN
            RETURN;
        END IF;

        -- create app record if developers login
        BEGIN
            SELECT a.app_id INTO v_app_id
            FROM apps a
            WHERE a.app_id          = rec.app_id;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            app.log_warning('CREATING_APP', rec.app_id);
            --
            INSERT INTO apps (app_id, updated_by, updated_at)
            SELECT
                a.application_id,
                rec.user_id,
                rec.updated_at
            FROM apex_applications a
            WHERE a.application_id = rec.app_id;

            -- also add first pages into Navigation table
            EXECUTE IMMEDIATE
                'BEGIN app_actions.nav_autoupdate(); END;';  -- to remove dependency
            --
            UPDATE navigation n
            SET n.order# = CASE
                WHEN n.page_id = 0 THEN 599
                ELSE TO_NUMBER(SUBSTR(TO_CHAR(n.page_id), 1, 3))
                END
            WHERE n.app_id = rec.app_id;
        END;

        -- adjust user_id in APEX, init session
        DBMS_SESSION.CLEAR_IDENTIFIER();
        DBMS_APPLICATION_INFO.SET_MODULE (
            module_name => NULL,
            action_name => NULL
        );
        --
        app.set_user_id();                      -- convert user_login to user_id
        rec.user_id := app.get_user_id();       -- update needed

        --
        -- any app/page items set here will be overwriten if clear cache is on
        --

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
        in_page_id              navigation.page_id%TYPE     := NULL,
        in_session_id           sessions.session_id%TYPE    := NULL,
        in_items                VARCHAR2                    := NULL
    ) AS
        PRAGMA AUTONOMOUS_TRANSACTION;
        --
        v_workspace_id          apex_applications.workspace%TYPE;
        v_user_name             apex_workspace_sessions.user_name%TYPE;
    BEGIN
        app.init_map();
        app.log_module_json (
            'user_id',          in_user_id,
            'app_id',           in_app_id,
            'page_id',          in_page_id,
            'session_id',       in_session_id,
            'items',            in_items
        );
        --
        v_user_name := in_user_id;

        -- create session from SQL Developer (not from APEX)
        SELECT MAX(s.user_name) INTO v_user_name
        FROM apex_workspace_sessions s
        WHERE s.apex_session_id = COALESCE(in_session_id, app.get_session_id());
        --
        IF ((v_user_name = app.get_user_id() AND in_app_id = app.get_app_id()) OR in_session_id != app.get_session_id()) THEN
            -- use existing session if possible
            IF (in_session_id > 0 OR in_session_id IS NULL) THEN
                BEGIN
                    APEX_SESSION.ATTACH (
                        p_app_id        => app.get_app_id(),
                        p_page_id       => NVL(in_page_id, 0),
                        p_session_id    => COALESCE(in_session_id, app.get_session_id())
                    );
                EXCEPTION
                WHEN OTHERS THEN
                    app.raise_error('ATTACH_SESSION_FAILED', in_app_id, v_user_name, COALESCE(in_session_id, app.get_session_id()));
                END;
            END IF;
        ELSE
            -- find and setup workspace
            BEGIN
                SELECT a.workspace INTO v_workspace_id
                FROM apex_applications a
                WHERE a.application_id = in_app_id;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                app.raise_error('INVALID_APP', in_app_id);
            END;
            --
            APEX_UTIL.SET_WORKSPACE (
                p_workspace => v_workspace_id
            );
            APEX_UTIL.SET_SECURITY_GROUP_ID (
                p_security_group_id => APEX_UTIL.FIND_SECURITY_GROUP_ID(p_workspace => v_workspace_id)
            );
        END IF;

        -- set username
        APEX_UTIL.SET_USERNAME (
            p_userid    => APEX_UTIL.GET_USER_ID(v_user_name),
            p_username  => v_user_name
        );
        --
        IF in_user_id != v_user_name THEN
            app.log_result(v_user_name);
        END IF;

        -- create new APEX session
        IF (app.get_session_id() IS NULL OR in_session_id = 0) THEN
            BEGIN
                APEX_SESSION.CREATE_SESSION (
                    p_app_id    => in_app_id,
                    p_page_id   => NVL(in_page_id, 0),
                    p_username  => in_user_id
                );
            EXCEPTION
            WHEN OTHERS THEN
                app.raise_error('CREATE_SESSION_FAILED', in_app_id, in_user_id);
            END;
        END IF;

        -- continue with standard process as from APEX
        app.create_session(in_init_map => FALSE);
        --
        IF in_items IS NOT NULL THEN
            app.apply_items(in_items);
        END IF;
        --
        app.log_success(recent_request_id);
        --
        DBMS_OUTPUT.PUT_LINE('--');
        DBMS_OUTPUT.PUT_LINE('SESSION: ' || app.get_app_id() || ' | ' || app.get_page_id() || ' | ' || app.get_session_id() || ' | ' || app.get_user_id());
        DBMS_OUTPUT.PUT_LINE('--');

        -- print app and page items
        FOR c IN (
            SELECT
                i.item_name,
                app.get_item(i.item_name) AS item_value
            FROM apex_application_items i
            WHERE i.application_id      = in_app_id
            UNION ALL
            SELECT
                i.item_name,
                app.get_item(i.item_name) AS item_value
            FROM apex_application_page_items i
            WHERE i.application_id      = in_app_id
                AND i.page_id           = in_page_id
            ORDER BY 1
        ) LOOP
            IF c.item_value IS NOT NULL THEN
                DBMS_OUTPUT.PUT_LINE('  ' || RPAD(c.item_name, 30) || ' = ' || c.item_value);
            END IF;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('--');
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
        app.log_success(recent_request_id);
        --
        -- log_warning for long page loads
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
                DELETE FROM log_events      WHERE log_parent    = v_rows_to_delete(i);
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
        RETURN SYS_CONTEXT('APEX$SESSION', 'APP_SESSION');  -- APEX_APPLICATION.G_INSTANCE
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



    FUNCTION get_env_name
    RETURN VARCHAR2
    AS
        out_name                VARCHAR2(4000);
    BEGIN
        out_name := out_name || 'Environment: ' || SYS_CONTEXT('USERENV', 'SERVER_HOST')    || CHR(10);
        out_name := out_name || 'Instance: '    || SYS_CONTEXT('USERENV', 'INSTANCE_NAME')  || CHR(10);
        --
        IF app.is_developer() THEN
            -- details for developers
            SELECT
                out_name ||
                'Oracle APEX: '     || a.version_no     || CHR(10) ||
                'Oracle DB: '       || p.version_full
            INTO out_name
            FROM apex_release a
            CROSS JOIN product_component_version p;
        END IF;
        --
        RETURN app.get_icon('fa-window-bookmark', out_name);
    END;



    FUNCTION get_role_name (
        in_role_id              roles.role_id%TYPE
    )
    RETURN roles.role_name%TYPE
    AS
        out_name                roles.role_name%TYPE;
    BEGIN
        SELECT NVL(r.role_name, r.role_id) INTO out_name
        FROM roles r
        WHERE r.app_id          = app.get_app_id()
            AND r.role_id       = in_role_id;
        --
        RETURN out_name;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN in_role_id;
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



    FUNCTION get_page_parent (
        in_page_id              navigation.page_id%TYPE     := NULL,
        in_app_id               navigation.app_id%TYPE      := NULL
    )
    RETURN navigation.page_id%TYPE
    AS
        out_id                  apex_application_pages.page_id%TYPE;
    BEGIN
        SELECT n.parent_id INTO out_id
        FROM navigation n
        WHERE n.app_id          = COALESCE(in_app_id, app.get_app_id())
            AND n.page_id       = COALESCE(in_page_id, app.get_page_id());
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
        IF out_name IS NULL THEN
            SELECT p.page_name INTO out_name
            FROM apex_application_pages p
            WHERE p.application_id      = COALESCE(in_app_id, app.get_app_id())
                AND p.page_id           = COALESCE(in_page_id, app.get_page_id());
        END IF;

        -- transform icons
        FOR i IN 1 .. NVL(REGEXP_COUNT(out_name, '(#fa-)'), 0) + 1 LOOP
            out_search  := REGEXP_SUBSTR(out_name, '(#fa-[[:alnum:]+_-]+\s*)+');
            out_name    := REPLACE (
                out_name,
                out_search,
                ' &' || 'nbsp; <span class="fa' || REPLACE(REPLACE(out_search, '#fa-', '+'), '+', ' fa-') || '"></span> &' || 'nbsp; '
            );
        END LOOP;

        -- translations
        out_name := REPLACE (
            out_name,
            '&' || app.transl_page_name || '.',
            COALESCE (
                app.get_translated_item(app.transl_page_name,  in_page_id, in_app_id),
                app.get_translated_item(app.transl_page_title, in_page_id, in_app_id)
            )
        );
        --
        RETURN REGEXP_REPLACE(out_name, '((^\s*&' || 'nbsp;\s*)|(\s*&' || 'nbsp;\s*$))', '');  -- trim hard spaces
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



    FUNCTION get_page_title (
        in_page_id              navigation.page_id%TYPE     := NULL,
        in_app_id               navigation.app_id%TYPE      := NULL,
        in_title                VARCHAR2                    := NULL
    )
    RETURN VARCHAR2
    AS
        out_title               apex_application_pages.page_title%TYPE      := in_title;
    BEGIN
        IF out_title IS NULL THEN
            SELECT p.page_title INTO out_title
            FROM apex_application_pages p
            WHERE p.application_id      = COALESCE(in_app_id, app.get_app_id())
                AND p.page_id           = COALESCE(in_page_id, app.get_page_id());
        END IF;

        -- translations
        out_title := REPLACE(out_title, '&' || app.transl_page_title  || '.', app.get_translated_item(app.transl_page_title, in_page_id, in_app_id));
        out_title := REPLACE(out_title, '&' || app.transl_page_name   || '.', app.get_translated_item(app.transl_page_name,  in_page_id, in_app_id));
        --
        RETURN out_title;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



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
*/

        -- generate url
        RETURN APEX_PAGE.GET_URL (
            p_application       => in_app_id,
            p_session           => COALESCE(in_session_id, app.get_session_id()),
            p_page              => out_page_id,
            p_clear_cache       => CASE WHEN in_reset THEN out_page_id END,
            p_items             => out_names,
            p_values            => NULLIF(out_values, 'NULL')
            /*
            p_request            IN VARCHAR2 DEFAULT NULL,
            p_debug              IN VARCHAR2 DEFAULT NULL,
            p_printer_friendly   IN VARCHAR2 DEFAULT NULL,
            p_trace              IN VARCHAR2 DEFAULT NULL,       
            p_triggering_element IN VARCHAR2 DEFAULT 'this',
            p_plain_url          IN BOOLEAN DEFAULT FALSE
            */
        );
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
    END;



    FUNCTION get_request_url (
        in_arguments_only       BOOLEAN                     := FALSE
    )
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN RTRIM(CASE WHEN NOT in_arguments_only
            THEN UTL_URL.UNESCAPE (
                OWA_UTIL.GET_CGI_ENV('SCRIPT_NAME') ||
                OWA_UTIL.GET_CGI_ENV('PATH_INFO')   || '?'
            ) END ||
            UTL_URL.UNESCAPE(OWA_UTIL.GET_CGI_ENV('QUERY_STRING')), '?');
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
        in_app_id               navigation.app_id%TYPE
    )
    RETURN CHAR
    AS
        v_auth_scheme           apex_application_pages.authorization_scheme%TYPE;
        v_package_name          user_procedures.object_name%TYPE;
        v_procedure_name        user_procedures.procedure_name%TYPE;
        v_data_type             user_arguments.pls_type%TYPE;
        v_page_argument         user_arguments.argument_name%TYPE;
        --
        out_result              CHAR;
        out_result_bool         BOOLEAN;
        --
        PRAGMA UDF;             -- SQL only
    BEGIN
        -- get auth cheme, procedure...
        SELECT
            MIN(p.authorization_scheme),
            MIN(f.package_name),            -- package_name
            MIN(f.object_name),             -- procedure_name
            MIN(f.pls_type),
            MIN(a.argument_name)            -- argument_name            
        INTO v_auth_scheme, v_package_name, v_procedure_name, v_data_type, v_page_argument
        FROM apex_application_pages p
        LEFT JOIN user_procedures s
            ON s.object_name                IN ('A' || TO_CHAR(in_app_id), 'APP', 'AUTH')   -- packages
            AND s.procedure_name            = p.authorization_scheme
        LEFT JOIN user_arguments f
            ON f.object_name                = s.procedure_name
            AND f.package_name              = s.object_name
            AND f.overload                  IS NULL
            AND f.position                  = 0
            AND f.argument_name             IS NULL
            AND f.in_out                    = 'OUT'
        LEFT JOIN user_arguments a
            ON a.object_name                = f.package_name
            AND a.package_name              = f.object_name
            AND a.overload                  IS NULL
            AND a.position                  = 1
            AND a.data_type                 = 'NUMBER'
            AND a.in_out                    = 'IN'
        WHERE p.application_id              = in_app_id
            AND p.page_id                   = in_page_id;

        -- log current page
        IF app.is_debug_on() AND in_page_id = app.get_page_id() THEN
            app.log_action (
                'IS_PAGE_AVAILABLE',
                in_app_id,
                in_page_id,
                v_auth_scheme,
                v_package_name || '.' || v_procedure_name,
                v_data_type,
                v_page_argument
            );
        END IF;

        -- skip global page and login/logout page
        IF in_page_id IN (0, 9999) THEN
            RETURN 'Y';  -- show
        END IF;

        -- check scheme and procedure
        IF v_auth_scheme IS NULL THEN
            app.log_warning('AUTH_SCHEME_MISSING', in_app_id, in_page_id);
            --
            RETURN 'Y';  -- show, page has no authorization set
            --
        ELSIF v_auth_scheme IN ('MUST_NOT_BE_PUBLIC_USER') THEN
            RETURN 'Y';  -- show
            --
        ELSIF v_procedure_name IS NULL THEN
            app.log_warning('AUTH_PROCEDURE_MISSING', in_app_id, in_page_id, v_auth_scheme);
            --
            RETURN 'N';  -- hide, auth function is set on page but missing in AUTH package
        END IF;

        -- call function to evaluate access
        IF v_data_type = 'BOOLEAN' THEN
            IF v_page_argument IS NOT NULL THEN
                -- pass page_id when neeeded
                EXECUTE IMMEDIATE
                    'BEGIN :r := ' || v_package_name || '.' || v_procedure_name || '(:page_id); END;'
                    USING IN in_page_id, OUT out_result_bool;
            ELSE
                EXECUTE IMMEDIATE
                    'BEGIN :r := ' || v_package_name || '.' || v_procedure_name || '; END;'
                    USING OUT out_result_bool;
            END IF;
            --
            RETURN CASE WHEN out_result_bool THEN 'Y' ELSE 'N' END;
        ELSE
            IF v_page_argument IS NOT NULL THEN
                -- pass page_id when neeeded
                EXECUTE IMMEDIATE
                    'BEGIN :r := ' || v_package_name || '.' || v_procedure_name || '(:page_id); END;'
                    USING IN in_page_id, OUT out_result;
            ELSE
                EXECUTE IMMEDIATE
                    'BEGIN :r := ' || v_package_name || '.' || v_procedure_name || '; END;'
                    USING OUT out_result;
            END IF;
        END IF;
        --
        RETURN NVL(out_result, 'N');
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
        out_target := app.get_page_url (
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
        in_name                 apex_application_page_items.item_name%TYPE,
        in_page_id              apex_application_page_items.page_id%TYPE            := NULL,
        in_app_id               apex_application_page_items.application_id%TYPE     := NULL
    )
    RETURN VARCHAR2
    AS
        v_item_name             apex_application_page_items.item_name%TYPE;
        v_page_id               apex_application_page_items.page_id%TYPE;
        v_app_id                apex_application_page_items.application_id%TYPE;
        is_valid                CHAR;
    BEGIN
        v_app_id        := NVL(in_app_id, app.get_real_app_id());
        v_page_id       := NVL(in_page_id, app.get_page_id());
        v_item_name     := REPLACE(in_name, app.page_item_wild, app.page_item_prefix || v_page_id || '_');

        -- check if item exists
        BEGIN
            SELECT 'Y' INTO is_valid
            FROM apex_application_page_items p
            WHERE p.application_id      = v_app_id
                AND p.page_id           IN (0, v_page_id, 947)
                AND p.item_name         = v_item_name;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            BEGIN
                SELECT 'Y' INTO is_valid
                FROM apex_application_items g
                WHERE g.application_id      = v_app_id
                    AND g.item_name         = in_name;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN NULL;
            END;
        END;
        --
        RETURN v_item_name;
    END;



    FUNCTION get_item (
        in_name                 VARCHAR2,
        in_raise                BOOLEAN         := FALSE
    )
    RETURN VARCHAR2
    AS
        v_item_name             apex_application_page_items.item_name%TYPE;
    BEGIN
        v_item_name := app.get_item_name(in_name);

        -- check item existence to avoid hidden errors
        IF v_item_name IS NOT NULL THEN
            RETURN APEX_UTIL.GET_SESSION_STATE(v_item_name);
        ELSIF in_raise THEN
            app.raise_error('ITEM_MISSING', v_item_name, in_name);
        END IF;
        --
        RETURN NULL;
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
        app.raise_error('INVALID_NUMBER', in_name, app.get_item(in_name, in_raise));
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
        app.raise_error('INVALID_DATE', in_name, app.get_item(in_name, in_raise), in_format);
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
                app.raise_error('INVALID_DATE', in_value, in_format);
            END;
        END IF;

        -- try different formats
        BEGIN
            RETURN TO_DATE(l_value, app.format_date_time);                      -- YYYY-MM-DD HH24:MI:SS
        EXCEPTION
        WHEN OTHERS THEN
            BEGIN
                RETURN TO_DATE(l_value, app.format_date_short);                 -- YYYY-MM-DD HH24:MI
            EXCEPTION
            WHEN OTHERS THEN
                BEGIN
                    RETURN TO_DATE(SUBSTR(l_value, 1, 10), app.format_date);    -- YYYY-MM-DD
                EXCEPTION
                WHEN OTHERS THEN
                    BEGIN
                        RETURN TO_DATE(SUBSTR(REPLACE(l_value, '.', '/'), 1, 10), 'DD/MM/YYYY');
                    EXCEPTION
                    WHEN OTHERS THEN
                        app.raise_error('INVALID_DATE', in_value, in_format);
                    END;
                END;
            END;
        END;
    END;



    FUNCTION get_date (
        in_date                 DATE            := NULL,
        in_format               VARCHAR2        := NULL
    )
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN TO_CHAR(COALESCE(in_date, SYSDATE), NVL(in_format, app.format_date));
    END;



    FUNCTION get_date_time (
        in_date                 DATE            := NULL,
        in_format               VARCHAR2        := NULL
    )
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN TO_CHAR(COALESCE(in_date, SYSDATE), NVL(in_format, app.format_date_time));
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



    PROCEDURE set_item (
        in_name                 VARCHAR2,
        in_value                VARCHAR2        := NULL,
        in_raise                BOOLEAN         := TRUE
    )
    AS
        v_item_name             apex_application_page_items.item_name%TYPE;
    BEGIN
        v_item_name := app.get_item_name(in_name);
        --
        IF v_item_name IS NOT NULL THEN
            BEGIN
                APEX_UTIL.SET_SESSION_STATE (
                    p_name      => v_item_name,
                    p_value     => in_value,
                    p_commit    => FALSE
                );
            EXCEPTION
            WHEN OTHERS THEN
                app.raise_error('ITEM_MISSING', v_item_name, in_name);
            END;
        ELSIF in_raise THEN
            app.raise_error('ITEM_MISSING', v_item_name, in_name);
        END IF;
    END;



    PROCEDURE set_date_item (
        in_name                 VARCHAR2,
        in_value                DATE,
        in_raise                BOOLEAN         := TRUE
    )
    AS
    BEGIN
        app.set_item (
            in_name             => in_name,
            in_value            => TO_CHAR(in_value, app.format_date_time),
            in_raise            => in_raise
        );
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
        WHERE t.application_id  = app.get_real_app_id()
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
        WHERE t.application_id  = app.get_real_app_id()
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



    FUNCTION get_region_filters (
        in_region_id            apex_application_page_regions.static_id%TYPE,
        in_page_id              apex_application_page_regions.page_id%TYPE          := NULL,
        in_app_id               apex_application_page_regions.application_id%TYPE   := NULL
    )
    RETURN VARCHAR2
    AS
        out_filters             VARCHAR2(32767);
    BEGIN
        FOR c IN (
            SELECT r.page_id, i.item_name, app.get_item(i.item_name) AS item_value
            FROM user_source_views s
            JOIN apex_application_page_items i
                ON i.item_name          = app.get_item_name(REPLACE(REGEXP_SUBSTR(s.text, '''(\$?[A-Z0-9_]+)[^'']'), ''''), i.page_id, i.application_id)
            JOIN apex_application_page_regions r
                ON r.application_id     = i.application_id
                AND r.page_id           = i.page_id
                AND r.static_id         IS NOT NULL
                AND r.query_type_code   = 'TABLE'
                AND r.table_name        = s.name
                AND s.text              LIKE '%app.get_%item%(%'
            WHERE r.application_id      = COALESCE(in_app_id, app.get_app_id())
                AND r.page_id           = COALESCE(in_page_id, app.get_page_id())
                AND r.static_id         = in_region_id
        ) LOOP
            IF c.item_value IS NOT NULL THEN
                out_filters := out_filters ||
                    '<span class="ITEM_NAME">' || REPLACE(c.item_name, 'P' || c.page_id || '_') || '</span>' ||
                    '<span class="ITEM_VALUE"><a href="' ||
                        app.get_page_url(c.page_id, c.item_name, 'NULL', in_reset => FALSE) ||
                        '" title="Clear filter">' || c.item_value || '</a></span>';
            END IF;
        END LOOP;
        --
        IF out_filters IS NULL THEN
            RETURN NULL;
        END IF;
        --
        RETURN '<div class="REGION_FILTERS"><span class="ITEM_NAME">Active filters:</span>' || out_filters || '</div>';
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
    RETURN VARCHAR2
    AS
        v_obj                   JSON_OBJECT_T;
    BEGIN
        -- construct a key-value pairs
        v_obj := JSON_OBJECT_T(JSON_OBJECT (
            CASE WHEN (in_name01 IS NULL OR in_value01 IS NULL) THEN '__' ELSE in_name01 END VALUE in_value01,
            CASE WHEN (in_name02 IS NULL OR in_value02 IS NULL) THEN '__' ELSE in_name02 END VALUE in_value02,
            CASE WHEN (in_name03 IS NULL OR in_value03 IS NULL) THEN '__' ELSE in_name03 END VALUE in_value03,
            CASE WHEN (in_name04 IS NULL OR in_value04 IS NULL) THEN '__' ELSE in_name04 END VALUE in_value04,
            CASE WHEN (in_name05 IS NULL OR in_value05 IS NULL) THEN '__' ELSE in_name05 END VALUE in_value05,
            CASE WHEN (in_name06 IS NULL OR in_value06 IS NULL) THEN '__' ELSE in_name06 END VALUE in_value06,
            CASE WHEN (in_name07 IS NULL OR in_value07 IS NULL) THEN '__' ELSE in_name07 END VALUE in_value07,
            CASE WHEN (in_name08 IS NULL OR in_value08 IS NULL) THEN '__' ELSE in_name08 END VALUE in_value08,
            CASE WHEN (in_name09 IS NULL OR in_value09 IS NULL) THEN '__' ELSE in_name09 END VALUE in_value09,
            CASE WHEN (in_name10 IS NULL OR in_value10 IS NULL) THEN '__' ELSE in_name10 END VALUE in_value10,
            CASE WHEN (in_name11 IS NULL OR in_value11 IS NULL) THEN '__' ELSE in_name11 END VALUE in_value11,
            CASE WHEN (in_name12 IS NULL OR in_value12 IS NULL) THEN '__' ELSE in_name12 END VALUE in_value12,
            CASE WHEN (in_name13 IS NULL OR in_value13 IS NULL) THEN '__' ELSE in_name13 END VALUE in_value13,
            CASE WHEN (in_name14 IS NULL OR in_value14 IS NULL) THEN '__' ELSE in_name14 END VALUE in_value14,
            CASE WHEN (in_name15 IS NULL OR in_value15 IS NULL) THEN '__' ELSE in_name15 END VALUE in_value15,
            CASE WHEN (in_name16 IS NULL OR in_value16 IS NULL) THEN '__' ELSE in_name16 END VALUE in_value16,
            CASE WHEN (in_name17 IS NULL OR in_value17 IS NULL) THEN '__' ELSE in_name17 END VALUE in_value17,
            CASE WHEN (in_name18 IS NULL OR in_value18 IS NULL) THEN '__' ELSE in_name18 END VALUE in_value18,
            CASE WHEN (in_name19 IS NULL OR in_value19 IS NULL) THEN '__' ELSE in_name19 END VALUE in_value19,
            CASE WHEN (in_name20 IS NULL OR in_value20 IS NULL) THEN '__' ELSE in_name20 END VALUE in_value20
        ));
        v_obj.REMOVE('__');     -- remove empty pairs
        --
        RETURN NULLIF(v_obj.STRINGIFY, '{}');
    END;



    FUNCTION log_request
    RETURN logs.log_id%TYPE
    AS
        v_args                  logs.arguments%TYPE;
    BEGIN
        app.init_map();

        -- parse arguments
        v_args := app.get_request_url(in_arguments_only => TRUE);
        --
        IF v_args IS NOT NULL THEN
            BEGIN
                SELECT JSON_OBJECTAGG (
                    REGEXP_REPLACE(REGEXP_SUBSTR(v_args, '[^&]+', 1, LEVEL), '[=].*$', '')
                    VALUE REGEXP_REPLACE(REGEXP_SUBSTR(v_args, '[^&]+', 1, LEVEL), '^[^=]+[=]', '')
                ) INTO v_args
                FROM DUAL
                CONNECT BY LEVEL <= REGEXP_COUNT(v_args, '&') + 1
                ORDER BY LEVEL;
            EXCEPTION
            WHEN OTHERS THEN
                app.log_error('JSON_ERROR', v_args);
            END;
        END IF;

        -- create log
        RETURN app.log__ (
            in_flag             => app.flag_request,
            in_action_name      => app.get_request(),
            in_arguments        => v_args,
            in_payload          => NULL
        );
    END;



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
    RETURN logs.log_id%TYPE
    AS
    BEGIN
        RETURN app.log__ (
            in_flag             => app.flag_module,
            in_arguments        => app.get_json_list (
                in_arg1,        in_arg2,
                in_arg3,        in_arg4,
                in_arg5,        in_arg6,
                in_arg7,        in_arg8
            ),
            in_payload          => in_payload,
            in_parent_id        => in_parent_id
        );
    END;



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
    )
    AS
        curr_id                 logs.log_id%TYPE;
    BEGIN
        curr_id := app.log__ (
            in_flag             => app.flag_module,
            in_arguments        => app.get_json_list (
                in_arg1,        in_arg2,
                in_arg3,        in_arg4,
                in_arg5,        in_arg6,
                in_arg7,        in_arg8
            ),
            in_payload          => in_payload,
            in_parent_id        => in_parent_id
        );
    END;



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
    RETURN logs.log_id%TYPE
    AS
    BEGIN
        RETURN app.log__ (
            in_flag             => app.flag_module,
            in_arguments        => app.get_json_object (
                in_name01,       in_value01,
                in_name02,       in_value02,
                in_name03,       in_value03,
                in_name04,       in_value04,
                in_name05,       in_value05,
                in_name06,       in_value06,
                in_name07,       in_value07,
                in_name08,       in_value08,
                in_name09,       in_value09,
                in_name10,       in_value10,
                in_name11,       in_value11,
                in_name12,       in_value12,
                in_name13,       in_value13,
                in_name14,       in_value14,
                in_name15,       in_value15,
                in_name16,       in_value16,
                in_name17,       in_value17,
                in_name18,       in_value18,
                in_name19,       in_value19,
                in_name20,       in_value20
            ),
            in_payload          => in_payload,
            in_parent_id        => in_parent_id
        );
    END;



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
    )
    AS
        curr_id                 logs.log_id%TYPE;
    BEGIN
        curr_id := app.log__ (
            in_flag             => app.flag_module,
            in_arguments        => app.get_json_object (
                in_name01,       in_value01,
                in_name02,       in_value02,
                in_name03,       in_value03,
                in_name04,       in_value04,
                in_name05,       in_value05,
                in_name06,       in_value06,
                in_name07,       in_value07,
                in_name08,       in_value08,
                in_name09,       in_value09,
                in_name10,       in_value10,
                in_name11,       in_value11,
                in_name12,       in_value12,
                in_name13,       in_value13,
                in_name14,       in_value14,
                in_name15,       in_value15,
                in_name16,       in_value16,
                in_name17,       in_value17,
                in_name18,       in_value18,
                in_name19,       in_value19,
                in_name20,       in_value20
            ),
            in_payload          => in_payload,
            in_parent_id        => in_parent_id
        );
    END;



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
    RETURN logs.log_id%TYPE
    AS
    BEGIN
        RETURN app.log__ (
            in_flag             => app.flag_action,
            in_action_name      => in_action_name,
            in_arguments        => app.get_json_list (
                in_arg1,        in_arg2,
                in_arg3,        in_arg4,
                in_arg5,        in_arg6,
                in_arg7,        in_arg8
            ),
            in_payload          => in_payload,
            in_parent_id        => in_parent_id
        );
    END;



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
    )
    AS
        curr_id                 logs.log_id%TYPE;
    BEGIN
        curr_id := app.log__ (
            in_flag             => app.flag_action,
            in_action_name      => in_action_name,
            in_arguments        => app.get_json_list (
                in_arg1,        in_arg2,
                in_arg3,        in_arg4,
                in_arg5,        in_arg6,
                in_arg7,        in_arg8
            ),
            in_payload          => in_payload,
            in_parent_id        => in_parent_id
        );
    END;



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
    )
    AS
        curr_id                 logs.log_id%TYPE;
    BEGIN
        curr_id := app.log__ (
            in_flag             => app.flag_debug,
            in_arguments        => app.get_json_list (
                in_arg1,        in_arg2,
                in_arg3,        in_arg4,
                in_arg5,        in_arg6,
                in_arg7,        in_arg8
            ),
            in_payload          => in_payload,
            in_parent_id        => in_parent_id
        );
    END;



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
    )
    AS
        curr_id                 logs.log_id%TYPE;
    BEGIN
        curr_id := app.log__ (
            in_flag             => app.flag_result,
            in_arguments        => app.get_json_list (
                in_arg1,        in_arg2,
                in_arg3,        in_arg4,
                in_arg5,        in_arg6,
                in_arg7,        in_arg8
            ),
            in_payload          => in_payload,
            in_parent_id        => in_parent_id
        );
    END;



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
    )
    AS
        curr_id                 logs.log_id%TYPE;
    BEGIN
        curr_id := app.log__ (
            in_flag             => app.flag_warning,
            in_action_name      => in_action_name,
            in_arguments        => app.get_json_list (
                in_arg1,        in_arg2,
                in_arg3,        in_arg4,
                in_arg5,        in_arg6,
                in_arg7,        in_arg8
            ),
            in_payload          => in_payload,
            in_parent_id        => in_parent_id
        );
    END;



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
    RETURN logs.log_id%TYPE
    AS
    BEGIN
        RETURN app.log__ (
            in_flag             => app.flag_error,
            in_action_name      => in_action_name,
            in_arguments        => app.get_json_list (
                in_arg1,        in_arg2,
                in_arg3,        in_arg4,
                in_arg5,        in_arg6,
                in_arg7,        in_arg8
            ),
            in_payload          => in_payload,
            in_parent_id        => in_parent_id
        );
    END;



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
    )
    AS
        curr_id                 logs.log_id%TYPE;
    BEGIN
        curr_id := app.log__ (
            in_flag             => app.flag_error,
            in_action_name      => in_action_name,
            in_arguments        => app.get_json_list (
                in_arg1,        in_arg2,
                in_arg3,        in_arg4,
                in_arg5,        in_arg6,
                in_arg7,        in_arg8
            ),
            in_payload          => in_payload,
            in_parent_id        => in_parent_id
        );
    END;



    PROCEDURE log_success (
        in_log_id               logs.log_id%TYPE        := NULL,
        in_action_name          logs.action_name%TYPE   := NULL,
        in_payload              logs.payload%TYPE       := NULL
    )
    AS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        -- mark module success by updating timer
        UPDATE logs l
        SET l.action_name   = NVL(in_action_name, l.action_name),
            l.payload       = NVL(in_payload, l.payload),
            l.module_timer  = app.get_duration(in_start => l.created_at)
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
            l.module_timer  = app.get_duration(in_start => l.created_at)
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
    RETURN logs.log_id%TYPE
    AS
    BEGIN
        RETURN app.log__ (
            in_flag             => app.flag_trigger,
            in_action_name      => in_action_name,
            in_arguments        => app.get_json_list (
                in_arg1,        in_arg2,
                in_arg3,        in_arg4,
                in_arg5,        in_arg6,
                in_arg7,        in_arg8
            ),
            in_payload          => in_payload,
            in_parent_id        => in_parent_id
        );
    END;



    PROCEDURE log_progress (
        in_action_name          logs.action_name%TYPE           := NULL,
        in_progress             NUMBER                          := NULL,  -- percentage (1 = 100%)
        in_note                 VARCHAR2                        := NULL,
        in_parent_id            logs.log_id%TYPE                := NULL
    )
    AS
        PRAGMA AUTONOMOUS_TRANSACTION;
        --
        callstack_hash          VARCHAR2(40);
        callstack_depth         PLS_INTEGER         := 2;
        v_rindex                PLS_INTEGER;
        v_slno                  PLS_INTEGER;
        rec                     logs%ROWTYPE;
    BEGIN
        rec.log_parent          := in_parent_id;

        -- find parent from callstack
        IF rec.log_parent IS NULL THEN
            callstack_hash := app.get_hash(app.get_call_stack (
                in_offset         => callstack_depth,
                in_skip_others    => TRUE,
                in_line_numbers   => FALSE,
                in_splitter       => '|'
            ));
            --
            IF map_tree.EXISTS(callstack_hash) THEN
                rec.log_parent := map_tree(callstack_hash);
            END IF;
        END IF;
        --
        IF rec.log_parent IS NULL THEN
            rec.log_parent := recent_log_id;
        END IF;

        -- find parent to get rindex, module and action names
        BEGIN
            SELECT l.log_id, l.module_name, l.action_name, l.arguments, l.created_at
            INTO rec.log_id, rec.module_name, rec.action_name, rec.arguments, rec.created_at
            FROM logs l
            WHERE l.log_id          > rec.log_parent
                AND l.log_parent    = rec.log_parent
                AND l.flag          = app.flag_longops;
            --
            v_rindex := REPLACE(REGEXP_SUBSTR(rec.arguments, '\|[^\|]*$'), '|', '');

            -- update progress in log
            UPDATE logs l
            SET l.arguments     = ROUND(NVL(in_progress, 0) * 100, 2) || '%|' || in_note || '|' || v_rindex,
                l.module_timer  = app.get_duration(in_start => rec.created_at)
            WHERE l.log_id      = rec.log_id;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_rindex := DBMS_APPLICATION_INFO.SET_SESSION_LONGOPS_NOHINT;

            -- create new longops record
            rec.log_id := app.log__ (
                in_flag             => app.flag_longops,
                in_action_name      => in_action_name,
                in_arguments        => ROUND(NVL(in_progress, 0) * 100, 2) || '%|' || in_note || '|' || v_rindex,
                in_parent_id        => rec.log_parent
            );
        END;

        -- update progress for system views
        DBMS_APPLICATION_INFO.SET_SESSION_LONGOPS (
            rindex          => v_rindex,
            slno            => v_slno,
            op_name         => rec.module_name,     -- 64 chars
            target_desc     => rec.action_name,     -- 32 chars
            context         => rec.log_id,
            sofar           => LEAST(NVL(in_progress, 0), 1),
            totalwork       => 1,                   -- 1 = 100%
            units           => '%'
        );
        --
        COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        app.raise_error();
    END;



    FUNCTION log_event (
        in_event_id             log_events.event_id%TYPE,
        in_event_value          log_events.event_value%TYPE     := NULL,
        in_parent_id            logs.log_parent%TYPE            := NULL
    )
    RETURN log_events.log_id%TYPE
    AS
        rec                     log_events%ROWTYPE;
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
                    app.log_warning('CREATING_EVENT', rec.event_id);
                    --
                    INSERT INTO events (app_id, event_id, is_active)
                    VALUES (
                        rec.app_id,
                        rec.event_id,
                        'Y'
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
        INSERT INTO log_events VALUES rec;
        --
        RETURN rec.log_id;
    EXCEPTION
    WHEN OTHERS THEN
        app.raise_error();
    END;



    PROCEDURE log_event (
        in_event_id             log_events.event_id%TYPE,
        in_event_value          log_events.event_value%TYPE     := NULL
    )
    AS
        out_log_id              log_events.log_id%TYPE;
    BEGIN
        out_log_id := app.log_event (
            in_event_id         => in_event_id,
            in_event_value      => in_event_value
        );
    END;



    PROCEDURE log_scheduler (
        in_log_id               logs.log_id%TYPE,
        in_job_name             VARCHAR2
    )
    AS
        curr_id                 logs.log_id%TYPE;
    BEGIN
        curr_id := app.log__ (
            in_flag             => app.flag_scheduler,
            in_arguments        => REPLACE(in_job_name, '"', ''),
            in_parent_id        => in_log_id
        );
    END;



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
    ) AS
        v_log_id                logs.log_id%TYPE;
        v_job_name              user_scheduler_jobs.job_name%TYPE;
        v_action                VARCHAR2(32767);
    BEGIN
        v_log_id := app.log_module_json (
            'job_name',         in_job_name,
            'statement',        in_statement,
            'user_id',          in_user_id,
            'app_id',           in_app_id,
            'session_id',       in_session_id,
            'priority',         in_priority,
            'start_date',       in_start_date,
            'comments',         in_comments
        );
        --
        v_job_name := '"' || in_job_name || '#' || v_log_id || '"';
        --
        v_action :=
            'BEGIN' || CHR(10) ||
            --
            CASE WHEN in_user_id IS NOT NULL THEN
                '    app.create_session ('                                                  || CHR(10) ||
                '        in_user_id      => ''' || in_user_id || ''','                      || CHR(10) ||
                '        in_app_id       => ' || NVL(in_app_id, app.get_app_id()) || ','    || CHR(10) ||
                '        in_session_id   => ' || NVL(in_session_id, 0)                      || CHR(10) ||
                '    );'                                                                    || CHR(10)
            END ||
            --
            '    app.log_scheduler(' || v_log_id || ', ''' || v_job_name || ''');'          || CHR(10) ||
            '    ' || RTRIM(in_statement, ';') || ';'                                       || CHR(10) ||
            '    app.log_success(' || v_log_id || ');'                                      || CHR(10) ||
            'EXCEPTION'                                                                     || CHR(10) ||
            'WHEN OTHERS THEN'                                                              || CHR(10) ||
            '    app.raise_error();'                                                        || CHR(10) ||
            'END;';
        --
        app.log_debug(v_action);
        --
        DBMS_SCHEDULER.CREATE_JOB (
            job_name        => v_job_name,
            job_type        => 'PLSQL_BLOCK',
            job_action      => v_action,
            start_date      => in_start_date,
            enabled         => FALSE,
            auto_drop       => in_autodrop,
            comments        => v_log_id || '|' || in_comments
        );
        --
        IF in_priority IS NOT NULL THEN
            DBMS_SCHEDULER.SET_ATTRIBUTE(v_job_name, 'JOB_PRIORITY', in_priority);
        END IF;
        --
        IF in_enabled THEN
            DBMS_SCHEDULER.ENABLE(v_job_name);
        END IF;
        --
        app.log_success(v_log_id);
    EXCEPTION
    WHEN OTHERS THEN
        app.raise_error();
    END;



    PROCEDURE sync_logs (
        in_interval             NUMBER := NULL
    )
    AS
    BEGIN
        -- create session for the job
        IF NULLIF(app.get_app_id(), 0) IS NULL THEN
            app.create_session (
                in_user_id      => 'NOBODY',
                in_app_id       => app.get_core_app_id()
            );
        END IF;

        -- sync scheduler
        FOR d IN (
            SELECT
                l.log_id,
                d.log_id            AS job_log_id,
                d.job_name,
                d.status,
                app.get_duration(d.run_duration) AS duration,
                d.cpu_used,
                d.errors,
                d.output
            FROM user_scheduler_job_run_details d
            JOIN user_scheduler_job_log j
                ON j.log_id         = d.log_id
                AND j.log_date      >= SYSDATE - NVL(in_interval, 1/24)
            JOIN logs l
                ON l.created_at     >= SYSDATE - NVL(in_interval, 1/24)
                AND l.flag          = app.flag_scheduler
                AND l.action_name   IS NULL
                AND l.arguments     = d.job_name
        ) LOOP
            UPDATE logs l
            SET l.action_name       = d.status,
                l.module_timer      = d.duration
            WHERE l.log_id          = d.log_id;

            -- Python scripts might fail just in the script output
            IF d.output LIKE 'Exception message:%' THEN
                app.log_error (
                    in_action_name      => 'PYTHON FAILED',
                    in_parent_id        => d.log_id,
                    in_payload          => d.output
                );
            END IF;
        END LOOP;

        -- sync DML errors
        app.process_dml_errors();
    EXCEPTION
    WHEN OTHERS THEN
        app.raise_error();
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

        -- dont log blacklisted records
        IF SQLCODE = 0 AND NOT app.is_debug_on() AND app.is_blacklisted(rec.flag, rec.module_name, rec.action_name) AND rec.flag NOT IN (app.flag_error, app.flag_warning) THEN
            RETURN NULL;    -- skip blacklisted record only if there is no error and debug mode off
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
        IF (SQLCODE != 0 OR INSTR(app.track_callstack, rec.flag) > 0) THEN
            rec.payload := SUBSTR(rec.payload || CHR(10) || '--' || CHR(10) || app.get_shorter_stack(app.get_call_stack()), 1, app.length_payload);
        END IF;

        -- add error stack
        IF SQLCODE != 0 THEN
            rec.payload := SUBSTR(rec.payload || CHR(10) || '--' || CHR(10) || app.get_shorter_stack(app.get_error_stack()), 1, app.length_payload);
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
        BEGIN
            rec.flag        := app.flag_error;
            rec.action_name := 'FATAL_ERROR';
            rec.payload     := DBMS_UTILITY.FORMAT_ERROR_STACK || CHR(10) || DBMS_UTILITY.FORMAT_CALL_STACK;
            --
            INSERT INTO logs VALUES rec;
            COMMIT;
        EXCEPTION
        WHEN OTHERS THEN
            NULL;
        END;
        --
        DBMS_OUTPUT.PUT_LINE('-- NOT LOGGED ERROR:');
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_CALL_STACK);
        DBMS_OUTPUT.PUT_LINE('-- ^');
        --
        RAISE_APPLICATION_ERROR(app.app_exception_code, 'LOG_FAILED', TRUE);
    END;



    FUNCTION is_blacklisted (
        in_flag                 logs.flag%TYPE,
        in_module_name          logs.module_name%TYPE,
        in_action_name          logs.action_name%TYPE
    )
    RETURN BOOLEAN
    AS
        v_blacklisted          CHAR;
    BEGIN
        SELECT 'Y' INTO V_blacklisted
        FROM logs_blacklist t
        WHERE (t.app_id         = app.get_app_id()      OR t.app_id         IS NULL)
            AND (t.user_id      = app.get_user_id()     OR t.user_id        IS NULL)
            AND (t.page_id      = app.get_page_id()     OR t.page_id        IS NULL)
            AND (t.flag         = in_flag               OR t.flag           IS NULL)
            --
            AND (in_module_name LIKE t.module_like ESCAPE '\' OR t.module_like  IS NULL)
            AND (in_action_name LIKE t.action_like ESCAPE '\' OR t.action_like  IS NULL OR in_action_name IS NULL);
        --
        RETURN TRUE;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
    END;



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
    )
    AS
        v_log_id                logs.log_id%TYPE;
        v_action_name           logs.action_name%TYPE;
    BEGIN
        IF in_rollback THEN
            ROLLBACK;
        END IF;
        --
        v_action_name := COALESCE(in_action_name, app.get_caller_name(), 'UNEXPECTED_ERROR');
        --
        v_log_id := app.log_error (
            in_action_name          => v_action_name,
            in_arg1                 => in_arg1,
            in_arg2                 => in_arg2,
            in_arg3                 => in_arg3,
            in_arg4                 => in_arg4,
            in_arg5                 => in_arg5,
            in_arg6                 => in_arg6,
            in_arg7                 => in_arg7,
            in_arg8                 => in_arg8,
            in_payload              => in_payload
        );
        --
        RAISE_APPLICATION_ERROR (
            app.app_exception_code,
            v_action_name || ' [' || v_log_id || ']',
            FALSE  -- dont stack, we have that in log
        );
    END;



    FUNCTION handle_apex_error (
        p_error                 APEX_ERROR.T_ERROR
    )
    RETURN APEX_ERROR.T_ERROR_RESULT
    AS
        out_result              APEX_ERROR.T_ERROR_RESULT;
        /*
            message             varchar2(32767),            -- Displayed error message
            additional_info     varchar2(32767),            -- Only used for display_location ON_ERROR_PAGE to display additional error information
            display_location    varchar2(40),               -- Use constants "used for display_location" below
            page_item_name      varchar2(255),              -- Associated page item name
            column_alias        varchar2(255)               -- Associated tabular form column alias
        */
        --
        v_log_id                NUMBER;                     -- log_id from your log_error function (returning most likely sequence)
        v_action_name           logs.action_name%TYPE;      -- short error type visible to user
        v_component             logs.payload%TYPE;          -- to identify source component in your app
        v_payload               logs.payload%TYPE;
    BEGIN
        out_result := APEX_ERROR.INIT_ERROR_RESULT(p_error => p_error);
        --
        out_result.message := REPLACE(out_result.message, '&' || 'quot;', '"');  -- remove HTML entities

        -- assign log_id sequence (app specific, probably from sequence)
        IF p_error.ora_sqlcode IN (-1, -2091, -2290, -2291, -2292) THEN
            -- handle constraint violations
            -- ORA-00001: unique constraint violated
            -- ORA-02091: transaction rolled back (can hide a deferred constraint)
            -- ORA-02290: check constraint violated
            -- ORA-02291: integrity constraint violated - parent key not found
            -- ORA-02292: integrity constraint violated - child record found
            v_action_name := SUBSTR(APEX_ERROR.EXTRACT_CONSTRAINT_NAME (
                p_error             => p_error,
                p_include_schema    => FALSE
            ), 1, app.length_action);
            --
            out_result.message          := 'CONSTRAINT_ERROR|' || v_action_name;
            out_result.display_location := APEX_ERROR.C_INLINE_IN_NOTIFICATION;
            --
        ELSIF p_error.ora_sqlcode IN (-1400) THEN
            out_result.message          := 'NOT_NULL|' || REGEXP_SUBSTR(out_result.message, '\.["]([^"]+)["]\)', 1, 1, NULL, 1);
            --
        ELSIF p_error.is_internal_error THEN
            v_action_name := 'INTERNAL_ERROR';
        ELSE
            v_action_name := 'UNKNOWN_ERROR';
        END IF;

        -- store incident in your log
        v_component :=
            TO_CHAR(APEX_APPLICATION.G_FLOW_STEP_ID)                                || '|' ||
            REPLACE(p_error.component.type, 'APEX_APPLICATION_', '')                || '|' ||
            REPLACE(SYS_CONTEXT('USERENV', 'ACTION'), 'Processes - point: ', '')    || '|' ||
            p_error.component.name;
        --
        v_payload := SUBSTR (
            out_result.message                                  || CHR(10) || '--' || CHR(10) ||
            app.get_shorter_stack(p_error.ora_sqlerrm)          || CHR(10) || '--' || CHR(10) ||
            app.get_shorter_stack(p_error.error_statement)      || CHR(10) || '--' || CHR(10),
            --app.get_shorter_stack(p_error.error_backtrace)    || CHR(10) || '--' || CHR(10)
            1, app.length_payload
        );
        --
        v_log_id := app.log_error (
            in_action_name  => v_action_name,
            in_arg1         => v_component,
            in_arg2         => APEX_ERROR.GET_FIRST_ORA_ERROR_TEXT(p_error => p_error),
            in_payload      => v_payload
        );

        -- mark associated page item (when possible)
        IF out_result.page_item_name IS NULL AND out_result.column_alias IS NULL THEN
            APEX_ERROR.AUTO_SET_ASSOCIATED_ITEM (
                p_error         => p_error,
                p_error_result  => out_result
            );
        END IF;

        -- translate message
        out_result.message := NVL(app.get_translated_message(out_result.message), out_result.message);

        -- show only the latest error message to common users
        /*
        IF p_error.ora_sqlcode = app.app_exception_code THEN
            out_result.message := v_action_name || '|' || TO_CHAR(v_log_id) || '<br />' ||
                v_component || '<br />' ||
                out_result.message || '<br />' ||
                APEX_ERROR.GET_FIRST_ORA_ERROR_TEXT(p_error => p_error);
            out_result.additional_info := '';
        ELSIF v_action_name != 'UNKNOWN_ERROR' THEN
            out_result.message          := v_action_name || '|' || TO_CHAR(v_log_id);
            out_result.additional_info  := '';
        END IF;
        */
        out_result.message          := REGEXP_REPLACE(out_result.message, '^(ORA-\d+:\s*)\s*', '') || ' #' || v_log_id;
        out_result.display_location := APEX_ERROR.C_INLINE_IN_NOTIFICATION;  -- also removes HTML entities
        --
        IF app.is_developer() THEN
            out_result.message := REPLACE(out_result.message, ' #' || v_log_id,
                '<br />#<a href="' ||
                app.get_page_url(902, 'P902_LOG_ID', v_log_id) ||
                '" style="font-weight: bold; text-decoration: none;">' || v_log_id || '</a>'
            );
        END IF;
        --
        RETURN out_result;
    EXCEPTION
    WHEN OTHERS THEN
        app.log_error (
            in_action_name  => v_action_name,
            in_arg1         => v_component,
            in_arg2         => APEX_ERROR.GET_FIRST_ORA_ERROR_TEXT(p_error => p_error),
            in_payload      => v_payload
        );
        app.raise_error();  -- raise why it is here in exception block
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
        WHERE s.created_at <= TRUNC(SYSDATE) - NVL(in_age, app.logs_max_age);

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
                AND TO_DATE(REGEXP_SUBSTR(h.high_value, '(\d{4}-\d{2}-\d{2})'), 'YYYY-MM-DD') <= TRUNC(SYSDATE) - COALESCE(in_age, app.logs_max_age)
        ) LOOP
            -- delete old data in batches
            FOR i IN 1 .. 100 LOOP
                EXECUTE IMMEDIATE
                    'DELETE FROM ' || c.table_name ||
                    ' PARTITION (' || c.partition_name || ') WHERE ROWNUM <= 100000';
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



    PROCEDURE purge_logs (
        in_date                 DATE
    ) AS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        DELETE FROM logs l
        WHERE l.created_at      >= in_date
            AND l.created_at    <  in_date + 1;
        --
        DELETE FROM sessions s
        WHERE s.created_at      >= in_date
            AND s.created_at    <  in_date + 1;
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
            CONTINUE WHEN in_skip_others AND NVL(UTL_CALL_STACK.OWNER(i), '-') NOT IN (app.get_owner(app.get_app_id()), app.get_owner(app.get_core_app_id()));
            --
            out_module  := SUBSTR(UTL_CALL_STACK.CONCATENATE_SUBPROGRAM(UTL_CALL_STACK.SUBPROGRAM(i)), 1, app.length_module);
            out_stack   := out_stack || out_module || CASE WHEN in_line_numbers THEN ' [' || TO_CHAR(UTL_CALL_STACK.UNIT_LINE(i)) || ']' END || in_splitter;
        END LOOP;
        --
        RETURN out_stack;
    EXCEPTION
    WHEN BAD_DEPTH THEN
        RETURN NULL;
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



    FUNCTION get_shorter_stack (
        in_stack                VARCHAR2
    )
    RETURN VARCHAR2
    AS
        out_stack               VARCHAR2(32767);
    BEGIN
        out_stack := REPLACE(in_stack, 'WWV_FLOW', '%');
        out_stack := REGEXP_REPLACE(out_stack, 'APEX_\d{6}', '%');
        --
        out_stack := REGEXP_REPLACE(out_stack, '\s.*SQL.*\.EXEC.*\]',   '.');
        out_stack := REGEXP_REPLACE(out_stack, '\s%.*EXEC.*\]',         '.');
        out_stack := REGEXP_REPLACE(out_stack, '\s%_PROCESS.*\]',       '.');
        out_stack := REGEXP_REPLACE(out_stack, '\s%_ERROR.*\]',         '.');
        out_stack := REGEXP_REPLACE(out_stack, '\s%_SECURITY.*\]',      '.');
        out_stack := REGEXP_REPLACE(out_stack, '\sHTMLDB*\]',           '.');
        out_stack := REGEXP_REPLACE(out_stack, '\s\d+\s\[\]',           '.');
        --
        out_stack := REGEXP_REPLACE(out_stack, '\sORA-\d+.*%\.%.*EXEC.*, line \d+',             '.');
        out_stack := REGEXP_REPLACE(out_stack, '\sORA-\d+.*%\.%.*PROCESS_NATIVE.*, line \d+',   '.');
        out_stack := REGEXP_REPLACE(out_stack, '\sORA-\d+.*DBMS_(SYS_)?SQL.*, line \d+',        '.');
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



    FUNCTION get_log_request_id
    RETURN logs.log_id%TYPE
    AS
    BEGIN
        RETURN recent_request_id;
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



    FUNCTION get_flag (
        in_flag_name            VARCHAR2
    )
    RETURN logs.flag%TYPE
    RESULT_CACHE
    AS
        PRAGMA UDF;
        --
        out_flag                logs.flag%TYPE;
    BEGIN
        -- I bet you didnt expected this
        SELECT REGEXP_SUBSTR(s.text, ':=\s*''([^'']+)', 1, 1, NULL, 1) INTO out_flag
        FROM user_source s
        WHERE s.name            = $$PLSQL_UNIT
            AND s.type          = 'PACKAGE'
            AND s.line          <= 100
            AND s.text          LIKE '%flag_%CONSTANT%logs.flag\%TYPE%' ESCAPE '\'
            AND in_flag_name    = UPPER(REGEXP_SUBSTR(s.text, 'flag_([a-z]+)', 1, 1, NULL, 1));
        --
        RETURN out_flag;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



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
    ) AS
        smtp_from               VARCHAR2(256);
        smtp_username           VARCHAR2(256);
        smtp_password           VARCHAR2(256);
        smtp_host               VARCHAR2(256);
        smtp_port               NUMBER(4);
        smtp_timeout            NUMBER(2);
        --
        boundary                CONSTANT VARCHAR2(128)      := '-----5b9d8059445a8eb8c025f159131f02d94969a12c16363d4dec42e893b374cb85-----';
        --
        reply                   UTL_SMTP.REPLY;
        conn                    UTL_SMTP.CONNECTION;
        --
        blob_content            BLOB;
        blob_gzipped            BLOB;
        blob_amount             BINARY_INTEGER              := 6000;
        blob_offset             PLS_INTEGER                 := 1;
        buffer                  VARCHAR2(32767);
        buffer_raw              RAW(6000);                  -- must match blob_amount^
        --
        FUNCTION quote_encoding (
            in_text VARCHAR2
        )
        RETURN VARCHAR2 AS
        BEGIN
            RETURN '=?UTF-8?Q?' || REPLACE(
                UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.QUOTED_PRINTABLE_ENCODE(
                    UTL_RAW.CAST_TO_RAW(in_text))), '=' || UTL_TCP.CRLF, '') || '?=';
        END;
        --
        FUNCTION quote_address (
            in_address      VARCHAR2,
            in_strip_name   BOOLEAN := FALSE
        )
        RETURN VARCHAR2 AS
            in_found PLS_INTEGER;
        BEGIN
            IF in_strip_name THEN
                RETURN REGEXP_REPLACE(in_address, '.*\s?<(\S+)>$', '\1');
            ELSE
                in_found := REGEXP_INSTR(in_address, '\s?<\S+@\S+\.\S{2,6}>$');
                IF in_found > 1 THEN
                    RETURN quote_encoding(RTRIM(SUBSTR(in_address, 1, in_found))) || SUBSTR(in_address, in_found);
                ELSE
                    RETURN in_address;
                END IF;
            END IF;
        END;
        --
        PROCEDURE split_addresses (
            in_out_conn     IN OUT NOCOPY   UTL_SMTP.CONNECTION,
            in_to           IN              VARCHAR2
        )
        AS
        BEGIN
            FOR i IN (
                SELECT LTRIM(RTRIM(REGEXP_SUBSTR(in_to, '[^;,]+', 1, LEVEL))) AS address
                FROM DUAL
                CONNECT BY REGEXP_SUBSTR(in_to, '[^;,]+', 1, LEVEL) IS NOT NULL)
            LOOP
                UTL_SMTP.RCPT(in_out_conn, quote_address(i.address, TRUE));
            END LOOP;
        END;
    BEGIN
        app.log_module(in_to, in_subject, in_cc, in_bcc, in_attach_name);

        -- SMTP setup
        smtp_from       := COALESCE(in_from, app.get_setting('SMTP_FROM'));
        smtp_host       := app.get_setting('SMTP_HOST');
        smtp_port       := COALESCE(TO_NUMBER(app.get_setting('SMTP_PORT')), 25);
        smtp_timeout    := COALESCE(TO_NUMBER(app.get_setting('SMTP_TIMEOUT')), 10);
        smtp_username   := app.get_setting('SMTP_USER');
        smtp_password   := app.get_setting('SMTP_PWD');
        --
        IF (smtp_host IS NULL OR smtp_port IS NULL OR smtp_from IS NULL) THEN
            app.raise_error('SMTP_SETUP_MISSING');
        END IF;

        -- connect to SMTP server
        BEGIN
            reply := UTL_SMTP.OPEN_CONNECTION(smtp_host, smtp_port, conn, smtp_timeout);
        EXCEPTION
        WHEN OTHERS THEN
            app.log_error('CONNECTION_FAILED');
            RETURN;
        END;
        --
        UTL_SMTP.HELO(conn, smtp_host);
        IF smtp_username IS NOT NULL THEN
            UTL_SMTP.COMMAND(conn, 'AUTH LOGIN');
            UTL_SMTP.COMMAND(conn, UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(smtp_username)));
            IF smtp_password IS NOT NULL THEN
                UTL_SMTP.COMMAND(conn, UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(smtp_password)));
            END IF;
        END IF;

        -- prepare headers
        UTL_SMTP.MAIL(conn, quote_address(smtp_from, TRUE));
        --
        -- apex_applications.email_from
        --

        -- handle multiple recipients
        split_addresses(conn, in_to);
        --
        IF in_cc IS NOT NULL THEN
            split_addresses(conn, in_cc);
        END IF;
        --
        IF in_bcc IS NOT NULL THEN
            split_addresses(conn, in_bcc);
        END IF;

        -- continue with headers
        UTL_SMTP.OPEN_DATA(conn);
        --
        UTL_SMTP.WRITE_DATA(conn, 'Date: '      || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(conn, 'From: '      || quote_address(smtp_from) || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(conn, 'To: '        || quote_address(in_to) || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(conn, 'Subject: '   || quote_encoding(in_subject) || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(conn, 'Reply-To: '  || quote_address(smtp_from) || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(conn, 'MIME-Version: 1.0' || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(conn, 'Content-Type: multipart/mixed; boundary="' || boundary || '"' || UTL_TCP.CRLF || UTL_TCP.CRLF);

        -- prepare body content
        IF in_body IS NOT NULL THEN
            UTL_SMTP.WRITE_DATA(conn, '--' || boundary || UTL_TCP.CRLF);
            UTL_SMTP.WRITE_DATA(conn, 'Content-Type: ' || 'text/html' || '; charset="utf-8"' || UTL_TCP.CRLF);
            UTL_SMTP.WRITE_DATA(conn, 'Content-Transfer-Encoding: base64' || UTL_TCP.CRLF || UTL_TCP.CRLF);
            --
            FOR i IN 0 .. TRUNC((DBMS_LOB.GETLENGTH(in_body) - 1) / 12000) LOOP
                UTL_SMTP.WRITE_RAW_DATA(conn, UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(DBMS_LOB.SUBSTR(in_body, 12000, i * 12000 + 1))));
            END LOOP;
            --
            UTL_SMTP.WRITE_DATA(conn, UTL_TCP.CRLF || UTL_TCP.CRLF);
        END IF;

        -- prepare attachment
        IF in_attach_name IS NOT NULL AND in_compress THEN
            -- compress attachment
            UTL_SMTP.WRITE_DATA(conn, '--' || boundary || UTL_TCP.CRLF);
            UTL_SMTP.WRITE_DATA(conn, 'Content-Transfer-Encoding: base64' || UTL_TCP.CRLF);
            UTL_SMTP.WRITE_DATA(conn, 'Content-Type: ' || 'application/octet-stream' || UTL_TCP.CRLF);
            UTL_SMTP.WRITE_DATA(conn, 'Content-Disposition: attachment; filename="' || in_attach_name || '.gz"' || UTL_TCP.CRLF || UTL_TCP.CRLF);
            --
            blob_content := app.clob_to_blob(in_attach_data);
            DBMS_LOB.CREATETEMPORARY(blob_gzipped, TRUE, DBMS_LOB.CALL);
            DBMS_LOB.OPEN(blob_gzipped, DBMS_LOB.LOB_READWRITE);
            --
            UTL_COMPRESS.LZ_COMPRESS(blob_content, blob_gzipped, quality => 8);
            --
            WHILE blob_offset <= DBMS_LOB.GETLENGTH(blob_gzipped) LOOP
                DBMS_LOB.READ(blob_gzipped, blob_amount, blob_offset, buffer_raw);
                UTL_SMTP.WRITE_RAW_DATA(conn, UTL_ENCODE.BASE64_ENCODE(buffer_raw));
                blob_offset := blob_offset + blob_amount;
            END LOOP;
            DBMS_LOB.FREETEMPORARY(blob_gzipped);
            --
            UTL_SMTP.WRITE_DATA(conn, UTL_TCP.CRLF || UTL_TCP.CRLF);
        ELSIF in_attach_name IS NOT NULL THEN
            -- regular attachment
            UTL_SMTP.WRITE_DATA(conn, '--' || boundary || UTL_TCP.CRLF);
            UTL_SMTP.WRITE_DATA(conn, 'Content-Transfer-Encoding: base64' || UTL_TCP.CRLF);
            UTL_SMTP.WRITE_DATA(conn, 'Content-Type: ' || in_attach_mime || '; name="' || in_attach_name || '"' || UTL_TCP.CRLF);
            UTL_SMTP.WRITE_DATA(conn, 'Content-Disposition: attachment; filename="' || in_attach_name || '"' || UTL_TCP.CRLF || UTL_TCP.CRLF);
            --
            FOR i IN 0 .. TRUNC((DBMS_LOB.GETLENGTH(in_attach_data) - 1) / 12000) LOOP
                UTL_SMTP.WRITE_RAW_DATA(conn, UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(DBMS_LOB.SUBSTR(in_attach_data, 12000, i * 12000 + 1))));
            END LOOP;
            --
            UTL_SMTP.WRITE_DATA(conn, UTL_TCP.CRLF || UTL_TCP.CRLF);
        END IF;

        -- close
        UTL_SMTP.WRITE_DATA(conn, '--' || boundary || '--' || UTL_TCP.CRLF);
        UTL_SMTP.CLOSE_DATA(conn);
        UTL_SMTP.QUIT(conn);
        --
        app.log_success();
    EXCEPTION
    WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR THEN
        BEGIN
            UTL_SMTP.QUIT(conn);
        EXCEPTION
        WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR THEN
            NULL;
        END;
    WHEN OTHERS THEN
        app.log_error('SEND_MAIL_FAILED');
    END;



    FUNCTION clob_to_blob (
        in_clob CLOB
    )
    RETURN BLOB
    AS
        out_blob        BLOB;
        --
        v_file_size     INTEGER     := DBMS_LOB.LOBMAXSIZE;
        v_dest_offset   INTEGER     := 1;
        v_src_offset    INTEGER     := 1;
        v_blob_csid     NUMBER      := DBMS_LOB.DEFAULT_CSID;
        v_lang_context  NUMBER      := DBMS_LOB.DEFAULT_LANG_CTX;
        v_warning       INTEGER;
        v_length        NUMBER;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(out_blob, TRUE);
        DBMS_LOB.CONVERTTOBLOB(out_blob, in_clob, v_file_size, v_dest_offset, v_src_offset, v_blob_csid, v_lang_context, v_warning);
        RETURN out_blob;
    END;



    PROCEDURE drop_dml_table (
        in_table_name           logs.module_name%TYPE
    )
    AS
    BEGIN
        app.log_module(in_table_name);

        -- process existing data first
        app.process_dml_errors(in_table_name);
        --
        BEGIN
            EXECUTE IMMEDIATE
                'DROP TABLE ' || app.get_dml_table(in_table_name) || ' PURGE';
            --
            app.log_success();
        EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE NOT IN (-942) THEN  -- table doesnt exists
                RAISE;
            END IF;
        END;
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
    END;



    PROCEDURE create_dml_table (
        in_table_name           logs.module_name%TYPE
    )
    AS
    BEGIN
        app.log_module(in_table_name);

        -- drop existing tables
        app.drop_dml_table(in_table_name);
        --
        IF app.get_dml_table(in_table_name) IS NULL THEN
            RETURN;
        END IF;

        -- create DML log table
        IF app.is_debug_on() THEN
            app.log_debug('DML', app.get_owner(app.get_app_id()) || '.' || in_table_name);
            app.log_debug('ERR', app.get_owner(app.get_app_id()), app.get_dml_table(in_table_name));
        END IF;
        --
        DBMS_ERRLOG.CREATE_ERROR_LOG (
            dml_table_name          => app.get_owner(app.get_app_id()) || '.' || in_table_name,
            err_log_table_owner     => app.get_owner(app.get_app_id()),
            err_log_table_name      => app.get_dml_table(in_table_name),
            skip_unsupported        => TRUE
        );
        --
        IF app.get_owner(app.get_app_id()) != app.dml_tables_owner THEN
            EXECUTE IMMEDIATE
                'GRANT ALL ON ' || app.get_dml_table(in_table_name) ||
                ' TO ' || app.get_owner(app.get_app_id());
        END IF;
        --
        app.log_success();
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
    END;



    PROCEDURE process_dml_errors (
        in_table_name           user_tables.table_name%TYPE := NULL
    )
    AS
        TYPE log_dml_error      IS RECORD (
            log_id              NUMBER,
            operation           VARCHAR2(2),
            table_name          VARCHAR2(30),
            table_rowid         VARCHAR2(30),
            dml_rowid           ROWID,
            error_message       VARCHAR2(2000),
            json_data           VARCHAR2(4000)
        );
        rec                     log_dml_error;      -- logs_dml_errors%ROWTYPE; avoid references
        --
        r                       SYS_REFCURSOR;
        q                       VARCHAR2(32767);
        dml_log_id              logs.log_id%TYPE;
        --
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        app.log_module(in_table_name);
        --
        FOR c IN (
            SELECT
                t.table_name    AS data_table,
                a.table_name    AS error_table,
                --
                LISTAGG(c.column_name, ', ') WITHIN GROUP (ORDER BY c.column_id) AS list_columns
            FROM user_tables t
            JOIN all_tables a
                ON a.owner          = COALESCE(app.dml_tables_owner, app.get_owner(app.get_app_id()), USER)
                AND a.table_name    = app.get_dml_table(t.table_name)
                AND a.table_name    != t.table_name
            JOIN all_tab_cols c
                ON c.owner          = a.owner
                AND c.table_name    = a.table_name
                AND c.column_name   NOT LIKE 'ORA_ERR_%$'
            WHERE t.table_name      = NVL(in_table_name, t.table_name)
            GROUP BY t.table_name, a.table_name
            ORDER BY 1
        ) LOOP
            BEGIN
                q :=      'SELECT'                                                      || CHR(10);
                q := q || '    TO_NUMBER(t.ora_err_tag$),'                              || CHR(10);
                q := q || '    t.ora_err_optyp$,'                                       || CHR(10);
                q := q || '    ''' || c.data_table || ''','                             || CHR(10);
                q := q || '    CAST(t.ora_err_rowid$ AS VARCHAR2(30)),'                 || CHR(10);
                q := q || '    t.ROWID,'                                                || CHR(10);
                q := q || '    t.ora_err_mesg$,'                                        || CHR(10);
                q := q || '    JSON_OBJECT(' || c.list_columns || ' ABSENT ON NULL)'    || CHR(10);
                q := q || 'FROM ' || c.error_table || ' t';
                --
                OPEN r FOR q;
                LOOP
                    FETCH r INTO rec;
                    EXIT WHEN r%NOTFOUND;
                    --
                    dml_log_id := app.log_error (
                        in_action_name      => 'DML_ERROR',
                        in_arg1             => rec.operation,
                        in_arg2             => rec.table_name,
                        in_arg3             => rec.table_rowid,
                        in_arg4             => rec.dml_rowid,
                        in_arg5             => rec.error_message,
                        in_arg6             => rec.json_data,
                        in_parent_id        => rec.log_id,
                        --
                        in_payload          => app.get_dml_query (
                            in_log_id       => rec.log_id,
                            in_table_name   => rec.table_name,
                            in_table_rowid  => rec.table_rowid,
                            in_operation    => rec.operation
                        )
                    );
            
                    -- remove from DML ERR table
                    IF dml_log_id IS NOT NULL THEN
                        EXECUTE IMMEDIATE
                            'DELETE FROM ' || app.get_dml_table(rec.table_name) ||
                            ' WHERE ora_err_tag$ = :id'
                            USING rec.log_id;
                        COMMIT;
                    END IF;
                END LOOP;
                --
                CLOSE r;
            EXCEPTION
            WHEN OTHERS THEN
                app.log_debug(c.data_table, c.error_table, q);
                --
                RAISE;
            END;
        END LOOP;
        --
        app.log_success();
        --
        COMMIT;
    EXCEPTION
    WHEN app.app_exception THEN
        COMMIT;
        RAISE;
    WHEN OTHERS THEN
        COMMIT;
        app.raise_error();
    END;



    FUNCTION get_dml_table (
        in_table_name           logs.module_name%TYPE,
        in_owner                CHAR                    := NULL,
        in_existing_only        BOOLEAN                 := FALSE
    )
    RETURN VARCHAR2
    AS
        v_table_name            all_tables.table_name%TYPE;
        v_valid                 CHAR;
    BEGIN
        v_table_name := app.dml_tables_prefix ||
            REGEXP_REPLACE(REGEXP_REPLACE(in_table_name,
                '(' || REPLACE(app.dml_tables_postfix, '$', '\$') || ')$', ''),
                '^(' || REPLACE(app.dml_tables_prefix, '$', '\$') || ')', '') ||
            app.dml_tables_postfix;
        --
        IF in_existing_only THEN
            SELECT 'Y' INTO v_valid
            FROM all_tables t
            WHERE t.owner           = COALESCE(in_owner, app.get_dml_owner())
                AND t.table_name    = v_table_name;
        END IF;
        --
        RETURN CASE WHEN in_owner IS NOT NULL THEN app.get_dml_owner() || '.' END || v_table_name;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;



    FUNCTION get_dml_owner
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN COALESCE(app.dml_tables_owner, app.get_owner(app.get_app_id()));
    END;



    FUNCTION get_dml_query (
        in_log_id               logs.log_id%TYPE,
        in_table_name           logs.module_name%TYPE,
        in_table_rowid          VARCHAR2,
        in_operation            CHAR  -- [I|U|D]
    )
    RETURN VARCHAR2
    AS
        out_query               VARCHAR2(32767);
        in_cursor               SYS_REFCURSOR;
    BEGIN
        -- prepare cursor for XML conversion and extraction
        BEGIN
            OPEN in_cursor FOR
                'SELECT * FROM ' || app.get_dml_table(in_table_name) ||
                ' WHERE ora_err_tag$ = ' || in_log_id;
        EXCEPTION
        WHEN OTHERS THEN
            app.raise_error('INVALID_TABLE', app.get_dml_table(in_table_name), in_log_id);
        END;

        -- build query the way you can run it again manually or run just inner select to view passed values
        -- to see dates properly setup nls_date_format first
        -- ALTER SESSION SET nls_date_format = 'YYYY-MM-DD HH24:MI:SS';
        SELECT
            'MERGE INTO ' || LOWER(in_table_name) || ' t' || CHR(10) ||
            'USING (' || CHR(10) ||
            --
            '    SELECT' || CHR(10) ||
            LISTAGG('        ''' || p.value || ''' AS ' || LOWER(p.name) || p.data_type, CHR(10) ON OVERFLOW TRUNCATE)
                WITHIN GROUP (ORDER BY p.pos) || CHR(10) ||
            '        ''' || in_table_rowid || ''' AS rowid_' || CHR(10) ||
            '    FROM DUAL' ||
            --
            CASE WHEN in_table_rowid IS NOT NULL THEN
                CHR(10) || '    UNION ALL' || CHR(10) ||
                '    SELECT' || CHR(10) ||
                LISTAGG('        TO_CHAR(' || LOWER(p.name), '),' || CHR(10) ON OVERFLOW TRUNCATE)
                    WITHIN GROUP (ORDER BY p.pos) || '),' || CHR(10) ||
                '        ''^'' AS rowid_' || CHR(10) ||  -- remove ROWID to match only on 1 row
                '    FROM ' || LOWER(in_table_name) || CHR(10) ||
                '    WHERE ROWID = ''' || in_table_rowid || ''''
                END || CHR(10) ||
            --
            ') s ON (s.rowid_ = t.ROWID)' || CHR(10) ||
            --
            CASE in_operation
                WHEN 'U' THEN
                    'WHEN MATCHED' || CHR(10) ||
                    'THEN UPDATE SET' || CHR(10) ||
                    LISTAGG('    t.' || LOWER(p.name) || ' = s.' || LOWER(p.name), ',' || CHR(10) ON OVERFLOW TRUNCATE)
                        WITHIN GROUP (ORDER BY p.pos)
                WHEN 'I' THEN
                    'WHEN NOT MATCHED' || CHR(10) ||
                    'THEN INSERT (' || CHR(10) ||
                    LISTAGG('    t.' || LOWER(p.name), ',' || CHR(10) ON OVERFLOW TRUNCATE)
                        WITHIN GROUP (ORDER BY p.pos) || CHR(10) || ')' || CHR(10) ||
                    'VALUES (' || CHR(10) ||
                    LISTAGG('    ''' || p.value || '''', ',' || CHR(10) ON OVERFLOW TRUNCATE)
                        WITHIN GROUP (ORDER BY p.pos) || CHR(10) || ')'
            END || ';'
        INTO out_query
        FROM (
            SELECT
                VALUE(p).GETROOTELEMENT()       AS name,
                EXTRACTVALUE(VALUE(p), '/*')    AS value,
                c.column_id                     AS pos,
                c.data_type
            FROM TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE.CREATEXML(in_cursor), '//ROWSET/ROW/*'))) p
            JOIN (
                SELECT
                    c.table_name, c.column_name, c.column_id,
                    ',  -- ' || CASE
                        WHEN c.data_type LIKE '%CHAR%' OR c.data_type = 'RAW' THEN
                            c.data_type ||
                            DECODE(COALESCE(c.char_length, 0), 0, '',
                                '(' || c.char_length || DECODE(c.char_used, 'C', ' CHAR', '') || ')'
                            )
                        WHEN c.data_type = 'NUMBER' AND c.data_precision = 38 THEN 'INTEGER'
                        WHEN c.data_type = 'NUMBER' THEN
                            c.data_type ||
                            DECODE(COALESCE(TO_NUMBER(c.data_precision || c.data_scale), 0), 0, '',
                                DECODE(COALESCE(c.data_scale, 0), 0, '(' || c.data_precision || ')',
                                    '(' || c.data_precision || ',' || c.data_scale || ')'
                                )
                            )
                        ELSE c.data_type
                        END AS data_type
                FROM user_tab_cols c
                WHERE c.table_name = in_table_name
            ) c
                ON c.column_name = VALUE(p).GETROOTELEMENT()
            ORDER BY c.column_id
        ) p;
        --
        CLOSE in_cursor;
        --
        RETURN out_query;
    END;



    PROCEDURE refresh_user_source_views (
        in_view_name            VARCHAR2        := NULL,
        in_force                BOOLEAN         := FALSE
    )
    AS
        PRAGMA AUTONOMOUS_TRANSACTION;
        --
        in_table_name           CONSTANT user_objects.object_name%TYPE := 'USER_SOURCE_VIEWS';  -- @TODO: remove hardcoded name
        --
        v_table_time            user_objects.last_ddl_time%TYPE;
        v_views_time            user_objects.last_ddl_time%TYPE;
        --
        PROCEDURE clob_to_lines (
            in_name         VARCHAR2,
            in_clob         CLOB,
            in_offset       NUMBER          := NULL
        )
        AS
            clob_len        PLS_INTEGER     := DBMS_LOB.GETLENGTH(in_clob);
            clob_line       PLS_INTEGER     := 1;
            offset          PLS_INTEGER     := 1;
            amount          PLS_INTEGER     := 32767;
            buffer          VARCHAR2(32767);
        BEGIN
            WHILE offset < clob_len LOOP
                IF INSTR(in_clob, CHR(10), offset) = 0 THEN
                    amount := clob_len - offset + 1;
                ELSE
                    amount := INSTR(in_clob, CHR(10), offset) - offset;
                END IF;
                --
                IF amount = 0 THEN
                    buffer := '';
                ELSE
                    DBMS_LOB.READ(in_clob, amount, offset, buffer);
                END IF;
                --
                -- @TODO: CREATE & RETURN COLLECTION INSTEAD
                --
                IF clob_line > 1 THEN
                    INSERT INTO user_source_views (name, line, text)
                    VALUES (
                        in_name,
                        clob_line - 1 - NVL(in_offset, 0),
                        REPLACE(REPLACE(CASE WHEN clob_line = 2 THEN LTRIM(buffer) ELSE buffer END, CHR(13), ''), CHR(10), '')
                    );
                END IF;
                --
                clob_line := clob_line + 1;
                IF INSTR(in_clob, CHR(10), offset) = clob_len THEN
                    buffer := '';
                END IF;
                --
                offset := offset + amount + 1;
            END LOOP;
        END;
    BEGIN
        app.log_module(in_view_name, CASE WHEN in_force THEN 'Y' END);

        -- compare timestamps
        IF NOT in_force THEN
            SELECT o.last_ddl_time INTO v_table_time
            FROM user_objects o
            WHERE o.object_name     = NVL(in_table_name, o.object_name)
                AND o.object_type   = 'TABLE';
            --
            SELECT MAX(o.last_ddl_time) INTO v_views_time
            FROM user_objects o
            WHERE o.object_type     = 'VIEW';

            -- refresh not needed
            IF v_table_time > v_views_time THEN
                app.log_result('SKIPPING', in_view_name);
                RETURN;
            END IF;
        ELSE
            -- in force mode cleanup whole table
            DELETE FROM user_source_views;  -- truncate?
        END IF;

        -- refresh table content
        FOR c IN (
            SELECT
                v.view_name,
                DBMS_METADATA.GET_DDL('VIEW', v.view_name) AS content
            FROM user_views v
            JOIN user_objects o
                ON o.object_name        = v.view_name
                AND o.object_type       = 'VIEW'
                AND (o.last_ddl_time    >= v_table_time OR v_table_time IS NULL)
        ) LOOP
            DELETE FROM user_source_views t
            WHERE t.name = c.view_name;
            --
            clob_to_lines(c.view_name, REGEXP_REPLACE(c.content, '^(\s*)', ''));
        END LOOP;
        --
        COMMIT;

        -- alter table to update last refresh date, but avoid APP package invalidation
        IF in_table_name IS NOT NULL THEN
            EXECUTE IMMEDIATE 'ALTER TABLE ' || in_table_name || ' ADD tmp_' || log_id.CURRVAL || ' NUMBER(1) INVISIBLE';
            EXECUTE IMMEDIATE 'ALTER TABLE ' || in_table_name || ' SET UNUSED (tmp_' || log_id.CURRVAL || ')';
        END IF;
        --
        app.log_success();
    EXCEPTION
    WHEN app.app_exception THEN
        ROLLBACK;
        RAISE;
    WHEN OTHERS THEN
        ROLLBACK;
        app.raise_error();
    END;



    PROCEDURE rebuild_settings
    AS
        v_package_name      VARCHAR2(64);
        --
        q                   VARCHAR2(32767);    -- spec
        b                   VARCHAR2(32767);    -- body
    BEGIN
        v_package_name := app.get_settings_package();
        --
        app.log_module(v_package_name);
        --
        IF v_package_name IS NULL THEN
            RETURN;
        END IF;
        --
        app.refresh_user_source_views();
        --
        q := 'CREATE OR REPLACE PACKAGE '       || LOWER(v_package_name) || ' AS' || CHR(10);
        b := 'CREATE OR REPLACE PACKAGE BODY '  || LOWER(v_package_name) || ' AS' || CHR(10);
        --
        FOR c IN (
            SELECT DISTINCT
                s.setting_name,
                s.is_numeric,
                s.is_date
            FROM settings s
            WHERE s.app_id              = app.get_app_id()
                AND s.setting_context   IS NULL
                AND s.is_private        IS NULL
            ORDER BY s.setting_name
        ) LOOP
            -- create specification
            q := q || CHR(10);
            q := q || '    FUNCTION ' || LOWER(app.settings_prefix) || LOWER(c.setting_name) || ' (' || CHR(10);
            q := q || '        in_context      settings.setting_context%TYPE := NULL' || CHR(10);
            q := q || '    )' || CHR(10);
            q := q || '    RETURN ' || CASE
                                WHEN c.is_numeric   = 'Y' THEN 'NUMBER'
                                WHEN c.is_date      = 'Y' THEN 'DATE'
                                ELSE 'VARCHAR2' END || CHR(10);
            q := q || '    RESULT_CACHE;' || CHR(10);

            -- create package body
            b := b || CHR(10);
            b := b || '    FUNCTION ' || LOWER(app.settings_prefix) || LOWER(c.setting_name) || ' (' || CHR(10);
            b := b || '        in_context      settings.setting_context%TYPE := NULL' || CHR(10);
            b := b || '    )' || CHR(10);
            b := b || '    RETURN ' || CASE
                                WHEN c.is_numeric   = 'Y' THEN 'NUMBER'
                                WHEN c.is_date      = 'Y' THEN 'DATE'
                                ELSE 'VARCHAR2' END || CHR(10);
            b := b || '    RESULT_CACHE AS' || CHR(10);
            b := b || '    BEGIN' || CHR(10);
            b := b || '        RETURN ' || CASE
                                    WHEN c.is_numeric   = 'Y' THEN 'TO_NUMBER('
                                    WHEN c.is_date      = 'Y' THEN 'app.get_date('
                                    END || 'app.get_setting (' || CHR(10);
            b := b || '            in_name             => ''' || c.setting_name || ''',' || CHR(10);
            b := b || '            in_context          => in_context' || CHR(10);
            b := b || '        ' || CASE
                                    WHEN NVL(c.is_numeric, c.is_date) = 'Y' THEN ')'
                                    END || ');' || CHR(10);
            b := b || '    EXCEPTION' || CHR(10);
            b := b || '    WHEN NO_DATA_FOUND THEN' || CHR(10);
            b := b || '        RETURN NULL;' || CHR(10);
            b := b || '    END;' || CHR(10);
        END LOOP;
        --
        q := q || CHR(10) || 'END;';
        b := b || CHR(10) || 'END;';
        --
        EXECUTE IMMEDIATE q;
        EXECUTE IMMEDIATE b;
        --
        app.log_debug('PACKAGE_CREATED');
        app.log_success();
        --
        recompile (
            in_name     => v_package_name,
            in_force    => TRUE
        );
        /*
        DBMS_RESULT_CACHE.INVALIDATE (
            owner   => app.schema_owner,
            name    => app_actions.settings_package
        );
        */
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.log_debug(q);       -- trimmed
        app.log_debug(b);       -- trimmed
        --
        app.raise_error();
    END;







    -- ### Dynamic procedure call
    --

    --
    -- @TODO:
    --
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
        --app.log_module(v_object_name, in_arg1, in_arg2, in_arg3, in_arg4);

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
        --app.log_success();
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



    PROCEDURE init_map
    AS
    BEGIN
        -- clear map for tracking logs hierarchy
        map_tree := app.arr_map_tree();
        --
        recent_log_id       := NULL;
        recent_request_id   := NULL;
        recent_tree_id      := NULL;
    END;

BEGIN
    app.init_map();
END;
/
