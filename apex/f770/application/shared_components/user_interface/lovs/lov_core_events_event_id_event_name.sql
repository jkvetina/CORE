prompt --application/shared_components/user_interface/lovs/lov_core_events_event_id_event_name
begin
--   Manifest
--     LOV_CORE_EVENTS (EVENT_ID, EVENT_NAME)
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
 p_id=>wwv_flow_api.id(23358048190795242)
,p_lov_name=>'LOV_CORE_EVENTS (EVENT_ID, EVENT_NAME)'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_use_local_sync_table=>false
,p_query_table=>'EVENTS'
,p_query_where=>'app_id = app.get_app_id()'
,p_return_column_name=>'EVENT_ID'
,p_display_column_name=>'EVENT_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'EVENT_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(23358483413799019)
,p_query_column_name=>'EVENT_ID'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(23358809259799020)
,p_query_column_name=>'EVENT_NAME'
,p_heading=>'Event Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
