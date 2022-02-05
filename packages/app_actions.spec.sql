CREATE OR REPLACE PACKAGE app_actions AS

    /**
     * This package is part of the APP CORE project under MIT licence.
     * https://github.com/jkvetina/#core
     *
     * Copyright (c) Jan Kvetina, 2021
     *
     *                                                      (R)
     *                      ---                  ---
     *                    #@@@@@@              &@@@@@@
     *                    @@@@@@@@     .@      @@@@@@@@
     *          -----      @@@@@@    @@@@@@,   @@@@@@@      -----
     *       &@@@@@@@@@@@    @@@   &@@@@@@@@@.  @@@@   .@@@@@@@@@@@#
     *           @@@@@@@@@@@   @  @@@@@@@@@@@@@  @   @@@@@@@@@@@
     *             \@@@@@@@@@@   @@@@@@@@@@@@@@@   @@@@@@@@@@
     *               @@@@@@@@@   @@@@@@@@@@@@@@@  &@@@@@@@@
     *                 @@@@@@@(  @@@@@@@@@@@@@@@  @@@@@@@@
     *                  @@@@@@(  @@@@@@@@@@@@@@,  @@@@@@@
     *                  .@@@@@,   @@@@@@@@@@@@@   @@@@@@
     *                   @@@@@@  *@@@@@@@@@@@@@   @@@@@@
     *                   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.
     *                    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
     *                    @@@@@@@@@@@@@@@@@@@@@@@@@@@@
     *                     .@@@@@@@@@@@@@@@@@@@@@@@@@
     *                       .@@@@@@@@@@@@@@@@@@@@@
     *                            jankvetina.cz
     *                               -------
     *
     */

    -- ### Help functions
    --

    --
    -- Get link to proper object page
    --
    FUNCTION get_object_link (
        in_object_type          VARCHAR2    := NULL,
        in_object_name          VARCHAR2    := NULL
    )
    RETURN VARCHAR2;



    --
    -- Get HTML alement A
    --
    FUNCTION get_html_a (
        in_href                 VARCHAR2,
        in_name                 VARCHAR2,
        in_title                VARCHAR2    := NULL
    )
    RETURN VARCHAR2;



    --
    -- Create AUTH scheme in APEX
    --
    PROCEDURE create_auth_scheme (
        in_app_id           apex_application_authorization.application_id%TYPE,
        in_name             apex_application_authorization.authorization_scheme_name%TYPE
    );







    -- ### Navigation page
    --

    --
    -- Remove missing pages from NAVIGATION table
    --
    PROCEDURE nav_remove_pages (
        in_page_id              navigation.page_id%TYPE         := NULL
    );



    --
    -- Add new pages to NAVIGATION table
    --
    PROCEDURE nav_add_pages (
        in_page_id              navigation.page_id%TYPE         := NULL
    );



    --
    -- Auto update navigation (add missing pages, remove old records)
    --
    PROCEDURE nav_autoupdate;







    -- ### User Roles page
    --

    --
    --
    --
    PROCEDURE prep_user_roles_pivot (
        in_page_id              apex_application_pages.page_id%TYPE
    );



    --
    --
    --
    PROCEDURE save_user_roles (
        in_action       CHAR,
        in_c001         VARCHAR2 := NULL,
        in_c002         VARCHAR2 := NULL,
        in_c003         VARCHAR2 := NULL,
        in_c004         VARCHAR2 := NULL,
        in_c005         VARCHAR2 := NULL,
        in_c006         VARCHAR2 := NULL,
        in_c007         VARCHAR2 := NULL,
        in_c008         VARCHAR2 := NULL,
        in_c009         VARCHAR2 := NULL,
        in_c010         VARCHAR2 := NULL,
        in_c011         VARCHAR2 := NULL,
        in_c012         VARCHAR2 := NULL,
        in_c013         VARCHAR2 := NULL,
        in_c014         VARCHAR2 := NULL,
        in_c015         VARCHAR2 := NULL,
        in_c016         VARCHAR2 := NULL,
        in_c017         VARCHAR2 := NULL,
        in_c018         VARCHAR2 := NULL,
        in_c019         VARCHAR2 := NULL,
        in_c020         VARCHAR2 := NULL,
        in_c021         VARCHAR2 := NULL,
        in_c022         VARCHAR2 := NULL,
        in_c023         VARCHAR2 := NULL,
        in_c024         VARCHAR2 := NULL,
        in_c025         VARCHAR2 := NULL,
        in_c026         VARCHAR2 := NULL,
        in_c027         VARCHAR2 := NULL,
        in_c028         VARCHAR2 := NULL,
        in_c029         VARCHAR2 := NULL,
        in_c030         VARCHAR2 := NULL,
        in_c031         VARCHAR2 := NULL,
        in_c032         VARCHAR2 := NULL,
        in_c033         VARCHAR2 := NULL,
        in_c034         VARCHAR2 := NULL,
        in_c035         VARCHAR2 := NULL,
        in_c036         VARCHAR2 := NULL,
        in_c037         VARCHAR2 := NULL,
        in_c038         VARCHAR2 := NULL,
        in_c039         VARCHAR2 := NULL,
        in_c040         VARCHAR2 := NULL,
        in_c041         VARCHAR2 := NULL,
        in_c042         VARCHAR2 := NULL,
        in_c043         VARCHAR2 := NULL,
        in_c044         VARCHAR2 := NULL,
        in_c045         VARCHAR2 := NULL,
        in_c046         VARCHAR2 := NULL,
        in_c047         VARCHAR2 := NULL,
        in_c048         VARCHAR2 := NULL,
        in_c049         VARCHAR2 := NULL,
        in_c050         VARCHAR2 := NULL
    );







    -- ### Settings page
    --

    --
    -- Store/update settings
    --
    PROCEDURE save_setting (
        in_action               CHAR,
        in_setting_name_old     settings.setting_name%TYPE,
        in_setting_name         settings.setting_name%TYPE,
        in_setting_group        settings.setting_group%TYPE         := NULL,
        in_setting_value        settings.setting_value%TYPE         := NULL,
        in_is_numeric           settings.is_numeric%TYPE            := NULL,
        in_is_date              settings.is_date%TYPE               := NULL,
        in_is_private           settings.is_private%TYPE            := NULL,
        in_description          settings.description_%TYPE          := NULL
    );



    --
    -- Store/update settings for specific contexts (pivot), including default
    --
    PROCEDURE set_setting_bulk (
        in_c001         settings.setting_value%TYPE,
        in_c002         settings.setting_value%TYPE,
        in_c003         settings.setting_value%TYPE         := NULL,
        in_c004         settings.setting_value%TYPE         := NULL,
        in_c005         settings.setting_value%TYPE         := NULL,
        in_c006         settings.setting_value%TYPE         := NULL,
        in_c007         settings.setting_value%TYPE         := NULL,
        in_c008         settings.setting_value%TYPE         := NULL,
        in_c009         settings.setting_value%TYPE         := NULL,
        in_c010         settings.setting_value%TYPE         := NULL,
        in_c011         settings.setting_value%TYPE         := NULL,
        in_c012         settings.setting_value%TYPE         := NULL,
        in_c013         settings.setting_value%TYPE         := NULL,
        in_c014         settings.setting_value%TYPE         := NULL,
        in_c015         settings.setting_value%TYPE         := NULL,
        in_c016         settings.setting_value%TYPE         := NULL,
        in_c017         settings.setting_value%TYPE         := NULL,
        in_c018         settings.setting_value%TYPE         := NULL,
        in_c019         settings.setting_value%TYPE         := NULL,
        in_c020         settings.setting_value%TYPE         := NULL,
        in_c021         settings.setting_value%TYPE         := NULL,
        in_c022         settings.setting_value%TYPE         := NULL,
        in_c023         settings.setting_value%TYPE         := NULL,
        in_c024         settings.setting_value%TYPE         := NULL,
        in_c025         settings.setting_value%TYPE         := NULL,
        in_c026         settings.setting_value%TYPE         := NULL,
        in_c027         settings.setting_value%TYPE         := NULL,
        in_c028         settings.setting_value%TYPE         := NULL,
        in_c029         settings.setting_value%TYPE         := NULL,
        in_c030         settings.setting_value%TYPE         := NULL,
        in_c031         settings.setting_value%TYPE         := NULL,
        in_c032         settings.setting_value%TYPE         := NULL,
        in_c033         settings.setting_value%TYPE         := NULL,
        in_c034         settings.setting_value%TYPE         := NULL,
        in_c035         settings.setting_value%TYPE         := NULL,
        in_c036         settings.setting_value%TYPE         := NULL,
        in_c037         settings.setting_value%TYPE         := NULL,
        in_c038         settings.setting_value%TYPE         := NULL,
        in_c039         settings.setting_value%TYPE         := NULL,
        in_c040         settings.setting_value%TYPE         := NULL,
        in_c041         settings.setting_value%TYPE         := NULL,
        in_c042         settings.setting_value%TYPE         := NULL,
        in_c043         settings.setting_value%TYPE         := NULL,
        in_c044         settings.setting_value%TYPE         := NULL,
        in_c045         settings.setting_value%TYPE         := NULL,
        in_c046         settings.setting_value%TYPE         := NULL,
        in_c047         settings.setting_value%TYPE         := NULL,
        in_c048         settings.setting_value%TYPE         := NULL,
        in_c049         settings.setting_value%TYPE         := NULL,
        in_c050         settings.setting_value%TYPE         := NULL
    );



    --
    -- Prepare pivot for Settings page
    --
    PROCEDURE prep_settings_pivot (
        in_page_id              apex_application_pages.page_id%TYPE
    );







    -- ### E-mails
    --

    FUNCTION clob_to_blob (
        in_clob CLOB
    )
    RETURN BLOB;



    --
    -- Send UTF_8 email with compressed attachements
    --
    PROCEDURE send_mail (
        in_to                   VARCHAR2,
        in_subject              VARCHAR2,
        in_body                 CLOB,
        in_cc                   VARCHAR2        := NULL,
        in_bcc                  VARCHAR2        := NULL,
        in_from                 VARCHAR2        := NULL,
        in_attach_name          VARCHAR2        := NULL,
        in_attach_mime          VARCHAR2        := NULL,
        in_attach_data          CLOB            := NULL,
        in_compress             BOOLEAN         := FALSE
    );







    -- ### GRID Handlers
    --

    --
    -- Update table columns
    --
    PROCEDURE save_obj_columns (
        in_action               CHAR,
        in_table_name           obj_columns.table_name%TYPE,
        in_column_id            obj_columns.column_id%TYPE          := NULL,
        in_column_name          obj_columns.column_name%TYPE        := NULL,
        in_column_name_old      obj_columns.column_name_old%TYPE    := NULL,
        in_is_nn                obj_columns.is_nn%TYPE              := NULL,
        in_data_type            obj_columns.data_type%TYPE          := NULL,
        in_data_default         obj_columns.data_default%TYPE       := NULL,
        in_comments             obj_columns.comments%TYPE           := NULL
    );



    --
    -- Update translations
    --
    PROCEDURE save_translations_overview (
        in_action           CHAR,
        in_app_id           translations_overview.app_id%TYPE,
        in_page_id_old      translations_overview.page_id_old%TYPE,
        in_page_id          translations_overview.page_id%TYPE,
        in_name_old         translations_overview.name_old%TYPE,
        in_name             translations_overview.name%TYPE,
        in_value_en         translations_overview.value_en%TYPE       := NULL,
        in_value_cz         translations_overview.value_cz%TYPE       := NULL,
        in_value_sk         translations_overview.value_sk%TYPE       := NULL,
        in_value_pl         translations_overview.value_pl%TYPE       := NULL,
        in_value_hu         translations_overview.value_hu%TYPE       := NULL
    );

END;
/
