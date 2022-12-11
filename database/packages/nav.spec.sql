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

    --
    -- Check if user have permissions to access the page
    --
    FUNCTION is_page_available (
        in_page_id              navigation.page_id%TYPE,
        in_app_id               navigation.app_id%TYPE
    )
    RETURN CHAR;



    --
    -- Redirect to page and set items if needed
    --
    PROCEDURE redirect (
        in_page_id              NUMBER          := NULL,
        in_names                VARCHAR2        := NULL,
        in_values               VARCHAR2        := NULL,
        in_overload             VARCHAR2        := NULL,    -- JSON object to overload passed items/values
        in_transform            BOOLEAN         := FALSE,   -- to pass all page items to new page
        in_reset                BOOLEAN         := TRUE     -- reset page items
    );





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
    -- Refresh navigation views
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

