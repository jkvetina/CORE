prompt --application/pages/page_00995
begin
--   Manifest
--     PAGE: 00995
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2021.04.15'
,p_release=>'21.1.7'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_api.create_page(
 p_id=>995
,p_user_interface_id=>wwv_flow_api.id(9169746885570061)
,p_name=>'#fa-unlink &PAGE_NAME.'
,p_alias=>'CLONE-SESSION'
,p_step_title=>'&PAGE_NAME.'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_api.id(9490872346072322)
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>'MUST_NOT_BE_PUBLIC_USER'
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220222183137'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(17064168445582727)
,p_plug_name=>'REDIRECT'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9049155795569902)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(17064291159582728)
,p_name=>'P995_JAVASCRIPT_TARGET'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(17064168445582727)
,p_source=>'onclick="javascript:window.open(window.location.href + ''&request=APEX_CLONE_SESSION'', ''_blank''); return false;"'
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
