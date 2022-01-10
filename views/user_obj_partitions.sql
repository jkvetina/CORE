CREATE OR REPLACE VIEW user_obj_partitions AS
WITH x AS (
    SELECT
        app.get_item('$TABLE_NAME') AS table_name
    FROM users u
    WHERE u.user_id = app.get_user_id()
),
p AS (
    SELECT
        p.*,
        --
        'SELECT p.high_value'                                       || CHR(10) ||
        'FROM user_tab_partitions p'                                || CHR(10) ||
        'WHERE p.table_name = ''' || p.table_name || ''''           || CHR(10) ||
        '    AND p.partition_name = ''' || p.partition_name || '''' AS query_
    FROM user_tab_partitions p
    JOIN x
        ON x.table_name = p.table_name
),
r AS (
    SELECT
        p.partition_name,
        LTRIM(RTRIM(h.high_value, ' )'), '( ') AS high_value
    FROM p,
        -- trick to convert LONG to VARCHAR2 on the fly
        XMLTABLE('/ROWSET/ROW'
            PASSING (DBMS_XMLGEN.GETXMLTYPE(p.query_))
            COLUMNS high_value VARCHAR2(4000) PATH 'HIGH_VALUE'
        ) h
)
SELECT
    p.partition_position,
    p.partition_name,
    p.partition_name        AS partition_name_old,
    p.high_value,
    --
    LTRIM(REGEXP_SUBSTR(r.high_value, '[^,' || ']+', 1, 1)) AS header_1,
    LTRIM(REGEXP_SUBSTR(r.high_value, '[^,' || ']+', 1, 2)) AS header_2,
    LTRIM(REGEXP_SUBSTR(r.high_value, '[^,' || ']+', 1, 3)) AS header_3,
    LTRIM(REGEXP_SUBSTR(r.high_value, '[^,' || ']+', 1, 4)) AS header_4,
    --
    TO_NUMBER(EXTRACTVALUE(XMLTYPE(DBMS_XMLGEN.GETXML(
        'SELECT /*+ PARALLEL(p,4) */ COUNT(*) AS r ' ||
        'FROM ' || p.table_name || ' PARTITION (' || p.partition_name || ') p'
        )), '/ROWSET/ROW/R')) AS count_rows,
    --
    p.subpartition_count    AS subpartitions,
    --
    p.read_only,
    p.read_only             AS read_only_old,
    --
    app.get_icon('fa-trash-o', 'Truncate partition (delete also data)') AS action_truncate
FROM p
JOIN r
    ON r.partition_name = p.partition_name;

