prompt --application/create_application
begin
--   Manifest
--     FLOW: 770
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2021.04.15'
,p_release=>'21.1.7'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_api.create_flow(
 p_id=>wwv_flow.g_flow_id
,p_owner=>nvl(wwv_flow_application_install.get_schema,'CORE')
,p_name=>nvl(wwv_flow_application_install.get_application_name,'CORE')
,p_alias=>nvl(wwv_flow_application_install.get_application_alias,'CORE')
,p_page_view_logging=>'NO'
,p_page_protection_enabled_y_n=>'Y'
,p_checksum_salt=>'C62B537B70AC296B7152F7F57C0D56DDDC653FBD3506844F47C8CF0F37321184'
,p_bookmark_checksum_function=>'SH512'
,p_max_session_length_sec=>86400
,p_max_session_idle_sec=>14400
,p_session_timeout_warning_sec=>600
,p_compatibility_mode=>'19.2'
,p_flow_language=>'en-gb'
,p_flow_language_derived_from=>'FLOW_PRIMARY_LANGUAGE'
,p_date_format=>'&FORMAT_DATE.'
,p_date_time_format=>'&FORMAT_DATE_TIME.'
,p_timestamp_format=>'DS'
,p_timestamp_tz_format=>'DS'
,p_direction_right_to_left=>'N'
,p_flow_image_prefix => nvl(wwv_flow_application_install.get_image_prefix,'')
,p_authentication=>'PLUGIN'
,p_authentication_id=>wwv_flow_api.id(9022228209569811)
,p_populate_roles=>'A'
,p_application_tab_set=>0
,p_logo_type=>'T'
,p_logo_text=>'&APP_NAME.'
,p_app_builder_icon_name=>'app-icon.svg'
,p_public_user=>'APEX_PUBLIC_USER'
,p_proxy_server=>nvl(wwv_flow_application_install.get_proxy,'')
,p_no_proxy_domains=>nvl(wwv_flow_application_install.get_no_proxy_domains,'')
,p_flow_version=>'Release 1.0'
,p_flow_status=>'AVAILABLE_W_EDIT_LINK'
,p_flow_unavailable_text=>'APPLICATION_OFFLINE'
,p_exact_substitutions_only=>'Y'
,p_browser_cache=>'N'
,p_browser_frame=>'D'
,p_deep_linking=>'Y'
,p_vpd=>'&CORE_SCHEMA..app.create_session'
,p_vpd_teardown_code=>'&CORE_SCHEMA..app.exit_session'
,p_runtime_api_usage=>'T:O'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
,p_rejoin_existing_sessions=>'N'
,p_csv_encoding=>'Y'
,p_auto_time_zone=>'N'
,p_error_handling_function=>'&CORE_SCHEMA..app.handle_apex_error'
,p_substitution_string_01=>'APP_NAME'
,p_substitution_value_01=>'CORE'
,p_substitution_string_02=>'CORE_SCHEMA'
,p_substitution_value_02=>'CORE'
,p_substitution_string_07=>'FORMAT_DATE'
,p_substitution_value_07=>'YYYY-MM-DD'
,p_substitution_string_08=>'FORMAT_DATE_TIME'
,p_substitution_value_08=>'YYYY-MM-DD HH24:MI'
,p_substitution_string_09=>'FORMAT_DATE_FULL'
,p_substitution_value_09=>'YYYY-MM-DD HH24:MI:SS'
,p_substitution_string_10=>'FORMAT_TIME'
,p_substitution_value_10=>'HH24:MI:SS'
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220130133953'
,p_file_prefix => nvl(wwv_flow_application_install.get_static_app_file_prefix,'')
,p_files_version=>64
,p_ui_type_name => null
,p_print_server_type=>'NATIVE'
);
wwv_flow_api.component_end;
end;
/
