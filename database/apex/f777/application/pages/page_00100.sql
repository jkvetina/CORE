prompt --application/pages/page_00100
begin
--   Manifest
--     PAGE: 00100
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
 p_id=>100
,p_user_interface_id=>wwv_flow_imp.id(36079120127308917)
,p_name=>'&APP_NAME.'
,p_alias=>'HOME'
,p_step_title=>'&APP_NAME.'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_imp.id(36129394652396267)
,p_page_css_classes=>'HOME'
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(36754108834239331)  -- IS_ACTIVE_USER
,p_page_component_map=>'11'
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220101000000'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(36173564167167898)
,p_plug_name=>'&APP_NAME.'
,p_icon_css_classes=>'fa-home'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(19818134006808508)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(27213304477687626)
,p_name=>'ON_CHANGE'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P100_TODAY'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(27213406975687627)
,p_event_id=>wwv_flow_imp.id(27213304477687626)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'app.set_item(''G_TODAY'', :P100_TODAY);',
''))
,p_attribute_02=>'P100_TODAY'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(27213576122687628)
,p_event_id=>wwv_flow_imp.id(27213304477687626)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp.component_end;
end;
/
