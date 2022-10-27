prompt --application/pages/page_00000
begin
--   Manifest
--     PAGE: 00000
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.4'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>777
,p_default_id_offset=>26909373241738856
,p_default_owner=>'CORE'
);
wwv_flow_imp_page.create_page(
 p_id=>0
,p_user_interface_id=>wwv_flow_imp.id(36079120127308917)
,p_name=>'Global Page'
,p_step_title=>'Global Page'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'D'
,p_page_component_map=>'14'
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220101000000'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(38334486193116667)
,p_name=>'ON_LOAD'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(38334614603116668)
,p_event_id=>wwv_flow_imp.id(38334486193116667)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex_page_loaded();',
''))
);
wwv_flow_imp.component_end;
end;
/
