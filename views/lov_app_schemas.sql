CREATE OR REPLACE VIEW lov_app_schemas AS
SELECT
    a.owner,
    a.owner AS owner_
FROM apex_applications a
WHERE a.owner NOT LIKE 'APEX%'
GROUP BY a.owner;

