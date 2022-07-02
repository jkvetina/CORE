prompt --application/pages/page_00991
begin
--   Manifest
--     PAGE: 00991
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.1'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_imp_page.create_page(
 p_id=>991
,p_user_interface_id=>wwv_flow_imp.id(9169746885570061)
,p_name=>'#fa-question'
,p_alias=>'HELP'
,p_step_title=>'&PAGE_NAME.'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_imp.id(9220021410657411)
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>'MUST_NOT_BE_PUBLIC_USER'
,p_page_component_map=>'17'
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220317075750'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(85099169139687618)
,p_plug_name=>'REDIRECT'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(9049155795569902)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(36303800075735397)
,p_name=>'P991_JAVASCRIPT_TARGET'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(85099169139687618)
,p_source=>'onclick="$(''.HELP'').toggle(); return false;"'
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp.component_end;
end;
/
