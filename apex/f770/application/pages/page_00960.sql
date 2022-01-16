prompt --application/pages/page_00960
begin
--   Manifest
--     PAGE: 00960
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
 p_id=>960
,p_user_interface_id=>wwv_flow_api.id(9169746885570061)
,p_name=>'#fa-table-pointer Packages'
,p_alias=>'PACKAGES'
,p_step_title=>'Packages'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_api.id(15841923064543077)
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_api.id(9556407311505078)
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220110214734'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(14931272082872321)
,p_plug_name=>'Packages'
,p_icon_css_classes=>'fa-table-pointer'
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
 p_id=>wwv_flow_api.id(14931328612872322)
,p_plug_name=>'Packages [GRID]'
,p_region_name=>'PACKAGES'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9078290074569925)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'OBJ_PACKAGES'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IG'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Packages [GRID]'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_api.create_region_column_group(
 p_id=>wwv_flow_api.id(15124507192615728)
,p_heading=>'Counts'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(15121818776615701)
,p_name=>'LAST_DDL_TIME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LAST_DDL_TIME'
,p_data_type=>'DATE'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_JET'
,p_heading=>'Last Ddl Time'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>50
,p_value_alignment=>'CENTER'
,p_attribute_01=>'N'
,p_attribute_02=>'POPUP'
,p_attribute_03=>'NONE'
,p_attribute_06=>'NONE'
,p_attribute_09=>'N'
,p_attribute_11=>'Y'
,p_format_mask=>'YYYY-MM-DD HH24:MI'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(15124055201615723)
,p_name=>'PACKAGE_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PACKAGE_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_LINK'
,p_heading=>'Package Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>10
,p_value_alignment=>'LEFT'
,p_link_target=>'f?p=&APP_ID.:960:&SESSION.::&DEBUG.:960:P960_PACKAGE_NAME:&PACKAGE_NAME.'
,p_link_text=>'&PACKAGE_NAME.'
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(15124107826615724)
,p_name=>'COUNT_PROCEDURES'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COUNT_PROCEDURES'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Procedures'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>20
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(15124507192615728)
,p_use_group_for=>'BOTH'
,p_attribute_03=>'right'
,p_is_required=>false
,p_link_target=>'f?p=&APP_ID.:960:&SESSION.::&DEBUG.:960:P960_PACKAGE_NAME,P960_MODULE_TYPE:&PACKAGE_NAME.,P'
,p_link_text=>'&COUNT_PROCEDURES.'
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(15124226782615725)
,p_name=>'COUNT_FUNCTIONS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COUNT_FUNCTIONS'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Functions'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>30
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(15124507192615728)
,p_use_group_for=>'BOTH'
,p_attribute_03=>'right'
,p_is_required=>false
,p_link_target=>'f?p=&APP_ID.:960:&SESSION.::&DEBUG.:960:P960_PACKAGE_NAME,P960_MODULE_TYPE:&PACKAGE_NAME.,F'
,p_link_text=>'&COUNT_FUNCTIONS.'
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(15124389358615726)
,p_name=>'COUNT_LINES'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COUNT_LINES'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Lines'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>40
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(15124507192615728)
,p_use_group_for=>'BOTH'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(15124491128615727)
,p_name=>'DESC_'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DESC_'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Desc'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>60
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_interactive_grid(
 p_id=>wwv_flow_api.id(14933531217872344)
,p_internal_uid=>14933531217872344
,p_is_editable=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>false
,p_fixed_row_height=>true
,p_pagination_type=>'SET'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_toolbar_buttons=>'SEARCH_COLUMN:SEARCH_FIELD:ACTIONS_MENU:SAVE'
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>true
,p_define_chart_view=>true
,p_enable_download=>true
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function(config) {',
'    return unified_ig_toolbar(config);',
'}',
''))
);
wwv_flow_api.create_ig_report(
 p_id=>wwv_flow_api.id(15128057304617605)
,p_interactive_grid_id=>wwv_flow_api.id(14933531217872344)
,p_static_id=>'151281'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_api.create_ig_report_view(
 p_id=>wwv_flow_api.id(15128264473617605)
,p_report_id=>wwv_flow_api.id(15128057304617605)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15134149172617620)
,p_view_id=>wwv_flow_api.id(15128264473617605)
,p_display_seq=>6
,p_column_id=>wwv_flow_api.id(15121818776615701)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>160
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15204743401251653)
,p_view_id=>wwv_flow_api.id(15128264473617605)
,p_display_seq=>1
,p_column_id=>wwv_flow_api.id(15124055201615723)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>300
,p_sort_order=>1
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15205674886251656)
,p_view_id=>wwv_flow_api.id(15128264473617605)
,p_display_seq=>1
,p_column_id=>wwv_flow_api.id(15124107826615724)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>120
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15206594984251659)
,p_view_id=>wwv_flow_api.id(15128264473617605)
,p_display_seq=>2
,p_column_id=>wwv_flow_api.id(15124226782615725)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>120
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15207473139251661)
,p_view_id=>wwv_flow_api.id(15128264473617605)
,p_display_seq=>3
,p_column_id=>wwv_flow_api.id(15124389358615726)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>120
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15208310750251664)
,p_view_id=>wwv_flow_api.id(15128264473617605)
,p_display_seq=>5
,p_column_id=>wwv_flow_api.id(15124491128615727)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(14931458804872323)
,p_plug_name=>'Package Modules'
,p_icon_css_classes=>'fa-table-search'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9070356145569920)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P960_PACKAGE_NAME'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(14931574823872324)
,p_plug_name=>'Package Modules [GRID]'
,p_region_name=>'MODULES'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9078290074569925)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'OBJ_MODULES'
,p_query_where=>wwv_flow_string.join(wwv_flow_t_varchar2(
'package_name = NVL(:P960_PACKAGE_NAME, package_name)',
''))
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IG'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P960_PACKAGE_NAME'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Package Modules [GRID]'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_api.create_region_column_group(
 p_id=>wwv_flow_api.id(14933225335872341)
