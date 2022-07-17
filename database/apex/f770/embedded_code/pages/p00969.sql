-- --------------------------------------------------------------------------------
-- 
-- Oracle APEX source export file
-- 
-- The contents of this file are intended for review and analysis purposes only.
-- Developers must use the Application Builder to make modifications to an
-- application. Changes to this file will not be reflected in the application.
-- 
-- --------------------------------------------------------------------------------

-- ----------------------------------------
-- Page 969: #fa-badge-list &PAGE_NAME.
-- Region: ACL
-- SQL Query

SELECT COUNT(*) AS views_available
FROM all_views v
WHERE v.owner       = 'SYS'
    AND v.view_name IN ('DBA_NETWORK_ACLS', 'DBA_NETWORK_ACL_PRIVILEGES')
HAVING COUNT(*)     = 2;

-- ----------------------------------------
-- Page 969: #fa-badge-list &PAGE_NAME.
-- Column: ACL [GRID].PRINCIPAL
-- SQL Query

SELECT
    principal,
    principal AS id
FROM (
    SELECT
        u.username AS principal
    FROM all_users u
    WHERE u.username LIKE 'APEX%'
        OR u.username IN (
            app.get_owner(app.get_app_id()),
            app.get_owner(app.get_core_app_id())
        )
)
GROUP BY principal
ORDER BY principal;


-- ----------------------------------------
-- Page 969: #fa-badge-list &PAGE_NAME.
-- Process: SAVE_ACL
-- PL/SQL Code to Insert/Update/Delete

app.log_action('SAVE_ACL', :PRINCIPAL, :ACL, :PRIVILEGE, :HOST, :LOWER_PORT, :UPPER_PORT);
--
IF :APEX$ROW_STATUS = 'D' THEN
    BEGIN
        DBMS_NETWORK_ACL_ADMIN.DROP_ACL(:ACL);
    EXCEPTION
    WHEN OTHERS THEN
        NULL;
    END;
END IF;
--
IF :APEX$ROW_STATUS = 'C' THEN
    BEGIN
        DBMS_NETWORK_ACL_ADMIN.CREATE_ACL (
            acl             => :ACL,
            description     => '',
            principal       => :PRINCIPAL,
            is_grant        => TRUE,
            privilege       => 'connect'
        );
    EXCEPTION
    WHEN OTHERS THEN
        NULL;
    END;
    --
    BEGIN
        DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
            acl             => :ACL,
            host            => :HOST,
            lower_port      => :LOWER_PORT,
            upper_port      => :UPPER_PORT
        );
    EXCEPTION
    WHEN OTHERS THEN
        NULL;
    END;
    --
    DBMS_NETWORK_ACL_ADMIN.add_privilege (
        acl             => :ACL,
        principal       => :PRINCIPAL,
        is_grant        => TRUE,
        privilege       => 'connect'
    );
END IF;


-- ----------------------------------------
-- Page 969: #fa-badge-list &PAGE_NAME.
-- Region: ACL [GRID]
-- SQL Query

SELECT
    b.principal,
    a.acl,
    b.privilege,
    a.host,
    a.lower_port,
    a.upper_port
FROM dba_network_acls a
JOIN dba_network_acl_privileges b
    ON a.acl = b.acl
WHERE (
        b.principal IN (app.get_owner(app.get_app_id()), app.get_owner(app.get_core_app_id()))
        OR b.principal = (
            SELECT MAX(b.principal) AS latest_apex
            FROM dba_network_acl_privileges b
            WHERE b.principal LIKE 'APEX%'
        )
    )
    AND b.is_grant = 'true';


