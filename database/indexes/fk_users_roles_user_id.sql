CREATE INDEX fk_users_roles_user_id
    ON user_roles (user_id)
    COMPUTE STATISTICS
    TABLESPACE "DATA";

