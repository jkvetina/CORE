prompt --application/shared_components/logic/build_options
begin
--   Manifest
--     BUILD OPTIONS: 770
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2021.04.15'
,p_release=>'21.1.7'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_api.create_build_option(
 p_id=>wwv_flow_api.id(21742571422268062)
,p_build_option_name=>'DEPRECIATED'
,p_build_option_status=>'EXCLUDE'
,p_on_upgrade_keep_status=>true
);
wwv_flow_api.create_build_option(
 p_id=>wwv_flow_api.id(21742714139271058)
,p_build_option_name=>'FEATURED'
,p_build_option_status=>'EXCLUDE'
,p_on_upgrade_keep_status=>true
);
wwv_flow_api.create_build_option(
 p_id=>wwv_flow_api.id(21742903463272848)
,p_build_option_name=>'ON_HOLD'
,p_build_option_status=>'EXCLUDE'
,p_on_upgrade_keep_status=>true
);
wwv_flow_api.create_build_option(
 p_id=>wwv_flow_api.id(21743573813327446)
,p_build_option_name=>'PROTOTYPE'
,p_build_option_status=>'EXCLUDE'
,p_on_upgrade_keep_status=>true
);
wwv_flow_api.component_end;
end;
/
