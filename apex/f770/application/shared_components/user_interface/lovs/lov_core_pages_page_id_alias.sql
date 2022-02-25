prompt --application/shared_components/user_interface/lovs/lov_core_pages_page_id_alias
begin
--   Manifest
--     LOV_CORE_PAGES (PAGE_ID + ALIAS)
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
 p_id=>wwv_flow_api.id(25536977246490292)
,p_lov_name=>'LOV_CORE_PAGES (PAGE_ID + ALIAS)'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    p.page_id,',
'    TO_CHAR(p.page_id) || '' - '' || p.page_alias AS page_name,',
'    p.page_group',
'FROM apex_application_pages p',
'WHERE p.application_id  = NVL(app.get_app_id(), :APP_ID)',
'    AND p.page_id       NOT IN (947);',
''))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_use_local_sync_table=>false
,p_query_table=>'NAVIGATION'
,p_return_column_name=>'PAGE_ID'
,p_display_column_name=>'PAGE_NAME'
,p_group_column_name=>'PAGE_GROUP'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'PAGE_ID'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(25537239416490300)
,p_query_column_name=>'PAGE_GROUP'
,p_heading=>'Page Group'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(25537666592490301)
,p_query_column_name=>'PAGE_ID'
,p_heading=>'Page Id'
,p_display_sequence=>15
,p_data_type=>'NUMBER'
);
wwv_flow_api.component_end;
end;
/
