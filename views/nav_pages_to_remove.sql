CREATE OR REPLACE VIEW nav_pages_to_remove AS
SELECT n.page_id
FROM navigation n
LEFT JOIN apex_application_pages p
    ON p.application_id     = n.app_id
    AND p.page_id           = n.page_id
WHERE n.app_id              = app.get_app_id()
    AND n.page_id           BETWEEN 1 AND 9999
    AND p.application_id    IS NULL;
