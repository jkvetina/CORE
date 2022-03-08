--DROP MATERIALIZED VIEW obj_modules_mvw;
CREATE MATERIALIZED VIEW obj_modules_mvw
BUILD DEFERRED
REFRESH ON DEMAND COMPLETE
AS
WITH w AS (
    SELECT DISTINCT a.owner
    FROM apex_applications a
    WHERE a.owner NOT LIKE 'APEX%'
),
p AS (
    -- find modules and start lines in spec and body
    SELECT /*+ MATERIALIZE */
        i.owner,
        i.object_name,
        i.object_type,
        i.name                  AS module_name,
        i.type                  AS module_type,
        i.line                  AS start_line,
        --
        LEAD(i.line) OVER (PARTITION BY i.object_name, i.object_type ORDER BY p.subprogram_id, i.line) - 1      AS end_line,
        ROW_NUMBER() OVER (PARTITION BY i.object_name, i.object_type, p.subprogram_id ORDER BY p.subprogram_id) AS overload_check,
        --
        NVL(p.overload, 1)      AS overload,
        p.subprogram_id,
        p.authid,
        p.result_cache
    FROM all_identifiers i
    JOIN w
        ON w.owner              = i.owner
    JOIN all_procedures p                           -- only public procedures
        ON p.owner              = i.owner
        AND p.object_name       = i.object_name
        AND p.procedure_name    = i.name
    WHERE i.type                IN ('PROCEDURE', 'FUNCTION')
        AND i.object_type       IN ('PACKAGE', 'PACKAGE BODY')
        AND i.usage             IN ('DEFINITION', 'DECLARATION')
),
e AS (
    -- find ending lines
    SELECT /*+ MATERIALIZE */
        s.owner,
        s.name,
        s.type,
        s.line
    FROM all_source s
    JOIN w
        ON w.owner              = s.owner
    WHERE (
        (s.type = 'PACKAGE BODY' AND REGEXP_LIKE(UPPER(s.text), '^\s*END(\s+[A-Z0-9_]+)?\s*;')) OR
        (s.type = 'PACKAGE'      AND REGEXP_LIKE(UPPER(s.text), ';'))
    )
),
t AS (
    -- calculate module start and end lines
    SELECT /*+ MATERIALIZE */
        p.owner,
        p.object_name       AS package_name,
        p.module_name,
        p.module_type,
        p.subprogram_id,
        p.overload,
        p.authid,
        p.result_cache,
        --
        MIN(CASE p.object_type WHEN 'PACKAGE'       THEN p.start_line END)              AS spec_start,
        MIN(CASE p.object_type WHEN 'PACKAGE'       THEN e.line END)                    AS spec_end,
        MIN(CASE p.object_type WHEN 'PACKAGE'       THEN e.line - p.start_line + 1 END) AS spec_lines,
        MAX(CASE p.object_type WHEN 'PACKAGE BODY'  THEN p.start_line END)              AS body_start,
        MAX(CASE p.object_type WHEN 'PACKAGE BODY'  THEN e.line END)                    AS body_end,
        MAX(CASE p.object_type WHEN 'PACKAGE BODY'  THEN e.line - p.start_line + 1 END) AS body_lines
    FROM p
    LEFT JOIN e
        ON e.owner      = p.owner
        AND e.name      = p.object_name
        AND e.type      = p.object_type
        AND e.line      BETWEEN p.start_line AND NVL(p.end_line, 999999)
    GROUP BY p.owner, p.object_name, p.module_name, p.module_type, p.subprogram_id, p.overload, p.authid, p.result_cache
),
a AS (
    -- arguments
    SELECT /*+ MATERIALIZE */
        t.owner,
        t.package_name,
        t.module_name,
        t.module_type,
        t.subprogram_id,
        --
        NULLIF(SUM(CASE WHEN a.in_out LIKE 'IN%' THEN 1 ELSE 0 END), 0)                     AS args_in,
        NULLIF(SUM(CASE WHEN a.in_out LIKE '%OUT' AND position > 0 THEN 1 ELSE 0 END), 0)   AS args_out
    FROM t
    LEFT JOIN all_arguments a
        ON a.owner              = t.owner
        AND a.package_name      = t.package_name
        AND a.object_name       = t.module_name
        AND a.subprogram_id     = t.subprogram_id
    GROUP BY t.owner, t.package_name, t.module_name, t.module_type, t.subprogram_id
),
g AS (
    -- group for related modules
    SELECT /*+ MATERIALIZE */
        s.owner,
        s.name,
        s.line,
        RTRIM(REGEXP_REPLACE(s.text, '^\s*--\s*###\s*', ''))    AS group_name,
        RPAD(' ', ROW_NUMBER() OVER(ORDER BY s.line DESC))      AS group_sort
    FROM all_source s
    JOIN w
        ON w.owner              = s.owner
    WHERE s.type                = 'PACKAGE'
        AND REGEXP_LIKE(s.text, '^\s*--\s*###')
),
q AS (
    -- search statements
    SELECT /*+ MATERIALIZE */
        t.owner,
        t.package_name,
        t.module_name,
        t.subprogram_id,
        --
        --s.type,  -- SELECT, INSERT, UPDATE, DELETE, MERGE, EXECUTE IMMEDIATE, FETCH, OPEN, CLOSE, COMMIT, ROLLBACK
        --
        COUNT(*)                AS count_statements
    FROM t
    JOIN all_statements s
        ON s.owner              = t.owner
        AND s.object_name       = t.package_name
        AND s.object_type       = 'PACKAGE BODY'
        AND s.line              BETWEEN t.body_start AND t.body_end
    GROUP BY t.owner, t.package_name, t.module_name, t.subprogram_id
),
d AS (
    -- documentation lines
    SELECT /*+ MATERIALIZE */
        d.owner,
        d.package_name,
        d.module_name,
        d.module_type,
        d.subprogram_id,
        LISTAGG(REGEXP_SUBSTR(s.text, '^\s*--\s*(.*)\s*$', 1, 1, NULL, 1), '<br />') WITHIN GROUP (ORDER BY s.line) AS comment_,
        MIN(s.line) AS doc_start
    FROM (
        SELECT
            t.owner, t.package_name, t.module_name, t.module_type, t.subprogram_id,
            MAX(s.line) + 1     AS doc_start,
            t.spec_start - 1    AS doc_end
        FROM t
        LEFT JOIN all_source s
            ON s.owner          = t.owner
            AND s.name          = t.package_name
            AND s.type          = 'PACKAGE'
            AND s.line          < t.spec_start
            AND REGEXP_LIKE(s.text, '^\s*$')
        GROUP BY t.owner, t.package_name, t.module_name, t.module_type, t.subprogram_id, t.spec_start
    ) d
    LEFT JOIN all_source s
        ON s.owner              = d.owner
        AND s.name              = d.package_name
        AND s.type              = 'PACKAGE'
        AND s.line              BETWEEN d.doc_start AND d.doc_end
        AND NOT REGEXP_LIKE(s.text, '^\s*--\s*$')
    GROUP BY d.owner, d.package_name, d.module_name, d.module_type, d.subprogram_id
)
SELECT
    t.owner,
    t.package_name,
    t.module_name,
    t.subprogram_id,
    t.overload,
    --
    CASE WHEN t.module_type = 'FUNCTION'    THEN 'Y' END AS is_function,
    CASE WHEN b.line IS NOT NULL            THEN 'Y' END AS is_private,
    CASE WHEN n.line IS NOT NULL            THEN 'Y' END AS is_autonomous,
    CASE WHEN t.result_cache = 'YES'        THEN 'Y' END AS is_cached,
    CASE WHEN t.authid = 'DEFINER'          THEN 'Y' END AS is_definer,
    --
    a.args_in,
    a.args_out,
    --
    t.spec_start,
    t.spec_end,
    t.spec_lines,
    t.body_start,
    t.body_end,
    t.body_lines                AS count_lines,
    --
    q.count_statements,
    d.comment_
FROM t
JOIN a
    ON a.owner                  = t.owner
    AND a.package_name          = t.package_name
    AND a.module_name           = t.module_name
    AND a.subprogram_id         = t.subprogram_id
JOIN d
    ON d.owner                  = t.owner
    AND d.package_name          = t.package_name
    AND d.module_name           = t.module_name
    AND d.subprogram_id         = t.subprogram_id
LEFT JOIN q
    ON q.owner                  = t.owner
    AND q.package_name          = t.package_name
    AND q.module_name           = t.module_name
    AND q.subprogram_id         = t.subprogram_id
LEFT JOIN all_source b
    ON b.owner                  = t.owner
    AND b.name                  = t.package_name
    AND b.type                  = 'PACKAGE'
    AND b.line                  BETWEEN t.spec_start AND t.spec_end
    AND REGEXP_LIKE(b.text, '^\s*(ACCESSIBLE BY)')
LEFT JOIN all_source n
    ON b.owner                  = t.owner
    AND n.name                  = t.package_name
    AND n.type                  = 'PACKAGE BODY'
    AND n.line                  BETWEEN t.body_start AND t.body_end
    AND REGEXP_LIKE(n.text, 'PRAGMA\s+AUTONOMOUS_TRANSACTION')
;
