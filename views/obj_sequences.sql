CREATE OR REPLACE VIEW obj_sequences AS
WITH m AS (
    -- map sequences to tables (based on column name)
    SELECT
        c.table_name,
        MIN(c.column_name)      AS column_name,
        s.sequence_name
    FROM user_constraints n
    JOIN user_cons_columns c
        ON c.constraint_name    = n.constraint_name
    LEFT JOIN user_tab_columns d
        ON d.table_name         = c.table_name
        AND d.column_name       = c.column_name
        AND d.column_id         = 1
        AND d.data_type         = 'NUMBER'
    LEFT JOIN user_sequences s
        ON (
            s.sequence_name     = c.column_name
            OR s.sequence_name  = 'SEQ_' || c.table_name
            OR s.sequence_name  = c.table_name || '_SEQ'
        )
    WHERE n.constraint_type     = 'P'
    GROUP BY c.table_name, c.constraint_name, s.sequence_name
    HAVING COUNT(c.table_name)  = 1
        AND MAX(c.position)     = 1
        AND MAX(d.data_type)    = 'NUMBER'
)
SELECT
    s.sequence_name,
    s.min_value,
    s.max_value,
    s.increment_by,
    NULLIF(s.cycle_flag, 'N')   AS cycle_flag,
    NULLIF(s.order_flag, 'N')   AS order_flag,
    s.cache_size,
    s.last_number,
    m.table_name,
    m.column_name
FROM user_sequences s
LEFT JOIN m
    ON m.sequence_name = s.sequence_name;



-- show foreign keys and related sequences
WITH s AS (
    SELECT t.table_name || '.' || c.column_name AS table_, s.seq_name
    FROM user_tables t
    INNER JOIN (
        SELECT sequence_name AS seq_name,
            REGEXP_REPLACE(sequence_name, '^SQ_([[:alnum:]_]+)$', '\1') AS table_name  -- define patterns
        FROM user_sequences
        UNION ALL
        SELECT sequence_name AS seq_name,
            REGEXP_REPLACE(sequence_name, '^SQ_([[:alnum:]_]+)$', '\1S') AS table_name
        FROM user_sequences
        UNION ALL
        SELECT sequence_name AS seq_name,
            REGEXP_REPLACE(sequence_name, '^SQ_([[:alnum:]_]+)Y$', '\1IES') AS table_name
        FROM user_sequences
    ) s ON s.table_name = t.table_name
    INNER JOIN user_tab_cols c ON c.table_name = t.table_name
        AND c.column_id = 1
    --ORDER BY 1
),
r AS (
    SELECT table_name, column_name,
        CONNECT_BY_ROOT parent_ AS super_parent
    FROM (
        SELECT
            fn.table_name,
            fc.column_name,
            fn.table_name || '.' || fc.column_name AS current_,
            pc.table_name || '.' || pc.column_name AS parent_,
            DECODE(rc.position, NULL, 'Y', 'N') AS is_root
        FROM user_constraints fn
        INNER JOIN user_constraints pn ON pn.constraint_name = fn.r_constraint_name
        INNER JOIN user_cons_columns fc ON fc.constraint_name = fn.constraint_name
        INNER JOIN user_cons_columns pc ON pc.constraint_name = pn.constraint_name
        LEFT JOIN user_cons_columns rc ON rc.table_name = pc.table_name
            AND rc.column_name = pc.column_name
            AND rc.constraint_name <> pc.constraint_name
            AND rc.position = 1
        WHERE fn.constraint_type = 'R'
            AND fc.position = 1
            AND pc.position = 1
        --ORDER BY 1, 2
    ) a
    CONNECT BY parent_ = PRIOR current_
    START WITH is_root = 'Y'
)
SELECT r.table_name, r.column_name, s.seq_name
FROM r
INNER JOIN s ON s.table_ = r.super_parent
ORDER BY 1;




