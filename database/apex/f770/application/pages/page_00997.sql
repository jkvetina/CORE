prompt --application/pages/page_00997
begin
--   Manifest
--     PAGE: 00997
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
 p_id=>997
,p_user_interface_id=>wwv_flow_api.id(9169746885570061)
,p_name=>'#fa-users-chat Chat with Support'
,p_alias=>'SUPPORT'
,p_page_mode=>'MODAL'
,p_step_title=>'Chat with Support'
,p_first_item=>'AUTO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_api.id(9490872346072322)
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
,p_dialog_height=>'600'
,p_dialog_width=>'800'
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220314210203'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36248215960846110)
,p_plug_name=>'Chat with Support'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9049155795569902)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(32967553013841150)
,p_plug_name=>'Chat with Support'
,p_parent_plug_id=>wwv_flow_api.id(36248215960846110)
,p_icon_css_classes=>'fa-users-chat'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9070356145569920)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(36187201121398301)
,p_name=>'[CHAT]'
,p_region_name=>'MESSAGES'
,p_parent_plug_id=>wwv_flow_api.id(36248215960846110)
,p_template=>wwv_flow_api.id(9049155795569902)
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#:margin-top-lg:margin-bottom-md:margin-left-md:margin-right-md'
,p_component_template_options=>'#DEFAULT#:t-Comments--chat:t-Report--hideNoPagination'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'USER_MESSAGES_CHAT'
,p_include_rowid_column=>false
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_api.id(9101604630569948)
,p_query_num_rows=>20
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(36190797240398336)
,p_query_column_id=>1
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>10
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(36190851056398337)
,p_query_column_id=>2
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>20
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(36190916786398338)
,p_query_column_id=>3
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>30
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(36191006733398339)
,p_query_column_id=>4
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>40
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(36191102294398340)
,p_query_column_id=>5
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>50
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(36191217058398341)
,p_query_column_id=>6
,p_column_alias=>'COMMENT_DATE'
,p_column_display_sequence=>60
,p_column_heading=>'Comment Date'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(36191304488398342)
,p_query_column_id=>7
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>70
,p_column_heading=>'Comment Text'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(36191425207398343)
,p_query_column_id=>8
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>80
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(36191519854398344)
,p_query_column_id=>9
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>90
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(36191647354398345)
,p_query_column_id=>10
,p_column_alias=>'USER_ICON'
,p_column_display_sequence=>100
,p_column_heading=>'User Icon'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(36191739673398346)
,p_query_column_id=>11
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>110
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36248442246846112)
,p_plug_name=>'[FORM]'
,p_parent_plug_id=>wwv_flow_api.id(36248215960846110)
,p_region_template_options=>'#DEFAULT#:margin-bottom-lg:margin-left-md:margin-right-md'
,p_plug_template=>wwv_flow_api.id(9049155795569902)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(36190529635398334)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(36248442246846112)
,p_button_name=>'SEND_MESSAGE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(9145249029569999)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Send Message'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_button_cattributes=>'style="margin-top: 1.4rem;"'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(36191855491398347)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(32967553013841150)
,p_button_name=>'CLOSE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(9144574670569995)
,p_button_image_alt=>'&BUTTON_CLOSE.'
,p_button_position=>'RIGHT_OF_TITLE'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'RIGHT'
,p_icon_css_classes=>'fa-times'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(36192026485398349)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(32967553013841150)
,p_button_name=>'REFRESH'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(9144574670569995)
,p_button_image_alt=>'&BUTTON_REFRESH.'
,p_button_position=>'RIGHT_OF_TITLE'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'RIGHT'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(36190479165398333)
,p_name=>'P997_MESSAGE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(36248442246846112)
,p_prompt=>'Message'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>10
,p_field_template=>wwv_flow_api.id(9142775823569991)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(36247479007846102)
,p_name=>'CLOSE_MODAL'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(36191855491398347)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(36247517443846103)
,p_event_id=>wwv_flow_api.id(36247479007846102)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(36247604083846104)
,p_name=>'REFRESH_MESSAGES'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(36192026485398349)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(36247767961846105)
,p_event_id=>wwv_flow_api.id(36247604083846104)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(36187201121398301)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(36247817205846106)
,p_name=>'SEND_MESSAGE'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(36190529635398334)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(36247984330846107)
,p_event_id=>wwv_flow_api.id(36247817205846106)
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
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(36248719408846115)
,p_name=>'New'
,p_event_sequence=>40
,p_bind_type=>'bind'
,p_bind_event_type=>'apexbeforepagesubmit'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(36248800103846116)
,p_event_id=>wwv_flow_api.id(36248719408846115)
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
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(36248951352846117)
,p_event_id=>wwv_flow_api.id(36248719408846115)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CANCEL_EVENT'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(36248028127846108)
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
);
wwv_flow_api.component_end;
end;
/
