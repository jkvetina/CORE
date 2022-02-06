prompt --application/shared_components/logic/application_processes/init_filters
begin
--   Manifest
--     APPLICATION PROCESS: INIT_FILTERS
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2021.04.15'
,p_release=>'21.1.7'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_api.create_flow_process(
 p_id=>wwv_flow_api.id(23399919571478084)
,p_process_sequence=>0
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'INIT_FILTERS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- show filters',
'FOR c IN (',
'    SELECT i.item_name, r.static_id',
'    FROM apex_application_page_items i',
'    JOIN apex_application_page_regions r',
'        ON r.application_id     = i.application_id',
'        AND r.page_id           = i.page_id',
'        AND r.static_id         IS NOT NULL',
'    WHERE i.item_name           LIKE ''P'' || r.page_id || ''_FILTERS_'' || r.static_id',
'        AND r.application_id    = app.get_app_id()',
'        AND r.page_id           = app.get_page_id()',
') LOOP',
'    app.set_item(c.item_name, app.get_region_filters(c.static_id));',
'END LOOP;'))
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
);
wwv_flow_api.component_end;
end;
/
