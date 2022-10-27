prompt --application/shared_components/logic/application_computations/g_version
begin
--   Manifest
--     APPLICATION COMPUTATION: G_VERSION
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.4'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_imp_shared.create_flow_computation(
 p_id=>wwv_flow_imp.id(9744406364948611)
,p_computation_sequence=>10
,p_computation_item=>'G_VERSION'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'EXPRESSION'
,p_computation_language=>'PLSQL'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>'TO_CHAR(SYSDATE, ''YYYY-MM-DD-HH24-MI-SS'')'
);
wwv_flow_imp.component_end;
end;
/
