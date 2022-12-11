BEGIN
    DBMS_UTILITY.EXEC_DDL_STATEMENT('DROP MATERIALIZED VIEW NAV_SOURCE_PAGES_MV');
    DBMS_OUTPUT.PUT_LINE('--');
    DBMS_OUTPUT.PUT_LINE('-- MATERIALIZED VIEW NAV_SOURCE_PAGES_MV DROPPED');
    DBMS_OUTPUT.PUT_LINE('--');
EXCEPTION
WHEN OTHERS THEN
    NULL;
END;
/
--
CREATE MATERIALIZED VIEW nav_source_pages_mv
SEGMENT CREATION IMMEDIATE
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
SELECT
    /**
     * THIS VIEW SHOULD BE PLACED IN EACH DATABASE SCHEMA
     * TO PROVIDE ACCESS TO APEX VIEWS FOR DIFFERENT SCHEMAS
     * AND TO INCREASE NAVIGATION PERFORMANCE
     */
    a.workspace,
    a.owner,
    p.application_id            AS app_id,
    p.page_id,
    p.page_alias,
    p.page_name,
    p.page_title,
    p.page_group,
    p.page_mode,
    p.page_template,
    p.page_comment              AS comments,
    p.authorization_scheme      AS auth_scheme,
    --
    NULLIF(MIN(s.owner || '.' || s.object_name || '.' || s.procedure_name), '..') AS procedure_name,
    --
    MIN(CASE WHEN g.position = 0 THEN g.pls_type END)       AS data_type,
    MIN(CASE WHEN g.position = 1 THEN g.argument_name END)  AS page_argument,
    MIN(i.item_source)                                      AS javascript
    --
FROM apex_application_pages p
JOIN apex_applications a
    ON a.application_id         = p.application_id
LEFT JOIN all_procedures s
    ON s.owner                  IN (USER, USER || '_OWNER')
    AND s.object_name           = 'AUTH'
    AND s.procedure_name        = p.authorization_scheme
LEFT JOIN all_arguments g
    ON g.owner                  = s.owner
    AND g.object_name           = s.procedure_name
    AND g.package_name          = s.object_name
    AND g.overload              IS NULL
    AND ((
            g.position          = 0
            AND g.argument_name IS NULL
            AND g.in_out        = 'OUT'
        )
        OR (
            g.position          = 1
            AND g.data_type     = 'NUMBER'
            AND g.in_out        = 'IN'
        )
    )
LEFT JOIN apex_application_page_items i
    ON i.application_id         = p.application_id
    AND i.page_id               = p.page_id
    AND i.item_name             = 'P' || TO_CHAR(i.page_id) || '_JAVASCRIPT_TARGET'
WHERE a.workspace               != 'INTERNAL'
GROUP BY
    a.workspace,
    a.owner,
    p.application_id,
    p.page_id,
    p.page_alias,
    p.page_name,
    p.page_title,
    p.page_group,
    p.page_mode,
    p.page_template,
    p.page_comment,
    p.authorization_scheme
ORDER BY p.application_id, p.page_id;
--
CREATE UNIQUE INDEX uq_nav_source_pages_mv ON nav_source_pages_mv (app_id, page_id);

