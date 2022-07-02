prompt --application/shared_components/user_interface/lovs/lov_core_pages_page_id_page_name
begin
--   Manifest
--     LOV_CORE_PAGES (PAGE_ID, PAGE_NAME)
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2021.04.15'
,p_release=>'21.1.7'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(22069438611267708)
,p_lov_name=>'LOV_CORE_PAGES (PAGE_ID, PAGE_NAME)'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    p.page_id,',
'    p.page_name,',
'    p.page_title,',
'    p.page_alias,',
'    p.page_group',
'FROM apex_application_pages p',
'WHERE p.application_id = NVL(app.get_app_id(), :APP_ID);',
''))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_use_local_sync_table=>false
,p_query_table=>'NAVIGATION'
,p_return_column_name=>'PAGE_ID'
,p_display_column_name=>'PAGE_ID'
,p_group_column_name=>'PAGE_GROUP'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'PAGE_ID'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(23874404662051650)
,p_query_column_name=>'PAGE_GROUP'
,p_heading=>'Page Group'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(22075308778885815)
,p_query_column_name=>'PAGE_ID'
,p_heading=>'Page Id'
,p_display_sequence=>15
,p_data_type=>'NUMBER'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(22075716636885815)
,p_query_column_name=>'PAGE_ALIAS'
,p_heading=>'Page Alias'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(22076188011885816)
,p_query_column_name=>'PAGE_TITLE'
,p_heading=>'Page Title'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
