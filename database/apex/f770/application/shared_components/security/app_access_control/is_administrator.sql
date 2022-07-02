prompt --application/shared_components/security/app_access_control/is_administrator
begin
--   Manifest
--     ACL ROLE: IS_ADMINISTRATOR
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.1'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_imp_shared.create_acl_role(
 p_id=>wwv_flow_imp.id(12936501967840248)
,p_static_id=>'IS_ADMINISTRATOR'
,p_name=>'IS_ADMINISTRATOR'
);
wwv_flow_imp.component_end;
end;
/
