CREATE OR REPLACE VIEW obj_constraints_fix_dt1 AS
WITH x AS (
    SELECT
        app.get_item('$TABLE_NAME') AS table_name
    FROM users u
    WHERE u.user_id = app.get_user_id()
),
s AS (
    SELECT
        a.table_name,
        a.column_name,
        c.position,
        --
        CASE
            WHEN a.data_type = 'NUMBER' THEN
                a.data_type ||
                CASE WHEN a.data_precision IS NOT NULL THEN '(' || a.data_precision || DECODE(a.data_scale, 0, '', ', ' || a.data_scale) || ')' END
            WHEN a.data_type IN ('CHAR', 'VARCHAR', 'VARCHAR2') THEN
                a.data_type || '(' ||
                DECODE(a.char_used, 'C', a.char_length || ' CHAR', a.data_length) || ')'
            ELSE a.data_type
            END AS data_type,
        --
        n.constraint_type,
        c.constraint_name,
        n.r_constraint_name
    FROM user_tab_columns a
    JOIN x
        ON a.table_name         = NVL(x.table_name, a.table_name)
    JOIN user_tables t
        ON t.table_name         = a.table_name
    JOIN user_cons_columns c
        ON c.table_name         = a.table_name
        AND c.column_name       = a.column_name
    JOIN user_constraints n
        ON n.constraint_name    = c.constraint_name
        AND n.constraint_type   IN ('P', 'R')
    ORDER BY a.table_name, n.constraint_type, n.constraint_name, a.column_name
)
SELECT
    b.table_name    AS foreign_table,
    b.column_name   AS foreign_column,
    b.data_type     AS foreign_type,
    --
    s.table_name    AS parent_table,
    s.column_name   AS parent_column,
    s.data_type     AS parent_type,
    --
    'ALTER TABLE ' || LOWER(b.table_name) ||
        ' MODIFY ' || LOWER(b.column_name) || ' ' || s.data_type || ';' AS fix
FROM s
JOIN s b
    ON b.r_constraint_name  = s.constraint_name
    AND b.position          = s.position
WHERE s.data_type           != b.data_type;

