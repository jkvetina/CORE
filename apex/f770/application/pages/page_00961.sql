prompt --application/pages/page_00961
begin
--   Manifest
--     PAGE: 00961
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
 p_id=>961
,p_user_interface_id=>wwv_flow_api.id(9169746885570061)
,p_name=>'#fa-file-code-o Source Code'
,p_alias=>'SOURCE-CODE'
,p_page_mode=>'MODAL'
,p_step_title=>'Source Code'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_api.id(15841923064543077)
,p_step_template=>wwv_flow_api.id(9037189326569883)
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_api.id(9556407311505078)
,p_dialog_width=>'1024'
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220127220837'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(16023674651727221)
,p_plug_name=>'Source Code'
,p_icon_css_classes=>'fa-file-code-o'
,p_region_template_options=>'#DEFAULT#'
,p_region_attributes=>'style="margin-top: -3rem;"'
,p_plug_template=>wwv_flow_api.id(9070356145569920)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<!--',
'&P961_PACKAGE_NAME.<br />',
'&P961_MODULE_NAME.',
'-->',
''))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(16026214981727247)
,p_name=>'Package Source Code [DATA]'
,p_template=>wwv_flow_api.id(9078290074569925)
,p_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_css_classes=>'SOURCE_CODE'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--noBorders:t-Report--hideNoPagination'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'USER_SOURCE'
,p_query_where=>wwv_flow_string.join(wwv_flow_t_varchar2(
'name        = :P961_PACKAGE_NAME',
'AND type    = ''PACKAGE BODY''',
'AND line    BETWEEN :P961_LINE_START AND :P961_LINE_END',
''))
,p_query_order_by=>'LINE'
,p_include_rowid_column=>false
,p_display_when_condition=>'P961_SHOW_PROCEDURE'
,p_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_api.id(9103852041569949)
,p_query_num_rows=>1000
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(16026326961727248)
,p_query_column_id=>1
,p_column_alias=>'NAME'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(16026485211727249)
,p_query_column_id=>2
,p_column_alias=>'TYPE'
,p_column_display_sequence=>20
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(16026593816727250)
,p_query_column_id=>3
,p_column_alias=>'LINE'
,p_column_display_sequence=>30
,p_column_heading=>'Line'
,p_use_as_row_header=>'N'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(16221294148514101)
,p_query_column_id=>4
,p_column_alias=>'TEXT'
,p_column_display_sequence=>40
,p_column_heading=>'Text'
,p_heading_alignment=>'LEFT'
,p_display_as=>'RICH_TEXT'
,p_attribute_01=>'HTML'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(16221307374514102)
,p_query_column_id=>5
,p_column_alias=>'ORIGIN_CON_ID'
,p_column_display_sequence=>50
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(16226090811514149)
,p_name=>'View Source Code [DATA]'
,p_template=>wwv_flow_api.id(9078290074569925)
,p_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_css_classes=>'SOURCE_CODE'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--noBorders:t-Report--hideNoPagination'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'USER_SOURCE_VIEWS'
,p_query_where=>'name = :P961_VIEW_NAME'
,p_query_order_by=>'LINE'
,p_include_rowid_column=>false
,p_display_when_condition=>'P961_SHOW_VIEW'
,p_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_api.id(9103852041569949)
,p_query_num_rows=>1000
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(16226177939514150)
,p_query_column_id=>1
,p_column_alias=>'NAME'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(16465470495696702)
,p_query_column_id=>2
,p_column_alias=>'LINE'
,p_column_display_sequence=>30
,p_column_heading=>'Line'
,p_use_as_row_header=>'N'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(16465549614696703)
,p_query_column_id=>3
,p_column_alias=>'TEXT'
,p_column_display_sequence=>40
,p_column_heading=>'Text'
,p_heading_alignment=>'LEFT'
,p_display_as=>'RICH_TEXT'
,p_attribute_01=>'HTML'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(21541647525954410)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(16023674651727221)
,p_button_name=>'GENERATE_CALLER'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(9145303400569999)
,p_button_image_alt=>'Caller'
,p_button_position=>'RIGHT_OF_TITLE'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P961_SHOW_PROCEDURE'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-code'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(21542011440954414)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(16023674651727221)
,p_button_name=>'GENERATE_HANDLER'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(9145303400569999)
,p_button_image_alt=>'Handler'
,p_button_position=>'RIGHT_OF_TITLE'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P961_SHOW_VIEW'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-code'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(21541592953954409)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(16023674651727221)
,p_button_name=>'COPY_SOURCE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(9144574670569995)
,p_button_image_alt=>'Copy Source'
,p_button_position=>'RIGHT_OF_TITLE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-copy'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(16023824951727223)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(16023674651727221)
,p_button_name=>'CLOSE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(9144574670569995)
,p_button_image_alt=>'Close'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_execute_validations=>'N'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'RIGHT'
,p_icon_css_classes=>'fa-remove'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(16023953626727224)
,p_name=>'P961_MODULE_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(16023674651727221)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(16024006234727225)
,p_name=>'P961_PACKAGE_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(16023674651727221)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(16024150723727226)
,p_name=>'P961_LINE_START'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(16023674651727221)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(16024200790727227)
,p_name=>'P961_LINE_END'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(16023674651727221)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(16225903886514148)
,p_name=>'P961_VIEW_NAME'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(16023674651727221)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21541724678954411)
,p_name=>'P961_SHOW_PROCEDURE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(16023674651727221)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21541867459954412)
,p_name=>'P961_SHOW_VIEW'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(16023674651727221)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21542290793954416)
,p_name=>'P961_SOURCE_CLOB'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(16023674651727221)
,p_prompt=>'CLOB'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_tag_attributes=>'style="max-height: 1px;"'
,p_grid_row_css_classes=>'HIDDEN'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21542719121954421)
,p_name=>'P961_CALLER_CLOB'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(16023674651727221)
,p_prompt=>'CLOB'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_tag_attributes=>'style="max-height: 1px;"'
,p_grid_row_css_classes=>'HIDDEN'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(16024413800727229)
,p_name=>'CLOSE_MODAL'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(16023824951727223)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(16225825315514147)
,p_event_id=>wwv_flow_api.id(16024413800727229)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'parent.apex.region(''PACKAGES'').refresh();',
'parent.apex.region(''MODULES'').refresh();',
''))
,p_server_condition_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(16024512776727230)
,p_event_id=>wwv_flow_api.id(16024413800727229)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(21542324823954417)
,p_name=>'COPY_SOURCE'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(21541592953954409)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(21542460104954418)
,p_event_id=>wwv_flow_api.id(21542324823954417)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var item = $(''#P961_SOURCE_CLOB'');',
'var parent = item.closest(''.HIDDEN'');',
'parent.removeClass(''HIDDEN'');',
'item.focus().select();',
'apex.clipboard.copy();',
'parent.addClass(''HIDDEN'');',
'apex.message.showPageSuccess(''Source code copied to clipboard'');',
''))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(21542877758954422)
,p_name=>'COPY_CALLER'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(21541647525954410)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(21543075155954424)
,p_event_id=>wwv_flow_api.id(21542877758954422)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var item = $(''#P961_CALLER_CLOB'');',
'var parent = item.closest(''.HIDDEN'');',
'parent.removeClass(''HIDDEN'');',
'item.focus().select();',
'apex.clipboard.copy();',
'parent.addClass(''HIDDEN'');',
'apex.message.showPageSuccess(''Procedure caller copied to clipboard'');',
''))
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(21541979804954413)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'INIT_DEFAULTS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P961_SHOW_PROCEDURE    := CASE WHEN :P961_PACKAGE_NAME IS NOT NULL THEN ''Y'' END;',
':P961_SHOW_VIEW         := CASE WHEN :P961_VIEW_NAME    IS NOT NULL THEN ''Y'' END;',
':P961_SOURCE_CLOB       := '''';',
'',
'-- prepare view for copy paste',
'IF :P961_SHOW_VIEW IS NOT NULL THEN',
'    FOR c IN (',
'        SELECT t.text',
'        FROM user_source_views t',
'        WHERE t.name = :P961_VIEW_NAME',
'        ORDER BY t.line',
'    ) LOOP',
'        :P961_SOURCE_CLOB := :P961_SOURCE_CLOB || c.text || CHR(10);',
'    END LOOP;',
'    --',
'    :P961_SOURCE_CLOB := RTRIM(:P961_SOURCE_CLOB, CHR(10)) || '';'' || CHR(10);',
'END IF;',
'',
'-- prepare procedure for copy paste',
'IF :P961_SHOW_PROCEDURE IS NOT NULL THEN',
'    FOR c IN (',
'        SELECT t.text',
'        FROM user_source t',
'        WHERE t.name        = :P961_PACKAGE_NAME',
'            AND t.type      = ''PACKAGE BODY''',
'            AND t.line      BETWEEN :P961_LINE_START AND :P961_LINE_END',
'        ORDER BY t.line',
'    ) LOOP',
'        :P961_SOURCE_CLOB := :P961_SOURCE_CLOB || c.text;',
'    END LOOP;',
'    --',
'    :P961_SOURCE_CLOB := :P961_SOURCE_CLOB || CHR(10);',
'END IF;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(21542612419954420)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'INIT_CALLER'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P961_CALLER_CLOB := '''';',
'--',
'DECLARE',
'    out_clob        VARCHAR2(32767);',
'    --',
'    v_message       VARCHAR2(200);',
'    v_status        INTEGER             := 0;',
'BEGIN',
'    DBMS_OUTPUT.ENABLE;',
'    gen.call_handler (',
'        in_procedure_name   => :P961_PACKAGE_NAME || ''.'' || :P961_MODULE_NAME,',
'        in_app_id           => 0,',
'        in_page_id          => 0',
'    );',
'    --',
'    LOOP',
'        EXIT WHEN v_status = 1;',
'        DBMS_OUTPUT.GET_LINE(v_message, v_status);',
'        --',
'        IF (v_status = 0) THEN',
'            out_clob := out_clob || v_message || CHR(10);',
'        END IF;',
'    END LOOP;',
'    --',
'    :P961_CALLER_CLOB := out_clob;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
