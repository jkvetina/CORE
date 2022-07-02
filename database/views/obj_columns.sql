CREATE OR REPLACE VIEW obj_columns AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_owner()                 AS owner,
        app.get_item('$TABLE_NAME')     AS table_name,
        --
        UPPER(app.get_item('$SEARCH_TABLES'))       AS search_tables,
        UPPER(app.get_item('$SEARCH_COLUMNS'))      AS search_columns,
        UPPER(app.get_item('$SEARCH_DATA_TYPE'))    AS search_data_type,
        app.get_number_item('$SEARCH_SIZE')         AS search_size
    FROM DUAL
),
c AS (
    SELECT /*+ MATERIALIZE */
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
        c.avg_col_len,
        --
        CASE WHEN c.column_name LIKE x.search_columns   || '%' ESCAPE '\'   THEN 'Y' END AS is_found_column,
        CASE WHEN c.data_type   LIKE x.search_data_type || '%' ESCAPE '\'   THEN 'Y' END AS is_found_data_type,
        CASE WHEN NVL(c.data_precision, c.data_length) = x.search_size      THEN 'Y' END AS is_found_size
    FROM all_tab_columns c
    JOIN x
        ON x.owner              = c.owner
    JOIN all_tables t
        ON t.owner              = c.owner
        AND t.table_name        = c.table_name
    CROSS JOIN x
    WHERE t.table_name          = NVL(x.table_name, t.table_name)
        AND t.table_name        != app.get_dml_table(t.table_name)
        AND (c.table_name       LIKE '%' || x.search_tables || '%' ESCAPE '\' OR x.search_tables IS NULL)
),
n AS (
    SELECT /*+ MATERIALIZE */
        m.table_name,
        m.column_name,
        CASE WHEN SUM(CASE WHEN n.constraint_type = 'P' THEN 1 ELSE 0 END) > 0 THEN 'Y' END AS is_pk,
        CASE WHEN SUM(CASE WHEN n.constraint_type = 'R' THEN 1 ELSE 0 END) > 0 THEN 'Y' END AS is_fk,
        CASE WHEN SUM(CASE WHEN n.constraint_type = 'U' THEN 1 ELSE 0 END) > 0 THEN 'Y' END AS is_uq,
        --
        SUM(CASE WHEN n.constraint_type = 'C' THEN 1 ELSE 0 END) AS count_ch
    FROM all_cons_columns m
    JOIN x
        ON x.owner              = m.owner
    JOIN all_constraints n
        ON n.owner              = m.owner
        AND n.constraint_name   = m.constraint_name
        AND n.constraint_type   IN ('P', 'R', 'U', 'C')
    CROSS JOIN x
    WHERE n.table_name          = NVL(x.table_name, n.table_name)
    GROUP BY m.table_name, m.column_name
)
SELECT
    c.table_name,
    c.column_id,
    c.column_name,
    c.column_name       AS column_name_old,
    c.data_type,
    c.data_default,
    c.avg_col_len       AS avg_length,
    --
    n.is_pk,
    n.is_uq,
    n.is_fk,
    --
    CASE WHEN n.count_ch - CASE WHEN c.nullable = 'N' THEN 1 ELSE 0 END > 0 THEN 'Y' END AS is_ch,
    --
    CASE WHEN c.nullable = 'N' THEN 'Y' END AS is_nn,
    --
    m.comments
FROM c
CROSS JOIN x
LEFT JOIN n
    ON n.table_name             = c.table_name
    AND n.column_name           = c.column_name
LEFT JOIN all_col_comments m
    ON m.owner                  = x.owner
    AND m.table_name            = c.table_name
    AND m.column_name           = c.column_name
WHERE 1 = 1
    AND (c.is_found_column      = 'Y'  OR x.search_columns      IS NULL)
    AND (c.is_found_data_type   = 'Y'  OR x.search_data_type    IS NULL)
    AND (c.is_found_size        = 'Y'  OR x.search_size         IS NULL);

