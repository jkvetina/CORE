prompt --application/pages/page_00900
begin
--   Manifest
--     PAGE: 00900
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
 p_id=>900
,p_user_interface_id=>wwv_flow_api.id(9169746885570061)
,p_name=>'#fa-gears'
,p_alias=>'DASHBOARD'
,p_step_title=>'Dashboard'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_api.id(9240371448352386)
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_api.id(9823062898204869)
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20211229180245'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(9263989035429040)
,p_plug_name=>'Dashboard'
,p_icon_css_classes=>'fa-gears'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9070356145569920)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_required_role=>wwv_flow_api.id(9556407311505078)
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11140213941125814)
,p_plug_name=>'Dashboard [GRID]'
,p_region_name=>'DASHBOARD'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9078290074569925)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'DASHBOARD_OVERVIEW'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IG'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Dashboard [GRID]'
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
 p_id=>wwv_flow_api.id(12110601971376305)
,p_heading=>'Logs'
);
wwv_flow_api.create_region_column_group(
 p_id=>wwv_flow_api.id(12110720899376306)
,p_heading=>'Schedulers'
);
wwv_flow_api.create_region_column_group(
 p_id=>wwv_flow_api.id(12110875985376307)
,p_heading=>'Other Metrics'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(11140416911125816)
,p_name=>'TODAY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TODAY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Today'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>20
,p_value_alignment=>'CENTER'
,p_attribute_02=>'VALUE'
,p_attribute_05=>'PLAIN'
,p_link_target=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.:901:G_TODAY:&TODAY.'
,p_link_text=>'&TODAY.'
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
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(11140522453125817)
,p_name=>'COUNT_REQUESTS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COUNT_REQUESTS'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Requests'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>30
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(12110601971376305)
,p_use_group_for=>'BOTH'
,p_attribute_02=>'VALUE'
,p_attribute_05=>'PLAIN'
,p_link_target=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.:901:G_TODAY,P901_FLAG:&TODAY.,A'
,p_link_text=>'&COUNT_REQUESTS.'
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
 p_id=>wwv_flow_api.id(11140648716125818)
,p_name=>'COUNT_MODULES'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COUNT_MODULES'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Modules'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>40
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(12110601971376305)
,p_use_group_for=>'BOTH'
,p_attribute_02=>'VALUE'
,p_attribute_05=>'PLAIN'
,p_link_target=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.:901:G_TODAY,P901_FLAG:&TODAY.,M'
,p_link_text=>'&COUNT_MODULES.'
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
 p_id=>wwv_flow_api.id(11140735129125819)
,p_name=>'COUNT_DEBUGS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COUNT_DEBUGS'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Debugs'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>50
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(12110601971376305)
,p_use_group_for=>'BOTH'
,p_attribute_02=>'VALUE'
,p_attribute_05=>'PLAIN'
,p_link_target=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.:901:G_TODAY,P901_FLAG:&TODAY.,D'
,p_link_text=>'&COUNT_DEBUGS.'
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
 p_id=>wwv_flow_api.id(11140855007125820)
,p_name=>'COUNT_RESULTS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COUNT_RESULTS'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Results'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>60
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(12110601971376305)
,p_use_group_for=>'BOTH'
,p_attribute_02=>'VALUE'
,p_attribute_05=>'PLAIN'
,p_link_target=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.:901:G_TODAY,P901_FLAG:&TODAY.,R'
,p_link_text=>'&COUNT_RESULTS.'
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
 p_id=>wwv_flow_api.id(11140924785125821)
,p_name=>'COUNT_WARNINGS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COUNT_WARNINGS'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Warnings'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>70
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(12110601971376305)
,p_use_group_for=>'BOTH'
,p_attribute_02=>'VALUE'
,p_attribute_05=>'PLAIN'
,p_link_target=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.:901:G_TODAY,P901_FLAG:&TODAY.,W'
,p_link_text=>'&COUNT_WARNINGS.'
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
 p_id=>wwv_flow_api.id(11141043056125822)
,p_name=>'COUNT_ERRORS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COUNT_ERRORS'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Errors'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>80
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(12110601971376305)
,p_use_group_for=>'BOTH'
,p_attribute_02=>'VALUE'
,p_attribute_05=>'PLAIN'
,p_link_target=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.:901:G_TODAY,P901_FLAG:&TODAY.,E'
,p_link_text=>'&COUNT_ERRORS.'
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
 p_id=>wwv_flow_api.id(11141108243125823)
,p_name=>'COUNT_LONGOPS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COUNT_LONGOPS'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Longops'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>90
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(12110601971376305)
,p_use_group_for=>'BOTH'
,p_attribute_02=>'VALUE'
,p_attribute_05=>'PLAIN'
,p_link_target=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.:901:G_TODAY,P901_FLAG:&TODAY.,L'
,p_link_text=>'&COUNT_LONGOPS.'
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
 p_id=>wwv_flow_api.id(11141298840125824)
,p_name=>'COUNT_TRIGGERS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COUNT_TRIGGERS'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Triggers'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>100
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(12110601971376305)
,p_use_group_for=>'BOTH'
,p_attribute_02=>'VALUE'
,p_attribute_05=>'PLAIN'
,p_link_target=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.:901:G_TODAY,P901_FLAG:&TODAY.,G'
,p_link_text=>'&COUNT_TRIGGERS.'
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
 p_id=>wwv_flow_api.id(11141332158125825)
,p_name=>'COUNT_SESSIONS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COUNT_SESSIONS'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Sessions'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>110
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(12110875985376307)
,p_use_group_for=>'BOTH'
,p_attribute_02=>'VALUE'
,p_attribute_05=>'PLAIN'
,p_link_target=>'f?p=&APP_ID.:915:&SESSION.::&DEBUG.:915:G_TODAY:&TODAY.'
,p_link_text=>'&COUNT_SESSIONS.'
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
 p_id=>wwv_flow_api.id(11141455989125826)
,p_name=>'COUNT_USERS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COUNT_USERS'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Users'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>120
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(12110875985376307)
,p_use_group_for=>'BOTH'
,p_attribute_02=>'VALUE'
,p_attribute_05=>'PLAIN'
,p_link_target=>'f?p=&APP_ID.:920:&SESSION.::&DEBUG.:920:G_TODAY:&TODAY.'
,p_link_text=>'&COUNT_USERS.'
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
 p_id=>wwv_flow_api.id(11141544517125827)
,p_name=>'COUNT_EVENTS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COUNT_EVENTS'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Events'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>130
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(12110875985376307)
,p_use_group_for=>'BOTH'
,p_attribute_02=>'VALUE'
,p_attribute_05=>'PLAIN'
,p_link_target=>'f?p=&APP_ID.:940:&SESSION.::&DEBUG.:940:G_TODAY:&TODAY.'
,p_link_text=>'&COUNT_EVENTS.'
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
 p_id=>wwv_flow_api.id(11141671632125828)
,p_name=>'COUNT_SUCCEEDED'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COUNT_SUCCEEDED'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Succeeded'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>140
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(12110720899376306)
,p_use_group_for=>'BOTH'
,p_attribute_02=>'VALUE'
,p_attribute_05=>'PLAIN'
,p_link_target=>'f?p=&APP_ID.:905:&SESSION.::&DEBUG.:905:G_TODAY:&TODAY.'
,p_link_text=>'&COUNT_SUCCEEDED.'
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
 p_id=>wwv_flow_api.id(11141710932125829)
,p_name=>'COUNT_FAILED'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COUNT_FAILED'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Failed'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>150
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(12110720899376306)
,p_use_group_for=>'BOTH'
,p_attribute_02=>'VALUE'
,p_attribute_05=>'PLAIN'
,p_link_target=>'f?p=&APP_ID.:905:&SESSION.::&DEBUG.::P905_JOB_STATUS:FAILED'
,p_link_text=>'&COUNT_FAILED.'
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
 p_id=>wwv_flow_api.id(11141856254125830)
,p_name=>'ACTION'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ACTION'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_LINK'
,p_heading=>'Action'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>160
,p_value_alignment=>'CENTER'
,p_link_target=>'f?p=&APP_ID.:900:&SESSION.::&DEBUG.::P900_DELETE:&TODAY.'
,p_link_text=>'&ACTION.'
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
,p_escape_on_http_output=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(11233365955343632)
,p_name=>'WEEK'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'WEEK'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Week'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>10
,p_value_alignment=>'LEFT'
,p_attribute_02=>'VALUE'
,p_attribute_05=>'PLAIN'
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
 p_id=>wwv_flow_api.id(11140343617125815)
,p_internal_uid=>11140343617125815
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
 p_id=>wwv_flow_api.id(11174233547911965)
,p_interactive_grid_id=>wwv_flow_api.id(11140343617125815)
,p_static_id=>'111743'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_rows_per_page=>20
,p_show_row_number=>false
,p_settings_area_expanded=>false
);
wwv_flow_api.create_ig_report_view(
 p_id=>wwv_flow_api.id(11174452530911965)
,p_report_id=>wwv_flow_api.id(11174233547911965)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(5100464011109)
,p_view_id=>wwv_flow_api.id(11174452530911965)
,p_display_seq=>15
,p_column_id=>wwv_flow_api.id(11233365955343632)
,p_is_visible=>false
,p_is_frozen=>false
,p_sort_order=>1
,p_break_order=>5
,p_break_is_enabled=>true
,p_break_sort_direction=>'ASC'
,p_break_sort_nulls=>'LAST'
,p_sort_direction=>'DESC'
,p_sort_nulls=>'FIRST'
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(11174972156911968)
,p_view_id=>wwv_flow_api.id(11174452530911965)
,p_display_seq=>0
,p_column_id=>wwv_flow_api.id(11140416911125816)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>160
,p_sort_order=>2
,p_sort_direction=>'DESC'
,p_sort_nulls=>'LAST'
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(11175876844911972)
,p_view_id=>wwv_flow_api.id(11174452530911965)
,p_display_seq=>1
,p_column_id=>wwv_flow_api.id(11140522453125817)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(11176719358911977)
,p_view_id=>wwv_flow_api.id(11174452530911965)
,p_display_seq=>2
,p_column_id=>wwv_flow_api.id(11140648716125818)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(11177684250911981)
,p_view_id=>wwv_flow_api.id(11174452530911965)
,p_display_seq=>3
,p_column_id=>wwv_flow_api.id(11140735129125819)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(11178591371911983)
,p_view_id=>wwv_flow_api.id(11174452530911965)
,p_display_seq=>4
,p_column_id=>wwv_flow_api.id(11140855007125820)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(11179455419911986)
,p_view_id=>wwv_flow_api.id(11174452530911965)
,p_display_seq=>5
,p_column_id=>wwv_flow_api.id(11140924785125821)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(11180366086911988)
,p_view_id=>wwv_flow_api.id(11174452530911965)
,p_display_seq=>6
,p_column_id=>wwv_flow_api.id(11141043056125822)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(11181243266911990)
,p_view_id=>wwv_flow_api.id(11174452530911965)
,p_display_seq=>7
,p_column_id=>wwv_flow_api.id(11141108243125823)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(11182016842911992)
,p_view_id=>wwv_flow_api.id(11174452530911965)
,p_display_seq=>8
,p_column_id=>wwv_flow_api.id(11141298840125824)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(11182945521911994)
,p_view_id=>wwv_flow_api.id(11174452530911965)
,p_display_seq=>9
,p_column_id=>wwv_flow_api.id(11141332158125825)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(11183897825911996)
,p_view_id=>wwv_flow_api.id(11174452530911965)
,p_display_seq=>10
,p_column_id=>wwv_flow_api.id(11141455989125826)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(11184713076911999)
,p_view_id=>wwv_flow_api.id(11174452530911965)
,p_display_seq=>11
,p_column_id=>wwv_flow_api.id(11141544517125827)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(11185688532912001)
,p_view_id=>wwv_flow_api.id(11174452530911965)
,p_display_seq=>12
,p_column_id=>wwv_flow_api.id(11141671632125828)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(11186545433912003)
,p_view_id=>wwv_flow_api.id(11174452530911965)
,p_display_seq=>13
,p_column_id=>wwv_flow_api.id(11141710932125829)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(11187412098912005)
,p_view_id=>wwv_flow_api.id(11174452530911965)
,p_display_seq=>14
,p_column_id=>wwv_flow_api.id(11141856254125830)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11231927369343618)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(9263989035429040)
,p_button_name=>'PURGE_OLD'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(9144574670569995)
,p_button_image_alt=>'Purge Old'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:900:&SESSION.::&DEBUG.::P900_PURGE:Y'
,p_icon_css_classes=>'fa-trash-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11233118896343630)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(9263989035429040)
,p_button_name=>'SHRINK'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(9144574670569995)
,p_button_image_alt=>'Shrink'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:900:&SESSION.::&DEBUG.::P900_SHRINK:Y'
,p_icon_css_classes=>'fa-scissors'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11141932052125831)
,p_name=>'P900_DELETE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(9263989035429040)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11232135785343620)
,p_name=>'P900_PURGE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(9263989035429040)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11232933536343628)
,p_name=>'P900_SHRINK'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(9263989035429040)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(11232067387343619)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PURGE_OLD'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'app.purge_logs();',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P900_PURGE'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(11232269699343621)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PURGE_DAY'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'app.purge_logs(app.get_date(:P900_DELETE));',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P900_DELETE'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(11233067937343629)
,p_process_sequence=>30
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SHRINK'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'app.log_module(''SHRINK'');',
'--',
'EXECUTE IMMEDIATE ''ALTER TABLE #OWNER#.logs ENABLE ROW MOVEMENT'';',
'EXECUTE IMMEDIATE ''ALTER TABLE #OWNER#.logs SHRINK SPACE'';',
'EXECUTE IMMEDIATE ''ALTER TABLE #OWNER#.logs DISABLE ROW MOVEMENT'';',
'--',
'DBMS_STATS.GATHER_TABLE_STATS(''#OWNER#'', ''LOGS'');',
'EXECUTE IMMEDIATE ''ANALYZE TABLE #OWNER#.logs COMPUTE STATISTICS FOR TABLE'';',
'--',
'EXECUTE IMMEDIATE ''ALTER TABLE #OWNER#.sessions ENABLE ROW MOVEMENT'';',
'EXECUTE IMMEDIATE ''ALTER TABLE #OWNER#.sessions SHRINK SPACE'';',
'EXECUTE IMMEDIATE ''ALTER TABLE #OWNER#.sessions DISABLE ROW MOVEMENT'';',
'--',
'DBMS_STATS.GATHER_TABLE_STATS(''#OWNER#'', ''SESSIONS'');',
'EXECUTE IMMEDIATE ''ANALYZE TABLE #OWNER#.sessions COMPUTE STATISTICS FOR TABLE'';',
'--',
'app.log_success();',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P900_SHRINK'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
);
wwv_flow_api.component_end;
end;
/
