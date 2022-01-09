CREATE OR REPLACE VIEW user_obj_columns AS
WITH x AS (
    SELECT
        app.get_item('$TABLE_NAME') AS table_name
    FROM users u
    WHERE u.user_id = app.get_user_id()
),
c AS (
    SELECT
        c.table_name,
        c.column_id,
        c.column_name,
        --
        c.data_type ||
        CASE
            WHEN c.data_type LIKE '%CHAR%' OR c.data_type = 'RAW' THEN
                DECODE(NVL(c.char_length, 0), 0, '',
                    '(' || c.char_length || DECODE(c.char_used, 'C', ' CHAR', '') || ')'
                )
            WHEN c.data_type = 'NUMBER' THEN
                DECODE(NVL(c.data_precision || c.data_scale, 0), 0, '',
                    DECODE(NVL(c.data_scale, 0), 0, '(' || c.data_precision || ')',
                        '(' || c.data_precision || ',' || c.data_scale || ')'
                    )
                )
            END AS data_type,
        --
        c.nullable,
        c.data_default,
        --
        CASE WHEN c.column_id = 1 THEN 'Y' END AS is_first,
        CASE WHEN LEAD(c.column_id) OVER(PARTITION BY c.table_name ORDER BY c.column_id) IS NULL THEN 'Y' END AS is_last,
        --
        MAX(LENGTH(c.column_name)) OVER(PARTITION BY c.table_name) AS name_length
    FROM user_tab_columns c
    JOIN user_tables t
        ON t.table_name         = c.table_name
    CROSS JOIN x
    WHERE t.table_name          = NVL(x.table_name, t.table_name)
        AND t.table_name        NOT LIKE '%\__$' ESCAPE '\'
),
n AS (
    SELECT
        m.table_name,
        m.column_name,
        NULLIF(SUM(CASE WHEN n.constraint_type = 'P' THEN 1 ELSE 0 END), 0) AS count_pk,
        NULLIF(SUM(CASE WHEN n.constraint_type = 'R' THEN 1 ELSE 0 END), 0) AS count_fk,
        NULLIF(SUM(CASE WHEN n.constraint_type = 'U' THEN 1 ELSE 0 END), 0) AS count_uq,
        NULLIF(SUM(CASE WHEN n.constraint_type = 'C' THEN 1 ELSE 0 END), 0) AS count_ch
    FROM user_cons_columns m
    JOIN user_constraints n
        ON n.constraint_name    = m.constraint_name
        AND n.constraint_type   IN ('P', 'R', 'U', 'C')
    CROSS JOIN x
    WHERE n.table_name          = NVL(x.table_name, n.table_name)
    GROUP BY m.table_name, m.column_name
)
SELECT
    c.table_name,
    c.column_id,
    c.column_name,
    c.name_length,
    c.data_type,
    --
    n.count_pk,
    n.count_uq,
    n.count_fk,
    --
    NULLIF(n.count_ch - CASE WHEN c.nullable = 'N' THEN 1 ELSE 0 END, 0) AS count_ch,
    --
    CASE WHEN c.nullable = 'N'              THEN 'Y' END AS is_nn,
    CASE WHEN c.data_default IS NOT NULL    THEN 'Y' END AS is_default,
    --
    m.comments
FROM c
LEFT JOIN n
    ON n.table_name     = c.table_name
    AND n.column_name   = c.column_name
LEFT JOIN user_col_comments m
    ON m.table_name     = c.table_name
    AND m.column_name   = c.column_name;

