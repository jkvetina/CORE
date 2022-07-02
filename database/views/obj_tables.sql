CREATE OR REPLACE FORCE VIEW obj_tables AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_owner()                             AS owner,
        app.get_item('$TABLE_NAME')                 AS table_name,
        app.get_dml_owner()                         AS dml_owner,
        --
        UPPER(app.get_item('$SEARCH_TABLES'))       AS search_tables,
        UPPER(app.get_item('$SEARCH_COLUMNS'))      AS search_columns,
        UPPER(app.get_item('$SEARCH_DATA_TYPE'))    AS search_data_type,
        app.get_number_item('$SEARCH_SIZE')         AS search_size
    FROM DUAL
),
c AS (
    -- search for tables, columns, data types, count columns, pass table comment
    SELECT /*+ MATERIALIZE */
        c.table_name,
        MAX(m.comments)         AS comments,
        COUNT(*)                AS count_cols,
        --
        MAX(CASE WHEN c.column_name LIKE x.search_columns   || '%' ESCAPE '\'   THEN 'Y' END) AS is_found_column,
        MAX(CASE WHEN c.data_type   LIKE x.search_data_type || '%' ESCAPE '\'   THEN 'Y' END) AS is_found_data_type,
        MAX(CASE WHEN NVL(c.data_precision, c.data_length) = x.search_size      THEN 'Y' END) AS is_found_size
    FROM all_tab_columns c
    JOIN x
        ON x.owner              = c.owner
    LEFT JOIN all_tab_comments m
        ON m.owner              = c.owner
        AND m.table_name        = c.table_name
    WHERE c.table_name          = NVL(x.table_name, c.table_name)
        AND (c.table_name       LIKE '%' || x.search_tables || '%' ESCAPE '\' OR x.search_tables IS NULL)
    GROUP BY c.table_name
),
n AS (
    -- constraints overview
    SELECT /*+ MATERIALIZE */
        c.table_name,
        NULLIF(SUM(CASE WHEN c.constraint_type = 'P' THEN 1 ELSE 0 END), 0) AS count_pk,
        NULLIF(SUM(CASE WHEN c.constraint_type = 'U' THEN 1 ELSE 0 END), 0) AS count_uq,
        NULLIF(SUM(CASE WHEN c.constraint_type = 'R' THEN 1 ELSE 0 END), 0) AS count_fk
    FROM all_constraints c
    JOIN x
        ON x.owner              = c.owner
    WHERE c.table_name          = NVL(x.table_name, c.table_name)
        AND c.constraint_type   IN ('P', 'U', 'R')
    GROUP BY c.table_name
),
i AS (
    -- indexes overview
    SELECT /*+ MATERIALIZE */
        i.table_name,
        COUNT(i.table_name)     AS count_ix
    FROM all_indexes i
    JOIN x
        ON x.owner              = i.owner
    LEFT JOIN all_constraints c
        ON c.owner              = i.owner
        AND c.constraint_name   = i.index_name
    WHERE i.table_name          = NVL(x.table_name, i.table_name)
        AND i.index_type        != 'LOB'
        AND c.constraint_name   IS NULL
    GROUP BY i.table_name
),
g AS (
    -- triggers overview
    SELECT /*+ MATERIALIZE */
        g.table_name,
        COUNT(g.table_name)     AS count_trg
    FROM all_triggers g
    JOIN x
        ON x.owner              = g.owner
    WHERE g.table_name          = NVL(x.table_name, g.table_name)
    GROUP BY g.table_name
),
p AS (
    -- partitions count
    SELECT /*+ MATERIALIZE */
        p.table_name,
        COUNT(*) AS partitions
    FROM all_tab_partitions p
    JOIN x
        ON x.owner              = p.table_owner
    WHERE p.table_name          = NVL(x.table_name, p.table_name)
    GROUP BY p.table_name
),
d AS (
    -- dml tables
    SELECT /*+ MATERIALIZE */
        t.table_name,
        a.table_name                AS dml_handler,
        NULLIF(COUNT(i.line), 0)    AS count_references
    FROM all_tables a
    JOIN x
        ON x.dml_owner      = a.owner
    JOIN all_tables t
        ON a.owner          = t.owner
        AND a.table_name    = app.get_dml_table(t.table_name)
    LEFT JOIN all_identifiers i
        ON i.owner          = a.owner
        AND i.object_type   = 'PACKAGE BODY'
        AND i.name          = a.table_name
        AND i.type          = 'TABLE'
    GROUP BY t.table_name, a.table_name
),
m AS (
    SELECT /*+ MATERIALIZE */
        m.mview_name
    FROM all_mviews m
    JOIN x
        ON x.owner          = m.owner
)
--
SELECT
    t.table_name,
    c.count_cols,
    t.num_rows              AS count_rows,
    --
    CASE
        WHEN c.comments LIKE '[%]%'
            THEN REGEXP_SUBSTR(c.comments, '^\[([^]]+)\]', 1, 1, NULL, 1)
        ELSE REGEXP_SUBSTR(t.table_name, '^[^_]+')
        END AS table_group,
    --
    CASE WHEN n.count_pk    IS NOT NULL THEN 'Y' END AS is_pk,
    CASE WHEN n.count_uq    IS NOT NULL THEN 'Y' END AS is_uq,
    --
    n.count_fk,
    i.count_ix,
    g.count_trg,
    --
    p.partitions            AS count_partitions,
    d.count_references      AS dml_references,
    d.dml_handler,
    --
    CASE WHEN d.table_name IS NOT NULL      THEN 'Y' END AS is_dml_handler,
    CASE WHEN t.temporary = 'Y'             THEN 'Y' END AS is_temp,
    CASE WHEN t.iot_type = 'IOT'            THEN 'Y' END AS is_iot,
    CASE WHEN t.row_movement = 'ENABLED'    THEN 'Y' END AS is_row_mov,
    CASE WHEN t.read_only = 'YES'           THEN 'Y' END AS is_read_only,
    --
    o.last_ddl_time,
    TRUNC(SYSDATE) - TRUNC(t.last_analyzed) AS last_analyzed,  -- in days
    --
    LTRIM(RTRIM(REGEXP_REPLACE(c.comments, '^\[[^]]+\]\s*', ''))) AS comments,
    --
    t.avg_row_len,
    --
    ROUND(t.blocks * 8, 2)                      AS fragmented_kb,
    ROUND(t.num_rows * t.avg_row_len / 1024, 2) AS actual_kb,
    --
    CASE
        WHEN ROUND(t.blocks * 8, 2) > 0
            THEN ROUND(t.blocks * 8, 2) - ROUND(t.num_rows * t.avg_row_len / 1024, 2)
            END AS wasted_kb,
    --
    CASE
        WHEN ROUND(t.blocks * 8, 2) > 0 AND ROUND(t.num_rows * t.avg_row_len / 1024, 2) > 0
            THEN FLOOR((ROUND(t.blocks * 8, 2) - ROUND(t.num_rows * t.avg_row_len / 1024, 2)) / ROUND(t.blocks * 8, 2) * 100)
            END AS wasted_perc,
    --
    t.cache,
    t.result_cache,
    t.buffer_pool
FROM all_tables t
JOIN x
    ON x.owner                  = t.owner
JOIN all_objects o
    ON o.owner                  = t.owner
    AND o.object_name           = t.table_name
    AND o.object_type           = 'TABLE'           -- skip views
JOIN c
    ON c.table_name             = t.table_name
--
LEFT JOIN n ON n.table_name     = t.table_name
LEFT JOIN i ON i.table_name     = t.table_name
LEFT JOIN g ON g.table_name     = t.table_name
LEFT JOIN p ON p.table_name     = t.table_name
LEFT JOIN d ON d.table_name     = t.table_name
LEFT JOIN m ON m.mview_name     = t.table_name      -- skip mviews
--
WHERE t.table_name              = NVL(x.table_name, t.table_name)
    AND t.table_name            != app.get_dml_table(t.table_name)
    AND m.mview_name            IS NULL
    AND (c.is_found_column      = 'Y'  OR x.search_columns      IS NULL)
    AND (c.is_found_data_type   = 'Y'  OR x.search_data_type    IS NULL)
    AND (c.is_found_size        = 'Y'  OR x.search_size         IS NULL);

