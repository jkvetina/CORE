CREATE OR REPLACE VIEW obj_constraints AS
WITH x AS (
    SELECT
        app.get_item('$TABLE_NAME') AS table_name
    FROM users u
    WHERE u.user_id = app.get_user_id()
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
    WHERE n.table_name          NOT IN (SELECT object_name FROM RECYCLEBIN)
    GROUP BY n.table_name, n.constraint_name, n.constraint_type
)
SELECT
    c.table_name,
    c.constraint_name,
    c.constraint_type,
    c.cols,
    --
    p.primary_table,
    p.primary_cols,
    p.primary_constraint,
    --
    c.is_generated,
    c.is_disabled,
    c.is_deferred,
    c.delete_rule
FROM c
LEFT JOIN p
    ON p.table_name         = c.table_name
    AND p.constraint_name   = c.constraint_name;

