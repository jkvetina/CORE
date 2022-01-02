prompt --application/pages/page_00990
begin
--   Manifest
--     PAGE: 00990
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
 p_id=>990
,p_user_interface_id=>wwv_flow_api.id(9169746885570061)
,p_name=>'&APP_USER.'
,p_alias=>'USER'
,p_step_title=>'User Info'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_api.id(9490872346072322)
,p_page_css_classes=>'USER_NAME'
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_api.id(9844735592500475)
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220102213123'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(9264299805429043)
,p_plug_name=>'User Info'
,p_icon_css_classes=>'fa-user'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9070356145569920)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(9519532707540348)
,p_plug_name=>'User [FORM]'
,p_region_name=>'FORM_USERS'
,p_region_template_options=>'#DEFAULT#:margin-left-md:margin-right-md'
,p_plug_template=>wwv_flow_api.id(9078290074569925)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>6
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'USERS'
,p_query_where=>'user_id = app.get_user_id()'
,p_include_rowid_column=>true
,p_is_editable=>true
,p_edit_operations=>'u'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(9560462665581617)
,p_plug_name=>'User Roles [CARDS]'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--styleC:margin-left-md:margin-right-md'
,p_plug_template=>wwv_flow_api.id(9052354744569904)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'ROLES_CARDS'
,p_include_rowid_column=>false
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_show_total_row_count=>false
);
wwv_flow_api.create_card(
 p_id=>wwv_flow_api.id(10243420607410323)
,p_region_id=>wwv_flow_api.id(9560462665581617)
,p_layout_type=>'GRID'
,p_grid_column_count=>3
,p_title_adv_formatting=>false
,p_title_column_name=>'ROLE_NAME'
,p_sub_title_adv_formatting=>false
,p_sub_title_column_name=>'ROLE_ID'
,p_body_adv_formatting=>false
,p_body_column_name=>'DESCRIPTION_'
,p_second_body_adv_formatting=>false
,p_badge_column_name=>'COUNT_PAGES'
,p_badge_label=>'Pages'
,p_media_adv_formatting=>false
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10243395317410322)
,p_plug_name=>'User Roles'
,p_icon_css_classes=>'fa-id-badge'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9070356145569920)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12994690916936906)
,p_plug_name=>'Available Applications [CARDS]'
,p_region_template_options=>'#DEFAULT#:margin-left-md:margin-right-md'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9052354744569904)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_new_grid_column=>false
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'USERS_APPS'
,p_query_where=>'is_available = ''Y'''
,p_query_order_by=>'APP_ID'
,p_include_rowid_column=>false
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_show_total_row_count=>false
,p_plug_footer=>'<br />'
);
wwv_flow_api.create_card(
 p_id=>wwv_flow_api.id(12994711561936907)
,p_region_id=>wwv_flow_api.id(12994690916936906)
,p_layout_type=>'GRID'
,p_grid_column_count=>5
,p_title_adv_formatting=>false
,p_title_column_name=>'APP_NAME'
,p_sub_title_adv_formatting=>false
,p_body_adv_formatting=>false
,p_body_column_name=>'DESCRIPTION_'
,p_second_body_adv_formatting=>false
,p_second_body_column_name=>'APP_ICON'
,p_badge_column_name=>'COUNT_PAGES'
,p_media_adv_formatting=>false
,p_pk1_column_name=>'APP_ID'
);
wwv_flow_api.create_card_action(
 p_id=>wwv_flow_api.id(12994906479936909)
,p_card_id=>wwv_flow_api.id(12994711561936907)
,p_action_type=>'FULL_CARD'
,p_display_sequence=>10
,p_link_target_type=>'REDIRECT_URL'
,p_link_target=>'&APP_URL.'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12994888224936908)
,p_plug_name=>'Available Applications'
,p_icon_css_classes=>'fa-map-o'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9070356145569920)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(9560520493581618)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(9519532707540348)
,p_button_name=>'SUBMIT'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(9145249029569999)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Submit'
,p_button_position=>'BELOW_BOX'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12997055906936930)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(9264299805429043)
,p_button_name=>'CLONE_SESSION'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(9144574670569995)
,p_button_image_alt=>'Clone Session'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'javascript:window.open(''f?p=&APP_ID.:990:&SESSION.:APEX_CLONE_SESSION::::'', ''_blank'');'
,p_icon_css_classes=>'fa-window-new'
,p_button_cattributes=>'target="_blank"'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9519736699540350)
,p_name=>'P990_USER_ID'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(9519532707540348)
,p_item_source_plug_id=>wwv_flow_api.id(9519532707540348)
,p_item_default=>'app.get_user_id()'
,p_item_default_type=>'EXPRESSION'
,p_item_default_language=>'PLSQL'
,p_prompt=>'User Id'
,p_source=>'USER_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>30
,p_field_template=>wwv_flow_api.id(9142775823569991)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9558884534581601)
,p_name=>'P990_USER_LOGIN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(9519532707540348)
,p_item_source_plug_id=>wwv_flow_api.id(9519532707540348)
,p_prompt=>'User Login'
,p_source=>'USER_LOGIN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>128
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(9142775823569991)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9558908527581602)
,p_name=>'P990_USER_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(9519532707540348)
,p_item_source_plug_id=>wwv_flow_api.id(9519532707540348)
,p_prompt=>'User Name'
,p_source=>'USER_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>64
,p_field_template=>wwv_flow_api.id(9142775823569991)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9559042923581603)
,p_name=>'P990_LANG_ID'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(9519532707540348)
,p_item_source_plug_id=>wwv_flow_api.id(9519532707540348)
,p_prompt=>'Lang Id'
,p_source=>'LANG_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:EN;EN,CZ;CZ'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(9142775823569991)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9559180358581604)
,p_name=>'P990_IS_ACTIVE'
,p_source_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(9519532707540348)
,p_item_source_plug_id=>wwv_flow_api.id(9519532707540348)
,p_source=>'IS_ACTIVE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9559297923581605)
,p_name=>'P990_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(9519532707540348)
,p_item_source_plug_id=>wwv_flow_api.id(9519532707540348)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9559355091581606)
,p_name=>'P990_UPDATED_AT'
,p_source_data_type=>'DATE'
,p_is_query_only=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(9519532707540348)
,p_item_source_plug_id=>wwv_flow_api.id(9519532707540348)
,p_source=>'UPDATED_AT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10889577453121604)
,p_name=>'P990_ROWID'
,p_source_data_type=>'ROWID'
,p_is_primary_key=>true
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(9519532707540348)
,p_item_source_plug_id=>wwv_flow_api.id(9519532707540348)
,p_source=>'ROWID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(13237523222910312)
,p_name=>'ON_CHANGE'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P990_SWITCH_APP'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13237689467910313)
,p_event_id=>wwv_flow_api.id(13237523222910312)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'app.log_action(''SWITCH_APP'', :P990_SWITCH_APP);',
'--',
'UPDATE sessions s',
'SET s.updated_at        = SYSDATE',
'WHERE s.app_id          = :P990_SWITCH_APP',
'    AND s.session_id    = app.get_session_id();',
''))
,p_attribute_02=>'P990_SWITCH_APP'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13237779606910314)
,p_event_id=>wwv_flow_api.id(13237523222910312)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(9560618719581619)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(9519532707540348)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'SAVE_FORM_USERS'
,p_attribute_01=>'TABLE'
,p_attribute_03=>'USERS'
,p_attribute_05=>'N'
,p_attribute_06=>'N'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(10243546752410324)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'INIT_FORM'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'app.log_action(''INIT_FORM'');',
'--',
'/*',
'FOR c IN (',
'    SELECT u.*, ROWID AS rid',
'    FROM users u',
'    WHERE u.user_id = app.get_user_id()',
') LOOP',
'    app.set_item(''$USER_ID'',    c.user_id);',
'    app.set_item(''$USER_LOGIN'', c.user_login);',
'    app.set_item(''$USER_NAME'',  c.user_name);',
'    app.set_item(''$LANG_ID'',    c.lang_id);',
'    app.set_item(''$ROWID'',      c.rid);',
'END LOOP;',
'*/',
'SELECT',
'    u.user_id,',
'    u.user_login,',
'    u.user_name,',
'    u.lang_id,',
'    u.is_active,',
'    ROWID',
'INTO',
'    :P990_USER_ID,',
'    :P990_USER_LOGIN,',
'    :P990_USER_NAME,',
'    :P990_LANG_ID,',
'    :P990_IS_ACTIVE,',
'    :P990_ROWID',
'FROM users u',
'WHERE u.user_id = app.get_user_id();',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