,p_heading=>'Module'
);
wwv_flow_api.create_region_column_group(
 p_id=>wwv_flow_api.id(14933304135872342)
,p_heading=>'Arguments'
);
wwv_flow_api.create_region_column_group(
 p_id=>wwv_flow_api.id(14933425852872343)
,p_heading=>'Body'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(14931760880872326)
,p_name=>'PACKAGE_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PACKAGE_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Package Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>10
,p_value_alignment=>'LEFT'
,p_group_id=>wwv_flow_api.id(14933225335872341)
,p_use_group_for=>'BOTH'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>true
,p_max_length=>128
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(14931800672872327)
,p_name=>'MODULE_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MODULE_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Module Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>20
,p_value_alignment=>'LEFT'
,p_group_id=>wwv_flow_api.id(14933225335872341)
,p_use_group_for=>'BOTH'
,p_attribute_02=>'VALUE'
,p_attribute_05=>'PLAIN'
,p_link_target=>'f?p=&APP_ID.:961:&SESSION.::&DEBUG.:961:P961_PACKAGE_NAME,P961_MODULE_NAME,P961_LINE_START,P961_LINE_END:&PACKAGE_NAME.,&MODULE_NAME.,&BODY_START.,&BODY_END.'
,p_link_text=>'&MODULE_NAME.'
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(14932080641872329)
,p_name=>'OVERLOAD'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'OVERLOAD'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Overload'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>60
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(14933225335872341)
,p_use_group_for=>'BOTH'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(14932186256872330)
,p_name=>'SPEC_START'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SPEC_START'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Spec Start'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>70
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(14932216175872331)
,p_name=>'SPEC_END'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SPEC_END'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Spec End'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>80
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(14932392053872332)
,p_name=>'SPEC_LINES'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SPEC_LINES'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Spec Lines'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>90
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(14932417414872333)
,p_name=>'BODY_START'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BODY_START'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Start'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>100
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(14933425852872343)
,p_use_group_for=>'BOTH'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(14932537775872334)
,p_name=>'BODY_END'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BODY_END'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'End'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>110
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(14933425852872343)
,p_use_group_for=>'BOTH'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(14932661840872335)
,p_name=>'BODY_LINES'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BODY_LINES'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Lines'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>120
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(14933425852872343)
,p_use_group_for=>'BOTH'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(14932753295872336)
,p_name=>'IS_PRIVATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'IS_PRIVATE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SINGLE_CHECKBOX'
,p_heading=>'Private'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>50
,p_value_alignment=>'CENTER'
,p_group_id=>wwv_flow_api.id(14933225335872341)
,p_use_group_for=>'BOTH'
,p_attribute_01=>'N'
,p_attribute_02=>'Y'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(14932826179872337)
,p_name=>'ARGS_IN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ARGS_IN'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'IN'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>130
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(14933304135872342)
,p_use_group_for=>'BOTH'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(14932937325872338)
,p_name=>'ARGS_OUT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ARGS_OUT'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'OUT'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>140
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(14933304135872342)
,p_use_group_for=>'BOTH'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(14933077407872339)
,p_name=>'COMMENT_'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COMMENT_'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Comment'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>150
,p_value_alignment=>'LEFT'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>false
,p_max_length=>32767
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(14933138200872340)
,p_name=>'IS_FUNCTION'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'IS_FUNCTION'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SINGLE_CHECKBOX'
,p_heading=>'Function'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>40
,p_value_alignment=>'CENTER'
,p_group_id=>wwv_flow_api.id(14933225335872341)
,p_use_group_for=>'BOTH'
,p_attribute_01=>'N'
,p_attribute_02=>'Y'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(15123964223615722)
,p_name=>'GROUP_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GROUP_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Group Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>30
,p_value_alignment=>'LEFT'
,p_attribute_02=>'VALUE'
,p_attribute_05=>'PLAIN'
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_api.create_interactive_grid(
 p_id=>wwv_flow_api.id(14931649685872325)
,p_internal_uid=>14931649685872325
,p_is_editable=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>false
,p_fixed_row_height=>true
,p_pagination_type=>'SET'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_toolbar_buttons=>'SEARCH_COLUMN:SEARCH_FIELD:ACTIONS_MENU:SAVE'
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>true
,p_define_chart_view=>true
,p_enable_download=>true
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function(config) {',
'    return unified_ig_toolbar(config);',
'}',
''))
);
wwv_flow_api.create_ig_report(
 p_id=>wwv_flow_api.id(15053863825502740)
,p_interactive_grid_id=>wwv_flow_api.id(14931649685872325)
,p_static_id=>'150539'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_rows_per_page=>100
,p_show_row_number=>false
,p_settings_area_expanded=>false
);
wwv_flow_api.create_ig_report_view(
 p_id=>wwv_flow_api.id(15054065173502740)
,p_report_id=>wwv_flow_api.id(15053863825502740)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15054580481502742)
,p_view_id=>wwv_flow_api.id(15054065173502740)
,p_display_seq=>0
,p_column_id=>wwv_flow_api.id(14931760880872326)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>200
,p_sort_order=>1
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15055494854502745)
,p_view_id=>wwv_flow_api.id(15054065173502740)
,p_display_seq=>1
,p_column_id=>wwv_flow_api.id(14931800672872327)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>300
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15057245108502750)
,p_view_id=>wwv_flow_api.id(15054065173502740)
,p_display_seq=>2
,p_column_id=>wwv_flow_api.id(14932080641872329)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>90
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15058132388502752)
,p_view_id=>wwv_flow_api.id(15054065173502740)
,p_display_seq=>4
,p_column_id=>wwv_flow_api.id(14932186256872330)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>90
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15059085287502754)
,p_view_id=>wwv_flow_api.id(15054065173502740)
,p_display_seq=>6
,p_column_id=>wwv_flow_api.id(14932216175872331)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>90
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15059983746502756)
,p_view_id=>wwv_flow_api.id(15054065173502740)
,p_display_seq=>7
,p_column_id=>wwv_flow_api.id(14932392053872332)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>90
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15060893769502758)
,p_view_id=>wwv_flow_api.id(15054065173502740)
,p_display_seq=>10
,p_column_id=>wwv_flow_api.id(14932417414872333)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>90
,p_sort_order=>2
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15061704781502760)
,p_view_id=>wwv_flow_api.id(15054065173502740)
,p_display_seq=>11
,p_column_id=>wwv_flow_api.id(14932537775872334)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>90
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15062637386502762)
,p_view_id=>wwv_flow_api.id(15054065173502740)
,p_display_seq=>12
,p_column_id=>wwv_flow_api.id(14932661840872335)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>90
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15063524211502764)
,p_view_id=>wwv_flow_api.id(15054065173502740)
,p_display_seq=>5
,p_column_id=>wwv_flow_api.id(14932753295872336)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>90
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15064428089502766)
,p_view_id=>wwv_flow_api.id(15054065173502740)
,p_display_seq=>8
,p_column_id=>wwv_flow_api.id(14932826179872337)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>90
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15065308029502769)
,p_view_id=>wwv_flow_api.id(15054065173502740)
,p_display_seq=>9
,p_column_id=>wwv_flow_api.id(14932937325872338)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>90
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15066272572502771)
,p_view_id=>wwv_flow_api.id(15054065173502740)
,p_display_seq=>13
,p_column_id=>wwv_flow_api.id(14933077407872339)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15068182252538368)
,p_view_id=>wwv_flow_api.id(15054065173502740)
,p_display_seq=>3
,p_column_id=>wwv_flow_api.id(14933138200872340)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>90
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(15178644954516095)
,p_view_id=>wwv_flow_api.id(15054065173502740)
,p_display_seq=>14
,p_column_id=>wwv_flow_api.id(15123964223615722)
,p_is_visible=>false
,p_is_frozen=>false
,p_break_order=>5
,p_break_is_enabled=>true
,p_break_sort_direction=>'ASC'
,p_break_sort_nulls=>'LAST'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(15123829307615721)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(14931272082872321)
,p_button_name=>'REFRESH'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(9144574670569995)
,p_button_image_alt=>'Refresh'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:960:&SESSION.::&DEBUG.:960::'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(15123714972615720)
,p_name=>'P960_PACKAGE_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(14931272082872321)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(15124759275615730)
,p_name=>'P960_MODULE_TYPE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(14931272082872321)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
