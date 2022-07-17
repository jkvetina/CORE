-- --------------------------------------------------------------------------------
-- 
-- Oracle APEX source export file
-- 
-- The contents of this file are intended for review and analysis purposes only.
-- Developers must use the Application Builder to make modifications to an
-- application. Changes to this file will not be reflected in the application.
-- 
-- --------------------------------------------------------------------------------

-- ----------------------------------------
-- Page 951: #fa-table-check &PAGE_NAME.
-- Region: Selected Records
-- SQL Query

SELECT t.column_value
FROM TABLE(APEX_STRING.SPLIT(RTRIM(:P951_SELECTED_COLUMNS, ':'), ':')) t;

-- ----------------------------------------
-- Page 951: #fa-table-check &PAGE_NAME.
-- Process: ACTION_FIX_DATATYPE
-- PL/SQL Code

app.log_action(
    'FIX_DATATYPE',
    app.get_item('$TABLE_NAME'),
    app.get_item('$COLUMN_NAME'),
    app.get_item('$DATA_TYPE')
);
--
FOR c IN (
    SELECT t.fix
    FROM obj_constraints_fix_dt2 t
    WHERE t.column_name     = app.get_item('$COLUMN_NAME')
        AND t.data_type     = app.get_item('$DATA_TYPE')
) LOOP
    EXECUTE IMMEDIATE RTRIM(c.fix, ';');
    app.log_result('DATA TYPE FIXED', c.fix);
END LOOP;
--
:P951_FIX_DATATYPE := NULL;


-- ----------------------------------------
-- Page 951: #fa-table-check &PAGE_NAME.
-- Process: SAVE_CONSTRAINTS
-- PL/SQL Code to Insert/Update/Delete

app.log_action('SAVE_CONSTRAINTS', app.get_item('$TABLE_NAME'), :CONSTRAINT_NAME_OLD, :CONSTRAINT_NAME, :IS_DISABLED);
--
EXECUTE IMMEDIATE
    'ALTER TABLE #OWNER#.' || :TABLE_NAME || ' ' ||
    CASE WHEN :IS_DISABLED = 'Y' THEN 'DISABLE' ELSE 'ENABLE' END ||
    ' CONSTRAINT ' || :CONSTRAINT_NAME_OLD;
--
IF :CONSTRAINT_NAME_OLD != :CONSTRAINT_NAME THEN
    EXECUTE IMMEDIATE
        'ALTER TABLE #OWNER#.' || :TABLE_NAME ||
        ' RENAME CONSTRAINT ' || :CONSTRAINT_NAME_OLD || ' TO ' || :CONSTRAINT_NAME;
    --
    :CONSTRAINT_NAME_OLD := :CONSTRAINT_NAME;
END IF;


-- ----------------------------------------
-- Page 951: #fa-table-check &PAGE_NAME.
-- Process: ACTION_ADD_MISSING_INDEX
-- PL/SQL Code

app.log_action('ADD_MISSING_INDEX', app.get_item('$INDEX_NAME'));
--
FOR c IN (
    SELECT t.fix
    FROM obj_indexes_missing t
    WHERE t.index_name  = app.get_item('$INDEX_NAME')
) LOOP
    EXECUTE IMMEDIATE RTRIM(c.fix, ';');
    app.log_result('INDEX CREATED', c.fix);
END LOOP;


-- ----------------------------------------
-- Page 951: #fa-table-check &PAGE_NAME.
-- Process: INIT_DEFAULTS
-- PL/SQL Code

-- recover table from constraint
IF :P951_TABLE_NAME IS NULL AND :P951_CONSTRAINT_NAME IS NOT NULL THEN
    SELECT MAX(t.table_name) INTO :P951_TABLE_NAME
    FROM user_constraints t
    WHERE t.constraint_name = :P951_CONSTRAINT_NAME;
END IF;
--
IF :P951_TABLE_NAME IS NULL AND :P951_INDEX_NAME IS NOT NULL THEN
    SELECT MAX(t.table_name) INTO :P951_TABLE_NAME
    FROM user_indexes t
    WHERE t.index_name = :P951_INDEX_NAME;
END IF;

-- get table comment
IF :P951_TABLE_NAME IS NOT NULL THEN
    SELECT
        LTRIM(RTRIM(REGEXP_REPLACE(MAX(t.comments), '^\[[^]]+\]\s*', '')))
    INTO :P951_TABLE_COMMENTS
    FROM user_tab_comments t
    WHERE t.table_name = :P951_TABLE_NAME;
END IF;

-- searching...
:P951_SHOW_SEARCH               := NULL;
--
IF (:P951_SEARCH_TABLES         IS NOT NULL
    OR :P951_SEARCH_COLUMNS     IS NOT NULL
    OR :P951_SEARCH_DATA_TYPE   IS NOT NULL
    OR :P951_SEARCH_SIZE        IS NOT NULL
) THEN
    :P951_SHOW_SEARCH           := 'Y';
    :P951_TABLE_NAME            := NULL;
END IF;
--
:P951_SEARCH_TABLES := NVL(:P951_SEARCH_TABLES, :P951_TABLE_NAME);

