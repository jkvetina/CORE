prompt --application/shared_components/logic/application_items/g_tomorrow
begin
--   Manifest
--     APPLICATION ITEM: G_TOMORROW
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2021.04.15'
,p_release=>'21.1.7'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(10619471263051799)
,p_name=>'G_TOMORROW'
,p_scope=>'GLOBAL'
,p_protection_level=>'I'
);
wwv_flow_api.component_end;
end;
/