prompt --application/pages/page_00950
begin
--   Manifest
--     PAGE: 00950
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2021.04.15'
,p_release=>'21.1.7'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_api.create_page(
 p_id=>950
,p_user_interface_id=>wwv_flow_api.id(9169746885570061)
,p_name=>'#fa-database'
,p_alias=>'DATABASE'
,p_step_title=>'&PAGE_NAME.'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_api.id(15841923064543077)
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_api.id(9556407311505078)
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220312183327'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(14218446056378932)
,p_plug_name=>'Database Objects'
,p_icon_css_classes=>'fa-database'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9070356145569920)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>6
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(14218529849378933)
,p_plug_name=>'Invalid Objects'
,p_icon_css_classes=>'fa-stethoscope'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9070356145569920)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>6
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(20857944656868436)
,p_plug_name=>'Database Objects [GEN]'
,p_region_name=>'OBJECTS'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9078290074569925)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>6
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- since badge list doesnt support links...',
'htp.p(''<ul class="t-BadgeList t-BadgeList--large t-BadgeList--dash t-BadgeList--cols t-BadgeList--5cols t-Report--hideNoPagination" data-region-id="OBJECTS">'');',
'--',
'FOR c IN (',
'    SELECT o.*',
'    FROM obj_overview o',
'    ORDER BY 1',
') LOOP',
'    htp.p(''<li class="t-BadgeList-item" style="border-bottom: 0;">'');',
'    htp.p(CASE WHEN c.page_link IS NOT NULL THEN ''<a href="'' || c.page_link || ''" style="color: #000;">'' END);',
'    htp.p(''<span class="t-BadgeList-wrap u-color">'');',
'    htp.p(''<span class="t-BadgeList-label">'' || c.object_type || ''</span>'');',
'    htp.p(''<span class="t-BadgeList-value">'' || c.count_objects || ''</span>'');',
'    htp.p(''</span>'' || CASE WHEN c.page_link IS NOT NULL THEN ''</a>'' END);',
'    htp.p(''</li>'');',
'END LOOP;',
'--',
'htp.p(''</ul>'');',
''))
,p_plug_source_type=>'NATIVE_PLSQL'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<br />',
''))
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(21745459628497819)
,p_plug_name=>'Invalid Objects (views)'
,p_region_name=>'OBJECTS_INVALID'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9052354744569904)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>2
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    o.object_type AS divider,',
'    ''<span style="margin-left: 2rem;">'' || o.object_name || ''</span>'' AS object_name,',
'    app_actions.get_object_link(o.object_type, o.object_name) AS object_link',
'FROM user_objects o',
'WHERE o.status != ''VALID''',
'    AND o.object_type IN (''VIEW'')',
'ORDER BY o.object_type, o.object_name;',
''))
,p_plug_source_type=>'NATIVE_JQM_LIST_VIEW'
,p_plug_query_num_rows=>50
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_query_no_data_found=>' '
,p_plug_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<br />',
''))
,p_attribute_01=>'DIVIDER'
,p_attribute_02=>'OBJECT_NAME'
,p_attribute_14=>'DIVIDER'
,p_attribute_16=>'&OBJECT_LINK.'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(21745510835497820)
,p_plug_name=>'Invalid Objects (others)'
,p_region_name=>'OBJECTS_INVALID'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9052354744569904)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>2
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    o.object_type AS divider,',
'    ''<span style="margin-left: 2rem;">'' || o.object_name || ''</span>'' AS object_name,',
'    app_actions.get_object_link(o.object_type, o.object_name) AS object_link',
'FROM user_objects o',
'WHERE o.status != ''VALID''',
'    AND o.object_type NOT IN (''VIEW'', ''PACKAGE'', ''PACKAGE BODY'', ''PROCEDURE'', ''FUNCTION'')',
'ORDER BY o.object_type, o.object_name;',
''))
,p_plug_source_type=>'NATIVE_JQM_LIST_VIEW'
,p_plug_query_num_rows=>50
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_query_no_data_found=>' '
,p_plug_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<br />',
''))
,p_attribute_01=>'DIVIDER'
,p_attribute_02=>'OBJECT_NAME'
,p_attribute_14=>'DIVIDER'
,p_attribute_16=>'&OBJECT_LINK.'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36914517833495810)
,p_plug_name=>'Database Objects'
,p_region_name=>'OBJECTS'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--styleB'
,p_plug_template=>wwv_flow_api.id(9052354744569904)
,p_plug_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>6
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'OBJ_OVERVIEW'
,p_query_order_by=>'OBJECT_TYPE'
,p_include_rowid_column=>false
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_show_total_row_count=>false
,p_plug_display_condition_type=>'NEVER'
,p_plug_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<br />',
''))
);
wwv_flow_api.create_card(
 p_id=>wwv_flow_api.id(14219563120378943)
,p_region_id=>wwv_flow_api.id(36914517833495810)
,p_layout_type=>'GRID'
,p_grid_column_count=>4
,p_title_adv_formatting=>false
,p_sub_title_adv_formatting=>true
,p_sub_title_html_expr=>'<b>&OBJECT_TYPE.</b>'
,p_body_adv_formatting=>false
,p_second_body_adv_formatting=>false
,p_badge_column_name=>'COUNT_OBJECTS'
,p_media_adv_formatting=>false
);
wwv_flow_api.create_card_action(
 p_id=>wwv_flow_api.id(14219961302378947)
,p_card_id=>wwv_flow_api.id(14219563120378943)
,p_action_type=>'FULL_CARD'
,p_display_sequence=>10
,p_link_target_type=>'REDIRECT_URL'
,p_link_target=>'&PAGE_LINK.'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(102497670620708980)
,p_plug_name=>'Invalid Objects (procedures)'
,p_region_name=>'OBJECTS_INVALID'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9052354744569904)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>2
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    o.object_type AS divider,',
'    ''<span style="margin-left: 2rem;">'' || o.object_name || ''</span>'' AS object_name,',
'    app_actions.get_object_link(o.object_type, o.object_name) AS object_link',
'FROM user_objects o',
'WHERE o.status != ''VALID''',
'    AND o.object_type IN (''PACKAGE'', ''PACKAGE BODY'', ''PROCEDURE'', ''FUNCTION'')',
'ORDER BY o.object_type, o.object_name;',
''))
,p_plug_source_type=>'NATIVE_JQM_LIST_VIEW'
,p_plug_query_num_rows=>50
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_query_no_data_found=>' '
,p_plug_footer=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<br />',
''))
,p_attribute_01=>'DIVIDER'
,p_attribute_02=>'OBJECT_NAME'
,p_attribute_14=>'DIVIDER'
,p_attribute_16=>'&OBJECT_LINK.'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(14425438113036849)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(14218446056378932)
,p_button_name=>'REFRESH'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(9144574670569995)
,p_button_image_alt=>'&BUTTON_REFRESH.'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:950:&SESSION.::&DEBUG.:950::'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(14428813625036858)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(14218529849378933)
,p_button_name=>'RECOMPILE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(9145249029569999)
,p_button_image_alt=>'Recompile'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:950:&SESSION.::&DEBUG.::P950_RECOMPILE:Y'
,p_button_css_classes=>'&P950_RECOMPILE_HOT.'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(14429259553036858)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(14218529849378933)
,p_button_name=>'RECOMPILE_FORCE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(9144574670569995)
,p_button_image_alt=>'Force recompilation on all objects'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:950:&SESSION.::&DEBUG.::P950_FORCE:Y'
,p_icon_css_classes=>'fa-medication'
,p_security_scheme=>wwv_flow_api.id(9556407311505078)
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(14430018673036860)
,p_name=>'P950_RECOMPILE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(14218529849378933)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(14430476882036860)
,p_name=>'P950_FORCE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(14218529849378933)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(22086676546580634)
,p_name=>'P950_RECOMPILE_HOT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(14218529849378933)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25435523465523603)
,p_name=>'P950_SCHEMA'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(14218446056378932)
,p_prompt=>'Current Schema'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'LOV_CORE_APP_SCHEMAS'
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>wwv_flow_api.id(9142775823569991)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(32963742103841112)
,p_name=>'CHANGED_SCHEMA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P950_SCHEMA'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(32963807659841113)
,p_event_id=>wwv_flow_api.id(32963742103841112)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(14431206414036864)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'ACTION_RECOMPILE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'app.log_action(''RECOMPILE'');',
'--',
'recompile();',
'--',
'app.log_success();',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P950_RECOMPILE'
,p_process_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_process_when2=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(14430832154036864)
,p_process_sequence=>20
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'ACTION_RECOMPILE_FORCE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'app.log_action(''RECOMPILE_FORCE'');',
'--',
'recompile();  -- to reuse settings',
'--',
'DBMS_UTILITY.COMPILE_SCHEMA (',
'    schema      => ''#OWNER#'',',
'    compile_all => TRUE',
');',
'--',
'app.log_success();',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P950_FORCE'
,p_process_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_process_when2=>'Y'
,p_security_scheme=>wwv_flow_api.id(9556407311505078)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(22086589223580633)
,p_process_sequence=>30
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'INIT_DEFAULTS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- hot button',
'SELECT NVL(MAX(''t-Button--hot''), '' '') INTO :P950_RECOMPILE_HOT',
'FROM user_objects o',
'WHERE o.status != ''VALID'';',
'',
'-- change schema',
':P950_SCHEMA := COALESCE(:P950_SCHEMA, app.get_owner());',
'--',
'app.set_owner(:P950_SCHEMA);',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
