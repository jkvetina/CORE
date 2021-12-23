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
    --
    --
    FUNCTION get_role_name (
        in_role_id              roles.role_id%TYPE
    )
    RETURN roles.role_name%TYPE;



    --
    --
    --
    PROCEDURE prep_user_roles_pivot (
        in_page_id              apex_application_pages.page_id%TYPE
    );

END;
/
