--
-- PACKAGE
--
GRANT EXECUTE ON app                            TO quiz;
GRANT EXECUTE ON gen                            TO quiz;

--
-- PROCEDURE
--
GRANT EXECUTE ON recompile                      TO quiz;

--
-- TABLE
--
GRANT SELECT ON logs                           TO quiz;
GRANT SELECT ON logs_blacklist                 TO quiz;
GRANT SELECT ON roles                          TO quiz;
GRANT SELECT ON user_roles                     TO quiz;
GRANT SELECT ON users                          TO quiz;

--
-- VIEW
--
GRANT SELECT ON logs_tree                      TO quiz;
GRANT SELECT ON nav_top                        TO quiz;

