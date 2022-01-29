prompt --application/shared_components/user_interface/lovs/lov_users_user_id_user_id_active_y
begin
--   Manifest
--     LOV_USERS (USER_ID, USER_ID, ACTIVE=Y)
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
 p_id=>wwv_flow_api.id(22067838698249746)
,p_lov_name=>'LOV_USERS (USER_ID, USER_ID, ACTIVE=Y)'
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
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(22068433905263192)
,p_query_column_name=>'USER_ID'
,p_heading=>'User Id'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(22068700511263192)
,p_query_column_name=>'USER_LOGIN'
,p_heading=>'User Login'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(22069126029263193)
,p_query_column_name=>'USER_NAME'
,p_heading=>'User Name'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
