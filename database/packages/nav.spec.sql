CREATE OR REPLACE PACKAGE nav AS

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
    -- Get HTML alement A
    --
    FUNCTION get_html_a (
        in_href                 VARCHAR2,
        in_name                 VARCHAR2,
        in_title                VARCHAR2    := NULL
    )
    RETURN VARCHAR2;





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



    --
    -- Refresh navigation MVW in a background job and inform user
    --
    PROCEDURE refresh_nav_views (
        in_log_id           logs.log_id%TYPE,
        in_user_id          logs.user_id%TYPE,
        in_app_id           logs.app_id%TYPE,
        in_lang_id          users.lang_id%TYPE
    );
    --
    PROCEDURE refresh_nav_views;



    --
    -- Save changes on Navigation page
    --
    PROCEDURE save_nav_overview (
        in_action               CHAR,
        in_app_id               navigation.app_id%TYPE,
        in_page_id              navigation.page_id%TYPE,
        in_parent_id            navigation.parent_id%TYPE,
        in_order#               navigation.order#%TYPE,
        in_is_hidden            navigation.is_hidden%TYPE,
        in_is_reset             navigation.is_reset%TYPE,
        in_is_shared            navigation.is_shared%TYPE
    );

END;
/

