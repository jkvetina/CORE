CREATE OR REPLACE FORCE VIEW lov_app_schemas AS
SELECT
    a.owner,
    a.owner AS owner_
FROM apex_applications a
WHERE a.owner NOT LIKE 'APEX%'
GROUP BY a.owner;
--
COMMENT ON TABLE lov_app_schemas IS '';

