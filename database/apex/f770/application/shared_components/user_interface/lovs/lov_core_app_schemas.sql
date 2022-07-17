prompt --application/shared_components/user_interface/lovs/lov_core_app_schemas
begin
--   Manifest
--     LOV_CORE_APP_SCHEMAS
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.2'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(36134366775466014)
,p_lov_name=>'LOV_CORE_APP_SCHEMAS'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'LOV_APP_SCHEMAS'
,p_return_column_name=>'OWNER'
,p_display_column_name=>'OWNER_'
,p_default_sort_column_name=>'OWNER_'
,p_default_sort_direction=>'ASC'
);
wwv_flow_imp.component_end;
end;
/
