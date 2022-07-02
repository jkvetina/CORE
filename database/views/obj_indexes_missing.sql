CREATE OR REPLACE VIEW obj_indexes_missing AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_owner()                 AS owner,
        app.get_item('$TABLE_NAME')     AS table_name
    FROM DUAL
),
f AS (
    SELECT /*+ MATERIALIZE */
        t.table_name,
        t.constraint_name                                               AS index_name,
        LISTAGG(t.column_name, ', ') WITHIN GROUP (ORDER BY t.position) AS cols
    FROM all_cons_columns t
    JOIN all_constraints n
        ON n.owner              = t.owner
        AND n.constraint_name   = t.constraint_name
    JOIN x
        ON x.owner              = n.owner
        AND n.table_name        = NVL(x.table_name, n.table_name)
    WHERE n.constraint_type     = 'R'
        AND n.table_name        NOT IN (SELECT object_name FROM RECYCLEBIN)
    GROUP BY t.table_name, t.constraint_name
)
SELECT
    app.get_icon('fa-plus-square') AS action,
    app.get_page_url(951,
        in_names        => 'P951_TABLE_NAME,P951_INDEX_NAME,P951_INDEX_ADD',
        in_values       => f.table_name || ',' || f.index_name || ',Y'
    ) AS action_url,
    --
    f.table_name,
    f.index_name,
    f.cols,
    --
    'CREATE INDEX ' || RPAD(f.index_name, 30) ||
        ' ON ' || RPAD(f.table_name, 30) || ' (' || f.cols || ') COMPUTE STATISTICS;' AS fix
FROM f
LEFT JOIN (
    SELECT i.table_name, i.index_name, LISTAGG(i.column_name, ', ') WITHIN GROUP (ORDER BY i.column_position) AS cols
    FROM all_ind_columns i
    JOIN x
        ON x.owner          = i.table_owner
        AND i.table_name    = NVL(x.table_name, i.table_name)
    GROUP BY i.table_name, i.index_name
) i
    ON i.table_name     = f.table_name
    AND i.cols          LIKE f.cols || '%'
WHERE i.index_name      IS NULL;

