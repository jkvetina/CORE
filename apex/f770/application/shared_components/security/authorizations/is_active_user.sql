prompt --application/shared_components/security/authorizations/is_active_user
begin
--   Manifest
--     SECURITY SCHEME: IS_ACTIVE_USER
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2021.04.15'
,p_release=>'21.1.6'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_api.create_security_scheme(
 p_id=>wwv_flow_api.id(9844735592500475)
,p_name=>'IS_ACTIVE_USER'
,p_scheme_type=>'NATIVE_EXISTS'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT 1',
'FROM users u',
'WHERE u.user_id     = app.get_user_id()',
'    AND u.is_active = ''Y'''))
,p_error_message=>'ACCESS_DENIED'
,p_caching=>'BY_USER_BY_PAGE_VIEW'
);
wwv_flow_api.component_end;
end;
/