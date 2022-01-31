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
                RPAD(gen.in_prefix || LOWER(c.column_name), width)
                    || LOWER(c.table_name) || '.' ||
                    CASE WHEN c.nullable = 'N'
                        THEN LOWER(c.column_name) || '%TYPE'
                        ELSE RPAD(LOWER(c.column_name) || '%TYPE', width, ' ') || ':= NULL'
                        END
                    || CASE WHEN c.column_id < COUNT(*) OVER() THEN ',' END AS text
            FROM user_tab_columns c
            WHERE c.table_name          = in_table_name
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
                RPAD(gen.rec_prefix || LOWER(c.column_name), width)
                    || ':= ' || gen.in_prefix || LOWER(c.column_name) || ';' AS text
            FROM user_tab_columns c
            WHERE c.table_name          = in_table_name
            ORDER BY c.column_id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(in_prepend || c.text);
        END LOOP;
    END;



    PROCEDURE get_table_where (
        in_table_name           user_tables.table_name%TYPE,
        in_prepend              VARCHAR2                        := NULL
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
            DBMS_OUTPUT.PUT_LINE(
                in_prepend || CASE WHEN c.column_id = 1 THEN 'WHERE ' ELSE '    AND ' END ||
                't.' || RPAD(c.column_name, c.len) || CASE WHEN c.column_id = 1 THEN '  ' END || '  = rec.' || c.column_name ||
                CASE WHEN c.column_id = c.columns_ THEN ';' END
            );
        END LOOP;
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
        DBMS_OUTPUT.PUT_LINE('    PROCEDURE ' || LOWER(NVL(in_proc_prefix, gen.proc_prefix) || in_table_name) || ' (');
        --
        DBMS_OUTPUT.PUT_LINE('        ' || RPAD(LOWER(gen.action_arg_name), width) || 'CHAR,');  --:APEX$ROW_STATUS
        --
        gen.get_table_args (
            in_table_name           => in_table_name,
            in_prepend              => gen.def_prepend || gen.def_prepend
        );
        --
        DBMS_OUTPUT.PUT_LINE('    ) AS');
        DBMS_OUTPUT.PUT_LINE('        ' || RPAD('rec', width) || LOWER(NVL(in_target_table, in_table_name)) || '%ROWTYPE;');
        DBMS_OUTPUT.PUT_LINE('    BEGIN');
        DBMS_OUTPUT.PUT_LINE('        app.log_module();');
        DBMS_OUTPUT.PUT_LINE('        --');
        --
        gen.get_table_rec (
            in_table_name           => NVL(in_target_table, in_table_name),
            in_prepend              => gen.def_prepend || gen.def_prepend
        );
        --
        DBMS_OUTPUT.PUT_LINE('        --');
        DBMS_OUTPUT.PUT_LINE('        DELETE FROM ' || LOWER(NVL(in_target_table, in_table_name)) || ' t');
        --
        gen.get_table_where (
            in_table_name           => in_table_name,
            in_prepend              => gen.def_prepend || gen.def_prepend
        );
        --
        DBMS_OUTPUT.PUT_LINE('        --');
        DBMS_OUTPUT.PUT_LINE('        BEGIN');
        DBMS_OUTPUT.PUT_LINE('            INSERT INTO ' || LOWER(NVL(in_target_table, in_table_name)));
        DBMS_OUTPUT.PUT_LINE('            VALUES rec;');
        DBMS_OUTPUT.PUT_LINE('        EXCEPTION');
        DBMS_OUTPUT.PUT_LINE('        WHEN DUP_VAL_ON_INDEX THEN');
        DBMS_OUTPUT.PUT_LINE('            UPDATE ' || LOWER(NVL(in_target_table, in_table_name)) || ' t');
        DBMS_OUTPUT.PUT_LINE('            SET ROW = rec');
        --
        gen.get_table_where (
            in_table_name           => in_table_name,
            in_prepend              => gen.def_prepend || gen.def_prepend
        );
        --
        DBMS_OUTPUT.PUT_LINE('        END;');
        DBMS_OUTPUT.PUT_LINE('        --');
        DBMS_OUTPUT.PUT_LINE('        app.log_success();');
        DBMS_OUTPUT.PUT_LINE('    EXCEPTION');
        DBMS_OUTPUT.PUT_LINE('    WHEN app.app_exception THEN');
        DBMS_OUTPUT.PUT_LINE('        RAISE;');
        DBMS_OUTPUT.PUT_LINE('    WHEN OTHERS THEN');
        DBMS_OUTPUT.PUT_LINE('        app.raise_error();');
        DBMS_OUTPUT.PUT_LINE('    END;');
    END;

END;
/
