prompt --application/pages/page_00100
begin
--   Manifest
--     PAGE: 00100
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.2'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_imp_page.create_page(
 p_id=>100
,p_user_interface_id=>wwv_flow_imp.id(9169746885570061)
,p_name=>'&ENV_NAME. &APP_NAME.'
,p_alias=>'HOME'
,p_step_title=>'&APP_NAME.'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_imp.id(9220021410657411)
,p_page_css_classes=>'HOME'
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(9844735592500475)  -- IS_ACTIVE_USER
,p_page_comment=>'UNDER CONSTRUCTION'
,p_page_component_map=>'11'
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220101000000'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9264190925429042)
,p_plug_name=>'CORE - framework for easier app development'
,p_icon_css_classes=>'fa-compass'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(9070356145569920)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_source=>'Home page in the progress.'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(21747472108497839)
,p_plug_name=>'About [LIST]'
,p_region_template_options=>'#DEFAULT#:margin-left-md:margin-right-md'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_imp.id(9049155795569902)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_new_grid_column=>false
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ''Designed to remove boring setup when building new app, just focus on your app'' AS name FROM DUAL UNION ALL',
'SELECT ''Designed for sharing pages and components between apps'' AS name FROM DUAL UNION ALL',
'SELECT ''Designed for sharing objects for multiple projects/apps in same db schema'' AS name FROM DUAL UNION ALL',
'SELECT ''Designed for sharing objects for multiple schemas in same db instance'' AS name FROM DUAL UNION ALL',
'SELECT ''Lower maintance time and effort when something change in shared code'' AS name FROM DUAL;',
'',
''))
,p_plug_source_type=>'NATIVE_JQM_LIST_VIEW'
,p_plug_query_num_rows=>50
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_02=>'NAME'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(21747531389497840)
,p_plug_name=>'Youtube [MEDIA]'
,p_region_template_options=>'#DEFAULT#:margin-left-md:margin-right-md'
,p_plug_template=>wwv_flow_imp.id(9049155795569902)
,p_plug_display_sequence=>80
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_new_grid_column=>false
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Embedded Youtube video',
''))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<br />',
''))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(21747684138497841)
,p_plug_name=>'Links [LIST]'
,p_region_template_options=>'#DEFAULT#:margin-left-md:margin-right-md'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_imp.id(9049155795569902)
,p_plug_display_sequence=>100
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_new_grid_column=>false
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    ''Blog articles related to project CORE'' AS name,',
'    ''http://www.oneoracledeveloper.com/search/label/project_core'' AS url',
'FROM DUAL',
'UNION ALL',
'SELECT',
'    ''Blog articles related to better coding practices (APEX Blueprint)'' AS name,',
'    ''http://www.oneoracledeveloper.com/search/label/blueprint'' AS url',
'FROM DUAL',
'UNION ALL',
'SELECT',
'    ''Project CORE on GitHub'' AS name,',
'    ''https://github.com/jkvetina/CORE'' AS url',
'FROM DUAL;',
'',
''))
,p_plug_source_type=>'NATIVE_JQM_LIST_VIEW'
,p_plug_query_num_rows=>50
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_02=>'NAME'
,p_attribute_16=>'&URL.'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(22084636582580614)
,p_plug_name=>'Links'
,p_region_template_options=>'#DEFAULT#:t-HeroRegion--hideIcon'
,p_plug_template=>wwv_flow_imp.id(9070356145569920)
,p_plug_display_sequence=>90
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_new_grid_column=>false
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(22084733808580615)
,p_plug_name=>'Youtube'
,p_region_template_options=>'#DEFAULT#:t-HeroRegion--hideIcon'
,p_plug_template=>wwv_flow_imp.id(9070356145569920)
,p_plug_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(22084855462580616)
,p_plug_name=>'About'
,p_region_template_options=>'#DEFAULT#:t-HeroRegion--hideIcon'
,p_plug_template=>wwv_flow_imp.id(9070356145569920)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(22084968010580617)
,p_plug_name=>'Features [LIST]'
,p_region_template_options=>'#DEFAULT#:margin-left-md:margin-right-md'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_imp.id(9049155795569902)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_new_grid_column=>false
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ''Custom logging and error handling''      AS name, '''' AS url FROM DUAL UNION ALL',
'SELECT ''Custom user and roles management''       AS name, '''' AS url FROM DUAL UNION ALL',
'SELECT ''Custom navigation''                      AS name, '''' AS url FROM DUAL UNION ALL',
'SELECT ''Universal app setting''                  AS name, '''' AS url FROM DUAL UNION ALL',
'SELECT ''Database and APEX objects reports''      AS name, '''' AS url FROM DUAL;',
''))
,p_plug_source_type=>'NATIVE_JQM_LIST_VIEW'
,p_plug_query_num_rows=>50
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_02=>'NAME'
,p_attribute_16=>'&URL.'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(22085091788580618)
,p_plug_name=>'Features'
,p_region_template_options=>'#DEFAULT#:t-HeroRegion--hideIcon'
,p_plug_template=>wwv_flow_imp.id(9070356145569920)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_new_grid_column=>false
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp.component_end;
end;
/
