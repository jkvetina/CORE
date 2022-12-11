CREATE OR REPLACE PACKAGE BODY nav AS

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
            n.auth_scheme,
            n.package_name,
            n.procedure_name,
            n.data_type,
            n.argument_name
        INTO v_auth_scheme, v_package_name, v_procedure_name, v_data_type, v_page_argument
        FROM nav_availability_mvw n
        WHERE n.application_id      = in_app_id
            AND n.page_id           = in_page_id;

        -- log current page
        IF app.is_debug_on() AND in_page_id = app.get_page_id() THEN
            app.log_action (
                'IS_PAGE_AVAILABLE',
                in_app_id,
                in_page_id,
                NVL(v_auth_scheme, '-'),
                NVL(v_package_name || '.' || v_procedure_name, '-'),
                NVL(v_data_type, '-'),
                NVL(v_page_argument, '-')
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
            IF app.is_developer() THEN  -- show in menu, allow access
                RETURN 'Y';
            END IF;
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



    FUNCTION get_html_a (
        in_href                 VARCHAR2,
        in_name                 VARCHAR2,
        in_title                VARCHAR2    := NULL
    )
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN '<a href="' || in_href || '" title="' || in_title ||'">' || in_name || '</a>';
    END;



    PROCEDURE nav_remove_pages (
        in_page_id              navigation.page_id%TYPE         := NULL
    )
    AS
        in_app_id               CONSTANT navigation.app_id%TYPE := app.get_app_id();
    BEGIN
        app.log_module(in_page_id);

        -- remove pages and references, related rows
        FOR c IN (
            SELECT in_app_id AS app_id, p.page_id
            FROM nav_pages_to_remove p
            WHERE p.page_id         = NVL(in_page_id, p.page_id)
            UNION
            SELECT n.app_id, n.page_id
            FROM navigation n
            WHERE n.app_id          = in_app_id
                AND n.page_id       = in_page_id
        ) LOOP
            app.log_debug('DELETING', c.app_id, c.page_id);
            --
            UPDATE navigation n
            SET n.parent_id         = NULL
            WHERE n.app_id          = c.app_id
                AND n.parent_id     = c.page_id;
            --
            DELETE FROM translated_items t
            WHERE t.app_id          = c.app_id
                AND t.page_id       = c.page_id;
            --
            DELETE FROM navigation n
            WHERE n.app_id          = c.app_id
                AND n.page_id       = c.page_id;
        END LOOP;
        --
        app.log_success();
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
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
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
    END;



    PROCEDURE nav_autoupdate
    AS
    BEGIN
        app.log_module();
        --
        nav_remove_pages();
        nav_add_pages();

        -- renumber sublings
        MERGE INTO navigation g
        USING (
            SELECT n.app_id, n.page_id, n.new_order#
            FROM (
                SELECT
                    n.app_id,
                    n.page_id,
                    n.order#,
                    ROW_NUMBER() OVER (PARTITION BY n.parent_id ORDER BY n.order#, n.page_id) * 5 + 5 AS new_order#
                FROM navigation n
                WHERE n.app_id          = app.get_app_id()
                    AND n.parent_id     IS NOT NULL
            ) n
            WHERE n.new_order# != n.order#
        ) n
            ON (
                g.app_id        = n.app_id
            AND g.page_id       = n.page_id
        )
        WHEN MATCHED THEN
        UPDATE SET g.order#     = n.new_order#;
        --
        app.log_success();
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
    END;



    PROCEDURE refresh_nav_views
    AS
    BEGIN
        app.log_module();
        --
        FOR c IN (
            SELECT v.mview_name
            FROM user_mviews v
            WHERE v.mview_name LIKE 'NAV\_%' ESCAPE '\'
        ) LOOP
            DBMS_MVIEW.REFRESH(c.mview_name, 'C', parallelism => 2);
            app.log_result(c.mview_name);
        END LOOP;
        --
        app.log_success();
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
    END;



    PROCEDURE save_nav_overview (
        in_action               CHAR,
        in_app_id               navigation.app_id%TYPE,
        in_page_id              navigation.page_id%TYPE,
        in_parent_id            navigation.parent_id%TYPE,
        in_order#               navigation.order#%TYPE,
        in_is_hidden            navigation.is_hidden%TYPE,
        in_is_reset             navigation.is_reset%TYPE,
        in_is_shared            navigation.is_shared%TYPE
    ) AS
        rec                     navigation%ROWTYPE;
        v_log_id                logs.log_id%TYPE;
    BEGIN
        v_log_id := app.log_module_json (
            'action',           in_action,
            'app_id',           in_app_id,
            'page_id',          in_page_id,
            'parent_id',        in_parent_id,
            'order#',           in_order#,
            'is_hidden',        in_is_hidden,
            'is_reset',         in_is_reset,
            'is_shared',        in_is_shared
        );
        --
        rec.app_id              := COALESCE(in_app_id, app.get_app_id());
        rec.page_id             := in_page_id;
        rec.parent_id           := NULLIF(in_parent_id, 0);
        rec.order#              := in_order#;
        rec.is_hidden           := in_is_hidden;
        rec.is_reset            := in_is_reset;
        rec.is_shared           := in_is_shared;
        rec.updated_by          := app.get_user_id();
        rec.updated_at          := SYSDATE;
        --
        IF in_action = 'D' THEN
            DELETE FROM navigation t
            WHERE t.app_id      = in_app_id
                AND t.page_id   = in_page_id;
        ELSE
            UPDATE navigation t
            SET ROW = rec
            WHERE t.app_id      = in_app_id
                AND t.page_id   = in_page_id;
            --
            IF SQL%ROWCOUNT = 0 THEN
                INSERT INTO navigation
                VALUES rec;
            END IF;
        END IF;
        --
        app.log_success(v_log_id);
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
    END;

END;
/

