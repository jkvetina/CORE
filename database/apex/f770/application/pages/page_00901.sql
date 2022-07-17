prompt --application/pages/page_00901
begin
--   Manifest
--     PAGE: 00901
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.2'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_imp_page.create_page(
 p_id=>901
,p_user_interface_id=>wwv_flow_imp.id(9169746885570061)
,p_name=>'#fa-bug &PAGE_NAME.'
,p_alias=>'LOGS'
,p_step_title=>'&PAGE_NAME.'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_imp.id(9240371448352386)
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(9556407311505078)
,p_page_component_map=>'21'
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220101000000'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9262174270429022)
,p_plug_name=>'Logs [GRID]'
,p_region_name=>'LOGS'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(9078290074569925)
,p_plug_display_sequence=>20
,p_query_type=>'TABLE'
,p_query_table=>'LOGS_OVERVIEW'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IG'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Logs [GRID]'
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
,p_plug_header=>'&P901_FILTERS_LOGS!RAW.'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(10429077315245706)
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
,p_link_target=>'f?p=&APP_ID.:902:&SESSION.::&DEBUG.:902:P902_LOG_ID:&LOG_ID.'
,p_link_text=>'&LOG_ID.'
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(10429114504245707)
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(10429255659245708)
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(10429351012245709)
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
,p_link_target=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.::P901_PAGE_ID:&PAGE_ID.'
,p_link_text=>'&PAGE_ID.'
,p_link_attributes=>'title="&PAGE_TITLE."'
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(10429415169245710)
,p_name=>'USER_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'USER_ID'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'User Id'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>60
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>30
,p_link_target=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.::P901_USER_ID:&USER_ID.'
,p_link_text=>'&USER_ID.'
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(10429544565245711)
,p_name=>'FLAG'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FLAG'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Flag'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>70
,p_value_alignment=>'CENTER'
,p_attribute_02=>'VALUE'
,p_attribute_05=>'PLAIN'
,p_link_target=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.::P901_FLAG:&FLAG.'
,p_link_text=>'&FLAG.'
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(10429636377245712)
,p_name=>'ACTION_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ACTION_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Action Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>80
,p_value_alignment=>'LEFT'
,p_attribute_02=>'VALUE'
,p_attribute_05=>'PLAIN'
,p_link_target=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.::P901_ACTION_NAME:&ACTION_NAME.'
,p_link_text=>'&ACTION_NAME.'
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(10429753489245713)
,p_name=>'MODULE_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MODULE_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Module Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>90
,p_value_alignment=>'LEFT'
,p_attribute_02=>'VALUE'
,p_attribute_05=>'PLAIN'
,p_link_target=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.::P901_MODULE_NAME:&MODULE_NAME.'
,p_link_text=>'&MODULE_NAME.'
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(10429891589245714)
,p_name=>'MODULE_LINE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MODULE_LINE'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Line'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>100
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(10429936306245715)
,p_name=>'MODULE_TIMER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MODULE_TIMER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Module Timer'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>110
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(10430054006245716)
,p_name=>'ARGUMENTS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ARGUMENTS'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Arguments'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>120
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
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(10430142300245717)
,p_name=>'PAYLOAD'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PAYLOAD'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Payload'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>130
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
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(10430286386245718)
,p_name=>'SESSION_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SESSION_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Session Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>140
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_link_target=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.::P901_SESSION_ID:&SESSION_ID.'
,p_link_text=>'&SESSION_ID.'
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(10430375710245719)
,p_name=>'CREATED_AT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_AT'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_JET'
,p_heading=>'Created At'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>150
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(23155108968829514)
,p_name=>'PAGE_TITLE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PAGE_TITLE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>50
,p_attribute_01=>'Y'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(10428992326245705)
,p_internal_uid=>10428992326245705
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
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(10443863387249321)
,p_interactive_grid_id=>wwv_flow_imp.id(10428992326245705)
,p_static_id=>'104439'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_rows_per_page=>100
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(10444067309249321)
,p_report_id=>wwv_flow_imp.id(10443863387249321)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(10444526429249326)
,p_view_id=>wwv_flow_imp.id(10444067309249321)
,p_display_seq=>0
,p_column_id=>wwv_flow_imp.id(10429077315245706)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>100
,p_sort_order=>1
,p_sort_direction=>'DESC'
,p_sort_nulls=>'FIRST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(10445429927249329)
,p_view_id=>wwv_flow_imp.id(10444067309249321)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(10429114504245707)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>100
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(10446320177249331)
,p_view_id=>wwv_flow_imp.id(10444067309249321)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(10429255659245708)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(10447201765249332)
,p_view_id=>wwv_flow_imp.id(10444067309249321)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(10429351012245709)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>80
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(10448120821249334)
,p_view_id=>wwv_flow_imp.id(10444067309249321)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(10429415169245710)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>200
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(10449039667249336)
,p_view_id=>wwv_flow_imp.id(10444067309249321)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(10429544565245711)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>60
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(10449990108249337)
,p_view_id=>wwv_flow_imp.id(10444067309249321)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(10429636377245712)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>360
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(10450807758249339)
,p_view_id=>wwv_flow_imp.id(10444067309249321)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(10429753489245713)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>260
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(10451757117249341)
,p_view_id=>wwv_flow_imp.id(10444067309249321)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(10429891589245714)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>80
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(10452657883249343)
,p_view_id=>wwv_flow_imp.id(10444067309249321)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(10429936306245715)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>120
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(10453506992249344)
,p_view_id=>wwv_flow_imp.id(10444067309249321)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(10430054006245716)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(10454453294249346)
,p_view_id=>wwv_flow_imp.id(10444067309249321)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(10430142300245717)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(10455369654249349)
,p_view_id=>wwv_flow_imp.id(10444067309249321)
,p_display_seq=>12
,p_column_id=>wwv_flow_imp.id(10430286386245718)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>160
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(10456273605249351)
,p_view_id=>wwv_flow_imp.id(10444067309249321)
,p_display_seq=>13
,p_column_id=>wwv_flow_imp.id(10430375710245719)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>100
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(23202203325930432)
,p_view_id=>wwv_flow_imp.id(10444067309249321)
,p_display_seq=>14
,p_column_id=>wwv_flow_imp.id(23155108968829514)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9263852973429039)
,p_plug_name=>'Logs'
,p_icon_css_classes=>'fa-bug'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(9070356145569920)
,p_plug_display_sequence=>10
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(10602598226436337)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(9263852973429039)
,p_button_name=>'TODAY_LEFT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(9144574670569995)
,p_button_image_alt=>'Previous Day'
,p_button_redirect_url=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.::G_TODAY:&G_YESTERDAY.'
,p_icon_css_classes=>'fa-arrow-left'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(10602802694437928)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_imp.id(9263852973429039)
,p_button_name=>'TODAY_RIGHT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(9144574670569995)
,p_button_image_alt=>'Next Day'
,p_button_redirect_url=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.::G_TODAY:&G_TOMORROW.'
,p_icon_css_classes=>'fa-arrow-right'
,p_grid_new_row=>'N'
,p_grid_new_column=>'N'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(10603120767438960)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_imp.id(9263852973429039)
,p_button_name=>'TODAY_SET'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(9144574670569995)
,p_button_image_alt=>'Set Current Date'
,p_button_redirect_url=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.::G_TODAY:'
,p_button_condition=>':G_TODAY != app.get_date()'
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
,p_icon_css_classes=>'fa-calendar-o'
,p_grid_new_row=>'N'
,p_grid_new_column=>'N'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(10613038195500286)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(9263852973429039)
,p_button_name=>'REFRESH_ALL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(9144574670569995)
,p_button_image_alt=>'Refresh'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.:901::'
,p_button_condition=>'P901_RECENT_LOG_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(21746924778497834)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(9263852973429039)
,p_button_name=>'CLOSE_RECENT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(9144574670569995)
,p_button_image_alt=>'Close Recent'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.:901::'
,p_button_condition=>'P901_RECENT_LOG_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-times'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(10579758623928824)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(9263852973429039)
,p_button_name=>'SHOW_RECENT_ONLY'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(9144574670569995)
,p_button_image_alt=>'Recent Only'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.::P901_RECENT_LOG_ID:&P901_CURR_LOG_ID.'
,p_button_condition=>'P901_IS_TODAY'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-level-up'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(12336038865960929)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(9263852973429039)
,p_button_name=>'REFRESH_RECENT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(9144574670569995)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Refresh'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:901:&SESSION.::&DEBUG.:::'
,p_button_condition=>'P901_RECENT_LOG_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(10578593460928812)
,p_name=>'P901_USER_ID'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_imp.id(9263852973429039)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(10578619006928813)
,p_name=>'P901_FLAG'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(9263852973429039)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(10578734947928814)
,p_name=>'P901_LOG_ID'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(9263852973429039)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(10578870285928815)
,p_name=>'P901_PAGE_ID'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(9263852973429039)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(10578916820928816)
,p_name=>'P901_SESSION_ID'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_imp.id(9263852973429039)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(10579635538928823)
,p_name=>'P901_RECENT_LOG_ID'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(9263852973429039)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(10579847515928825)
,p_name=>'P901_CURR_LOG_ID'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(9263852973429039)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(10602295032432920)
,p_name=>'P901_TODAY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9263852973429039)
,p_use_cache_before_default=>'NO'
,p_prompt=>'&G_TODAY_LABEL.'
,p_format_mask=>'&FORMAT_DATE.'
,p_source=>'G_TODAY'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_DATE_PICKER_JET'
,p_cSize=>30
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(9142775823569991)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'POPUP'
,p_attribute_03=>'NONE'
,p_attribute_06=>'NONE'
,p_attribute_09=>'N'
,p_attribute_11=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11851187854169102)
,p_name=>'P901_IS_TODAY'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(9263852973429039)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14219165267378939)
,p_name=>'P901_MODULE_NAME'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(9263852973429039)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(21746836282497833)
,p_name=>'P901_ACTION_NAME'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(9263852973429039)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(23306067035761016)
,p_name=>'P901_FILTERS_LOGS'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_imp.id(9263852973429039)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(10634979944820464)
,p_name=>'TODAY_CHANGED'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P901_TODAY'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(10635393023820471)
,p_event_id=>wwv_flow_imp.id(10634979944820464)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(10581964232928846)
,p_process_sequence=>10
,p_process_point=>'BEFORE_BOX_BODY'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'INIT_CURR_LOG_ID'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- at the last possible moment before rendering page',
'IF app.get_date_item(''G_TODAY'') = TRUNC(SYSDATE) THEN',
'    SELECT MAX(l.log_id) INTO :P901_CURR_LOG_ID',
'    FROM logs l',
'    WHERE l.created_at  >= SYSDATE - 1/24/60',
'        AND l.app_id    = app.get_app_id();',
'END IF;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(10581797263928844)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'INIT_DEFAULTS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P901_IS_TODAY := CASE WHEN NVL(app.get_date_item(''G_TODAY''), TRUNC(SYSDATE)) = TRUNC(SYSDATE) THEN ''Y'' END;',
'',
'-- init recent log',
'IF :P901_IS_TODAY IS NULL THEN',
'    :P901_CURR_LOG_ID       := NULL;',
'    :P901_RECENT_LOG_ID     := NULL;',
'END IF;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_imp.component_end;
end;
/
