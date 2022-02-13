CREATE OR REPLACE PACKAGE gen AS

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

    -- defaults
    in_prefix                   CONSTANT VARCHAR2(4)        := 'in_';
    out_prefix                  CONSTANT VARCHAR2(4)        := 'out_';
    rec_prefix                  CONSTANT VARCHAR2(4)        := 'rec.';
    proc_prefix                 CONSTANT VARCHAR2(30)       := 'save_';
    --
    minimal_space               CONSTANT PLS_INTEGER        := 5;
    tab_width                   CONSTANT PLS_INTEGER        := 4;
    --
    action_arg_name             CONSTANT VARCHAR2(30)       :='IN_ACTION';
    action_replacement          CONSTANT VARCHAR2(30)       :='APEX$ROW_STATUS';
    --
    def_prepend                 CONSTANT VARCHAR2(30)       := '    ';



    --
    -- Calculate width for the max column name in a table/procedure
    --
    FUNCTION get_width (
        in_table_name           user_tables.table_name%TYPE,
        in_prefix               VARCHAR2
    )
    RETURN PLS_INTEGER;



    --
    -- Generate list of arguments
    --
    PROCEDURE get_table_args (
        in_table_name           user_tables.table_name%TYPE,
        in_prepend              VARCHAR2                        := NULL
    );



    --
    -- Generate a record with assignment from arguments
    --
    PROCEDURE get_table_rec (
        in_table_name           user_tables.table_name%TYPE,
        in_prepend              VARCHAR2                        := NULL
    );



    --
    -- Generate table WHERE condition
    --
    PROCEDURE get_table_where (
        in_table_name           user_tables.table_name%TYPE,
        in_prepend              VARCHAR2                        := NULL,
        in_prefix               VARCHAR2                        := NULL,
        in_postfix              VARCHAR2                        := NULL
    );



    --
    -- Generate processing handler
    --
    PROCEDURE create_handler (
        in_table_name           user_tables.table_name%TYPE,
        in_target_table         user_tables.table_name%TYPE             := NULL,
        in_proc_prefix          user_procedures.procedure_name%TYPE     := NULL
    );



    --
    -- Generate procedure call (GRID/FORM processing)
    --
    PROCEDURE call_handler (
        in_procedure_name       user_procedures.procedure_name%TYPE,
        in_prepend              VARCHAR2                                        := NULL,
        in_app_id               apex_application_pages.application_id%TYPE      := NULL,
        in_page_id              apex_application_pages.page_id%TYPE             := NULL
    );

END;
/



    FUNCTION get_view_tables (
        in_table_like       VARCHAR2,
        in_table2_like      VARCHAR2 := NULL,
        in_table3_like      VARCHAR2 := NULL,
        in_table4_like      VARCHAR2 := NULL,
        in_table5_like      VARCHAR2 := NULL,
        in_table6_like      VARCHAR2 := NULL,
        in_table7_like      VARCHAR2 := NULL,
        in_table8_like      VARCHAR2 := NULL
    )
    RETURN VARCHAR2;


/*
    PROCEDURE get_view (
        in_tables       VARCHAR2,
        in_view_name    VARCHAR2        := NULL
    );
*/

