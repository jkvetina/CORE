prompt --application/shared_components/user_interface/lovs/lov_core_templates
begin
--   Manifest
--     LOV_CORE_TEMPLATES
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
 p_id=>wwv_flow_imp.id(23870250359957521)
,p_lov_name=>'LOV_CORE_TEMPLATES'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    t.template_id,',
'    MIN(t.template_group)   AS template_group,',
'    MIN(t.description_)     AS description_',
'FROM mail_templates t',
'WHERE t.app_id = app.get_app_id()',
'GROUP BY t.template_id;',
''))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_use_local_sync_table=>false
,p_query_table=>'MAIL_TEMPLATES'
,p_return_column_name=>'TEMPLATE_ID'
,p_display_column_name=>'TEMPLATE_ID'
,p_group_column_name=>'TEMPLATE_GROUP'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'TEMPLATE_ID'
,p_default_sort_direction=>'ASC'
);
wwv_flow_imp_shared.create_list_of_values_cols(
 p_id=>wwv_flow_imp.id(23871257953996289)
,p_query_column_name=>'TEMPLATE_GROUP'
,p_heading=>'Template Group'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_imp_shared.create_list_of_values_cols(
 p_id=>wwv_flow_imp.id(23871694446996293)
,p_query_column_name=>'TEMPLATE_ID'
,p_heading=>'Template Id'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_imp_shared.create_list_of_values_cols(
 p_id=>wwv_flow_imp.id(23871940773996293)
,p_query_column_name=>'DESCRIPTION_'
,p_heading=>'Description '
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_imp.component_end;
end;
/
