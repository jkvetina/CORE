prompt --application/shared_components/user_interface/lovs/lov_core_flags_name_value
begin
--   Manifest
--     LOV_CORE_FLAGS (NAME, VALUE)
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
 p_id=>wwv_flow_api.id(22069796307284852)
,p_lov_name=>'LOV_CORE_FLAGS (NAME, VALUE)'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    UPPER(REGEXP_SUBSTR(s.text, ''flag_([a-z]+)'', 1, 1, NULL, 1))    AS flag_name,',
'    REGEXP_SUBSTR(s.text, '':=\s*''''([^'''']+)'', 1, 1, NULL, 1)         AS flag_value,',
'    REGEXP_SUBSTR(s.text, ''--\s*(.*)$'', 1, 1, NULL, 1)              AS flag_comment',
'FROM user_source s',
'WHERE s.name = ''APP''',
'    AND s.type = ''PACKAGE''',
'    AND s.line <= 100',
'    AND s.text LIKE ''%flag_%CONSTANT%logs.flag\%TYPE%'' ESCAPE ''\'';',
''))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_use_local_sync_table=>false
,p_return_column_name=>'FLAG_VALUE'
,p_display_column_name=>'FLAG_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'FLAG_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(22077393048900459)
,p_query_column_name=>'FLAG_VALUE'
,p_heading=>'Flag Code'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(22077629040900459)
,p_query_column_name=>'FLAG_NAME'
,p_heading=>'Flag Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
