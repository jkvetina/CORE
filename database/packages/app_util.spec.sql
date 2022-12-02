CREATE OR REPLACE PACKAGE app_util AS

    TYPE page_items_type IS RECORD (
        column_name     VARCHAR2(30),
        item_name       VARCHAR2(64),
        item_value      VARCHAR2(2000)
    );
    --
    TYPE page_items_table IS TABLE OF page_items_type;



    /**
     * SET PAGE ITEMS BASED ON QUERY OR CURSOR (ONE ROW IS EXPECTED)
     */

    PROCEDURE set_page_items (
        in_query            VARCHAR2,
        in_page_id          NUMBER          := NULL
    );



    FUNCTION set_page_items (
        in_query            VARCHAR2,
        in_page_id          NUMBER          := NULL
    )
    RETURN page_items_table PIPELINED;



    PROCEDURE set_page_items (
        in_cursor           SYS_REFCURSOR,
        in_page_id          NUMBER          := NULL
    );



    FUNCTION set_page_items (
        in_cursor           SYS_REFCURSOR,
        in_page_id          NUMBER          := NULL
    )
    RETURN page_items_table PIPELINED;



    /**
     * HELP FUNCTION TO MAKE THIS ENDEAVOUR POSSIBLE
     */

    FUNCTION set_item (
        in_page_id          VARCHAR2,
        in_column_name      VARCHAR2,
        in_value            VARCHAR2
    )
    RETURN VARCHAR2;



    FUNCTION get_item (
        in_page_id          NUMBER,
        in_column_name      VARCHAR2
    )
    RETURN VARCHAR2;



    FUNCTION get_item (
        in_item_name        VARCHAR2
    )
    RETURN VARCHAR2;



    FUNCTION get_values (
        io_cursor           IN OUT  PLS_INTEGER,
        in_page_id                  NUMBER          := NULL
    )
    RETURN page_items_table;



    FUNCTION get_cursor_number (
        io_cursor           IN OUT SYS_REFCURSOR
    )
    RETURN PLS_INTEGER;



    PROCEDURE close_cursor (
        io_cursor           IN OUT PLS_INTEGER
    );

END;
/

