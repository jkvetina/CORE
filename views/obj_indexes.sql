CREATE OR REPLACE VIEW obj_indexes AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_owner()                 AS owner,
        app.get_item('$TABLE_NAME')     AS table_name
    FROM DUAL
),
c AS (
    SELECT /*+ MATERIALIZE */
        c.table_owner,
        c.table_name,
        c.index_name,
        LISTAGG(c.column_name, ', ') WITHIN GROUP (ORDER BY c.column_position) AS list_columns
    FROM all_ind_columns c
    JOIN x
        ON x.owner          = c.table_owner
        AND c.table_name    = NVL(x.table_name, c.table_name)
    WHERE c.table_name      NOT IN (SELECT object_name FROM RECYCLEBIN)
    GROUP BY c.table_owner, c.table_name, c.index_name
)
SELECT
    i.table_name,
    i.index_name,
    i.index_type,
    --
    CASE WHEN i.uniqueness                      = 'UNIQUE'  THEN 'Y' END AS is_unique,
    CASE WHEN i.constraint_index                = 'YES'     THEN 'Y' END AS is_constraint,
    CASE WHEN NVL(i.funcidx_status, i.status)   = 'VALID'   THEN 'Y' END AS is_valid,
    CASE WHEN i.compression                     = 'ENABLED' THEN 'Y' END AS is_compressed,
    CASE WHEN i.partitioned                     = 'YES'     THEN 'Y' END AS is_partitioned,
    CASE WHEN i.visibility                      = 'VISIBLE' THEN 'Y' END AS is_visible,
    --
    c.list_columns,
    --
    i.num_rows,
    i.distinct_keys,
    i.leaf_blocks,
    i.tablespace_name,
    i.last_analyzed
FROM all_indexes i
JOIN c
    ON c.table_owner        = i.table_owner
    AND c.table_name        = i.table_name
    AND c.index_name        = i.index_name
WHERE i.generated           = 'N';