-- show columns only sometimes
:P951_SHOW_COLUMNS := CASE
    WHEN :P951_TABLE_NAME       IS NOT NULL
    OR :P951_SEARCH_COLUMNS     IS NOT NULL
    OR :P951_SEARCH_DATA_TYPE   IS NOT NULL
    OR :P951_SEARCH_SIZE        IS NOT NULL
    THEN 'Y' END;

-- show fixes
:P951_SHOW_FIXES := CASE
    WHEN :P951_TABLE_NAME       IS NOT NULL
        THEN 'Y'
    --
    WHEN :P951_SHOW_COLUMNS     IS NULL
        THEN 'Y'
    END;


-- ----------------------------------------
-- Page 951: #fa-table-check &PAGE_NAME.
-- Process: SAVE_TABLES
-- PL/SQL Code to Insert/Update/Delete

app_actions.save_obj_tables (
    in_action               => :APEX$ROW_STATUS,
    in_table_name           => :TABLE_NAME,
    in_table_group          => :TABLE_GROUP,
    in_is_dml_handler       => :IS_DML_HANDLER,
    in_is_row_mov           => :IS_ROW_MOV,
    in_is_read_only         => :IS_READ_ONLY,
    in_comments             => :COMMENTS
);


-- ----------------------------------------
-- Page 951: #fa-table-check &PAGE_NAME.
-- Process: SAVE_COLUMNS
-- PL/SQL Code to Insert/Update/Delete

app_actions.save_obj_columns (
    in_action           => :APEX$ROW_STATUS,
    in_table_name       => NVL(:TABLE_NAME, :P951_TABLE_NAME),
    in_column_id        => :COLUMN_ID,
    in_column_name      => :COLUMN_NAME,
    in_column_name_old  => :COLUMN_NAME_OLD,
    in_is_nn            => :IS_NN,
    in_data_type        => :DATA_TYPE,
    in_data_default     => :DATA_DEFAULT,
    in_comments         => :COMMENTS
);
--
:COLUMN_NAME_OLD := :COLUMN_NAME;


-- ----------------------------------------
-- Page 951: #fa-table-check &PAGE_NAME.
-- Process: INIT_PARTITION_HEADERS
-- PL/SQL Code

app.log_action('PARTITION_HEADERS', app.get_item('$TABLE_NAME'));
--
FOR c IN (
    WITH x AS (
        SELECT
            LEVEL                       AS column_position,
            '$PART_HEADER_' || LEVEL    AS item_name
        FROM DUAL
        CONNECT BY LEVEL <= 4
    )
    SELECT
        x.item_name,
        c.column_name                   AS item_value
    FROM x
    LEFT JOIN user_part_key_columns c
        ON c.name                       = app.get_item('$TABLE_NAME')
        AND c.column_position           = x.column_position
) LOOP
    --app.log_result(c.item_name, c.item_value);
    app.set_item(c.item_name, c.item_value);
END LOOP;


-- ----------------------------------------
-- Page 951: #fa-table-check &PAGE_NAME.
-- Process: ACTION_DROP_PARTITION
-- PL/SQL Code

app.log_action('DROP_PARTITION', app.get_item('$TABLE_NAME'), app.get_item('$PARTITION'));
--
EXECUTE IMMEDIATE
    'DELETE FROM ' || app.get_item('$TABLE_NAME') ||
    ' PARTITION (' || app.get_item('$PARTITION') || ')';
--
EXECUTE IMMEDIATE
    'ALTER TABLE ' || app.get_item('$TABLE_NAME') ||
    ' DROP PARTITION ' || app.get_item('$PARTITION') || ' UPDATE INDEXES';
--
app.log_success();


-- ----------------------------------------
-- Page 951: #fa-table-check &PAGE_NAME.
-- Process: ACTION_PURGE
-- PL/SQL Code

app.log_action('PURGE');
--
EXECUTE IMMEDIATE
    'PURGE RECYCLEBIN';
--
FOR c IN (
    SELECT t.table_name
    FROM user_unused_col_tabs t
) LOOP
    EXECUTE IMMEDIATE
        'ALTER TABLE ' || c.table_name ||
        ' DROP UNUSED COLUMNS CHECKPOINT 10000';
END LOOP;


-- ----------------------------------------
-- Page 951: #fa-table-check &PAGE_NAME.
-- Process: ACTION_SHRINK_TABLES
-- PL/SQL Code

DECLARE
    q_indexes       VARCHAR2(32767);
