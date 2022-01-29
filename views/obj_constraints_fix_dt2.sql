CREATE OR REPLACE VIEW obj_constraints_fix_dt2 AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_item('$TABLE_NAME') AS table_name
    FROM DUAL
),
s AS (
    SELECT
        a.table_name,
        a.column_name,
        --
        CASE
            WHEN a.data_type = 'NUMBER' THEN
                a.data_type ||
                CASE WHEN a.data_precision IS NOT NULL THEN '(' || a.data_precision || DECODE(a.data_scale, 0, '', ', ' || a.data_scale) || ')' END
            WHEN a.data_type IN ('CHAR', 'VARCHAR', 'VARCHAR2') THEN
                a.data_type || '(' ||
                DECODE(a.char_used, 'C', a.char_length || ' CHAR', a.data_length) || ')'
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
)
SELECT
    s.column_name,
    s.data_type,
    s.tables,
    s.fix || ';'                AS fix
FROM (
    SELECT
        s.column_name,
        s.data_type,
        --
        LISTAGG('<a href="' || app_actions.get_object_link('TABLE', s.table_name) || '">' || s.table_name || '</a>', ', ')
            WITHIN GROUP (ORDER BY s.table_name) AS tables,
        --
        LISTAGG('ALTER TABLE ' || LOWER(s.table_name) ||
                ' MODIFY ' || LOWER(s.column_name) || ' ' || s.data_type, '; ')
            WITHIN GROUP (ORDER BY s.table_name) AS fix,
        --
        COUNT(*)                                                            AS count_tables,
        COUNT(DISTINCT s.data_type) OVER (PARTITION BY s.column_name)       AS count_types
    FROM s
    GROUP BY s.column_name, s.data_type
) s
CROSS JOIN x
WHERE (
        s.column_name IN (
            SELECT c.column_name
            FROM user_tab_cols c
            JOIN x
                ON x.table_name = c.table_name
        )
        OR x.table_name IS NULL
    )
    AND s.count_types > 1;

