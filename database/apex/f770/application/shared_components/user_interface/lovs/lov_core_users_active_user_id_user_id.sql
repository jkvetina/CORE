prompt --application/shared_components/user_interface/lovs/lov_core_users_active_user_id_user_id
begin
--   Manifest
--     LOV_CORE_USERS_ACTIVE (USER_ID, USER_ID)
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
 p_id=>wwv_flow_imp.id(22067838698249746)
,p_lov_name=>'LOV_CORE_USERS_ACTIVE (USER_ID, USER_ID)'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_use_local_sync_table=>false
,p_query_table=>'USERS'
,p_query_where=>'is_active = ''Y'''
,p_return_column_name=>'USER_ID'
,p_display_column_name=>'USER_ID'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'USER_ID'
,p_default_sort_direction=>'ASC'
);
wwv_flow_imp_shared.create_list_of_values_cols(
 p_id=>wwv_flow_imp.id(22068433905263192)
,p_query_column_name=>'USER_ID'
,p_heading=>'User Id'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_imp_shared.create_list_of_values_cols(
 p_id=>wwv_flow_imp.id(22068700511263192)
,p_query_column_name=>'USER_LOGIN'
,p_heading=>'User Login'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_imp_shared.create_list_of_values_cols(
 p_id=>wwv_flow_imp.id(22069126029263193)
,p_query_column_name=>'USER_NAME'
,p_heading=>'User Name'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_imp.component_end;
end;
/
