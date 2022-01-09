prompt --application/pages/page_00950
begin
--   Manifest
--     PAGE: 00950
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2021.04.15'
,p_release=>'21.1.6'
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
,p_step_title=>'Database Objects'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_api.id(9240371448352386)
,p_step_template=>wwv_flow_api.id(9463753933679086)
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_api.id(9556407311505078)
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220109080551'
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
,p_icon_css_classes=>'fa-warning'
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
 p_id=>wwv_flow_api.id(36914517833495810)
,p_plug_name=>'Database Objects'
,p_region_name=>'OBJECTS'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--styleB'
,p_plug_template=>wwv_flow_api.id(9052354744569904)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>6
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    object_type,',
'    COUNT(*) AS count_objects,',
'    NULL AS page_link',
'FROM user_objects',
'WHERE object_type NOT IN (''PACKAGE BODY'', ''TABLE PARTITION'')',
'GROUP BY object_type',
'ORDER BY 1;',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_show_total_row_count=>false
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(102497670620708980)
,p_plug_name=>'Invalid Objects'
,p_region_name=>'OBJECTS_INVALID'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9052354744569904)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>6
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    o.object_type,',
'    o.object_name,',
'    o.last_ddl_time',
'FROM user_objects o',
'WHERE o.status != ''VALID''',
'ORDER BY 1, 2;',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_show_total_row_count=>false
);
wwv_flow_api.create_card(
 p_id=>wwv_flow_api.id(14219678078378944)
,p_region_id=>wwv_flow_api.id(102497670620708980)
,p_layout_type=>'GRID'
,p_grid_column_count=>4
,p_title_adv_formatting=>false
,p_sub_title_adv_formatting=>true
,p_sub_title_html_expr=>'<b>&OBJECT_NAME.</b><br />&OBJECT_TYPE.'
,p_body_adv_formatting=>false
,p_second_body_adv_formatting=>false
,p_second_body_column_name=>'LAST_DDL_TIME'
,p_media_adv_formatting=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(14425438113036849)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(14218446056378932)
,p_button_name=>'REFRESH'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(9144574670569995)
,p_button_image_alt=>'Refresh'
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
,p_icon_css_classes=>'fa-tank'
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
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(14218529849378933)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(14431206414036864)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'RECOMPILE'
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
,p_process_name=>'RECOMPILE_FORCE'
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
);
wwv_flow_api.component_end;
end;
/
