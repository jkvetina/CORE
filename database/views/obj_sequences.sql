CREATE OR REPLACE FORCE VIEW obj_sequences AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_owner()         AS owner
    FROM DUAL
),
m AS (
    -- map sequences to tables (based on column name)
    SELECT
        c.table_name,
        MIN(c.column_name)      AS column_name,
        s.sequence_name
    FROM all_constraints n
    JOIN x
        ON n.owner              = x.owner
    JOIN all_cons_columns c
        ON c.owner              = n.owner
        AND c.constraint_name   = n.constraint_name
    LEFT JOIN all_tab_columns d
        ON d.owner              = c.owner
        AND d.table_name        = c.table_name
        AND d.column_name       = c.column_name
        AND d.column_id         = 1
        AND d.data_type         = 'NUMBER'
    LEFT JOIN all_sequences s
        ON s.sequence_owner     = c.owner
        AND (
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
FROM all_sequences s
JOIN x
    ON x.owner                  = s.sequence_owner
LEFT JOIN m
    ON m.sequence_name          = s.sequence_name;
--
COMMENT ON TABLE obj_sequences IS '';

