CREATE OR REPLACE PACKAGE BODY nav AS

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



    PROCEDURE refresh_nav_views (
        in_log_id           logs.log_id%TYPE,
        in_user_id          logs.user_id%TYPE,
        in_app_id           logs.app_id%TYPE,
        in_lang_id          users.lang_id%TYPE
    )
    AS
    BEGIN
        DBMS_MVIEW.REFRESH('NAV_AVAILABILITY_MVW',  'C', parallelism => 2);
        DBMS_MVIEW.REFRESH('NAV_OVERVIEW_MVW',      'C', parallelism => 2);
        --
        app_actions.send_message (
            in_app_id       => in_app_id,
            in_user_id      => in_user_id,
            in_message      => app.get_translated_message('MVW_REFRESHED', in_app_id, in_lang_id)
        );
        --
        app.log_success(TO_CHAR(in_log_id));
    EXCEPTION
    WHEN OTHERS THEN
        app_actions.send_message (
            in_app_id       => in_app_id,
            in_user_id      => in_user_id,
            in_message      => app.get_translated_message('MVW_FAILED', in_app_id, in_lang_id),
            in_type         => 'WARNING'
        );
        COMMIT;
        --
        app.raise_error();
    END;



    PROCEDURE refresh_nav_views
    AS
        v_log_id            logs.log_id%TYPE;
        v_query             VARCHAR2(32767);
    BEGIN
        v_log_id := app.log_module();
        --
        app.create_job (
            in_job_name     => 'RECALC_MVW_NAV',
            in_statement    => 'app_actions.refresh_nav_views('
                || v_log_id || ', '''
                || app.get_user_id() || ''', '
                || app.get_app_id() || ', '''
                || app.get_user_lang() || ''''
                || ');'
        );
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

