prompt --application/shared_components/navigation/lists/nav_top
begin
--   Manifest
--     LIST: NAV_TOP
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.2'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>777
,p_default_id_offset=>26909373241738856
,p_default_owner=>'CORE'
);
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(36349524449195649)
,p_name=>'NAV_TOP'
,p_list_type=>'SQL_QUERY'
,p_list_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    lvl,',
'    label, ',
'    target, ',
'    is_current_list_entry,',
'    image, ',
'    image_attribute,',
'    image_alt_attribute,',
'    attribute01,',
'    attribute02,',
'    attribute03,',
'    attribute04,',
'    attribute05,',
'    attribute06,',
'    attribute07,',
'    attribute08,',
'    attribute09,',
'    attribute10',
'FROM nav_top',
'ORDER BY page_group, sort_order;'))
,p_list_status=>'PUBLIC'
);
wwv_flow_imp.component_end;
end;
/
