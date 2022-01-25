CREATE OR REPLACE VIEW obj_constraints AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_item('$TABLE_NAME') AS table_name
    FROM DUAL
),
n AS (
    SELECT XMLTYPE(DBMS_XMLGEN.GETXML('SELECT c.constraint_name AS name, c.search_condition AS text
FROM user_constraints c
WHERE c.table_name = NVL(''' || x.table_name || ''', c.table_name)
    AND c.constraint_type = ''C''
')) AS constraint_source
    FROM x
),
s AS (
    SELECT
        EXTRACTVALUE(s.object_value, '/ROW/NAME') AS constraint_name,
        EXTRACTVALUE(s.object_value, '/ROW/TEXT') AS search_condition
    FROM n
    CROSS JOIN TABLE(XMLSEQUENCE(EXTRACT(n.constraint_source, '/ROWSET/ROW'))) s
),
p AS (
    SELECT
        n.table_name,
        n.constraint_name,
        k.table_name                                                    AS primary_table,
        LISTAGG(p.column_name, ', ') WITHIN GROUP (ORDER BY p.position) AS primary_cols,
        n.r_constraint_name                                             AS primary_constraint
    FROM user_constraints n
    JOIN x
        ON n.table_name         = NVL(x.table_name, n.table_name)
    JOIN user_cons_columns c
        ON c.constraint_name    = n.constraint_name
    JOIN user_cons_columns p
        ON p.constraint_name    = n.r_constraint_name
        AND p.position          = c.position
    JOIN user_constraints k
        ON k.constraint_name    = n.r_constraint_name
    WHERE n.constraint_type     = 'R'
    GROUP BY n.table_name, n.constraint_name, k.table_name, n.r_constraint_name
),
c AS (
    SELECT
        n.table_name,
        n.constraint_name,
        n.constraint_type,
        --
        LISTAGG(c.column_name, ', ') WITHIN GROUP (ORDER BY c.position) AS cols,
        --
        MAX(CASE WHEN s.constraint_name IS NOT NULL     THEN 'Y' END) AS is_nn,
        MAX(CASE WHEN n.generated = 'GENERATED NAME'    THEN 'Y' END) AS is_generated,
        MAX(CASE WHEN n.status = 'DISABLED'             THEN 'Y' END) AS is_disabled,
        MAX(CASE WHEN n.deferrable = 'DEFERRABLE'       THEN 'Y' END) AS is_deferred,
        --
        MAX(n.delete_rule) AS delete_rule
    FROM user_constraints n
    JOIN x
        ON n.table_name         = NVL(x.table_name, n.table_name)
    JOIN user_cons_columns c
        ON c.constraint_name    = n.constraint_name
    LEFT JOIN s
        ON s.constraint_name    = n.constraint_name
        AND s.search_condition  = '"' || c.column_name || '" IS NOT NULL'
    WHERE n.table_name          NOT IN (SELECT object_name FROM RECYCLEBIN)
    GROUP BY n.table_name, n.constraint_name, n.constraint_type
)
SELECT
    c.table_name,
    c.constraint_name,
    c.constraint_name       AS constraint_name_old,
    c.constraint_type,
    c.cols,
    --
    p.primary_table,
    p.primary_cols,
    p.primary_constraint,
    --
    c.is_nn,
    c.is_generated,
    c.is_disabled,
    c.is_deferred,
    c.delete_rule,
    --
    TO_CHAR(CASE c.constraint_type WHEN 'P' THEN 1 WHEN 'R' THEN 2 ELSE 3 END) || c.constraint_name AS sort#
FROM c
LEFT JOIN p
    ON p.table_name         = c.table_name
    AND p.constraint_name   = c.constraint_name;

