prompt --application/shared_components/user_interface/lovs/lov_core_schedules
begin
--   Manifest
--     LOV_CORE_SCHEDULES
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
 p_id=>wwv_flow_imp.id(24119159536460151)  -- LOV_CORE_SCHEDULES
,p_lov_name=>'LOV_CORE_SCHEDULES'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_use_local_sync_table=>false
,p_query_table=>'MAIL_SCHEDULES'
,p_query_where=>'app_id = app.get_app_id()'
,p_return_column_name=>'SCHEDULE_ID'
,p_display_column_name=>'SCHEDULE_ID'
,p_group_column_name=>'SCHEDULE_GROUP'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'SCHEDULE_ID'
,p_default_sort_direction=>'ASC'
);
wwv_flow_imp_shared.create_list_of_values_cols(
 p_id=>wwv_flow_imp.id(24119589931466015)
,p_query_column_name=>'SCHEDULE_ID'
,p_heading=>'Schedule Id'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_imp_shared.create_list_of_values_cols(
 p_id=>wwv_flow_imp.id(24119958623466017)
,p_query_column_name=>'SCHEDULE_GROUP'
,p_heading=>'Schedule Group'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_imp_shared.create_list_of_values_cols(
 p_id=>wwv_flow_imp.id(24120349566466017)
,p_query_column_name=>'DESCRIPTION_'
,p_heading=>'Description '
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_imp.component_end;
end;
/
