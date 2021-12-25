prompt --application/shared_components/logic/application_processes/init_globals
begin
--   Manifest
--     APPLICATION PROCESS: INIT_GLOBALS
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2021.04.15'
,p_release=>'21.1.6'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_api.create_flow_process(
 p_id=>wwv_flow_api.id(10627210683574012)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'INIT_GLOBALS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_date DATE;',
'BEGIN',
'    v_date := COALESCE(app.get_date_item(''$TODAY''), app.get_date_item(''G_TODAY''), TRUNC(SYSDATE));',
'    --',
'    app.set_item(''G_TODAY'',         app.get_date(v_date));',
'    app.set_item(''G_TODAY_LABEL'',   ''Filter Date ('' || INITCAP(RTRIM(TO_CHAR(v_date, ''DAY''))) || '')'');',
'    app.set_item(''G_YESTERDAY'',     app.get_date(v_date - 1));',
'    app.set_item(''G_TOMORROW'',      app.get_date(v_date + 1));',
'    --',
'    app.set_item(''$TODAY'');',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
);
wwv_flow_api.component_end;
end;
/
