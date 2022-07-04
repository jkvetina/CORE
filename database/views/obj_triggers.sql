CREATE OR REPLACE FORCE VIEW obj_triggers AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_owner()                 AS owner,
        app.get_app_id()                AS app_id,
        app.get_item('$TABLE_NAME')     AS table_name,
        app.get_item('$TRIGGER_NAME')   AS trigger_name,
        app.get_date_item('G_TODAY')    AS today
    FROM DUAL
),
r AS (
    SELECT /* materialize */
        l.action_name       AS table_name,
        COUNT(l.log_id)                                                                     AS count_calls,
        SUM(TO_NUMBER(REGEXP_SUBSTR(l.arguments, '"inserted":"?(\d+)', 1, 1, NULL, 1)))     AS count_inserted,
        SUM(TO_NUMBER(REGEXP_SUBSTR(l.arguments, '"updated":"?(\d+)',  1, 1, NULL, 1)))     AS count_updated,
        SUM(TO_NUMBER(REGEXP_SUBSTR(l.arguments, '"deleted":"?(\d+)',  1, 1, NULL, 1)))     AS count_deleted
    FROM x
    JOIN logs l
        ON l.created_at     >= x.today
        AND l.created_at    < x.today + 1
        AND l.app_id        = x.app_id
        AND l.flag          = 'G'
        AND l.action_name   = NVL(x.table_name, l.action_name)
    GROUP BY l.action_name
)
SELECT
    t.table_name,
    --
    CASE
        WHEN c.comments LIKE '[%]%'
            THEN REGEXP_SUBSTR(c.comments, '^\[([^]]+)\]', 1, 1, NULL, 1)
        ELSE REGEXP_SUBSTR(t.table_name, '^[^_]+')
        END AS table_group,
    --
    g.trigger_name,
    g.trigger_type,
    g.base_object_type,
    --
    CASE WHEN g.when_clause IS NOT NULL     THEN 'Y' END AS is_when,
    CASE WHEN g.status != 'ENABLED'         THEN 'Y' END AS is_disabled,
    CASE WHEN g.instead_of_row    = 'YES'   THEN 'Y' END AS is_instead_of,
    CASE WHEN g.before_statement  = 'YES'   THEN 'Y' END AS is_before_statement,
    CASE WHEN g.before_row        = 'YES'   THEN 'Y' END AS is_before_row,
    CASE WHEN g.after_row         = 'YES'   THEN 'Y' END AS is_after_row,
    CASE WHEN g.after_statement   = 'YES'   THEN 'Y' END AS is_after_statement,
    --
    CASE
        WHEN g.trigger_name         = t.table_name || '__'          -- default trigger name
            AND g.trigger_type      = 'COMPOUND'
            AND g.triggering_event  = 'INSERT OR UPDATE OR DELETE'
            AND g.before_statement  = 'YES'
            AND g.before_row        = 'YES'
            AND g.after_row         = 'YES'
            AND g.after_statement   = 'YES'
            AND g.status            = 'ENABLED'
        THEN 'Y'
        END AS is_valid,
    --
    r.count_calls,
    r.count_inserted,
    r.count_updated,
    r.count_deleted,
    --
    o.last_ddl_time
FROM all_tables t
JOIN x
    ON x.owner          = t.owner
LEFT JOIN all_triggers g
    ON g.owner          = x.owner
    AND g.table_name    = t.table_name
    AND g.trigger_name  = NVL(x.trigger_name, g.trigger_name)
LEFT JOIN all_objects o
    ON o.owner          = g.owner
    AND o.object_name   = g.trigger_name
LEFT JOIN all_mviews v
    ON v.owner          = t.owner
    AND v.mview_name    = t.table_name
LEFT JOIN r
    ON r.table_name     = g.table_name
LEFT JOIN all_tab_comments c
    ON c.owner          = t.owner
    AND c.table_name    = t.table_name
WHERE t.table_name      = NVL(x.table_name, t.table_name)
    AND t.table_name    != app.get_dml_table(t.table_name)
    AND v.mview_name    IS NULL;
--
COMMENT ON TABLE obj_triggers IS '';

