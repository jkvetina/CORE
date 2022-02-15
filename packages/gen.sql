CREATE OR REPLACE PACKAGE BODY gen AS

    FUNCTION get_width (
        in_table_name           user_tables.table_name%TYPE,
        in_prefix               VARCHAR2
    )
    RETURN PLS_INTEGER AS
        out_size                PLS_INTEGER;
    BEGIN
        -- check tables/views
        SELECT MAX(LENGTH(c.column_name)) INTO out_size
        FROM user_tab_columns c
        WHERE c.table_name          = UPPER(in_table_name);
        --
        IF out_size IS NULL THEN
            -- check procedures and procedures in packages
            SELECT MAX(LENGTH(a.argument_name)) INTO out_size
            FROM user_arguments a
            WHERE a.package_name || '.' || a.object_name IN (UPPER(in_table_name), '.' || UPPER(in_table_name));
        END IF;
        --
        RETURN CEIL((NVL(LENGTH(in_prefix), 0) + gen.minimal_space + out_size) / gen.tab_width) * gen.tab_width;
    END;



    PROCEDURE get_table_args (
        in_table_name           user_tables.table_name%TYPE,
        in_prepend              VARCHAR2                        := NULL
    )
    AS
        width                   PLS_INTEGER;
    BEGIN
        width := gen.get_width (
            in_table_name           => in_table_name,
            in_prefix               => gen.in_prefix
        );
        --
        FOR c IN (
            SELECT
                CASE WHEN c.column_name LIKE 'OUT\_%' ESCAPE '\'
                    THEN RPAD(LOWER(c.column_name), width) || 'IN OUT  '
                    ELSE RPAD(gen.in_prefix || LOWER(c.column_name), width) || '        '
                    END
                || LOWER(c.table_name) || '.'
                || CASE WHEN (c.nullable = 'N' OR c.column_name NOT LIKE 'OUT\_%' ESCAPE '\')
                    THEN LOWER(c.column_name) || '%TYPE'
                    ELSE RPAD(LOWER(c.column_name) || '%TYPE', width, ' ') || ' := NULL'
                    END
                || CASE WHEN c.column_id < COUNT(*) OVER() THEN ',' END AS text
            FROM user_tab_columns c
            WHERE c.table_name          = in_table_name
                AND c.column_name       NOT IN ('UPDATED_AT', 'UPDATED_BY')
            ORDER BY c.column_id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(in_prepend || c.text);
        END LOOP;
    END;



    PROCEDURE get_table_out_args (
        in_table_name           user_tables.table_name%TYPE,
        in_prepend              VARCHAR2                        := NULL,
        in_value                VARCHAR2                        := NULL
    )
    AS
        width                   PLS_INTEGER;
    BEGIN
        width := gen.get_width (
            in_table_name           => in_table_name,
            in_prefix               => gen.in_prefix
        );
        --
        FOR c IN (
            SELECT
                RPAD(LOWER(c.column_name), width + 8, ' ')
                || ':= ' || COALESCE(in_value, LOWER(REGEXP_REPLACE(c.column_name, '^OUT_', 'rec.'))) || ';' AS text
            FROM user_tab_columns c
            WHERE c.table_name          = in_table_name
                AND c.column_name       LIKE 'OUT\_%' ESCAPE '\'
            ORDER BY c.column_id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(in_prepend || c.text);
        END LOOP;
    END;



    PROCEDURE get_table_out_logs (
        in_table_name           user_tables.table_name%TYPE,
        in_prepend              VARCHAR2                        := NULL
    )
    AS
        width                   PLS_INTEGER;
    BEGIN
        width := gen.get_width (
            in_table_name           => in_table_name,
            in_prefix               => gen.in_prefix
        );
        --
        FOR c IN (
            SELECT
                RPAD('''' || LOWER(REGEXP_REPLACE(c.column_name, '^OUT_', 'old_')) || ''',', width + 4, ' ')
                || LOWER(c.column_name) || ',' AS text
            FROM user_tab_columns c
            WHERE c.table_name          = in_table_name
                AND c.column_name       LIKE 'OUT\_%' ESCAPE '\'
            ORDER BY c.column_id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(in_prepend || c.text);
        END LOOP;
    END;



    PROCEDURE get_table_in_logs (
        in_table_name           user_tables.table_name%TYPE,
        in_prepend              VARCHAR2                        := NULL
    )
    AS
        width                   PLS_INTEGER;
    BEGIN
        width := gen.get_width (
            in_table_name           => in_table_name,
            in_prefix               => gen.in_prefix
        );
        --
        FOR c IN (
            SELECT
                RPAD('''' || LOWER(c.column_name) || ''',', width + 4, ' ')
                || LOWER(gen.in_prefix || c.column_name) || ',' AS text
            FROM user_tab_columns c
            WHERE c.table_name          = in_table_name
                AND c.column_name       NOT LIKE 'OUT\_%' ESCAPE '\'
                AND c.column_name       NOT IN ('UPDATED_BY', 'UPDATED_AT')
            ORDER BY c.column_id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(in_prepend || c.text);
        END LOOP;
    END;



    PROCEDURE get_table_rec (
        in_table_name           user_tables.table_name%TYPE,
        in_prepend              VARCHAR2                        := NULL
    )
    AS
        width                   PLS_INTEGER;
    BEGIN
        width := gen.get_width (
            in_table_name           => in_table_name,
            in_prefix               => gen.rec_prefix
        );
        --
        FOR c IN (
            SELECT
                RPAD(gen.rec_prefix || LOWER(c.column_name), width + 4)
                    || ':= '
                    || CASE
                        WHEN c.column_name = 'APP_ID'       THEN 'COALESCE(' || gen.in_prefix || LOWER(c.column_name) || ', app.get_app_id())'
                        WHEN c.column_name = 'UPDATED_BY'   THEN 'app.get_user_id()'
                        WHEN c.column_name = 'UPDATED_AT'   THEN 'SYSDATE'
                        ELSE gen.in_prefix || LOWER(c.column_name)
                        END
                    || ';' AS text
            FROM user_tab_columns c
            WHERE c.table_name          = in_table_name
            ORDER BY c.column_id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(in_prepend || c.text);
        END LOOP;
    END;



    PROCEDURE get_table_where (
        in_table_name           user_tables.table_name%TYPE,
        in_prepend              VARCHAR2                        := NULL,
        in_prefix               VARCHAR2                        := NULL,
        in_postfix              VARCHAR2                        := NULL
    ) AS
    BEGIN
        FOR c IN (
            SELECT
                LOWER(c.column_name)    AS column_name,
                c.position              AS column_id,
                COUNT(*) OVER()         AS columns_,
                --
                CEIL((MAX(LENGTH(c.column_name)) OVER() + gen.minimal_space) / gen.tab_width) * gen.tab_width AS len
            FROM user_cons_columns c
            JOIN user_constraints n
                ON n.constraint_name    = c.constraint_name
            WHERE n.table_name          = UPPER(in_table_name)
                AND n.constraint_type   = 'P'
            ORDER BY c.position
        ) LOOP
            DBMS_OUTPUT.PUT_LINE (
                in_prepend || CASE WHEN c.column_id = 1 THEN 'WHERE ' ELSE '    AND ' END ||
                't.' || RPAD(c.column_name, c.len) || CASE WHEN c.column_id = 1 THEN '  ' END || '  = ' || NVL(in_prefix, gen.in_prefix) || c.column_name ||
                CASE WHEN c.column_id = c.columns_ THEN in_postfix END
            );
        END LOOP;
    END;



    PROCEDURE get_table_dml_handler (
        in_table_name       VARCHAR2,
        in_prepend          VARCHAR2 := NULL
    )
    AS
    BEGIN
        IF app.get_dml_table(in_table_name, in_existing_only => TRUE) IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE(in_prepend || 'LOG ERRORS INTO ' || LOWER(app.get_dml_table(in_table_name, in_existing_only => TRUE)) || ' (v_log_id);');
        END IF;
    END;



    PROCEDURE create_handler (
        in_table_name           user_tables.table_name%TYPE,
        in_target_table         user_tables.table_name%TYPE             := NULL,
        in_proc_prefix          user_procedures.procedure_name%TYPE     := NULL
    )
    AS
        width                   PLS_INTEGER;
    BEGIN
        width := gen.get_width (
            in_table_name           => in_table_name,
            in_prefix               => gen.in_prefix
        );
        --
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('    PROCEDURE ' || LOWER(NVL(in_proc_prefix, gen.proc_prefix) || NVL(in_target_table, in_table_name)) || ' (');
        DBMS_OUTPUT.PUT_LINE('        ' || RPAD(LOWER(gen.action_arg_name), width  + 8) || 'CHAR,');  --:APEX$ROW_STATUS
        --
        gen.get_table_args (
            in_table_name           => in_table_name,
            in_prepend              => gen.def_prepend || gen.def_prepend
        );
        --
        DBMS_OUTPUT.PUT_LINE('    ) AS');
        DBMS_OUTPUT.PUT_LINE('        ' || RPAD('rec', width + 8) || LOWER(NVL(in_target_table, in_table_name)) || '%ROWTYPE;');
        DBMS_OUTPUT.PUT_LINE('        ' || RPAD('v_log_id', width + 8) || 'logs.log_id%TYPE;');
        DBMS_OUTPUT.PUT_LINE('    BEGIN');
        DBMS_OUTPUT.PUT_LINE('        v_log_id := app.log_module_json (');
        DBMS_OUTPUT.PUT_LINE('            ' || RPAD('''action'',', width + 4, ' ') || 'in_action,');
        --
        gen.get_table_out_logs (
            in_table_name           => in_table_name,
            in_prepend              => gen.def_prepend || gen.def_prepend || gen.def_prepend
        );
        --
        gen.get_table_in_logs (
            in_table_name           => in_table_name,
            in_prepend              => gen.def_prepend || gen.def_prepend || gen.def_prepend
        );
        --
        DBMS_OUTPUT.PUT_LINE('            NULL  -- max 20 rows');
        DBMS_OUTPUT.PUT_LINE('        );');
        --
        -- @TODO: log first 1 args except OUT args
        --
        DBMS_OUTPUT.PUT_LINE('        --');
        --
        gen.get_table_rec (
            in_table_name           => NVL(in_target_table, in_table_name),
            in_prepend              => gen.def_prepend || gen.def_prepend
        );
        --
        DBMS_OUTPUT.PUT_LINE('        --');
        DBMS_OUTPUT.PUT_LINE('        IF in_action = ''D'' THEN');
        DBMS_OUTPUT.PUT_LINE('            DELETE FROM ' || LOWER(NVL(in_target_table, in_table_name)) || ' t');
        --
        gen.get_table_where (
            in_table_name           => NVL(in_target_table, in_table_name),
            in_prepend              => gen.def_prepend || gen.def_prepend || gen.def_prepend,
            in_prefix               => gen.out_prefix,
            in_postfix              => CASE WHEN app.get_dml_table(in_table_name, in_existing_only => TRUE) IS NULL THEN ';' END
        );
        --
        gen.get_table_dml_handler (
            in_table_name           => NVL(in_target_table, in_table_name),
            in_prepend              => gen.def_prepend || gen.def_prepend || gen.def_prepend
        );
        --
        DBMS_OUTPUT.PUT_LINE('        ELSE');
        DBMS_OUTPUT.PUT_LINE('            UPDATE ' || LOWER(NVL(in_target_table, in_table_name)) || ' t');
        DBMS_OUTPUT.PUT_LINE('            SET ROW = rec');
        --
        gen.get_table_where (
            in_table_name           => NVL(in_target_table, in_table_name),
            in_prepend              => gen.def_prepend || gen.def_prepend || gen.def_prepend,
            in_prefix               => gen.out_prefix,
            in_postfix              => CASE WHEN app.get_dml_table(in_table_name, in_existing_only => TRUE) IS NULL THEN ';' END
        );
        --
        gen.get_table_dml_handler (
            in_table_name           => NVL(in_target_table, in_table_name),
            in_prepend              => gen.def_prepend || gen.def_prepend || gen.def_prepend
        );
        --
        DBMS_OUTPUT.PUT_LINE('            --');
        DBMS_OUTPUT.PUT_LINE('            IF SQL%ROWCOUNT = 0 THEN');
        DBMS_OUTPUT.PUT_LINE('                INSERT INTO ' || LOWER(NVL(in_target_table, in_table_name)));
        DBMS_OUTPUT.PUT_LINE('                VALUES rec' || CASE WHEN app.get_dml_table(in_table_name, in_existing_only => TRUE) IS NULL THEN ';' END);
        --
        gen.get_table_dml_handler (
            in_table_name           => NVL(in_target_table, in_table_name),
            in_prepend              => gen.def_prepend || gen.def_prepend || gen.def_prepend || gen.def_prepend
        );
        --
        DBMS_OUTPUT.PUT_LINE('            END IF;');
        DBMS_OUTPUT.PUT_LINE('        END IF;');
        DBMS_OUTPUT.PUT_LINE('        --');
        --
        gen.get_table_out_args (
            in_table_name           => in_table_name,
            in_prepend              => gen.def_prepend || gen.def_prepend
        );
        --
        DBMS_OUTPUT.PUT_LINE('        --');
        DBMS_OUTPUT.PUT_LINE('        app.log_success(v_log_id);');
        DBMS_OUTPUT.PUT_LINE('    EXCEPTION');
        DBMS_OUTPUT.PUT_LINE('    WHEN app.app_exception THEN');
        DBMS_OUTPUT.PUT_LINE('        RAISE;');
        DBMS_OUTPUT.PUT_LINE('    WHEN OTHERS THEN');
        DBMS_OUTPUT.PUT_LINE('        app.raise_error();');
        DBMS_OUTPUT.PUT_LINE('    END;');
    END;



    PROCEDURE call_handler (
        in_procedure_name       user_procedures.procedure_name%TYPE,
        in_prepend              VARCHAR2                                        := NULL,
        in_app_id               apex_application_pages.application_id%TYPE      := NULL,
        in_page_id              apex_application_pages.page_id%TYPE             := NULL
    )
    AS
        width                   PLS_INTEGER;
    BEGIN
        width := gen.get_width (
            in_table_name           => in_procedure_name,
            in_prefix               => ''
        );
        --
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT(in_prepend);
        --
        FOR c IN (
            SELECT a.data_type
            FROM user_arguments a
            WHERE a.package_name || '.' || a.object_name IN (UPPER(in_procedure_name), '.' || UPPER(in_procedure_name))
                AND a.argument_name IS NULL
        ) LOOP
            DBMS_OUTPUT.PUT(c.data_type || ' := ');
        END LOOP;
        --
        DBMS_OUTPUT.PUT_LINE(LOWER(in_procedure_name) || ' (');
        --
        FOR c IN (
            SELECT
                '    ' || RPAD(LOWER(c.column_name), width, ' ')
                    || '=> :' ||
                    CASE WHEN c.column_name = UPPER(gen.action_arg_name) THEN gen.action_replacement || ','
                        ELSE
                            CASE
                                WHEN NULLIF(in_page_id, 0) IS NOT NULL
                                    THEN 'P' || TO_CHAR(in_page_id) || '_' END
                            || REGEXP_REPLACE(c.column_name, '^(' || UPPER(gen.in_prefix) || ')', '')
                            || CASE WHEN c.column_id < COUNT(*) OVER() THEN ',' END
                        END AS text
            FROM (
                --
                -- @TODO: on grid: skip query_only columns
                --
                SELECT c.column_name, c.column_id
                FROM user_tab_columns c
                WHERE c.table_name = UPPER(in_procedure_name)
                UNION ALL
                SELECT a.argument_name, a.position
                FROM user_arguments a
                WHERE a.package_name || '.' || a.object_name IN (UPPER(in_procedure_name), '.' || UPPER(in_procedure_name))
                    AND a.argument_name IS NOT NULL
            ) c
            LEFT JOIN apex_application_page_items i
                ON i.application_id     = in_app_id
                AND i.page_id           = in_page_id
                AND i.item_name         = 'P' || TO_CHAR(i.page_id) || '_' || REGEXP_REPLACE(c.column_name, '^(' || UPPER(gen.in_prefix) || ')', '')
            ORDER BY c.column_id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(in_prepend || c.text);
        END LOOP;
        --
        DBMS_OUTPUT.PUT_LINE(in_prepend || ');');
    END;

END;
/





    FUNCTION get_view_tables (
        in_table_like       VARCHAR2,
        in_table2_like      VARCHAR2 := NULL,
        in_table3_like      VARCHAR2 := NULL,
        in_table4_like      VARCHAR2 := NULL,
        in_table5_like      VARCHAR2 := NULL,
        in_table6_like      VARCHAR2 := NULL,
        in_table7_like      VARCHAR2 := NULL,
        in_table8_like      VARCHAR2 := NULL
    )
    RETURN VARCHAR2
    AS
        out_tables          VARCHAR2(4000);
    BEGIN
        WITH x AS (
            SELECT in_table_like AS tables_like FROM DUAL UNION ALL
            SELECT in_table2_like FROM DUAL WHERE in_table2_like IS NOT NULL UNION ALL
            SELECT in_table3_like FROM DUAL WHERE in_table3_like IS NOT NULL UNION ALL
            SELECT in_table4_like FROM DUAL WHERE in_table4_like IS NOT NULL UNION ALL
            SELECT in_table5_like FROM DUAL WHERE in_table5_like IS NOT NULL UNION ALL
            SELECT in_table6_like FROM DUAL WHERE in_table6_like IS NOT NULL UNION ALL
            SELECT in_table7_like FROM DUAL WHERE in_table7_like IS NOT NULL UNION ALL
            SELECT in_table8_like FROM DUAL WHERE in_table8_like IS NOT NULL
        )
        SELECT LISTAGG(t.table_name || ' ' || t.table_alias, ',') WITHIN GROUP (ORDER BY t.table_name)
        INTO out_tables
        FROM (
            SELECT
                t.table_name,
                CHR(96 + ROW_NUMBER() OVER (ORDER BY t.table_name)) AS table_alias
            FROM x
            JOIN user_tables t
                ON t.table_name     LIKE x.tables_like
                AND t.table_name    NOT LIKE '%$'
            GROUP BY t.table_name
        ) t;
        --
        RETURN out_tables;
    END;


/*
    PROCEDURE get_view (
        in_tables       VARCHAR2,
        in_view_name    VARCHAR2            := NULL
    )
    AS
        passed_tables   VARCHAR2(4000)      := UPPER(REGEXP_REPLACE(in_tables, ',\s+', ','));
        passed_cols     VARCHAR2(32767)     := '|';
        max_col_size    PLS_INTEGER;
    BEGIN
        IF in_view_name IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('CREATE OR REPLACE VIEW ' || LOWER(in_view_name) || ' AS');
        END IF;

        -- create select columns
        DBMS_OUTPUT.PUT_LINE('SELECT');
        --
        FOR c IN list_columns(passed_tables) LOOP
            DBMS_OUTPUT.PUT_LINE(
                '    ' ||
                CASE WHEN passed_cols LIKE '%|' || c.column_name || '|%' THEN '-- ' END ||
                LOWER(c.table_alias) || '.' || LOWER(c.column_name) || ','
            );
            --
            passed_cols := passed_cols || c.column_name || '|';
        END LOOP;

        -- calculate column size for join alignment
        SELECT MAX((FLOOR(LENGTH(c.column_name) / 4) + 1) * 4) INTO max_col_size
        FROM user_tab_columns c
        JOIN (
            SELECT
                UPPER(REGEXP_REPLACE(REGEXP_SUBSTR(passed_tables, '[^,]+', 1, LEVEL), '\s.*', '')) AS table_name
            FROM DUAL
            CONNECT BY REGEXP_SUBSTR(passed_tables, '[^,]+', 1, LEVEL) IS NOT NULL
        ) x
            ON c.table_name     LIKE x.table_name
            AND c.table_name    NOT LIKE '%$';

        -- continue with joins
        FOR c IN list_tables(passed_tables) LOOP
            DBMS_OUTPUT.PUT_LINE(
                CASE WHEN c.table_order = 1 THEN 'FROM' ELSE 'JOIN' END ||
                ' ' || LOWER(c.table_name) || ' ' || LOWER(c.table_alias)
            );
            --
            IF c.table_order > 1 THEN
                FOR r IN list_constraints(c.table_name, passed_tables) LOOP
                    DBMS_OUTPUT.PUT_LINE(
                        '    ' ||
                        CASE WHEN r.position = 1 THEN 'ON' ELSE 'AND' END ||
                        ' ' || LOWER(c.table_alias) || '.' || RPAD(LOWER(r.column_name), max_col_size + 3 + CASE WHEN r.position = 1 THEN 1 ELSE 0 END) ||
                        ' = ' || LOWER(r.table_alias) || '.' || LOWER(r.parent_column)
                    );
                END LOOP;
            END IF;
        END LOOP;
        --
        DBMS_OUTPUT.PUT_LINE(';');
    END;
*/