-- get max(id) from matched tables and rebuild sequences
BEGIN
    FOR c IN (
        WITH patterns AS (  -- match sequences with tables
            SELECT
                '^S[E]?Q_([A-Z_]+)$' AS pattern,
                '\1' AS replacement
            FROM DUAL UNION ALL
            SELECT '^S[E]?Q_([A-Z_]+)$', '\1S' FROM DUAL UNION ALL
            SELECT '^S[E]?Q_([A-Z_]+)Y$', '\1IES' FROM DUAL UNION ALL
            SELECT '^([A-Z_]+)_S[E]?Q$', '\1' FROM DUAL UNION ALL
            SELECT '^([A-Z_]+)_S[E]?Q$', '\1S' FROM DUAL UNION ALL
            SELECT '^([A-Z_]+)Y_S[E]?Q$', '\1IES' FROM DUAL UNION ALL
            SELECT '^([A-Z_]+)_ID$', '\1' FROM DUAL UNION ALL
            SELECT '^([A-Z_]+)_ID$', '\1S' FROM DUAL UNION ALL
            SELECT '^([A-Z_]+)Y_ID$', '\1IES' FROM DUAL
        )
        SELECT r.*, c.column_name, 1 AS seq_start
        FROM (
            SELECT
                s.sequence_name, s.last_number, s.increment_by,
                REGEXP_REPLACE(s.sequence_name, p.pattern, p.replacement) AS table_name
            FROM patterns p
            CROSS JOIN user_sequences s
        ) r
        INNER JOIN user_tables t ON t.table_name = r.table_name
        INNER JOIN user_tab_cols l ON l.table_name = t.table_name
            AND l.column_id = 1
        INNER JOIN user_cons_columns c ON c.table_name = l.table_name
            AND c.column_name = l.column_name
        INNER JOIN user_constraints n ON n.constraint_name = c.constraint_name
            AND n.constraint_type = 'P'
        ORDER BY 1
    ) LOOP
        -- get latest id
        EXECUTE IMMEDIATE
            'BEGIN SELECT MAX(' || c.column_name || ') + ' || c.increment_by ||
            ' INTO :seq_start FROM ' || c.table_name || '; END;'
            USING OUT c.seq_start;
        c.seq_start := GREATEST(NVL(c.seq_start, c.increment_by), c.last_number);
        -- recreate sequence with new number
        IF c.last_number <> c.last_number THEN
            DBMS_OUTPUT.PUT_LINE(c.sequence_name || ' ' || c.last_number || ' -> ' || c.seq_start);
            EXECUTE IMMEDIATE
                'DROP SEQUENCE ' || c.sequence_name;
            EXECUTE IMMEDIATE
                'CREATE SEQUENCE ' || c.sequence_name ||
                ' START WITH ' || c.seq_start;
        END IF;
        -- check/fix grants
    END LOOP;
END;
/








CREATE OR REPLACE FUNCTION find_seq (
    in_table_name VARCHAR2,
    in_column_name VARCHAR2 := NULL
)
RETURN VARCHAR2
AS
    parent_table VARCHAR2(30);
    parent_column VARCHAR2(30);
    super_parent VARCHAR2(30);
    out_ VARCHAR2(30);
BEGIN

    SELECT pc.table_name, pc.column_name
    INTO parent_table, parent_column
    FROM user_constraints fn
    INNER JOIN user_constraints pn ON pn.constraint_name = fn.r_constraint_name
        AND fn.constraint_type = 'R'
    INNER JOIN user_cons_columns fc ON fc.constraint_name = fn.constraint_name
    INNER JOIN user_cons_columns pc ON pc.constraint_name = pn.constraint_name
    WHERE fc.table_name = in_table_name
        AND fc.column_name = in_column_name;

    BEGIN
        SELECT MAX(CONNECT_BY_ROOT pc.table_name) INTO super_parent
        FROM user_constraints fn
        INNER JOIN user_constraints pn ON pn.constraint_name = fn.r_constraint_name
            AND fn.constraint_type = 'R'
        INNER JOIN user_cons_columns fc ON fc.constraint_name = fn.constraint_name
        INNER JOIN user_cons_columns pc ON pc.constraint_name = pn.constraint_name
        CONNECT BY PRIOR fn.table_name = pc.table_name
            AND PRIOR fc.column_name = pc.column_name
        START WITH fn.table_name = parent_table
            AND fc.column_name = parent_column;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL;
    END;

    IF super_parent IS NULL THEN
        SELECT n.table_name INTO super_parent
        FROM user_constraints n
        INNER JOIN user_cons_columns c ON c.constraint_name = n.constraint_name
            AND n.constraint_type = 'P'
        WHERE c.table_name = parent_table
            AND c.column_name = parent_column;
    END IF;

    BEGIN
        SELECT sequence_name INTO out_
        FROM user_sequences
        WHERE REGEXP_LIKE(sequence_name, '^(S[E]?Q_)?' || super_parent || '(_S[E]?Q)?$');
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL;
    END;

    --RETURN parent_table || '.' || parent_column || '.' || super_parent || '.' || out_;
    RETURN out_;
END;
/

-- deep search for sequences in super parent tables
SELECT t.table_name, t.column_name, find_seq(t.table_name, t.column_name) AS seq_name
FROM user_tab_cols t
INNER JOIN user_cons_columns c ON c.table_name = t.table_name
    AND c.column_name = t.column_name
INNER JOIN user_constraints n ON n.constraint_name = c.constraint_name
    AND n.constraint_type = 'R'
ORDER BY 1, 2
;



