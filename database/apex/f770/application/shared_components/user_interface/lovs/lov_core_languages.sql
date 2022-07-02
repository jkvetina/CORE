prompt --application/shared_components/user_interface/lovs/lov_core_languages
begin
--   Manifest
--     LOV_CORE_LANGUAGES
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.1'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(22926631492053614)
,p_lov_name=>'LOV_CORE_LANGUAGES'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    REPLACE(c.column_name, ''VALUE_'', '''') AS lang_id,',
'    c.column_id',
'FROM user_tab_cols c',
'WHERE c.table_name      = ''TRANSLATED_ITEMS''',
'    AND c.column_name   LIKE ''VALUE_%'' ESCAPE ''\'';',
''))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_use_local_sync_table=>false
,p_return_column_name=>'LANG_ID'
,p_display_column_name=>'LANG_ID'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'COLUMN_ID'
,p_default_sort_direction=>'ASC'
);
wwv_flow_imp.component_end;
end;
/
