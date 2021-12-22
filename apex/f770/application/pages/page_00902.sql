prompt --application/pages/page_00902
begin
--   Manifest
--     PAGE: 00902
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
 p_id=>902
,p_user_interface_id=>wwv_flow_api.id(9169746885570061)
,p_name=>'#fa-user-secret Sessions'
,p_alias=>'SESSIONS'
,p_step_title=>'Sessions'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_api.id(9240371448352386)
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_api.id(9556407311505078)
,p_last_updated_by=>'DEV'
,p_last_upd_yyyymmddhh24miss=>'20211222211420'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(9264033779429041)
,p_plug_name=>'Sessions'
,p_icon_css_classes=>'fa-user-secret'
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
 p_id=>wwv_flow_api.id(9612532712237511)
,p_plug_name=>'Sessions'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9078290074569925)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'SESSIONS'
,p_query_where=>'app_id = app.get_app_id()'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Sessions'
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
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(9613668586237522)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y_OF_Z'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF:RTF:EMAIL'
,p_owner=>'DEV'
,p_internal_uid=>9613668586237522
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9613734324237523)
,p_db_column_name=>'APP_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'App Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9613892313237524)
,p_db_column_name=>'SESSION_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Session Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9613935810237525)
,p_db_column_name=>'USER_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'User Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9614024498237526)
,p_db_column_name=>'CREATED_AT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Created At'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9614123111237527)
,p_db_column_name=>'UPDATED_AT'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Updated At'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(9649923148450245)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'96500'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>20
,p_report_columns=>'APP_ID:SESSION_ID:USER_ID:CREATED_AT:UPDATED_AT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(9615572744237541)
,p_plug_name=>'Activity'
,p_region_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(9078290074569925)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'WITH t AS (',
'    SELECT',
'        NVL(d.user_id, LOWER(l.apex_user))  AS user_id,',
'        l.application_id,',
'        l.application_name,                 -- NULL for APEX Builder',
'        l.page_id,',
'        l.page_name,',
'        SUBSTR(l.page_view_type, 1, 1)      AS request_type,',
'        l.page_view_type,',
'        l.request_value,',
'        l.view_timestamp                    AS requested_at',
'    FROM apex_workspace_activity_log l',
'    JOIN apex_workspaces w',
'        ON w.workspace_id                   = l.workspace_id',
'    JOIN apex_applications a',
'        ON a.workspace                      = w.workspace',
'        AND a.application_id                = l.application_id',
'    LEFT JOIN (',
'        SELECT',
'            UPPER(d.user_name)              AS user_name,',
'            LOWER(d.email)                  AS user_id',
'        FROM apex_workspace_developers d',
'        WHERE d.is_application_developer    = ''Yes''',
'            AND d.account_locked            = ''No''',
'    ) d',
'        ON d.user_name                      = l.apex_user',
'    WHERE a.application_id                  = 770--NVL(NV(''APP_ID''), a.application_id)',
'        AND l.page_view_type                IN (''Rendering'', ''Processing'', ''Ajax'')',
'        AND l.apex_user                     NOT IN (''nobody'')',
'        AND l.view_timestamp                >= TRUNC(SYSDATE) - 1',
')',
'SELECT',
'    t.page_id,',
'    COUNT(*) AS visits,',
'    TRUNC(t.requested_at, ''MI'') AS requested_at',
'FROM t',
'GROUP BY t.page_id, TRUNC(t.requested_at, ''MI'');',
''))
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(9716231569455615)
,p_region_id=>wwv_flow_api.id(9615572744237541)
,p_chart_type=>'bubble'
,p_height=>'400'
,p_animation_on_display=>'none'
,p_animation_on_data_change=>'none'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_legend_rendered=>'off'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(9716320770455616)
,p_chart_id=>wwv_flow_api.id(9716231569455615)
,p_seq=>10
,p_name=>'MAIN'
,p_location=>'REGION_SOURCE'
,p_items_x_column_name=>'PAGE_ID'
,p_items_y_column_name=>'PAGE_ID'
,p_items_z_column_name=>'VISITS'
,p_items_label_column_name=>'REQUESTED_AT'
,p_line_style=>'solid'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_items_label_rendered=>false
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(9716421072455617)
,p_chart_id=>wwv_flow_api.id(9716231569455615)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(9716562813455618)
,p_chart_id=>wwv_flow_api.id(9716231569455615)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_type=>'decimal'
,p_decimal_places=>0
,p_format_scaling=>'none'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(9716171545455614)
,p_plug_name=>'Activity'
,p_icon_css_classes=>'fa-bar-chart'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(9070356145569920)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.component_end;
end;
/
