CREATE OR REPLACE VIEW obj_view_columns AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_item('$VIEW_NAME') AS view_name,
        --
        UPPER(app.get_item('$SEARCH_VIEWS'))        AS search_views,
        UPPER(app.get_item('$SEARCH_COLUMNS'))      AS search_columns
        --UPPER(app.get_item('$SEARCH_DATA_TYPE'))    AS search_data_type,
        --app.get_number_item('$SEARCH_SIZE')         AS search_size
    FROM DUAL
),
c AS (
    SELECT
        c.table_name    AS view_name,
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
        CASE WHEN c.column_name LIKE x.search_columns   || '%' ESCAPE '\'   THEN 'Y' END AS is_found_column
        --CASE WHEN c.data_type   LIKE x.search_data_type || '%' ESCAPE '\'   THEN 'Y' END AS is_found_data_type,
        --CASE WHEN NVL(c.data_precision, c.data_length) = x.search_size      THEN 'Y' END AS is_found_size
    FROM user_tab_columns c
    JOIN user_views t
        ON t.view_name         = c.table_name
    CROSS JOIN x
    WHERE t.view_name          = NVL(x.view_name, t.view_name)
        AND t.view_name        != app.get_dml_table(t.view_name)
        AND (c.table_name      LIKE '%' || x.search_views || '%' ESCAPE '\' OR x.search_views IS NULL)
)
SELECT
    c.view_name,
    c.column_id,
    c.column_name,
    c.column_name       AS column_name_old,
    c.data_type,
    c.data_default,
    c.avg_col_len       AS avg_length,
    --
    CASE WHEN c.nullable = 'N' THEN 'Y' END AS is_nn,
    --
    m.comments
FROM c
CROSS JOIN x
LEFT JOIN user_col_comments m
    ON m.table_name     = c.view_name
    AND m.column_name   = c.column_name
WHERE 1 = 1
    AND (c.is_found_column      = 'Y'  OR x.search_columns      IS NULL)
    --AND (c.is_found_data_type   = 'Y'  OR x.search_data_type    IS NULL)
    --AND (c.is_found_size        = 'Y'  OR x.search_size         IS NULL)
;
