BEGIN
    DBMS_UTILITY.EXEC_DDL_STATEMENT('DROP MATERIALIZED VIEW NAV_SOURCE_SORTED_MV');
    DBMS_OUTPUT.PUT_LINE('--');
    DBMS_OUTPUT.PUT_LINE('-- MATERIALIZED VIEW NAV_SOURCE_SORTED_MV DROPPED');
    DBMS_OUTPUT.PUT_LINE('--');
EXCEPTION
WHEN OTHERS THEN
    NULL;
END;
/
--
CREATE MATERIALIZED VIEW nav_source_sorted_mv
SEGMENT CREATION IMMEDIATE
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
SELECT
    ROWNUM AS r#,   -- to keep hierarchy sorted
    t.*
FROM (
    SELECT
        n.*,
        LEVEL - 1                                   AS depth,
        CONNECT_BY_ROOT NVL(n.order#, n.page_id)    AS page_root
    FROM navigation n
    JOIN apps a
        ON a.app_id                 = n.app_id
    CONNECT BY n.parent_id          = PRIOR n.page_id
        AND n.app_id                = PRIOR n.app_id
    START WITH n.parent_id          IS NULL
    ORDER SIBLINGS BY n.app_id, n.order#, n.page_id
) t;
--
CREATE UNIQUE INDEX uq_nav_source_sorted_mv ON nav_source_sorted_mv (app_id, page_id);

