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
'-- show untranslated items to developers',
'IF app.is_developer() THEN',
'    FOR c IN (',
'        SELECT i.item_name',
'        FROM apex_application_page_items i',
'        WHERE i.application_id  = app.get_app_id()',
'            AND i.page_id       = app.get_page_id()',
'            AND i.item_name     LIKE ''T%''',
'    ) LOOP',
'        app.set_item (',
'            in_name     => c.item_name,',
'            in_value    => ''{'' || c.item_name || ''}'',',
'            in_raise    => FALSE',
'        );',
'        app.log_warning(''MISSING_TRANSLATION'', c.item_name);',
'    END LOOP;',
'END IF;',
'',
'-- load translations',
'FOR c IN (',
'    SELECT',
'        NVL(t.page_item_name, t.app_item_name) AS item_name',
'    FROM translations_current t',
'    WHERE NVL(t.page_item_name, t.app_item_name) IS NOT NULL',
') LOOP',
'    app.set_item (',
'        in_name     => c.item_name,',
'        in_value    => app.get_translated_item(c.item_name),',
'        in_raise    => FALSE',
'    );',
'END LOOP;',
'',
'-- show page comment into footer',
'SELECT p.page_comment INTO :G_FOOTER',
'FROM apex_application_pages p',
'WHERE p.application_id  = app.get_app_id()',
'    AND p.page_id       = app.get_page_id();'))
,p_process_clob_language=>'PLSQL'
);
wwv_flow_api.component_end;
end;
/
