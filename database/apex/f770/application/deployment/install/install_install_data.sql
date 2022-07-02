prompt --application/deployment/install/install_install_data
begin
--   Manifest
--     INSTALL: INSTALL-INSTALL_DATA
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2021.04.15'
,p_release=>'21.1.7'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_api.create_install_script(
 p_id=>wwv_flow_api.id(20452605375414152)
,p_install_id=>wwv_flow_api.id(12958699824624058)
,p_name=>'INSTALL_DATA'
,p_sequence=>80
,p_script_type=>'INSTALL'
,p_script_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'--',
'-- SEED DATA',
'--',
'INSERT INTO apps (app_id, app_name, is_active, updated_by, updated_at)',
'VALUES (',
'    770,',
'    ''CORE'',',
'    ''Y'',',
'    USER,',
'    SYSDATE',
');',
'',
'INSERT INTO roles (app_id, role_id, role_name, is_active)',
'VALUES (',
'    770,',
'    ''IS_ADMINISTRATOR'',',
'    ''Administrator'',',
'    ''Y''',
');',
'',
'--',
'-- NAVIGATION',
'--',
'DELETE FROM navigation;',
'--',
'INSERT INTO navigation (app_id, page_id, parent_id, order#)',
'SELECT 770, 0,      NULL,   599     FROM DUAL UNION ALL',
'SELECT 770, 100,    NULL,   100     FROM DUAL UNION ALL',
'SELECT 770, 990,    NULL,   990     FROM DUAL UNION ALL',
'SELECT 770, 9999,   NULL,   999     FROM DUAL UNION ALL',
'SELECT 770, 900,    NULL,   900     FROM DUAL UNION ALL',
'SELECT 770, 901,    900,    10      FROM DUAL UNION ALL',
'SELECT 770, 915,    900,    15      FROM DUAL UNION ALL',
'SELECT 770, 920,    900,    20      FROM DUAL UNION ALL',
'SELECT 770, 922,    900,    25      FROM DUAL UNION ALL',
'SELECT 770, 905,    900,    30      FROM DUAL UNION ALL',
'SELECT 770, 940,    900,    35      FROM DUAL UNION ALL',
'SELECT 770, 925,    900,    40      FROM DUAL UNION ALL',
'SELECT 770, 910,    900,    45      FROM DUAL UNION ALL',
'SELECT 770, 970,    900,    50      FROM DUAL;',
'--',
'UPDATE navigation n',
'SET n.is_reset  = CASE WHEN n.page_id > 0 THEN ''Y'' END,',
'    n.is_shared = CASE WHEN n.page_id >= 900 AND n.page_id < 9999 THEN ''Y'' END;',
'',
''))
);
wwv_flow_api.component_end;
end;
/
