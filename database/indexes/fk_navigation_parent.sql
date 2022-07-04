CREATE INDEX fk_navigation_parent
    ON navigation (app_id, parent_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

