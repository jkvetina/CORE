CREATE OR REPLACE VIEW obj_constraints_fix_dt2 AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_item('$TABLE_NAME') AS table_name
    FROM DUAL
),
s AS (
    SELECT /*+ MATERIALIZE */
        a.table_name,
        a.column_name,
        --
        CASE
            WHEN a.data_type = 'NUMBER' THEN
                a.data_type ||
                CASE WHEN a.data_precision IS NOT NULL THEN '(' || a.data_precision || DECODE(a.data_scale, 0, '', ', ' || a.data_scale) || ')' END
                --
            WHEN a.data_type IN ('CHAR', 'VARCHAR', 'VARCHAR2') THEN
                a.data_type || '(' ||
                DECODE(a.char_used, 'C', a.char_length || ' CHAR', a.data_length) || ')'
                --
            ELSE a.data_type
        END AS data_type        
    FROM user_tab_columns a
    JOIN user_tables t
        ON t.table_name         = a.table_name
    LEFT JOIN user_mviews m
        ON m.mview_name         = a.table_name
    LEFT JOIN obj_constraints_fix_dt1 d
        ON d.foreign_table      = a.table_name
        AND d.foreign_column    = a.column_name
    WHERE t.table_name          NOT LIKE '%$' ESCAPE '\'    -- skip DML err tables, audit tables...
        AND m.mview_name        IS NULL                     -- skip materialized views
        AND d.foreign_table     IS NULL                     -- skip columns marked as FK errors
),
t AS (
    SELECT
        s.column_name,
        s.data_type,
        --
        COUNT(DISTINCT s.data_type) OVER (PARTITION BY s.column_name) AS count_types
    FROM s
    GROUP BY s.column_name, s.data_type
),
r AS (
    -- unmatching column data types
    SELECT t.*
    FROM t
    CROSS JOIN x
    WHERE (
            t.column_name IN (
                SELECT c.column_name
                FROM user_tab_cols c
                JOIN x
                    ON x.table_name = c.table_name
            )
            OR x.table_name IS NULL
        )
        AND t.count_types > 1
)
SELECT
    r.column_name,
    s.data_type,
    --
    LISTAGG(app_actions.get_html_a(app_actions.get_object_link('TABLE', s.table_name), s.table_name), ', ')
        WITHIN GROUP (ORDER BY s.table_name) AS list_tables,
    --
    COUNT(s.table_name) AS count_tables,
    --
    app.get_icon (
        CASE
            WHEN r.data_type = (SELECT MAX(s.data_type) FROM s WHERE s.table_name = x.table_name AND s.column_name = r.column_name)
                THEN NULL
                --
            WHEN x.table_name IS NOT NULL
                THEN 'fa-check-square' 
            END
        ) AS action_fix,
    --
    'ALTER TABLE ' || NVL(LOWER(x.table_name), '?') ||
        ' MODIFY ' || LOWER(r.column_name) || ' ' || r.data_type || ';' AS fix
FROM r
CROSS JOIN x
JOIN s
    ON s.column_name        = r.column_name
    AND s.data_type         != r.data_type
GROUP BY x.table_name, r.column_name, r.data_type, s.data_type;

