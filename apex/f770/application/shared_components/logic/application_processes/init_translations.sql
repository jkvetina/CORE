prompt --application/shared_components/logic/application_processes/init_translations
begin
--   Manifest
--     APPLICATION PROCESS: INIT_TRANSLATIONS
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
 p_id=>wwv_flow_api.id(23018028681776980)
,p_process_sequence=>0
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'INIT_TRANSLATIONS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- load translations',
'FOR c IN (',
'    SELECT t.name, t.item_name',
'    FROM translations_mapped t',
') LOOP',
'    app.set_item(c.item_name, app.get_translation(c.name), in_raise => FALSE);',
'END LOOP;'))
,p_process_clob_language=>'PLSQL'
);
wwv_flow_api.component_end;
end;
/
