CREATE OR REPLACE FORCE VIEW obj_overview AS
SELECT
    INITCAP(o.object_type)  AS object_type,
    COUNT(*)                AS count_objects,
    --
    app_actions.get_object_link(o.object_type) AS page_link
FROM all_objects o
WHERE o.owner               = app.get_owner()
    AND o.object_type       NOT IN ('PACKAGE BODY', 'TABLE PARTITION')
GROUP BY o.object_type;
--
COMMENT ON TABLE obj_overview IS '';

