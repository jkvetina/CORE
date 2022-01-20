prompt --application/shared_components/security/app_access_control/is_administrator
begin
--   Manifest
--     ACL ROLE: IS_ADMINISTRATOR
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2021.04.15'
,p_release=>'21.1.7'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_api.create_acl_role(
 p_id=>wwv_flow_api.id(12936501967840248)
,p_static_id=>'IS_ADMINISTRATOR'
,p_name=>'IS_ADMINISTRATOR'
);
wwv_flow_api.component_end;
end;
/
