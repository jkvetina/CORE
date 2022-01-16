prompt --application/pages/page_00961
begin
--   Manifest
--     PAGE: 00961
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
 p_id=>961
,p_user_interface_id=>wwv_flow_api.id(9169746885570061)
,p_name=>'#fa-file-code-o Source Code'
,p_alias=>'SOURCE-CODE'
,p_page_mode=>'MODAL'
,p_step_title=>'Source Code'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_api.id(15841923064543077)
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// hide original header',
'$(window).on(''load'', function() {',
'    var bar = parent.$(''.ui-dialog-titlebar'');',
'    bar.find(''*'').hide();',
'    bar.css(''border-bottom'', ''0'');',
'    bar.css(''margin-bottom'', ''0'');',
'});',
''))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'td.t-Report-cell {',
'    padding:        0.1rem 0.5rem;',
'    font-family:    monospace;',
'    font-size:      85%;',
'    white-space:    pre;',
'    color:          #111;',
'}',
''))
,p_step_template=>wwv_flow_api.id(9037189326569883)
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_api.id(9556407311505078)
,p_dialog_width=>'1024'
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220116214345'
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
,p_name=>'Source Code [DATA]'
,p_template=>wwv_flow_api.id(9078290074569925)
,p_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(16023824951727223)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(16023674651727221)
,p_button_name=>'CLOSE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(9144574670569995)
,p_button_image_alt=>'Close'
,p_button_position=>'RIGHT_OF_TITLE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-remove'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(16023953626727224)
,p_name=>'P961_MODULE_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(16023674651727221)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(16024006234727225)
,p_name=>'P961_PACKAGE_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(16023674651727221)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(16024150723727226)
,p_name=>'P961_LINE_START'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(16023674651727221)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(16024200790727227)
,p_name=>'P961_LINE_END'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(16023674651727221)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
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
 p_id=>wwv_flow_api.id(16024512776727230)
,p_event_id=>wwv_flow_api.id(16024413800727229)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.component_end;
end;
/
