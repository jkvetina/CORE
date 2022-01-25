CREATE OR REPLACE VIEW obj_indexes AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_item('$TABLE_NAME') AS table_name
    FROM DUAL
)
SELECT
    i.table_name,
    i.index_name,
    LISTAGG(i.column_name, ', ') WITHIN GROUP (ORDER BY i.column_position) AS cols
FROM user_ind_columns i
JOIN x
    ON i.table_name     = NVL(x.table_name, i.table_name)
WHERE i.table_name      NOT IN (SELECT object_name FROM RECYCLEBIN)
GROUP BY i.table_name, i.index_name;

