prompt --application/shared_components/logic/application_items/g_today
begin
--   Manifest
--     APPLICATION ITEM: G_TODAY
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2021.04.15'
,p_release=>'21.1.6'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(9186648580615726)
,p_name=>'G_TODAY'
,p_scope=>'GLOBAL'
,p_protection_level=>'N'
);
wwv_flow_api.component_end;
end;
/
