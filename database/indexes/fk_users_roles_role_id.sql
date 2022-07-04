CREATE INDEX fk_users_roles_role_id
    ON user_roles (app_id, role_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

