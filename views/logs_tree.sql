CREATE OR REPLACE FORCE VIEW logs_tree AS
SELECT
    l.log_id,
    l.log_parent,
    l.app_id,
    l.page_id,
    l.user_id,
    l.flag,
    l.action_name,
    LPAD(' ', (LEVEL - 1) * 6) || l.module_name AS module_name,
    l.module_line,
    l.module_time,
    l.arguments,
    l.payload,
    l.session_id,
    l.created_at
FROM logs l
CONNECT BY l.log_parent = PRIOR l.log_id
START WITH l.log_id     = app.get_log_tree_id()
ORDER SIBLINGS BY l.log_id;
--
COMMENT ON TABLE  logs_tree                     IS 'All messages related to selected tree id (`app.get_log_tree_id()`)';
--
COMMENT ON COLUMN logs_tree.log_id              IS 'Log ID generated from `LOG_ID` sequence';
COMMENT ON COLUMN logs_tree.log_parent          IS 'Parent log record; dont use FK to avoid deadlocks';
COMMENT ON COLUMN logs_tree.app_id              IS 'APEX Application ID';
COMMENT ON COLUMN logs_tree.page_id             IS 'APEX Application PAGE ID';
COMMENT ON COLUMN logs_tree.user_id             IS 'User ID';
COMMENT ON COLUMN logs_tree.flag                IS 'Type of error listed in `tree` package specification; FK missing for performance reasons';
COMMENT ON COLUMN logs_tree.action_name         IS 'Action name to distinguish position in module or use it as warning/error names';
COMMENT ON COLUMN logs_tree.module_name         IS 'Module name (procedure or function name)';
COMMENT ON COLUMN logs_tree.module_line         IS 'Line in the module';
COMMENT ON COLUMN logs_tree.module_time         IS 'Timer for current row in seconds';
COMMENT ON COLUMN logs_tree.arguments           IS 'Arguments passed to module';
COMMENT ON COLUMN logs_tree.payload             IS 'Formatted call stack, error stack or query with DML error';
COMMENT ON COLUMN logs_tree.session_id          IS 'Session id from `sessions` table';
COMMENT ON COLUMN logs_tree.created_at          IS 'Timestamp of creation';
