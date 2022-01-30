prompt --application/pages/page_00902
begin
--   Manifest
--     PAGE: 00902
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
 p_id=>902
,p_user_interface_id=>wwv_flow_api.id(9169746885570061)
,p_name=>'Log &P902_LOG_ID.'
,p_alias=>'LOG'
,p_page_mode=>'MODAL'
,p_step_title=>'Log &P902_LOG_ID.'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_api.id(9240371448352386)
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_required_role=>wwv_flow_api.id(9556407311505078)
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220130090906'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(32439252690717788)
,p_plug_name=>'Log Tree [GRID]'
,p_region_name=>'LOGS_TREE'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9078290074569925)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'LOGS_TREE'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IG'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Log Tree [GRID]'
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
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(32439405796717790)
,p_name=>'LOG_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LOG_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Log Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>10
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>true
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(32439522037717791)
,p_name=>'LOG_PARENT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LOG_PARENT'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Log Parent'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>20
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
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(32439631068717792)
,p_name=>'APP_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APP_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>30
,p_attribute_01=>'Y'
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(32439743507717793)
,p_name=>'PAGE_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PAGE_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Page Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>40
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
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(32439798614717794)
,p_name=>'USER_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'USER_ID'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'User Id'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>30
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
 p_id=>wwv_flow_api.id(32439873313717795)
,p_name=>'FLAG'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FLAG'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Flag'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>60
,p_value_alignment=>'CENTER'
,p_attribute_05=>'BOTH'
,p_is_required=>true
,p_max_length=>1
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
 p_id=>wwv_flow_api.id(32440025803717796)
,p_name=>'ACTION_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ACTION_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Action Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>70
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>32
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
 p_id=>wwv_flow_api.id(32440120055717797)
,p_name=>'MODULE_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MODULE_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HTML_EXPRESSION'
,p_heading=>'Module Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>80
,p_value_alignment=>'LEFT'
,p_attribute_01=>'<span style="white-space: pre;">&MODULE_NAME.</span>'
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(32440242390717798)
,p_name=>'MODULE_LINE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MODULE_LINE'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Line'
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
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(32440281083717799)
,p_name=>'MODULE_TIMER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MODULE_TIMER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Module Timer'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>100
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>12
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
 p_id=>wwv_flow_api.id(32440466873717800)
