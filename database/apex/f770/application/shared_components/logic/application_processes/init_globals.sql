prompt --application/shared_components/logic/application_processes/init_globals
begin
--   Manifest
--     APPLICATION PROCESS: INIT_GLOBALS
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.4'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_imp_shared.create_flow_process(
 p_id=>wwv_flow_imp.id(10627210683574012)
,p_process_sequence=>2
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'INIT_GLOBALS'
,p_process_sql_clob=>'app_actions.init_globals();'
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
);
wwv_flow_imp.component_end;
end;
/
