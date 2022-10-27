prompt --application/shared_components/user_interface/lovs/lov_core_pages_page_id
begin
--   Manifest
--     LOV_CORE_PAGES (PAGE_ID)
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.4'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(26277379897705945)  -- LOV_CORE_PAGES (PAGE_ID)
,p_lov_name=>'LOV_CORE_PAGES (PAGE_ID)'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    p.page_id',
'FROM apex_application_pages p',
'WHERE p.application_id  = NVL(app.get_app_id(), :APP_ID)',
'    AND p.page_id       NOT IN (947);',
''))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_use_local_sync_table=>false
,p_return_column_name=>'PAGE_ID'
,p_display_column_name=>'PAGE_ID'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'PAGE_ID'
,p_default_sort_direction=>'ASC'
);
wwv_flow_imp.component_end;
end;
/
