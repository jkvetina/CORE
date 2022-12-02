CREATE OR REPLACE PACKAGE BODY app_util AS

    PROCEDURE set_page_items (
        in_query            VARCHAR2,
        in_page_id          NUMBER          := NULL
    )
    AS
        l_cursor            PLS_INTEGER;
        l_refcur            SYS_REFCURSOR;
        l_items             page_items_table;
    BEGIN
        -- process cursor
        OPEN l_refcur FOR LTRIM(RTRIM(in_query));
        --
        l_cursor    := DBMS_SQL.TO_CURSOR_NUMBER(l_refcur);
        l_items     := get_values(l_cursor , in_page_id);
    EXCEPTION
    WHEN OTHERS THEN
        RAISE;
    END;



    FUNCTION set_page_items (
        in_query            VARCHAR2,
        in_page_id          NUMBER          := NULL
    )
    RETURN page_items_table PIPELINED
    AS
        l_cursor            PLS_INTEGER;
        l_refcur            SYS_REFCURSOR;
        l_items             page_items_table;
    BEGIN
        -- process cursor
        OPEN l_refcur FOR LTRIM(RTRIM(in_query));
        --
        l_cursor    := DBMS_SQL.TO_CURSOR_NUMBER(l_refcur);
        l_items     := get_values(l_cursor , in_page_id);
        --
        FOR i IN l_items.FIRST .. l_items.LAST LOOP
            PIPE ROW (l_items(i));
        END LOOP;
        --
        RETURN;
    EXCEPTION
    WHEN OTHERS THEN
        RAISE;
        RETURN;
    END;



    PROCEDURE set_page_items (
        in_cursor           SYS_REFCURSOR,
        in_page_id          NUMBER          := NULL
    )
    AS
        l_cursor            PLS_INTEGER;
        l_cloned_curs       SYS_REFCURSOR;
        l_items             page_items_table;
    BEGIN
        l_cloned_curs   := in_cursor;
        l_cursor        := get_cursor_number(l_cloned_curs);
        l_items         := get_values(l_cursor , in_page_id);
    EXCEPTION
    WHEN OTHERS THEN
        RAISE;
    END;



    FUNCTION set_page_items (
        in_cursor           SYS_REFCURSOR,
        in_page_id          NUMBER          := NULL
    )
    RETURN page_items_table PIPELINED
    AS
        l_cursor            PLS_INTEGER;
        l_cloned_curs       SYS_REFCURSOR;
        l_items             page_items_table;
    BEGIN
        l_cloned_curs   := in_cursor;
        l_cursor        := get_cursor_number(l_cloned_curs);
        l_items         := get_values(l_cursor , in_page_id);
        --
        FOR i IN l_items.FIRST .. l_items.LAST LOOP
            PIPE ROW (l_items(i));
        END LOOP;
        --
        RETURN;
    EXCEPTION
    WHEN OTHERS THEN
        RAISE;
        RETURN;
    END;



    FUNCTION set_item (
        in_page_id          VARCHAR2,
        in_column_name      VARCHAR2,
        in_value            VARCHAR2
    )
    RETURN VARCHAR2
    AS
        l_item_name         VARCHAR2(64);
    BEGIN
        l_item_name := 'P' || COALESCE(in_page_id, APEX_APPLICATION.G_FLOW_STEP_ID) || '_' || in_column_name;
        --
        IF APEX_CUSTOM_AUTH.APPLICATION_PAGE_ITEM_EXISTS(l_item_name) THEN
            BEGIN
                APEX_UTIL.SET_SESSION_STATE(l_item_name, in_value, FALSE);
                --
                RETURN l_item_name;
            EXCEPTION
            WHEN OTHERS THEN
                NULL;
            END;
        END IF;
        --
        RETURN NULL;
    END;



    FUNCTION get_item (
        in_page_id          NUMBER,
        in_column_name      VARCHAR2
    )
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN APEX_UTIL.GET_SESSION_STATE('P' || COALESCE(in_page_id, APEX_APPLICATION.G_FLOW_STEP_ID) || '_' || in_column_name);
    END;



    FUNCTION get_item (
        in_item_name        VARCHAR2
    )
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN APEX_UTIL.GET_SESSION_STATE(in_item_name);
    END;



    FUNCTION get_values (
        io_cursor           IN OUT  PLS_INTEGER,
        in_page_id                  NUMBER          := NULL
    )
    RETURN page_items_table
    AS
        l_desc          DBMS_SQL.DESC_TAB;
        l_cols          PLS_INTEGER;
        l_number        NUMBER;
        l_date          DATE;
        l_string        VARCHAR2(4000);
        --
        out_items       page_items_table    := page_items_table();
        out_item        page_items_type;
    BEGIN
        -- get column names
        DBMS_SQL.DESCRIBE_COLUMNS(io_cursor, l_cols, l_desc);
        --
        FOR i IN 1 .. l_cols LOOP
            IF l_desc(i).col_type = DBMS_SQL.NUMBER_TYPE THEN
                DBMS_SQL.DEFINE_COLUMN(io_cursor, i, l_number);
            ELSIF l_desc(i).col_type = DBMS_SQL.DATE_TYPE THEN
                DBMS_SQL.DEFINE_COLUMN(io_cursor, i, l_date);
            ELSE
                DBMS_SQL.DEFINE_COLUMN(io_cursor, i, l_string, 4000);
            END IF;
        END LOOP;

        -- fetch data
        WHILE DBMS_SQL.FETCH_ROWS(io_cursor) > 0 LOOP
            FOR i IN 1 .. l_cols LOOP
                IF l_desc(i).col_type = DBMS_SQL.NUMBER_TYPE THEN
                    DBMS_SQL.COLUMN_VALUE(io_cursor, i, l_number);
                    l_string := TO_CHAR(l_number);
                ELSIF l_desc(i).col_type = DBMS_SQL.DATE_TYPE THEN
                    DBMS_SQL.COLUMN_VALUE(io_cursor, i, l_date);
                    l_string := TO_CHAR(l_date);
                ELSE
                    DBMS_SQL.COLUMN_VALUE(io_cursor, i, l_string);
                END IF;

                -- set application/page item
                out_item.column_name    := l_desc(i).col_name;
                out_item.item_name      := set_item(in_page_id, l_desc(i).col_name, l_string);
                out_item.item_value     := l_string;
                out_items.EXTEND;
                out_items(out_items.LAST) := out_item;
            END LOOP;
        END LOOP;

        -- cleanup
        close_cursor(io_cursor);
        --
        RETURN out_items;
    EXCEPTION
    WHEN OTHERS THEN
        close_cursor(io_cursor);
        RAISE;
    END;



    FUNCTION get_cursor_number (
        io_cursor           IN OUT SYS_REFCURSOR
    )
    RETURN PLS_INTEGER
    AS
    BEGIN
        RETURN DBMS_SQL.TO_CURSOR_NUMBER(io_cursor);
    END;



    PROCEDURE close_cursor (
        io_cursor           IN OUT PLS_INTEGER
    )
    AS
    BEGIN
        DBMS_SQL.CLOSE_CURSOR(io_cursor);
    EXCEPTION
    WHEN OTHERS THEN
        NULL;
    END;

END;
/
