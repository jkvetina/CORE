prompt --application/deployment/definition
begin
--   Manifest
--     INSTALL: 770
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2021.04.15'
,p_release=>'21.1.7'
,p_default_workspace_id=>9014660246496943
,p_default_application_id=>770
,p_default_id_offset=>0
,p_default_owner=>'CORE'
);
wwv_flow_api.create_install(
 p_id=>wwv_flow_api.id(12958699824624058)
,p_required_free_kb=>1000
,p_required_sys_privs=>'CREATE PROCEDURE:CREATE SEQUENCE:CREATE TABLE:CREATE TRIGGER:CREATE VIEW'
);
wwv_flow_api.component_end;
end;
/
