prompt --application/deployment/install/install_install_sequences
begin
--   Manifest
--     INSTALL: INSTALL-INSTALL_SEQUENCES
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2021.04.15'
,p_release=>'21.1.7'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_api.create_install_script(
 p_id=>wwv_flow_api.id(20451203514326110)
,p_install_id=>wwv_flow_api.id(12958699824624058)
,p_name=>'INSTALL_SEQUENCES'
,p_sequence=>30
,p_script_type=>'INSTALL'
,p_script_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
' CREATE SEQUENCE  "LOG_ID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21919 CACHE 100 NOORDER  NOCYCLE  NOKEEP  GLOBAL ;',
'',
''))
);
wwv_flow_api.create_install_object(
 p_id=>wwv_flow_api.id(20451386683326110)
,p_script_id=>wwv_flow_api.id(20451203514326110)
,p_object_owner=>'#OWNER#'
,p_object_type=>'SEQUENCE'
,p_object_name=>'LOG_ID'
,p_last_updated_by=>'DEV'
,p_last_updated_on=>to_date('20220123180322','YYYYMMDDHH24MISS')
,p_created_by=>'DEV'
,p_created_on=>to_date('20220123180322','YYYYMMDDHH24MISS')
);
wwv_flow_api.component_end;
end;
/
