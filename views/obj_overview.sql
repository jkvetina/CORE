CREATE OR REPLACE VIEW obj_overview AS
SELECT
    INITCAP(o.object_type)  AS object_type,
    COUNT(*)                AS count_objects,
    --
    app_actions.get_object_link(o.object_type) AS page_link
FROM user_objects o
WHERE o.object_type NOT IN ('PACKAGE BODY', 'TABLE PARTITION')
GROUP BY o.object_type;

