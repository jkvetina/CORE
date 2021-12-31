CREATE OR REPLACE PACKAGE BODY app_actions AS

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



    PROCEDURE prep_user_roles_pivot (
        in_page_id              apex_application_pages.page_id%TYPE
    ) AS
        in_collection           CONSTANT apex_collections.collection_name%TYPE := 'P' || TO_CHAR(in_page_id);
        --
        v_query                 VARCHAR2(32767);
        v_cols                  PLS_INTEGER;
        v_cursor                PLS_INTEGER                 := DBMS_SQL.OPEN_CURSOR;
        v_desc                  DBMS_SQL.DESC_TAB;
    BEGIN
        -- build query
        v_query := v_query || 'SELECT' || CHR(10) || '    u.user_id,';
        --
        FOR r IN (
            SELECT r.role_id
            FROM roles r
            WHERE r.app_id = app.get_app_id()
            ORDER BY r.role_group NULLS LAST, r.order# NULLS LAST, r.role_id
        ) LOOP
            v_query := v_query || CHR(10) || '    MAX(CASE WHEN r.role_id = ''' || r.role_id || ''' THEN ''Y'' END) AS ' || LOWER(r.role_id) || '_, ';
        END LOOP;
        --
        v_query := RTRIM(v_query, ', ') || CHR(10) || 'FROM users u LEFT JOIN user_roles r ON r.app_id = app.get_app_id() AND r.user_id = u.user_id' || CHR(10) || 'GROUP BY u.user_id';
        --
        DBMS_OUTPUT.PUT_LINE(v_query);

        -- initialize and populate collection
        IF APEX_COLLECTION.COLLECTION_EXISTS(in_collection) THEN
            APEX_COLLECTION.DELETE_COLLECTION(in_collection);
        END IF;
        --
        APEX_COLLECTION.CREATE_COLLECTION_FROM_QUERY (
            p_collection_name   => in_collection,
            p_query             => v_query
        );

        -- pass proper column names via page items
        DBMS_SQL.PARSE(v_cursor, v_query, DBMS_SQL.NATIVE);
        DBMS_SQL.DESCRIBE_COLUMNS(v_cursor, v_cols, v_desc);
        DBMS_SQL.CLOSE_CURSOR(v_cursor);
        --
        FOR i IN 1 .. v_desc.COUNT LOOP
            BEGIN
                APEX_UTIL.SET_SESSION_STATE (
                    p_name      => 'P' || in_page_id || '_C' || LPAD(i, 3, 0),
                    p_value     => get_role_name(RTRIM(v_desc(i).col_name, '_')),
                    p_commit    => FALSE
                );
            EXCEPTION
            WHEN OTHERS THEN
                NULL;           -- item might not exists
            END;
        END LOOP;
    END;



    PROCEDURE save_user_roles (
        in_action       CHAR,
        in_c001         VARCHAR2 := NULL,
        in_c002         VARCHAR2 := NULL,
        in_c003         VARCHAR2 := NULL,
        in_c004         VARCHAR2 := NULL,
        in_c005         VARCHAR2 := NULL,
        in_c006         VARCHAR2 := NULL,
        in_c007         VARCHAR2 := NULL,
        in_c008         VARCHAR2 := NULL,
        in_c009         VARCHAR2 := NULL,
        in_c010         VARCHAR2 := NULL,
        in_c011         VARCHAR2 := NULL,
        in_c012         VARCHAR2 := NULL,
        in_c013         VARCHAR2 := NULL,
        in_c014         VARCHAR2 := NULL,
        in_c015         VARCHAR2 := NULL,
        in_c016         VARCHAR2 := NULL,
        in_c017         VARCHAR2 := NULL,
        in_c018         VARCHAR2 := NULL,
        in_c019         VARCHAR2 := NULL,
        in_c020         VARCHAR2 := NULL,
        in_c021         VARCHAR2 := NULL,
        in_c022         VARCHAR2 := NULL,
        in_c023         VARCHAR2 := NULL,
        in_c024         VARCHAR2 := NULL,
        in_c025         VARCHAR2 := NULL,
        in_c026         VARCHAR2 := NULL,
        in_c027         VARCHAR2 := NULL,
        in_c028         VARCHAR2 := NULL,
        in_c029         VARCHAR2 := NULL,
        in_c030         VARCHAR2 := NULL,
        in_c031         VARCHAR2 := NULL,
        in_c032         VARCHAR2 := NULL,
        in_c033         VARCHAR2 := NULL,
        in_c034         VARCHAR2 := NULL,
        in_c035         VARCHAR2 := NULL,
        in_c036         VARCHAR2 := NULL,
        in_c037         VARCHAR2 := NULL,
        in_c038         VARCHAR2 := NULL,
        in_c039         VARCHAR2 := NULL,
        in_c040         VARCHAR2 := NULL,
        in_c041         VARCHAR2 := NULL,
        in_c042         VARCHAR2 := NULL,
        in_c043         VARCHAR2 := NULL,
        in_c044         VARCHAR2 := NULL,
        in_c045         VARCHAR2 := NULL,
        in_c046         VARCHAR2 := NULL,
        in_c047         VARCHAR2 := NULL,
        in_c048         VARCHAR2 := NULL,
        in_c049         VARCHAR2 := NULL,
        in_c050         VARCHAR2 := NULL
    ) AS
        rec             user_roles%ROWTYPE;
        v_offset        CONSTANT PLS_INTEGER := 1;  -- used columns
    BEGIN
        app.log_module(in_action, in_c001);
        --
        rec.app_id          := app.get_app_id();
        rec.user_id         := in_c001;
        rec.role_id         := NULL;
        rec.updated_by      := app.get_user_id();
        rec.updated_at      := SYSDATE;

        -- cleanup all roles
        DELETE FROM user_roles t
        WHERE t.app_id      = rec.app_id
            AND t.user_id   = rec.user_id;
        --
        IF in_action = 'D' THEN
            app.log_success();
            RETURN;
        END IF;

        -- match order with view on page
        FOR r IN (
            SELECT
                r.role_id,
                'C' || SUBSTR(1000 + v_offset + ROW_NUMBER() OVER(ORDER BY r.role_group NULLS LAST, r.order# NULLS LAST, r.role_id), 2, 3) AS arg
            FROM roles r
            WHERE r.app_id = rec.app_id
        ) LOOP
            rec.role_id := CASE
                WHEN r.arg = 'C002' AND in_c002 = 'Y' THEN r.role_id
                WHEN r.arg = 'C003' AND in_c003 = 'Y' THEN r.role_id
                WHEN r.arg = 'C004' AND in_c004 = 'Y' THEN r.role_id
                WHEN r.arg = 'C005' AND in_c005 = 'Y' THEN r.role_id
                WHEN r.arg = 'C006' AND in_c006 = 'Y' THEN r.role_id
                WHEN r.arg = 'C007' AND in_c007 = 'Y' THEN r.role_id
                WHEN r.arg = 'C008' AND in_c008 = 'Y' THEN r.role_id
                WHEN r.arg = 'C009' AND in_c009 = 'Y' THEN r.role_id
                WHEN r.arg = 'C010' AND in_c010 = 'Y' THEN r.role_id
                WHEN r.arg = 'C011' AND in_c011 = 'Y' THEN r.role_id
                WHEN r.arg = 'C012' AND in_c012 = 'Y' THEN r.role_id
                WHEN r.arg = 'C013' AND in_c013 = 'Y' THEN r.role_id
                WHEN r.arg = 'C014' AND in_c014 = 'Y' THEN r.role_id
                WHEN r.arg = 'C015' AND in_c015 = 'Y' THEN r.role_id
                WHEN r.arg = 'C016' AND in_c016 = 'Y' THEN r.role_id
                WHEN r.arg = 'C017' AND in_c017 = 'Y' THEN r.role_id
                WHEN r.arg = 'C018' AND in_c018 = 'Y' THEN r.role_id
                WHEN r.arg = 'C019' AND in_c019 = 'Y' THEN r.role_id
                WHEN r.arg = 'C020' AND in_c020 = 'Y' THEN r.role_id
                WHEN r.arg = 'C021' AND in_c021 = 'Y' THEN r.role_id
                WHEN r.arg = 'C022' AND in_c022 = 'Y' THEN r.role_id
                WHEN r.arg = 'C023' AND in_c023 = 'Y' THEN r.role_id
                WHEN r.arg = 'C024' AND in_c024 = 'Y' THEN r.role_id
                WHEN r.arg = 'C025' AND in_c025 = 'Y' THEN r.role_id
                WHEN r.arg = 'C026' AND in_c026 = 'Y' THEN r.role_id
                WHEN r.arg = 'C027' AND in_c027 = 'Y' THEN r.role_id
                WHEN r.arg = 'C028' AND in_c028 = 'Y' THEN r.role_id
                WHEN r.arg = 'C029' AND in_c029 = 'Y' THEN r.role_id
                WHEN r.arg = 'C030' AND in_c030 = 'Y' THEN r.role_id
                WHEN r.arg = 'C031' AND in_c031 = 'Y' THEN r.role_id
                WHEN r.arg = 'C032' AND in_c032 = 'Y' THEN r.role_id
                WHEN r.arg = 'C033' AND in_c033 = 'Y' THEN r.role_id
                WHEN r.arg = 'C034' AND in_c034 = 'Y' THEN r.role_id
                WHEN r.arg = 'C035' AND in_c035 = 'Y' THEN r.role_id
                WHEN r.arg = 'C036' AND in_c036 = 'Y' THEN r.role_id
                WHEN r.arg = 'C037' AND in_c037 = 'Y' THEN r.role_id
                WHEN r.arg = 'C038' AND in_c038 = 'Y' THEN r.role_id
                WHEN r.arg = 'C039' AND in_c039 = 'Y' THEN r.role_id
                WHEN r.arg = 'C040' AND in_c040 = 'Y' THEN r.role_id
                WHEN r.arg = 'C041' AND in_c041 = 'Y' THEN r.role_id
                WHEN r.arg = 'C042' AND in_c042 = 'Y' THEN r.role_id
                WHEN r.arg = 'C043' AND in_c043 = 'Y' THEN r.role_id
                WHEN r.arg = 'C044' AND in_c044 = 'Y' THEN r.role_id
                WHEN r.arg = 'C045' AND in_c045 = 'Y' THEN r.role_id
                WHEN r.arg = 'C046' AND in_c046 = 'Y' THEN r.role_id
                WHEN r.arg = 'C047' AND in_c047 = 'Y' THEN r.role_id
                WHEN r.arg = 'C048' AND in_c048 = 'Y' THEN r.role_id
                WHEN r.arg = 'C049' AND in_c049 = 'Y' THEN r.role_id
                WHEN r.arg = 'C050' AND in_c050 = 'Y' THEN r.role_id
                END;
            --
            IF rec.role_id IS NOT NULL THEN
                INSERT INTO user_roles
                VALUES rec;
            END IF;
        END LOOP;
        --
        app.log_success();
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
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



    PROCEDURE set_setting (
        in_action               CHAR,
        in_setting_name_old     settings.setting_name%TYPE,
        in_setting_name         settings.setting_name%TYPE,
        in_setting_group        settings.setting_group%TYPE         := NULL,
        in_setting_value        settings.setting_value%TYPE         := NULL,
        in_is_numeric           settings.is_numeric%TYPE            := NULL,
        in_is_date              settings.is_date%TYPE               := NULL,
        in_description          settings.description_%TYPE          := NULL
    )
    AS
        rec                     settings%ROWTYPE;
    BEGIN
        app.log_module_json (
            'in_action',        in_action,
            'in_name_old',      in_setting_name_old,
            'in_name',          in_setting_name,
            'in_value',         in_setting_value,
            'in_group',         in_setting_group,
            'in_is_numeric',    in_is_numeric,
            'in_is_date',       in_is_date
        );
        --
        rec.app_id              := app.get_app_id();
        rec.setting_name        := UPPER(in_setting_name);
        rec.setting_value       := in_setting_value;
        rec.setting_context     := NULL;
        rec.setting_group       := in_setting_group;
        rec.is_numeric          := in_is_numeric;
        rec.is_date             := in_is_date;
        rec.description_        := in_description;
        rec.updated_by          := app.get_user_id();
        rec.updated_at          := SYSDATE;
        --
        CASE in_action
        WHEN 'D' THEN
            DELETE FROM settings s
            WHERE s.app_id              = rec.app_id
                AND s.setting_name      = in_setting_name_old;
        --
        WHEN 'U' THEN
            UPDATE settings s
            SET ROW                     = rec
            WHERE s.app_id              = rec.app_id
                AND s.setting_name      = in_setting_name_old
                AND s.setting_context   IS NULL;
            --
            IF SQL%ROWCOUNT = 0 THEN
                app.raise_error('SETTINGS_UPDATE_FAILED');
            END IF;
            --
            UPDATE settings s
            SET s.setting_name          = rec.setting_name
            WHERE s.app_id              = rec.app_id
                AND s.setting_name      = in_setting_name_old;
        --
        ELSE
            BEGIN
                INSERT INTO settings VALUES rec;
            EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                app.raise_error('SETTINGS_EXISTS');
            END;
        END CASE;
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
    END;



    PROCEDURE set_setting_bulk (
        in_c001         settings.setting_value%TYPE,
        in_c002         settings.setting_value%TYPE,
        in_c003         settings.setting_value%TYPE         := NULL,
        in_c004         settings.setting_value%TYPE         := NULL,
        in_c005         settings.setting_value%TYPE         := NULL,
        in_c006         settings.setting_value%TYPE         := NULL,
        in_c007         settings.setting_value%TYPE         := NULL,
        in_c008         settings.setting_value%TYPE         := NULL,
        in_c009         settings.setting_value%TYPE         := NULL,
        in_c010         settings.setting_value%TYPE         := NULL,
        in_c011         settings.setting_value%TYPE         := NULL,
        in_c012         settings.setting_value%TYPE         := NULL,
        in_c013         settings.setting_value%TYPE         := NULL,
        in_c014         settings.setting_value%TYPE         := NULL,
        in_c015         settings.setting_value%TYPE         := NULL,
        in_c016         settings.setting_value%TYPE         := NULL,
        in_c017         settings.setting_value%TYPE         := NULL,
        in_c018         settings.setting_value%TYPE         := NULL,
        in_c019         settings.setting_value%TYPE         := NULL,
        in_c020         settings.setting_value%TYPE         := NULL,
        in_c021         settings.setting_value%TYPE         := NULL,
        in_c022         settings.setting_value%TYPE         := NULL,
        in_c023         settings.setting_value%TYPE         := NULL,
        in_c024         settings.setting_value%TYPE         := NULL,
        in_c025         settings.setting_value%TYPE         := NULL,
        in_c026         settings.setting_value%TYPE         := NULL,
        in_c027         settings.setting_value%TYPE         := NULL,
        in_c028         settings.setting_value%TYPE         := NULL,
        in_c029         settings.setting_value%TYPE         := NULL,
        in_c030         settings.setting_value%TYPE         := NULL,
        in_c031         settings.setting_value%TYPE         := NULL,
        in_c032         settings.setting_value%TYPE         := NULL,
        in_c033         settings.setting_value%TYPE         := NULL,
        in_c034         settings.setting_value%TYPE         := NULL,
        in_c035         settings.setting_value%TYPE         := NULL,
        in_c036         settings.setting_value%TYPE         := NULL,
        in_c037         settings.setting_value%TYPE         := NULL,
        in_c038         settings.setting_value%TYPE         := NULL,
        in_c039         settings.setting_value%TYPE         := NULL,
        in_c040         settings.setting_value%TYPE         := NULL,
        in_c041         settings.setting_value%TYPE         := NULL,
        in_c042         settings.setting_value%TYPE         := NULL,
        in_c043         settings.setting_value%TYPE         := NULL,
        in_c044         settings.setting_value%TYPE         := NULL,
        in_c045         settings.setting_value%TYPE         := NULL,
        in_c046         settings.setting_value%TYPE         := NULL,
        in_c047         settings.setting_value%TYPE         := NULL,
        in_c048         settings.setting_value%TYPE         := NULL,
        in_c049         settings.setting_value%TYPE         := NULL,
        in_c050         settings.setting_value%TYPE         := NULL
    )
    AS
        rec             settings%ROWTYPE;
        v_offset        CONSTANT PLS_INTEGER := 3;  -- used columns (name, group, default)
    BEGIN
        app.log_module(in_c001, in_c002, in_c003, in_c004, in_c005, in_c006, in_c007, in_c008);
        --
        rec.app_id              := app.get_app_id();
        rec.setting_name        := in_c001;
        rec.setting_value       := in_c003;                 -- fill in the loop
        rec.setting_context     := NULL;                    -- fill in the loop
        rec.setting_group       := in_c002;
        rec.updated_by          := app.get_user_id();
        rec.updated_at          := SYSDATE;
    
        -- cleanup setting
        DELETE FROM settings s
        WHERE s.app_id              = rec.app_id
            AND s.setting_name      = rec.setting_name
            AND s.setting_context   IS NOT NULL;

        -- update default value
        UPDATE settings s
        SET ROW                     = rec
        WHERE s.app_id              = rec.app_id
            AND s.setting_name      = rec.setting_name
            AND s.setting_context   IS NULL;

        -- match order with view on page
        FOR r IN (
            SELECT
                s.context_id,
                'C' || SUBSTR(1000 + v_offset + ROW_NUMBER() OVER(ORDER BY s.order# NULLS LAST, s.context_id), 2, 3) AS arg
            FROM setting_contexts s
            WHERE s.app_id = rec.app_id
        ) LOOP
            CONTINUE WHEN r.arg IN ('C001', 'C002', 'C003');
            --
            rec.setting_context := CASE
                WHEN r.arg = 'C003' THEN r.context_id       WHEN r.arg = 'C004' THEN r.context_id
                WHEN r.arg = 'C005' THEN r.context_id       WHEN r.arg = 'C006' THEN r.context_id
                WHEN r.arg = 'C007' THEN r.context_id       WHEN r.arg = 'C008' THEN r.context_id
                WHEN r.arg = 'C009' THEN r.context_id       WHEN r.arg = 'C010' THEN r.context_id
                WHEN r.arg = 'C011' THEN r.context_id       WHEN r.arg = 'C012' THEN r.context_id
                WHEN r.arg = 'C013' THEN r.context_id       WHEN r.arg = 'C014' THEN r.context_id
                WHEN r.arg = 'C015' THEN r.context_id       WHEN r.arg = 'C016' THEN r.context_id
                WHEN r.arg = 'C017' THEN r.context_id       WHEN r.arg = 'C018' THEN r.context_id
                WHEN r.arg = 'C019' THEN r.context_id       WHEN r.arg = 'C020' THEN r.context_id
                WHEN r.arg = 'C021' THEN r.context_id       WHEN r.arg = 'C022' THEN r.context_id
                WHEN r.arg = 'C023' THEN r.context_id       WHEN r.arg = 'C024' THEN r.context_id
                WHEN r.arg = 'C025' THEN r.context_id       WHEN r.arg = 'C026' THEN r.context_id
                WHEN r.arg = 'C027' THEN r.context_id       WHEN r.arg = 'C028' THEN r.context_id
                WHEN r.arg = 'C029' THEN r.context_id       WHEN r.arg = 'C030' THEN r.context_id
                WHEN r.arg = 'C031' THEN r.context_id       WHEN r.arg = 'C032' THEN r.context_id
                WHEN r.arg = 'C033' THEN r.context_id       WHEN r.arg = 'C034' THEN r.context_id
                WHEN r.arg = 'C035' THEN r.context_id       WHEN r.arg = 'C036' THEN r.context_id
                WHEN r.arg = 'C037' THEN r.context_id       WHEN r.arg = 'C038' THEN r.context_id
                WHEN r.arg = 'C039' THEN r.context_id       WHEN r.arg = 'C040' THEN r.context_id
                WHEN r.arg = 'C041' THEN r.context_id       WHEN r.arg = 'C042' THEN r.context_id
                WHEN r.arg = 'C043' THEN r.context_id       WHEN r.arg = 'C044' THEN r.context_id
                WHEN r.arg = 'C045' THEN r.context_id       WHEN r.arg = 'C046' THEN r.context_id
                WHEN r.arg = 'C047' THEN r.context_id       WHEN r.arg = 'C048' THEN r.context_id
                WHEN r.arg = 'C049' THEN r.context_id       WHEN r.arg = 'C050' THEN r.context_id
                END;
            --
            rec.setting_value := CASE
                WHEN r.arg = 'C003' THEN in_c003            WHEN r.arg = 'C004' THEN in_c004
                WHEN r.arg = 'C005' THEN in_c005            WHEN r.arg = 'C006' THEN in_c006
                WHEN r.arg = 'C007' THEN in_c007            WHEN r.arg = 'C008' THEN in_c008
                WHEN r.arg = 'C009' THEN in_c009            WHEN r.arg = 'C010' THEN in_c010
                WHEN r.arg = 'C011' THEN in_c011            WHEN r.arg = 'C012' THEN in_c012
                WHEN r.arg = 'C013' THEN in_c013            WHEN r.arg = 'C014' THEN in_c014
                WHEN r.arg = 'C015' THEN in_c015            WHEN r.arg = 'C016' THEN in_c016
                WHEN r.arg = 'C017' THEN in_c017            WHEN r.arg = 'C018' THEN in_c018
                WHEN r.arg = 'C019' THEN in_c019            WHEN r.arg = 'C020' THEN in_c020
                WHEN r.arg = 'C021' THEN in_c021            WHEN r.arg = 'C022' THEN in_c022
                WHEN r.arg = 'C023' THEN in_c023            WHEN r.arg = 'C024' THEN in_c024
                WHEN r.arg = 'C025' THEN in_c025            WHEN r.arg = 'C026' THEN in_c026
                WHEN r.arg = 'C027' THEN in_c027            WHEN r.arg = 'C028' THEN in_c028
                WHEN r.arg = 'C029' THEN in_c029            WHEN r.arg = 'C030' THEN in_c030
                WHEN r.arg = 'C031' THEN in_c031            WHEN r.arg = 'C032' THEN in_c032
                WHEN r.arg = 'C033' THEN in_c033            WHEN r.arg = 'C034' THEN in_c034
                WHEN r.arg = 'C035' THEN in_c035            WHEN r.arg = 'C036' THEN in_c036
                WHEN r.arg = 'C037' THEN in_c037            WHEN r.arg = 'C038' THEN in_c038
                WHEN r.arg = 'C039' THEN in_c039            WHEN r.arg = 'C040' THEN in_c040
                WHEN r.arg = 'C041' THEN in_c041            WHEN r.arg = 'C042' THEN in_c042
                WHEN r.arg = 'C043' THEN in_c043            WHEN r.arg = 'C044' THEN in_c044
                WHEN r.arg = 'C045' THEN in_c045            WHEN r.arg = 'C046' THEN in_c046
                WHEN r.arg = 'C047' THEN in_c047            WHEN r.arg = 'C048' THEN in_c048
                WHEN r.arg = 'C049' THEN in_c049            WHEN r.arg = 'C050' THEN in_c050
                END;
            --
            CONTINUE WHEN (rec.setting_context IS NULL OR rec.setting_value IS NULL);
            --
            INSERT INTO settings
            VALUES rec;
        END LOOP;
        --
        app.log_success();
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
    END;



    PROCEDURE rebuild_settings
    AS
        q       VARCHAR2(32767);
        b       VARCHAR2(32767);
    BEGIN
        app.log_module();
        --
        app_actions.refresh_user_source_views();
        --
        q := 'CREATE OR REPLACE PACKAGE '       || LOWER(in_settings_package) || ' AS' || CHR(10);
        b := 'CREATE OR REPLACE PACKAGE BODY '  || LOWER(in_settings_package) || ' AS' || CHR(10);
        --
        FOR c IN (
            SELECT
                s.setting_name,
                s.is_numeric,
                s.is_date
            FROM settings s
            WHERE s.app_id              = app.get_app_id()
                AND s.setting_context   IS NULL
            ORDER BY s.setting_name
        ) LOOP
            -- create specification
            q := q || CHR(10);
            q := q || '    FUNCTION ' || LOWER(in_settings_prefix) || LOWER(c.setting_name) || ' (' || CHR(10);
            q := q || '        in_context      settings.setting_context%TYPE := NULL' || CHR(10);
            q := q || '    )' || CHR(10);
            q := q || '    RETURN ' || CASE
                                WHEN c.is_numeric   = 'Y' THEN 'NUMBER'
                                WHEN c.is_date      = 'Y' THEN 'DATE'
                                ELSE 'VARCHAR2' END || CHR(10);
            q := q || '    RESULT_CACHE;' || CHR(10);

            -- create package body
            b := b || CHR(10);
            b := b || '    FUNCTION ' || LOWER(in_settings_prefix) || LOWER(c.setting_name) || ' (' || CHR(10);
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
                                    END || 'app_actions.get_setting (' || CHR(10);
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
        recompile();
        --
        /*
        DBMS_RESULT_CACHE.INVALIDATE (
            owner   => app.schema_owner,
            name    => app_actions.in_settings_package
        );
        */
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
    END;



    PROCEDURE prep_settings_pivot (
        in_page_id              apex_application_pages.page_id%TYPE
    ) AS
        in_collection           CONSTANT apex_collections.collection_name%TYPE := 'P' || TO_CHAR(in_page_id);
        --
        v_query                 VARCHAR2(32767);
        v_cols                  PLS_INTEGER;
        v_cursor                PLS_INTEGER                 := DBMS_SQL.OPEN_CURSOR;
        v_desc                  DBMS_SQL.DESC_TAB;
        --
        v_context_name          setting_contexts.context_name%TYPE;
    BEGIN
        -- build query
        v_query := v_query || 'SELECT' || CHR(10);
        v_query := v_query || '    s.setting_name,' || CHR(10);
        v_query := v_query || '    MAX(s.setting_group) AS setting_group,' || CHR(10);
        --
        v_query := v_query || '    MAX(CASE WHEN s.setting_context IS NULL THEN s.setting_value END) AS null__,' || CHR(10);
        --
        FOR c IN (
            SELECT c.context_id
            FROM setting_contexts c
            WHERE c.app_id = app.get_app_id()
            ORDER BY c.order#, c.context_id
        ) LOOP
            v_query := v_query || '    MAX(CASE WHEN s.setting_context = ''' || c.context_id || ''' THEN s.setting_value END) AS ' || LOWER(c.context_id) || '_,' || CHR(10);
        END LOOP;
        --
        v_query := RTRIM(RTRIM(v_query, CHR(10)), ',') || CHR(10);
        v_query := v_query || 'FROM settings s' || CHR(10);
        v_query := v_query || 'WHERE s.app_id = app.get_app_id()' || CHR(10);
        v_query := v_query || 'GROUP BY s.setting_name';
        --
        app.log_debug(in_payload => v_query);
        DBMS_OUTPUT.PUT_LINE(v_query);

        -- initialize and populate collection
        IF APEX_COLLECTION.COLLECTION_EXISTS(in_collection) THEN
            APEX_COLLECTION.DELETE_COLLECTION(in_collection);
        END IF;
        --
        APEX_COLLECTION.CREATE_COLLECTION_FROM_QUERY (
            p_collection_name   => in_collection,
            p_query             => v_query
        );

        -- pass proper column names via page items
        DBMS_SQL.PARSE(v_cursor, v_query, DBMS_SQL.NATIVE);
        DBMS_SQL.DESCRIBE_COLUMNS(v_cursor, v_cols, v_desc);
        DBMS_SQL.CLOSE_CURSOR(v_cursor);
        --
        FOR i IN 1 .. v_desc.COUNT LOOP
            BEGIN
                SELECT NVL(c.context_name, c.context_id) INTO v_context_name
                FROM setting_contexts c
                WHERE c.app_id          = app.get_app_id()
                    AND c.context_id    = RTRIM(v_desc(i).col_name, '_');
                --
                APEX_UTIL.SET_SESSION_STATE (
                    p_name      => 'P' || in_page_id || '_C' || LPAD(i, 3, 0),
                    p_value     => v_context_name,
                    p_commit    => FALSE
                );
            EXCEPTION
            WHEN OTHERS THEN
                NULL;           -- item might not exists
            END;
        END LOOP;
    EXCEPTION
    WHEN app.app_exception THEN
        RAISE;
    WHEN OTHERS THEN
        app.raise_error();
    END;



    PROCEDURE refresh_user_source_views
    AS
        PRAGMA AUTONOMOUS_TRANSACTION;
        --
        PROCEDURE clob_to_lines (
            in_name         VARCHAR2,
            in_clob         CLOB
        ) AS
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
                INSERT INTO user_source_views (name, line, text)
                VALUES (
                    in_name,
                    clob_line,
                    REPLACE(REPLACE(buffer, CHR(13), ''), CHR(10), '')
                );
                --
                clob_line := clob_line + 1;
                IF INSTR(in_clob, CHR(10), offset) = clob_len THEN
                    buffer := '';
                END IF;
                offset := offset + amount + 1;
            END LOOP;
        END;
    BEGIN
        app.log_module();
        --
        DELETE FROM user_source_views;
        --
        FOR c IN (
            SELECT
                v.view_name,
                DBMS_METADATA.GET_DDL('VIEW', v.view_name) AS content
            FROM user_views v
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(c.view_name);
            clob_to_lines(c.view_name, REGEXP_REPLACE(c.content, '^(\s*)', ''));
        END LOOP;
        --
        COMMIT;
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

END;
/