BEGIN
    -- cant put this into package due to missing grants
    FOR t IN (
        SELECT t.table_name
        FROM user_tables t
        WHERE t.table_name = NVL(app.get_item('$TABLE_NAME'), t.table_name)
        ORDER BY 1
    ) LOOP
        BEGIN
            app.log_action('SHRINK_TABLE', t.table_name);
            q_indexes := '';

            -- save functional indexes
            FOR c IN (
                SELECT DBMS_METADATA.GET_DDL('INDEX', i.index_name, '#OWNER#') AS content
                FROM user_indexes i
                WHERE i.index_type      LIKE 'FUNCTION%'
                    AND i.table_name    = t.table_name
            ) LOOP
                q_indexes := q_indexes || c.content || ';';
            END LOOP;

            -- drop functional indexes
            FOR c IN (
                SELECT i.index_name
                FROM user_indexes i
                WHERE i.index_type      LIKE 'FUNCTION%'
                    AND i.table_name    = t.table_name
            ) LOOP
                EXECUTE IMMEDIATE 'DROP INDEX #OWNER#.' || c.index_name;
            END LOOP;

            -- shrink table
            EXECUTE IMMEDIATE 'ALTER TABLE #OWNER#.' || t.table_name || ' ENABLE ROW MOVEMENT';
            EXECUTE IMMEDIATE 'ALTER TABLE #OWNER#.' || t.table_name || ' SHRINK SPACE';
            EXECUTE IMMEDIATE 'ALTER TABLE #OWNER#.' || t.table_name || ' DISABLE ROW MOVEMENT';

            -- rebuild functional indexes
            IF q_indexes IS NOT NULL THEN
                FOR c IN (
                    WITH t AS (
                        SELECT q_indexes AS src FROM DUAL
                    )
                    SELECT REGEXP_SUBSTR(src, '([^;]+)', 1, LEVEL) AS col
                    FROM t
                    CONNECT BY REGEXP_INSTR(src, '([^;]+)', 1, LEVEL) > 0
                    ORDER BY LEVEL ASC
                ) LOOP
                    DBMS_OUTPUT.PUT_LINE(c.col);
                    EXECUTE IMMEDIATE c.col;
                END LOOP;
            END IF;

            -- refresh statistics
            EXECUTE IMMEDIATE 'ANALYZE TABLE #OWNER#.' || t.table_name || ' COMPUTE STATISTICS FOR TABLE';
            --
            app.log_success();
        EXCEPTION
        WHEN OTHERS THEN
            EXECUTE IMMEDIATE 'ALTER TABLE #OWNER#.' || t.table_name || ' DISABLE ROW MOVEMENT';
            --
            app.raise_error();
        END;
    END LOOP;
END;


-- ----------------------------------------
-- Page 951: #fa-table-check &PAGE_NAME.
-- Process: ACTION_RECALC_STATS
-- PL/SQL Code

FOR t IN (
    SELECT t.table_name
    FROM user_tables t
    WHERE t.table_name = NVL(app.get_item('$TABLE_NAME'), t.table_name)
    ORDER BY 1
) LOOP
    app.log_action('RECALC_STATS', t.table_name);
    --
    DBMS_STATS.GATHER_TABLE_STATS('#OWNER#', t.table_name);
    --
    app.log_success();
END LOOP;


-- ----------------------------------------
-- Page 951: #fa-table-check &PAGE_NAME.
-- Process: SAVE_PARTITIONS
-- PL/SQL Code to Insert/Update/Delete

app.log_action('SAVE_PARTITIONS', app.get_item('$TABLE_NAME'), :PARTITION_NAME_OLD, :PARTITION_NAME, :READ_ONLY);

-- rename partition
IF :PARTITION_NAME != :PARTITION_NAME_OLD THEN
    EXECUTE IMMEDIATE
        'ALTER TABLE ' || app.get_item('$TABLE_NAME') ||
        ' RENAME PARTITION ' || :PARTITION_NAME_OLD || ' TO ' || :PARTITION_NAME;
END IF;

-- lock/unlock partition
IF :READ_ONLY != :READ_ONLY_OLD THEN
    EXECUTE IMMEDIATE
        'ALTER TABLE ' || app.get_item('$TABLE_NAME') ||
        ' MODIFY PARTITION ' || :PARTITION_NAME ||
        ' READ ' || CASE WHEN :READ_ONLY = 'YES' THEN 'ONLY' ELSE 'WRITE' END;
END IF;


-- ----------------------------------------
-- Page 951: #fa-table-check &PAGE_NAME.
-- Action: NATIVE_EXECUTE_PLSQL_CODE
-- PL/SQL Code

app_actions.move_table_columns_bottom (
    in_table_name   => :P951_TABLE_NAME,
    in_columns      => :P951_SELECTED_COLUMNS
);


-- ----------------------------------------
-- Page 951: #fa-table-check &PAGE_NAME.
-- Region: Fix Data Types
-- SQL Query

SELECT 1
FROM obj_constraints_fix_dt1
WHERE ROWNUM = 1;

-- ----------------------------------------
-- Page 951: #fa-table-check &PAGE_NAME.
-- Region: Check Data Types
-- SQL Query

SELECT 1
FROM obj_constraints_fix_dt2
WHERE ROWNUM = 1;

-- ----------------------------------------
-- Page 951: #fa-table-check &PAGE_NAME.
-- Region: Partitions
-- SQL Query

SELECT 1
FROM obj_partitions p
WHERE ROWNUM = 1;

-- ----------------------------------------
-- Page 951: #fa-table-check &PAGE_NAME.
-- Region: Missing Indexes
-- SQL Query

SELECT 1
FROM obj_indexes_missing
WHERE ROWNUM = 1;

