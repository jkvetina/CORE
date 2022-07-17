prompt --application/shared_components/user_interface/themes
begin
--   Manifest
--     THEME: 777
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.2'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>777
,p_default_id_offset=>26909373241738856
,p_default_owner=>'CORE'
);
wwv_flow_imp_shared.create_theme(
 p_id=>wwv_flow_imp.id(19896217911808550)
,p_theme_id=>777
,p_theme_name=>'Universal Theme'
,p_theme_internal_name=>'UNIVERSAL_THEME'
,p_ui_type_name=>'DESKTOP'
,p_navigation_type=>'L'
,p_nav_bar_type=>'LIST'
,p_reference_id=>9148097615570028
,p_is_locked=>false
,p_default_page_template=>wwv_flow_imp.id(19789210659808496)
,p_default_dialog_template=>wwv_flow_imp.id(19782470775808493)
,p_error_template=>wwv_flow_imp.id(19774591096808490)
,p_printer_friendly_template=>wwv_flow_imp.id(19786762067808495)
,p_breadcrumb_display_point=>'REGION_POSITION_01'
,p_sidebar_display_point=>'REGION_POSITION_02'
,p_login_template=>wwv_flow_imp.id(19774591096808490)
,p_default_button_template=>wwv_flow_imp.id(19893458126808548)
,p_default_region_template=>wwv_flow_imp.id(19827995985808513)
,p_default_chart_template=>wwv_flow_imp.id(19827995985808513)
,p_default_form_template=>wwv_flow_imp.id(19827995985808513)
,p_default_reportr_template=>wwv_flow_imp.id(19827995985808513)
,p_default_tabform_template=>wwv_flow_imp.id(19827995985808513)
,p_default_wizard_template=>wwv_flow_imp.id(19827995985808513)
,p_default_menur_template=>wwv_flow_imp.id(19837377456808517)
,p_default_listr_template=>wwv_flow_imp.id(19827995985808513)
,p_default_irr_template=>wwv_flow_imp.id(19826069766808512)
,p_default_report_template=>wwv_flow_imp.id(19858077451808528)
,p_default_label_template=>wwv_flow_imp.id(19890920135808545)
,p_default_menu_template=>wwv_flow_imp.id(19894861674808548)
,p_default_calendar_template=>wwv_flow_imp.id(19894976780808549)
,p_default_list_template=>wwv_flow_imp.id(19874494638808536)
,p_default_nav_list_template=>wwv_flow_imp.id(19886655000808543)
,p_default_top_nav_list_temp=>wwv_flow_imp.id(19880807290808540)
,p_default_side_nav_list_temp=>wwv_flow_imp.id(19880807290808540)
,p_default_nav_list_position=>'SIDE'
,p_default_dialogbtnr_template=>wwv_flow_imp.id(19797937616808500)
,p_default_dialogr_template=>wwv_flow_imp.id(19796918320808499)
,p_default_option_label=>wwv_flow_imp.id(19890920135808545)
,p_default_required_label=>wwv_flow_imp.id(19892204653808546)
,p_default_page_transition=>'NONE'
,p_default_popup_transition=>'NONE'
,p_default_navbar_list_template=>wwv_flow_imp.id(19880485036808539)
,p_file_prefix => nvl(wwv_flow_application_install.get_static_theme_file_prefix(777),'#IMAGE_PREFIX#themes/theme_42/21.1/')
,p_files_version=>64
,p_icon_library=>'FONTAPEX'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#IMAGE_PREFIX#libraries/apex/#MIN_DIRECTORY#widget.stickyWidget#MIN#.js?v=#APEX_VERSION#',
'#THEME_IMAGES#js/theme42#MIN#.js?v=#APEX_VERSION#'))
,p_css_file_urls=>'#THEME_IMAGES#css/Core#MIN#.css?v=#APEX_VERSION#'
);
wwv_flow_imp.component_end;
end;
/
