prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 777
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.2'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>777
,p_default_id_offset=>26909373241738856
,p_default_owner=>'CORE'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(36082254889308963)
,p_group_name=>'ADMIN'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(36149744690091242)
,p_group_name=>'DASHBOARD'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(36129394652396267)
,p_group_name=>'MAIN'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(36400245587811178)
,p_group_name=>'USER'
);
wwv_flow_imp.component_end;
end;
/