,p_name=>'ARGUMENTS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ARGUMENTS'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Arguments'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>110
,p_value_alignment=>'LEFT'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>false
,p_max_length=>2000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(32440519354717801)
,p_name=>'PAYLOAD'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PAYLOAD'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Payload'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>120
,p_value_alignment=>'LEFT'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>false
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(32440627171717802)
,p_name=>'SESSION_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SESSION_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Session Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>130
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
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(32440764338717803)
,p_name=>'CREATED_AT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_AT'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_JET'
,p_heading=>'Created At'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>140
,p_value_alignment=>'CENTER'
,p_attribute_01=>'N'
,p_attribute_02=>'POPUP'
,p_attribute_03=>'NONE'
,p_attribute_06=>'NONE'
,p_attribute_09=>'N'
,p_attribute_11=>'Y'
,p_format_mask=>'&FORMAT_TIME.'
,p_is_required=>true
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
wwv_flow_api.create_interactive_grid(
 p_id=>wwv_flow_api.id(32439362025717789)
,p_internal_uid=>32439362025717789
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
 p_id=>wwv_flow_api.id(32513326447292335)
,p_interactive_grid_id=>wwv_flow_api.id(32439362025717789)
,p_static_id=>'106542'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_rows_per_page=>100
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_api.create_ig_report_view(
 p_id=>wwv_flow_api.id(32513484450292336)
,p_report_id=>wwv_flow_api.id(32513326447292335)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(32514035687292338)
,p_view_id=>wwv_flow_api.id(32513484450292336)
,p_display_seq=>0
,p_column_id=>wwv_flow_api.id(32439405796717790)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>100
,p_sort_order=>1
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(32514888366292344)
,p_view_id=>wwv_flow_api.id(32513484450292336)
,p_display_seq=>1
,p_column_id=>wwv_flow_api.id(32439522037717791)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>95
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(32515838448292347)
,p_view_id=>wwv_flow_api.id(32513484450292336)
,p_display_seq=>3
,p_column_id=>wwv_flow_api.id(32439631068717792)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(32516740451292349)
,p_view_id=>wwv_flow_api.id(32513484450292336)
,p_display_seq=>3
,p_column_id=>wwv_flow_api.id(32439743507717793)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>80
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(32517540984292352)
,p_view_id=>wwv_flow_api.id(32513484450292336)
,p_display_seq=>4
,p_column_id=>wwv_flow_api.id(32439798614717794)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>240
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(32518466272292354)
,p_view_id=>wwv_flow_api.id(32513484450292336)
,p_display_seq=>5
,p_column_id=>wwv_flow_api.id(32439873313717795)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>60
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(32519359352292356)
,p_view_id=>wwv_flow_api.id(32513484450292336)
,p_display_seq=>6
,p_column_id=>wwv_flow_api.id(32440025803717796)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>280
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(32520228875292358)
,p_view_id=>wwv_flow_api.id(32513484450292336)
,p_display_seq=>7
,p_column_id=>wwv_flow_api.id(32440120055717797)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>360
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(32521085130292361)
,p_view_id=>wwv_flow_api.id(32513484450292336)
,p_display_seq=>8
,p_column_id=>wwv_flow_api.id(32440242390717798)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>80
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(32522046070292363)
,p_view_id=>wwv_flow_api.id(32513484450292336)
,p_display_seq=>11
,p_column_id=>wwv_flow_api.id(32440281083717799)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>120
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(32522885659292365)
,p_view_id=>wwv_flow_api.id(32513484450292336)
,p_display_seq=>10
,p_column_id=>wwv_flow_api.id(32440466873717800)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>400
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(32523839360292368)
,p_view_id=>wwv_flow_api.id(32513484450292336)
,p_display_seq=>11
,p_column_id=>wwv_flow_api.id(32440519354717801)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(32524744224292370)
,p_view_id=>wwv_flow_api.id(32513484450292336)
,p_display_seq=>12
,p_column_id=>wwv_flow_api.id(32440627171717802)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(32525656229292373)
,p_view_id=>wwv_flow_api.id(32513484450292336)
,p_display_seq=>13
,p_column_id=>wwv_flow_api.id(32440764338717803)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>100
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(32750233273910580)
,p_plug_name=>'Log &P902_LOG_ID.'
,p_icon_css_classes=>'fa-bug'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9070356145569920)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(33711724220958077)
,p_plug_name=>'Arguments, Payload...'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody:margin-top-sm'
,p_plug_template=>wwv_flow_api.id(9080157814569926)
,p_plug_display_sequence=>30
,p_plug_grid_column_css_classes=>'NO_BORDERS'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(21889674046789037)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(32750233273910580)
,p_button_name=>'CLOSE_TREE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(9144574670569995)
,p_button_image_alt=>'Close'
,p_button_position=>'RIGHT_OF_TITLE'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'RIGHT'
,p_icon_css_classes=>'fa-times'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21746756338497832)
,p_name=>'P902_LOG_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(32750233273910580)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21888197503789036)
,p_name=>'P902_ACTION_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(33711724220958077)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Action Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_attributes=>'style="font-family: monospace;"'
,p_colspan=>6
,p_field_template=>wwv_flow_api.id(9142775823569991)
,p_item_template_options=>'#DEFAULT#:margin-top-none'
,p_attribute_01=>'N'
,p_attribute_05=>'HTML'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21888528773789036)
,p_name=>'P902_ARGUMENTS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(33711724220958077)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Arguments'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_attributes=>'style="font-family: monospace;"'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(9142775823569991)
,p_item_template_options=>'#DEFAULT#:margin-top-none'
,p_attribute_01=>'N'
,p_attribute_05=>'HTML'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21888997006789037)
,p_name=>'P902_PAYLOAD'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(33711724220958077)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Payload'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_attributes=>'style="font-family: monospace;"'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(9142775823569991)
,p_item_template_options=>'#DEFAULT#:margin-top-none'
,p_attribute_01=>'N'
,p_attribute_05=>'HTML'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(21892023461789048)
,p_name=>'TODAY_CHANGED'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P902_TODAY'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(21892571388789049)
,p_event_id=>wwv_flow_api.id(21892023461789048)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(21892909876789050)
,p_name=>'LOAD_DETAILS'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(32439252690717788)
,p_bind_type=>'live'
,p_bind_event_type=>'NATIVE_IG|REGION TYPE|interactivegridselectionchange'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(21893431917789051)
,p_event_id=>wwv_flow_api.id(21892909876789050)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// get selection',
'var curr  = '''';',
'var model = this.data.model;',
'for (var i = 0; i < this.data.selectedRecords.length; i++) {',
'    curr = model.getValue(this.data.selectedRecords[i], ''LOG_ID'');',
'}',
'',
'if (curr) {',
'    // get action name for selected row',
'    apex.server.process(',
'        ''GET_ACTION_NAME'', { x01: curr },',
'        {',
'        success: function (pData) {',
'            apex.item(''P902_ACTION_NAME'').setValue(pData);',
'        },',
'        dataType: ''text''',
'        }',
'    );',
'',
'    // get arguments for selected row',
'    apex.server.process(',
'        ''GET_ARGUMENTS'', { x01: curr },',
'        {',
'        success: function (pData) {',
'            apex.item(''P902_ARGUMENTS'').setValue(pData);',
'        },',
'        dataType: ''text''',
'        }',
'    );',
'',
'    // get payload for selected row',
'    apex.server.process(',
'        ''GET_PAYLOAD'', { x01: curr },',
'        {',
'        success: function (pData) {',
'            apex.item(''P902_PAYLOAD'').setValue(pData);',
'        },',
'        dataType: ''text''',
'        }',
'    );',
'}'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(21893895516789051)
,p_name=>'PRESELECT_LOG_ID'
,p_event_sequence=>10
,p_bind_type=>'live'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(21894396293789051)
,p_event_id=>wwv_flow_api.id(21893895516789051)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var curr = apex.item(''P902_LOG_ID'').getValue();',
'if (curr) {',
'    var grid = apex.region(''LOGS_TREE'').widget().interactiveGrid(''getViews'', ''grid'');',
'    var rec = grid.model.getRecord(curr);',
'    grid.setSelectedRecords([rec], true);',
'}',
''))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(21746560839497830)
,p_name=>'CLOSE_MODAL'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(21889674046789037)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(21746698878497831)
,p_event_id=>wwv_flow_api.id(21746560839497830)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(21890087633789046)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'INIT_DEFAULTS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'app.log_action(''INIT_DEFAULTS'');',
'--',
'IF :P902_LOG_ID IS NOT NULL THEN',
'    app.set_log_tree_id(app.get_log_root(:P902_LOG_ID));',
'END IF;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(21891653691789047)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_ACTION_NAME'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'app.log_action(''GET_ACTION_NAME'', APEX_APPLICATION.G_X01);',
'--',
'FOR c IN (',
'    SELECT l.action_name AS line',
'    FROM logs l',
'    WHERE l.log_id = APEX_APPLICATION.G_X01',
') LOOP',
'    htp.p(c.line);',
'END LOOP;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(21891218156789047)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_ARGUMENTS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'app.log_action(''GET_ARGUMENTS'', APEX_APPLICATION.G_X01);',
'--',
'DECLARE',
'    out_line logs.arguments%TYPE;',
'BEGIN',
'    SELECT l.arguments INTO out_line',
'    FROM logs l',
'    WHERE l.log_id = APEX_APPLICATION.G_X01;',
'    --',
'    IF out_line LIKE ''{"%}'' THEN',
'        SELECT JSON_QUERY(out_line, ''$'' RETURNING VARCHAR2(4000) PRETTY) INTO out_line',
'        FROM DUAL;',
'    END IF;',
'    --',
'    htp.p(REPLACE(out_line, CHR(10), ''<br />''));',
'EXCEPTION',
'WHEN NO_DATA_FOUND THEN',
'    NULL;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(21890856084789047)
,p_process_sequence=>30
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_PAYLOAD'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'app.log_action(''GET_PAYLOAD'', APEX_APPLICATION.G_X01);',
'--',
'FOR c IN (',
'    SELECT l.payload AS line',
'    FROM logs l',
'    WHERE l.log_id = APEX_APPLICATION.G_X01',
') LOOP',
'    c.line := REGEXP_REPLACE(c.line, ''\s.*SQL.*\.EXEC.*\]'', ''.'');',
'    c.line := REGEXP_REPLACE(c.line, ''\s%.*EXEC.*\]'', ''.'');',
'    c.line := REGEXP_REPLACE(c.line, ''\s%_PROCESS.*\]'', ''.'');',
'    c.line := REGEXP_REPLACE(c.line, ''\s%_ERROR.*\]'', ''.'');',
'    c.line := REGEXP_REPLACE(c.line, ''\s%_SECURITY.*\]'', ''.'');',
'    c.line := REGEXP_REPLACE(c.line, ''\sHTMLDB*\]'', ''.'');',
'    --',
'    htp.p(REPLACE(c.line, CHR(10), ''<br />''));',
'END LOOP;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
