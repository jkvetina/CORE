prompt --application/pages/page_00100
begin
--   Manifest
--     PAGE: 00100
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2021.04.15'
,p_release=>'21.1.6'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_api.create_page(
 p_id=>100
,p_user_interface_id=>wwv_flow_api.id(9169746885570061)
,p_name=>'&ENV_NAME. &APP_NAME.'
,p_alias=>'HOME'
,p_step_title=>'&APP_NAME.'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_api.id(9220021410657411)
,p_page_css_classes=>'HOME'
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_api.id(9844735592500475)
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220105192138'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(9264190925429042)
,p_plug_name=>'Home'
,p_icon_css_classes=>'fa-home'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9070356145569920)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.component_end;
end;
/
