CREATE OR REPLACE VIEW obj_tables AS
WITH x AS (
    SELECT
        app.get_item('$TABLE_NAME') AS table_name
    FROM users u
    WHERE u.user_id = app.get_user_id()
),
s AS (
    -- columns count
    SELECT /* materialize */
        c.table_name,
        COUNT(*)                AS count_cols
    FROM user_tab_cols c
    CROSS JOIN x
    WHERE c.table_name          = NVL(x.table_name, c.table_name)
    GROUP BY c.table_name
),
c AS (
    -- constraints overview
    SELECT /* materialize */
        c.table_name,
        NULLIF(SUM(CASE WHEN c.constraint_type = 'P' THEN 1 ELSE 0 END), 0) AS count_pk,
        NULLIF(SUM(CASE WHEN c.constraint_type = 'U' THEN 1 ELSE 0 END), 0) AS count_uq,
        NULLIF(SUM(CASE WHEN c.constraint_type = 'R' THEN 1 ELSE 0 END), 0) AS count_fk
    FROM user_constraints c
    CROSS JOIN x
    WHERE c.table_name          = NVL(x.table_name, c.table_name)
        AND c.constraint_type   IN ('P', 'U', 'R')
    GROUP BY c.table_name
),
i AS (
    -- indexes overview
    SELECT /* materialize */
        i.table_name,
        COUNT(i.table_name)     AS count_ix
    FROM user_indexes i
    CROSS JOIN x
    LEFT JOIN user_constraints c
        ON c.constraint_name    = i.index_name
    WHERE i.table_name          = NVL(x.table_name, i.table_name)
        AND i.index_type        != 'LOB'
        AND c.constraint_name   IS NULL
    GROUP BY i.table_name
),
g AS (
    -- triggers overview
    SELECT /* materialize */
        g.table_name,
        COUNT(g.table_name)     AS count_trg
    FROM user_triggers g
    CROSS JOIN x
    WHERE g.table_name          = NVL(x.table_name, g.table_name)
    GROUP BY g.table_name
),
p AS (
    -- partitions count
    SELECT /* materialize */
        p.table_name,
        COUNT(*) AS partitions
    FROM user_tab_partitions p
    CROSS JOIN x
    WHERE p.table_name          = NVL(x.table_name, p.table_name)
    GROUP BY p.table_name
)
--
SELECT
    t.table_name,
    s.count_cols,
    t.num_rows              AS count_rows,
    --
    CASE WHEN c.count_pk    IS NOT NULL THEN 'Y' END AS is_pk,
    CASE WHEN c.count_uq    IS NOT NULL THEN 'Y' END AS is_uq,
    --
    c.count_fk,
    i.count_ix,
    g.count_trg,
    --
    p.partitions,
    --
    CASE WHEN t.temporary = 'Y'             THEN 'Y' END AS is_temp,
    CASE WHEN t.iot_type = 'IOT'            THEN 'Y' END AS is_iot,
    CASE WHEN t.row_movement = 'ENABLED'    THEN 'Y' END AS is_row_mov,
    CASE WHEN t.read_only = 'YES'           THEN 'Y' END AS is_read_only,
    --
    o.last_ddl_time,
    TRUNC(SYSDATE) - TRUNC(t.last_analyzed) AS last_analyzed,  -- in days
    --
    c.comments,
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
FROM user_tables t
JOIN user_objects o
    ON o.object_name            = t.table_name
    AND o.object_type           = 'TABLE'           -- skip views
CROSS JOIN x
LEFT JOIN user_mviews m
    ON m.mview_name             = t.table_name      -- skip mviews
LEFT JOIN user_tab_comments c
    ON c.table_name             = t.table_name
--
LEFT JOIN s ON s.table_name     = t.table_name
LEFT JOIN c ON c.table_name     = t.table_name
LEFT JOIN i ON i.table_name     = t.table_name
LEFT JOIN g ON g.table_name     = t.table_name
LEFT JOIN p ON p.table_name     = t.table_name
--
WHERE t.table_name      = NVL(x.table_name, t.table_name)
    AND t.table_name    NOT LIKE '%\__$' ESCAPE '\'
    AND m.mview_name    IS NULL;

