prompt --application/shared_components/security/authorizations/is_active_user
begin
--   Manifest
--     SECURITY SCHEME: IS_ACTIVE_USER
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.4'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>777
,p_default_id_offset=>26909373241738856
,p_default_owner=>'CORE'
);
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(36754108834239331)  -- IS_ACTIVE_USER
,p_name=>'IS_ACTIVE_USER'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attribute_01=>'RETURN app.is_active_user();'
,p_error_message=>'ACCESS_DENIED'
,p_caching=>'BY_USER_BY_PAGE_VIEW'
);
wwv_flow_imp.component_end;
end;
/
