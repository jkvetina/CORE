prompt --application/pages/page_00996
begin
--   Manifest
--     PAGE: 00996
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.4'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_imp_page.create_page(
 p_id=>996
,p_user_interface_id=>wwv_flow_imp.id(9169746885570061)
,p_name=>'#fa-support Support Users'
,p_alias=>'SUPPORT-USERS'
,p_step_title=>'Support Users'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_imp.id(9240371448352386)
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(9823062898204869)  -- IS_ADMINISTRATOR
,p_page_component_map=>'21'
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20220101000000'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(72639996065039745)
,p_plug_name=>'TABS'
,p_region_name=>'TABS'
,p_region_template_options=>'#DEFAULT#:js-useLocalStorage:t-TabsRegion-mod--simple'
,p_plug_template=>wwv_flow_imp.id(9086964183569930)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(72640436135039749)
,p_plug_name=>'Support Users'
,p_parent_plug_id=>wwv_flow_imp.id(72639996065039745)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(9049155795569902)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(72640103383039746)
,p_plug_name=>'Support Users'
,p_parent_plug_id=>wwv_flow_imp.id(72640436135039749)
,p_icon_css_classes=>'fa-support'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(9070356145569920)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(72640270226039747)
,p_plug_name=>'Support Users [GRID]'
,p_parent_plug_id=>wwv_flow_imp.id(72640436135039749)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(9078290074569925)
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'TABLE'
,p_query_table=>'USER_MESSAGES_CHATS'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IG'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Support Users [GRID]'
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
wwv_flow_imp_page.create_region_column_group(
 p_id=>wwv_flow_imp.id(36251077826846138)
,p_heading=>'Actions'
);
wwv_flow_imp_page.create_region_column_group(
 p_id=>wwv_flow_imp.id(36251127863846139)
,p_heading=>'Statistics'
);
wwv_flow_imp_page.create_region_column_group(
 p_id=>wwv_flow_imp.id(36251229347846140)
,p_heading=>'Identification'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(72640720326039752)
,p_name=>'APP_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APP_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_LINK'
,p_heading=>'App Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>10
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_imp.id(36251229347846140)
,p_use_group_for=>'BOTH'
,p_link_target=>'f?p=&APP_ID.:925:&SESSION.::&DEBUG.:925:P925_APP_ID:&APP_ID.'
,p_link_text=>'&APP_ID.'
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
,p_escape_on_http_output=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(72640808275039753)
,p_name=>'USER_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'USER_ID'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_LINK'
,p_heading=>'User Id'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>20
,p_value_alignment=>'LEFT'
,p_group_id=>wwv_flow_imp.id(36251229347846140)
,p_use_group_for=>'BOTH'
,p_link_target=>'f?p=&APP_ID.:920:&SESSION.::&DEBUG.:920:P920_USER_ID:&USER_ID.'
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
,p_escape_on_http_output=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(72640950256039754)
,p_name=>'SESSION_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SESSION_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_LINK'
,p_heading=>'Session Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>30
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_imp.id(36251229347846140)
,p_use_group_for=>'BOTH'
,p_link_target=>'f?p=&APP_ID.:915:&SESSION.::&DEBUG.:915:P915_SESSION_ID:&SESSION_ID.'
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
,p_escape_on_http_output=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(72641011026039755)
,p_name=>'COUNT_MESSAGES'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COUNT_MESSAGES'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Messages'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>40
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_imp.id(36251127863846139)
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(72641151250039756)
,p_name=>'COUNT_USERS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COUNT_USERS'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Users'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>50
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_imp.id(36251127863846139)
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(72641188926039757)
,p_name=>'START_AT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'START_AT'
,p_data_type=>'DATE'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_JET'
,p_heading=>'Start At'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>60
,p_value_alignment=>'CENTER'
,p_group_id=>wwv_flow_imp.id(36251127863846139)
,p_use_group_for=>'BOTH'
,p_attribute_01=>'N'
,p_attribute_02=>'POPUP'
,p_attribute_03=>'NONE'
,p_attribute_06=>'NONE'
,p_attribute_09=>'N'
,p_attribute_11=>'Y'
,p_format_mask=>'&FORMAT_DATE_TIME.'
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(72641345825039758)
,p_name=>'END_AT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'END_AT'
,p_data_type=>'DATE'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_JET'
,p_heading=>'End At'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>70
,p_value_alignment=>'CENTER'
,p_group_id=>wwv_flow_imp.id(36251127863846139)
,p_use_group_for=>'BOTH'
,p_attribute_01=>'N'
,p_attribute_02=>'POPUP'
,p_attribute_03=>'NONE'
,p_attribute_06=>'NONE'
,p_attribute_09=>'N'
,p_attribute_11=>'Y'
,p_format_mask=>'&FORMAT_DATE_TIME.'
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(72641407864039759)
,p_name=>'ACTION_OPEN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ACTION_OPEN'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_LINK'
,p_heading=>'Open'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>80
,p_value_alignment=>'CENTER'
,p_group_id=>wwv_flow_imp.id(36251077826846138)
,p_use_group_for=>'BOTH'
,p_link_target=>'f?p=&APP_ID.:997:&SESSION.::&DEBUG.:997:P997_APP_ID,P997_USER_ID,P997_SESSION_ID:&APP_ID.,&USER_ID.,&SESSION_ID.'
,p_link_text=>'&ACTION_OPEN.'
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
,p_escape_on_http_output=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(72641538783039760)
,p_name=>'ACTION_CLOSE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ACTION_CLOSE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_LINK'
,p_heading=>'Close'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>90
,p_value_alignment=>'CENTER'
,p_group_id=>wwv_flow_imp.id(36251077826846138)
,p_use_group_for=>'BOTH'
,p_link_target=>'f?p=&APP_ID.:998:&SESSION.::&DEBUG.:998::'
,p_link_text=>'&ACTION_CLOSE.'
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
,p_escape_on_http_output=>true
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(72640601744039751)
,p_internal_uid=>72640601744039751
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
 p_id=>wwv_flow_imp.id(72670698332037790)
,p_interactive_grid_id=>wwv_flow_imp.id(72640601744039751)
,p_static_id=>'362798'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_rows_per_page=>20
,p_show_row_number=>false
,p_settings_area_expanded=>false
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(72670919595037791)
,p_report_id=>wwv_flow_imp.id(72670698332037790)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(72671431756037793)
,p_view_id=>wwv_flow_imp.id(72670919595037791)
,p_display_seq=>0
,p_column_id=>wwv_flow_imp.id(72640720326039752)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>100
,p_break_order=>5
,p_break_is_enabled=>true
,p_break_sort_direction=>'ASC'
,p_break_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(72672296243037796)
,p_view_id=>wwv_flow_imp.id(72670919595037791)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(72640808275039753)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(72673239217037798)
,p_view_id=>wwv_flow_imp.id(72670919595037791)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(72640950256039754)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>160
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(72674145725037800)
,p_view_id=>wwv_flow_imp.id(72670919595037791)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(72641011026039755)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>80
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(72675070041037802)
,p_view_id=>wwv_flow_imp.id(72670919595037791)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(72641151250039756)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>80
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(72675901545037804)
,p_view_id=>wwv_flow_imp.id(72670919595037791)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(72641188926039757)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>160
,p_sort_order=>2
,p_sort_direction=>'DESC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(72676827272037807)
,p_view_id=>wwv_flow_imp.id(72670919595037791)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(72641345825039758)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>160
,p_sort_order=>1
,p_sort_direction=>'DESC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(72685723022331240)
,p_view_id=>wwv_flow_imp.id(72670919595037791)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(72641407864039759)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>120
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(72686625959331246)
,p_view_id=>wwv_flow_imp.id(72670919595037791)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(72641538783039760)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>120
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(36415896299319854)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(72640103383039746)
,p_button_name=>'REFRESH'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(9144574670569995)
,p_button_image_alt=>'&BUTTON_REFRESH.'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:996:&SESSION.::&DEBUG.:996::'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_imp.component_end;
end;
/
