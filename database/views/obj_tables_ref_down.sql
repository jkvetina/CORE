CREATE OR REPLACE FORCE VIEW obj_tables_ref_down AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_owner()                 AS owner,
        app.get_item('$TABLE_NAME')     AS table_name
    FROM DUAL
),
t AS (
    SELECT
        r.table_name,
        p.table_name            AS referenced_table,
        p.constraint_name       AS primary_key_name,
        r.constraint_name       AS foreign_key_name
    FROM all_constraints r
    JOIN x
        ON x.owner              = r.owner
    JOIN all_constraints p
        ON r.r_constraint_name  = p.constraint_name
        AND r.constraint_type   = 'R'
    WHERE p.constraint_type     = 'P'
)
SELECT
    t.table_name                AS table_name_,
    t.table_name,
    NULL                        AS foreign_key_name,
    NULL                        AS primary_key_name
FROM all_tables t
JOIN x
    ON x.owner                  = t.owner
    AND x.table_name            = t.table_name
UNION ALL
--
SELECT
    t.table_name                AS table_name_,
    --
    '<span style="margin-left: ' || (LEVEL * 2) || 'rem;">' || t.table_name         || '</span>' AS table_name,
    '<span style="margin-left: ' || (LEVEL * 2) || 'rem;">' || t.foreign_key_name   || '</span>' AS foreign_key_name,
    t.primary_key_name
FROM t
CONNECT BY NOCYCLE t.referenced_table = PRIOR t.table_name
START WITH t.referenced_table = (SELECT x.table_name FROM x);

