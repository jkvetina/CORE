prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 770
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2021.04.15'
,p_release=>'21.1.7'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(9172881647570107)
,p_group_name=>'ADMIN'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(9240371448352386)
,p_group_name=>'DASHBOARD'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(9220021410657411)
,p_group_name=>'MAIN'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(15841923064543077)
,p_group_name=>'OBJECTS'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(14877738597396292)
,p_group_name=>'UPLOADER'
);
wwv_flow_api.create_page_group(
 p_id=>wwv_flow_api.id(9490872346072322)
,p_group_name=>'USER'
);
wwv_flow_api.component_end;
end;
/
