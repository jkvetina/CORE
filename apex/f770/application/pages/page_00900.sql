prompt --application/pages/page_00900
begin
--   Manifest
--     PAGE: 00900
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
 p_id=>900
,p_user_interface_id=>wwv_flow_api.id(9169746885570061)
,p_name=>'#fa-gears'
,p_alias=>'DASHBOARD'
,p_step_title=>'Dashboard'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_api.id(9240371448352386)
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_api.id(9823062898204869)
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20211224091408'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(9263989035429040)
,p_plug_name=>'Dashboard'
,p_icon_css_classes=>'fa-gears'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9070356145569920)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_required_role=>wwv_flow_api.id(9556407311505078)
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.component_end;
end;
/
