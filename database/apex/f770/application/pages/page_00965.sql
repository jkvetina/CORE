prompt --application/pages/page_00965
begin
--   Manifest
--     PAGE: 00965
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
 p_id=>965
,p_user_interface_id=>wwv_flow_api.id(9169746885570061)
,p_name=>'#fa-list-ol &PAGE_NAME.'
,p_alias=>'SEQUENCES'
,p_step_title=>'&PAGE_NAME.'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_api.id(15841923064543077)
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_api.id(9556407311505078)
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220226152512'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(15126384113615746)
,p_plug_name=>'Sequences'
,p_icon_css_classes=>'fa-list-ol'
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
 p_id=>wwv_flow_api.id(24137167894306105)
,p_plug_name=>'Sequences [GRID]'
,p_region_name=>'SEQUENCES'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9078290074569925)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'OBJ_SEQUENCES'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IG'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Sequences [GRID]'
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
 p_id=>wwv_flow_api.id(24138341066306117)
,p_heading=>'Sequence Info'
);
wwv_flow_api.create_region_column_group(
 p_id=>wwv_flow_api.id(24138466780306118)
,p_heading=>'Sizing'
);
wwv_flow_api.create_region_column_group(
 p_id=>wwv_flow_api.id(24138568064306119)
,p_heading=>'Flags'
);
wwv_flow_api.create_region_column_group(
 p_id=>wwv_flow_api.id(24138670091306120)
,p_heading=>'Related Objects'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(24137355340306107)
,p_name=>'SEQUENCE_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SEQUENCE_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Sequence Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>10
,p_value_alignment=>'LEFT'
,p_group_id=>wwv_flow_api.id(24138341066306117)
,p_use_group_for=>'BOTH'
,p_attribute_05=>'BOTH'
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
 p_id=>wwv_flow_api.id(24137407726306108)
,p_name=>'MIN_VALUE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MIN_VALUE'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Min Value'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>40
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(24138466780306118)
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
 p_id=>wwv_flow_api.id(24137538309306109)
,p_name=>'MAX_VALUE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MAX_VALUE'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Max Value'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>50
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(24138466780306118)
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
 p_id=>wwv_flow_api.id(24137643815306110)
,p_name=>'INCREMENT_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'INCREMENT_BY'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Increment'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>60
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(24138466780306118)
,p_use_group_for=>'BOTH'
,p_attribute_03=>'right'
,p_is_required=>true
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
 p_id=>wwv_flow_api.id(24137785078306111)
,p_name=>'CYCLE_FLAG'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CYCLE_FLAG'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SINGLE_CHECKBOX'
,p_heading=>'Cycle'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>70
,p_value_alignment=>'CENTER'
,p_group_id=>wwv_flow_api.id(24138568064306119)
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
 p_id=>wwv_flow_api.id(24137858203306112)
,p_name=>'ORDER_FLAG'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ORDER_FLAG'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SINGLE_CHECKBOX'
,p_heading=>'Order'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>80
,p_value_alignment=>'CENTER'
,p_group_id=>wwv_flow_api.id(24138568064306119)
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
 p_id=>wwv_flow_api.id(24137901961306113)
,p_name=>'CACHE_SIZE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CACHE_SIZE'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Cache Size'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>30
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(24138341066306117)
,p_use_group_for=>'BOTH'
,p_attribute_03=>'right'
,p_is_required=>true
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
 p_id=>wwv_flow_api.id(24138018192306114)
,p_name=>'LAST_NUMBER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LAST_NUMBER'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Last Number'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>20
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_api.id(24138341066306117)
,p_use_group_for=>'BOTH'
,p_attribute_03=>'right'
,p_is_required=>true
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
 p_id=>wwv_flow_api.id(24138182406306115)
,p_name=>'TABLE_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TABLE_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_LINK'
,p_heading=>'Table Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>90
,p_value_alignment=>'LEFT'
,p_group_id=>wwv_flow_api.id(24138670091306120)
,p_use_group_for=>'BOTH'
,p_link_target=>'f?p=&APP_ID.:951:&SESSION.::&DEBUG.:951:P951_TABLE_NAME:&TABLE_NAME.'
,p_link_text=>'&TABLE_NAME.'
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
 p_id=>wwv_flow_api.id(24138250856306116)
,p_name=>'COLUMN_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COLUMN_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_LINK'
,p_heading=>'Column Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>100
,p_value_alignment=>'LEFT'
,p_group_id=>wwv_flow_api.id(24138670091306120)
,p_use_group_for=>'BOTH'
,p_link_target=>'f?p=&APP_ID.:951:&SESSION.::&DEBUG.:951:P951_SEARCH_COLUMNS:&COLUMN_NAME.'
,p_link_text=>'&COLUMN_NAME.'
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
wwv_flow_api.create_interactive_grid(
 p_id=>wwv_flow_api.id(24137261996306106)
,p_internal_uid=>24137261996306106
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
);
wwv_flow_api.create_ig_report(
 p_id=>wwv_flow_api.id(24179780156999189)
,p_interactive_grid_id=>wwv_flow_api.id(24137261996306106)
,p_static_id=>'241798'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_rows_per_page=>100
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_api.create_ig_report_view(
 p_id=>wwv_flow_api.id(24179968388999189)
,p_report_id=>wwv_flow_api.id(24179780156999189)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(24180482343999192)
,p_view_id=>wwv_flow_api.id(24179968388999189)
,p_display_seq=>0
,p_column_id=>wwv_flow_api.id(24137355340306107)
,p_is_visible=>true
,p_is_frozen=>false
,p_sort_order=>1
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(24181359001999195)
,p_view_id=>wwv_flow_api.id(24179968388999189)
,p_display_seq=>3
,p_column_id=>wwv_flow_api.id(24137407726306108)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>90
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(24182245090999198)
,p_view_id=>wwv_flow_api.id(24179968388999189)
,p_display_seq=>4
,p_column_id=>wwv_flow_api.id(24137538309306109)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>300
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(24183191652999201)
,p_view_id=>wwv_flow_api.id(24179968388999189)
,p_display_seq=>5
,p_column_id=>wwv_flow_api.id(24137643815306110)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>80
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(24184018093999203)
,p_view_id=>wwv_flow_api.id(24179968388999189)
,p_display_seq=>6
,p_column_id=>wwv_flow_api.id(24137785078306111)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>70
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(24184934801999206)
,p_view_id=>wwv_flow_api.id(24179968388999189)
,p_display_seq=>7
,p_column_id=>wwv_flow_api.id(24137858203306112)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>70
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(24185862596999209)
,p_view_id=>wwv_flow_api.id(24179968388999189)
,p_display_seq=>2
,p_column_id=>wwv_flow_api.id(24137901961306113)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>90
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(24186782859999211)
,p_view_id=>wwv_flow_api.id(24179968388999189)
,p_display_seq=>1
,p_column_id=>wwv_flow_api.id(24138018192306114)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>160
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(24187685484999213)
,p_view_id=>wwv_flow_api.id(24179968388999189)
,p_display_seq=>8
,p_column_id=>wwv_flow_api.id(24138182406306115)
,p_is_visible=>true
,p_is_frozen=>false
,p_sort_order=>2
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(24188575334999216)
,p_view_id=>wwv_flow_api.id(24179968388999189)
,p_display_seq=>9
,p_column_id=>wwv_flow_api.id(24138250856306116)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(24238303000066496)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(15126384113615746)
,p_button_name=>'REFRESH'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(9144574670569995)
,p_button_image_alt=>'Refresh'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:965:&SESSION.::&DEBUG.:965::'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.component_end;
end;
/