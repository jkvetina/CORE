CREATE TABLE navigation (
    app_id                          NUMBER(4,0)     CONSTRAINT nn_navigation_app_id NOT NULL,
    page_id                         NUMBER(6,0)     CONSTRAINT nn_navigation_page_id NOT NULL,
    parent_id                       NUMBER(6,0),
    order#                          NUMBER(4,0),
    is_hidden                       CHAR(1),
    is_reset                        CHAR(1),
    is_shared                       CHAR(1),
    updated_by                      VARCHAR2(30),
    updated_at                      DATE,
    --
    CONSTRAINT ch_navigation_is_hidden
        CHECK (is_hidden = 'Y' OR is_hidden IS NULL),
    --
    CONSTRAINT ch_navigation_is_reset
        CHECK (is_reset = 'Y' OR is_reset IS NULL),
    --
    CONSTRAINT pk_navigation
        PRIMARY KEY (app_id, page_id),
    --
    CONSTRAINT ch_navigation_is_shared
        CHECK (is_shared = 'Y' OR is_shared IS NULL),
    --
    CONSTRAINT fk_navigation_app_id
        FOREIGN KEY (app_id)
        REFERENCES apps (app_id),
    --
    CONSTRAINT fk_navigation_parent
        FOREIGN KEY (app_id, parent_id)
        REFERENCES navigation (app_id, page_id)
);
--
COMMENT ON TABLE navigation IS '[CORE] Navigation items';
--
COMMENT ON COLUMN navigation.app_id         IS 'APEX application ID';
COMMENT ON COLUMN navigation.page_id        IS 'APEX page ID';
COMMENT ON COLUMN navigation.parent_id      IS 'Parent page id for tree structure';
COMMENT ON COLUMN navigation.order#         IS 'Order of siblings';
COMMENT ON COLUMN navigation.is_hidden      IS 'Y = dont show in menu';
COMMENT ON COLUMN navigation.is_reset       IS 'Y = reset/clear all items not passed in url';
COMMENT ON COLUMN navigation.is_shared      IS 'Y = show these items in other apps, only for CORE app';

