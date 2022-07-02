prompt --application/pages/page_00997
begin
--   Manifest
--     PAGE: 00997
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.1'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_imp_page.create_page(
 p_id=>997
,p_user_interface_id=>wwv_flow_imp.id(9169746885570061)
,p_name=>'#fa-users-chat Chat with Support'
,p_alias=>'CHAT-SUPPORT'
,p_page_mode=>'MODAL'
,p_step_title=>'Chat with Support'
,p_first_item=>'AUTO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_imp.id(9490872346072322)
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function loop(i) {',
'    setTimeout(function() {',
'        apex.region(''MESSAGES'').refresh();',
'        loop(i);',
'    }, 10000);  // 10sec forever',
'})();',
''))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.t-Comments--chat li.RIGHT .t-Comments-icon {',
'    order: 2;',
'    margin-left: var(--ut-comment-icon-margin-x, 12px);',
'    margin-right: 0;',
'}',
'.t-Comments--chat li.RIGHT .t-Comments-body {',
'    align-items: flex-end;',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>'MUST_NOT_BE_PUBLIC_USER'
,p_dialog_height=>'600'
,p_dialog_width=>'800'
,p_page_component_map=>'03'
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220317120819'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(32967553013841150)
,p_plug_name=>'Chat with Support'
,p_icon_css_classes=>'fa-users-chat'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(9070356145569920)
,p_plug_display_sequence=>10
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(36248442246846112)
,p_plug_name=>'USER [FORM]'
,p_region_template_options=>'#DEFAULT#:margin-bottom-lg:margin-left-md:margin-right-md'
,p_plug_template=>wwv_flow_imp.id(9049155795569902)
,p_plug_display_sequence=>20
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_required_role=>'!'||wwv_flow_imp.id(9823062898204869)
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(36251737316846145)
,p_plug_name=>'SUPPORT [FORM]'
,p_region_template_options=>'#DEFAULT#:margin-bottom-lg:margin-left-md:margin-right-md'
,p_plug_template=>wwv_flow_imp.id(9049155795569902)
,p_plug_display_sequence=>30
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_required_role=>wwv_flow_imp.id(9823062898204869)
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(36252022207846148)
,p_name=>'[CHAT]'
,p_region_name=>'MESSAGES'
,p_template=>wwv_flow_imp.id(9049155795569902)
,p_display_sequence=>40
,p_region_template_options=>'#DEFAULT#:margin-top-lg:margin-bottom-md:margin-left-md:margin-right-md'
,p_component_template_options=>'#DEFAULT#:t-Comments--chat:t-Report--hideNoPagination'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'USER_MESSAGES_CHAT'
,p_include_rowid_column=>false
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(9101604630569948)
,p_query_num_rows=>20
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(36252185095846149)
,p_query_column_id=>1
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>10
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(36252203138846150)
,p_query_column_id=>2
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>20
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(36462173137516301)
,p_query_column_id=>3
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>30
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(36462218479516302)
,p_query_column_id=>4
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>40
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(36462393732516303)
,p_query_column_id=>5
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>50
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(36462441792516304)
,p_query_column_id=>6
,p_column_alias=>'COMMENT_DATE'
,p_column_display_sequence=>60
,p_column_heading=>'Comment Date'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(36462585049516305)
,p_query_column_id=>7
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>70
,p_column_heading=>'Comment Text'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(36462629501516306)
,p_query_column_id=>8
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>80
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(36462720908516307)
,p_query_column_id=>9
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>90
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(36462821698516308)
,p_query_column_id=>10
,p_column_alias=>'USER_ICON'
,p_column_display_sequence=>100
,p_column_heading=>'User Icon'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(36462915881516309)
,p_query_column_id=>11
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>110
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(36251976725846147)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(36251737316846145)
,p_button_name=>'SEND_RESPONSE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(9145249029569999)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Send Response'
,p_warn_on_unsaved_changes=>null
,p_button_cattributes=>'style="margin-top: 1.4rem;"'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(36190529635398334)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(36248442246846112)
,p_button_name=>'SEND_MESSAGE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(9145249029569999)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Send Message'
,p_warn_on_unsaved_changes=>null
,p_button_cattributes=>'style="margin-top: 1.4rem;"'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(36191855491398347)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(32967553013841150)
,p_button_name=>'CLOSE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(9144574670569995)
,p_button_image_alt=>'&BUTTON_CLOSE.'
,p_button_position=>'RIGHT_OF_TITLE'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'RIGHT'
,p_icon_css_classes=>'fa-times'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(36192026485398349)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(32967553013841150)
,p_button_name=>'REFRESH'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(9144574670569995)
,p_button_image_alt=>'&BUTTON_REFRESH.'
,p_button_position=>'RIGHT_OF_TITLE'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'RIGHT'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(36190479165398333)
,p_name=>'P997_MESSAGE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(36248442246846112)
,p_prompt=>'Message'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>10
,p_field_template=>wwv_flow_imp.id(9142775823569991)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(36251873032846146)
,p_name=>'P997_RESPONSE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(36251737316846145)
,p_prompt=>'Response'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>10
,p_field_template=>wwv_flow_imp.id(9142775823569991)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(36463087748516310)
,p_name=>'P997_APP_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(32967553013841150)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(36463109339516311)
,p_name=>'P997_USER_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(32967553013841150)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(36463290931516312)
,p_name=>'P997_SESSION_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(32967553013841150)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(36247479007846102)
,p_name=>'CLOSE_MODAL'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(36191855491398347)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(36247517443846103)
,p_event_id=>wwv_flow_imp.id(36247479007846102)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(36247604083846104)
,p_name=>'REFRESH_MESSAGES'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(36192026485398349)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(36247817205846106)
,p_name=>'SEND_MESSAGE'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(36190529635398334)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(36247984330846107)
,p_event_id=>wwv_flow_imp.id(36247817205846106)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.server.process (',
'    ''AJAX_SEND_MESSAGE'',',
'    {',
'        x01: apex.item(''P997_MESSAGE'').getValue()',
'    },',
'    {',
'        async       : true,',
'        dataType    : ''text'',',
'        success     : function(data) {',
'            apex.item(''P997_MESSAGE'').setValue('''');',
'            apex.region(''MESSAGES'').refresh();',
'            $(''#P997_MESSAGE'').focus();',
'        }',
'    }',
');',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(36463692715516316)
,p_name=>'SEND_RESPONSE'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(36251976725846147)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(36463788356516317)
,p_event_id=>wwv_flow_imp.id(36463692715516316)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.server.process (',
'    ''AJAX_SEND_MESSAGE'',',
'    {',
'        x01: apex.item(''P997_RESPONSE'').getValue(),',
'        x02: apex.item(''P997_APP_ID'').getValue(),',
'        x03: apex.item(''P997_USER_ID'').getValue(),',
'        x04: apex.item(''P997_SESSION_ID'').getValue()',
'    },',
'    {',
'        async       : true,',
'        dataType    : ''text'',',
'        success     : function(data) {',
'            apex.item(''P997_RESPONSE'').setValue('''');',
'            apex.region(''MESSAGES'').refresh();',
'            $(''#P997_RESPONSE'').focus();',
'        }',
'    }',
');',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(36248719408846115)
,p_name=>'SUBMIT_PAGE'
,p_event_sequence=>50
,p_bind_type=>'bind'
,p_bind_event_type=>'apexbeforepagesubmit'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(36248800103846116)
,p_event_id=>wwv_flow_imp.id(36248719408846115)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.server.process (',
'    ''AJAX_SEND_MESSAGE'',',
'    {',
'        x01: apex.item(''P997_MESSAGE'').getValue()',
'    },',
'    {',
'        async       : true,',
'        dataType    : ''text'',',
'        success     : function(data) {',
'            apex.item(''P997_MESSAGE'').setValue('''');',
'            apex.region(''MESSAGES'').refresh();',
'            $(''#P997_MESSAGE'').focus();',
'        }',
'    }',
');',
''))
,p_security_scheme=>'!'||wwv_flow_imp.id(9823062898204869)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(36463495749516314)
,p_event_id=>wwv_flow_imp.id(36248719408846115)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.server.process (',
'    ''AJAX_SEND_RESPONSE'',',
'    {',
'        x01: apex.item(''P997_RESPONSE'').getValue(),',
'        x02: apex.item(''P997_APP_ID'').getValue(),',
'        x03: apex.item(''P997_USER_ID'').getValue(),',
'        x04: apex.item(''P997_SESSION_ID'').getValue()',
'    },',
'    {',
'        async       : true,',
'        dataType    : ''text'',',
'        success     : function(data) {',
'console.log(''SENT:'', apex.item(''P997_RESPONSE'').getValue());',
'            apex.item(''P997_RESPONSE'').setValue('''');',
'            apex.region(''MESSAGES'').refresh();',
'            $(''#P997_RESPONSE'').focus();',
'        }',
'    }',
');',
''))
,p_security_scheme=>wwv_flow_imp.id(9823062898204869)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(36248951352846117)
,p_event_id=>wwv_flow_imp.id(36248719408846115)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CANCEL_EVENT'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(36463800444516318)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'INIT_DEFAULTS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P997_APP_ID        := COALESCE(:P997_APP_ID,       app.get_app_id());',
':P997_USER_ID       := COALESCE(:P997_USER_ID,      app.get_user_id());',
':P997_SESSION_ID    := COALESCE(:P997_SESSION_ID,   app.get_session_id());',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(36248028127846108)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'AJAX_SEND_MESSAGE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'app_actions.send_message (',
'    in_user_id      => app.get_user_id(),',
'    in_message      => APEX_APPLICATION.G_X01,',
'    in_type         => ''CHAT'',',
'    in_session_id   => app.get_session_id()',
');',
'--',
':P997_MESSAGE := NULL;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_security_scheme=>'!'||wwv_flow_imp.id(9823062898204869)
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(36474943634532372)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'AJAX_SEND_RESPONSE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'app.log_action(''AJAX_SEND_RESPONSE'', APEX_APPLICATION.G_X01);',
'app_actions.send_message (',
'    in_app_id       => app.get_number_item(''P997_APP_ID''),',
'    in_user_id      => app.get_item(''P997_USER_ID''),',
'    in_session_id   => app.get_number_item(''P997_SESSION_ID''),',
'    in_message      => APEX_APPLICATION.G_X01,',
'    in_type         => ''CHAT''',
');',
'--',
':P997_RESPONSE := NULL;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(36251976725846147)
,p_security_scheme=>wwv_flow_imp.id(9823062898204869)
);
wwv_flow_imp.component_end;
end;
/
