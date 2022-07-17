-- --------------------------------------------------------------------------------
-- 
-- Oracle APEX source export file
-- 
-- The contents of this file are intended for review and analysis purposes only.
-- Developers must use the Application Builder to make modifications to an
-- application. Changes to this file will not be reflected in the application.
-- 
-- --------------------------------------------------------------------------------

-- ----------------------------------------
-- Page 970: #fa-wrench &PAGE_NAME.
-- Region: &REGION_CONTEXT_VALUES.
-- SQL Query

SELECT 1
FROM setting_contexts
WHERE ROWNUM = 1

-- ----------------------------------------
-- Page 970: #fa-wrench &PAGE_NAME.
-- Process: INIT_PIVOT
-- PL/SQL Code

app_actions.prep_settings_pivot(:APP_PAGE_ID);


-- ----------------------------------------
-- Page 970: #fa-wrench &PAGE_NAME.
-- Process: INIT_PIVOT
-- SQL Query

SELECT 1
FROM setting_contexts
WHERE ROWNUM = 1

-- ----------------------------------------
-- Page 970: #fa-wrench &PAGE_NAME.
-- Process: SAVE_CONTEXT_VALUES
-- PL/SQL Code to Insert/Update/Delete

app.log_action('SAVE_CONTEXT_VALUES');
--
app_actions.set_setting_bulk (
    in_c001     => :C001,
    in_c002     => :C002,
    in_c003     => :C003,
    in_c004     => :C004,
    in_c005     => :C005,
    in_c006     => :C006,
    in_c007     => :C007,
    in_c008     => :C008,
    in_c009     => :C009,
    in_c010     => :C010,
    in_c011     => :C011,
    in_c012     => :C012,
    in_c013     => :C013,
    in_c014     => :C014,
    in_c015     => :C015,
    in_c016     => :C016,
    in_c017     => :C017,
    in_c018     => :C018,
    in_c019     => :C019,
    in_c020     => :C020,
    in_c021     => :C021,
    in_c022     => :C022,
    in_c023     => :C023,
    in_c024     => :C024,
    in_c025     => :C025,
    in_c026     => :C026,
    in_c027     => :C027,
    in_c028     => :C028,
    in_c029     => :C029,
    in_c030     => :C030,
    in_c031     => :C031,
    in_c032     => :C032,
    in_c033     => :C033,
    in_c034     => :C034,
    in_c035     => :C035,
    in_c036     => :C036,
    in_c037     => :C037,
    in_c038     => :C038,
    in_c039     => :C039,
    in_c040     => :C040,
    in_c041     => :C041,
    in_c042     => :C042,
    in_c043     => :C043,
    in_c044     => :C044,
    in_c045     => :C045,
    in_c046     => :C046,
    in_c047     => :C047,
    in_c048     => :C048,
    in_c049     => :C049,
    in_c050     => :C050
);


-- ----------------------------------------
-- Page 970: #fa-wrench &PAGE_NAME.
-- Process: INIT_DEFAULTS
-- PL/SQL Code

app.log_action('INIT_DEFAULTS');
--
:P970_REBUILD_TITLE := 'Rebuild ' || app.get_settings_package() || ' package with ' || app.get_settings_prefix() || '* functions';
--
SELECT NVL(MAX('t-Button--hot'), ' ') INTO :P970_REBUILD_HOT
FROM settings_overview s
WHERE s.action_check IS NOT NULL;


-- ----------------------------------------
-- Page 970: #fa-wrench &PAGE_NAME.
-- Process: ACTION_REBUILD_PACKAGE
-- PL/SQL Code

app.log_action('REBUILD_PACKAGE');
--
app.rebuild_settings();


-- ----------------------------------------
-- Page 970: #fa-wrench &PAGE_NAME.
-- Process: SAVE_SETTINGS
-- PL/SQL Code to Insert/Update/Delete

app.log_action('SAVE_SETTINGS');
--
app_actions.save_setting (
    in_action               => :APEX$ROW_STATUS,
    in_setting_name         => :SETTING_NAME,
    in_setting_name_old     => :SETTING_NAME_OLD,
    in_setting_value        => :SETTING_VALUE,
    in_setting_group        => :SETTING_GROUP,
    in_is_numeric           => :IS_NUMERIC,
    in_is_date              => :IS_DATE,
    in_is_private           => :IS_PRIVATE,
    in_description          => :DESCRIPTION_
);

-- update PK
:SETTING_NAME_OLD := UPPER(:SETTING_NAME);


-- ----------------------------------------
-- Page 970: #fa-wrench &PAGE_NAME.
-- Action: NATIVE_EXECUTE_PLSQL_CODE
-- PL/SQL Code

app_actions.prep_settings_pivot(:APP_PAGE_ID);


-- ----------------------------------------
-- Page 970: #fa-wrench &PAGE_NAME.
-- Region: Context Values (DYNAMIC PIVOT) [GRID]
-- SQL Query

SELECT
    seq_id AS row#,
    c001, c002, c003, c004, c005, c006, c007, c008, c009, c010,
    c011, c012, c013, c014, c015, c016, c017, c018, c019, c020,
    c021, c022, c023, c024, c025, c026, c027, c028, c029, c030,
    c031, c032, c033, c034, c035, c036, c037, c038, c039, c040,
    c041, c042, c043, c044, c045, c046, c047, c048, c049, c050
FROM apex_collections c
WHERE c.collection_name     = 'P' || :APP_PAGE_ID
    AND c.c001              = NVL(app.get_item('$SETTING_NAME'), c.c001);


