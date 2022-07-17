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
-- Page 945: #fa-language &PAGE_NAME.
-- Page Item: P945_ITEM_TYPE
-- SQL Query

SELECT
    REGEXP_SUBSTR(t.item_name, '^([^_]+)', 1, 1, NULL, 1) AS item_type,
    REGEXP_SUBSTR(t.item_name, '^([^_]+)', 1, 1, NULL, 1) AS item_type_
FROM translated_items t
WHERE t.app_id = app.get_app_id()
GROUP BY REGEXP_SUBSTR(t.item_name, '^([^_]+)', 1, 1, NULL, 1)
ORDER BY 1;


-- ----------------------------------------
-- Page 945: #fa-language &PAGE_NAME.
-- Process: ACTION_AUTO_TRANSLATE_MESSAGES
-- PL/SQL Code

app.log_action('AUTO_TRANSLATE_MESSAGES', app.get_app_id(), :P945_PAGE_ID, :P945_LANG);
--
app_actions.auto_translate_messages (
    in_app_id       => app.get_app_id(),
    in_lang_id      => :P945_LANG
);


-- ----------------------------------------
-- Page 945: #fa-language &PAGE_NAME.
-- Process: ACTION_AUTO_TRANSLATE
-- PL/SQL Code

app.log_action('AUTO_TRANSLATE', app.get_app_id(), :P945_PAGE_ID, :P945_LANG);
--
app_actions.auto_translate (
    in_app_id       => app.get_app_id(),
    in_page_id      => :P945_PAGE_ID,
    in_lang_id      => :P945_LANG
);


-- ----------------------------------------
-- Page 945: #fa-language &PAGE_NAME.
-- Process: SAVE_UNUSED_ITEMS
-- PL/SQL Code to Insert/Update/Delete

app_actions.save_translated_items_new (
    in_action                   => :APEX$ROW_STATUS,
    in_item_type                => :ITEM_TYPE,
    in_item_name                => :ITEM_NAME,
    in_page_id                  => :PAGE_ID,
    in_value_en                 => :VALUE_EN
);


-- ----------------------------------------
-- Page 945: #fa-language &PAGE_NAME.
-- Process: SAVE_SLIPPED_ITEMS
-- PL/SQL Code to Insert/Update/Delete

app_actions.save_translated_items_new (
    in_action                   => :APEX$ROW_STATUS,
    in_item_type                => :ITEM_TYPE,
    in_item_name                => :ITEM_NAME,
    in_page_id                  => :PAGE_ID,
    in_value_en                 => :VALUE_EN
);


-- ----------------------------------------
-- Page 945: #fa-language &PAGE_NAME.
-- Process: SAVE_NEW_ITEMS
-- PL/SQL Code to Insert/Update/Delete

app_actions.save_translated_items_new (
    in_action                   => :APEX$ROW_STATUS,
    in_item_type                => :ITEM_TYPE,
    in_item_name                => :ITEM_NAME,
    in_page_id                  => :PAGE_ID,
    in_value_en                 => :VALUE_EN
);


-- ----------------------------------------
-- Page 945: #fa-language &PAGE_NAME.
-- Process: ACTION_REBUILD_PAGE_947
-- PL/SQL Code

app.log_action('REBUILD_PAGE_947');
--
app_actions.rebuild_page_947();


-- ----------------------------------------
-- Page 945: #fa-language &PAGE_NAME.
-- Process: SAVE_TRANSLATED_ITEMS
-- PL/SQL Code to Insert/Update/Delete

app_actions.save_translated_items (
    in_action           => :APEX$ROW_STATUS,
    out_page_id         => :OUT_PAGE_ID,
    out_item_name       => :OUT_ITEM_NAME,
    in_page_id          => :PAGE_ID,
    in_item_name        => :ITEM_NAME,
    in_item_type        => :ITEM_TYPE,
    in_value_en         => :VALUE_EN,
    in_value_cz         => :VALUE_CZ,
    in_value_sk         => :VALUE_SK,
    in_value_pl         => :VALUE_PL,
    in_value_hu         => :VALUE_HU
);


-- ----------------------------------------
-- Page 945: #fa-language &PAGE_NAME.
-- Process: SAVE_TRANSLATED_MESSAGES
-- PL/SQL Code to Insert/Update/Delete

app_actions.save_translated_messages (
    in_action       => :APEX$ROW_STATUS,
    out_message     => :OUT_MESSAGE,
    in_message      => :MESSAGE,
    in_value_en     => :VALUE_EN,
    in_value_cz     => :VALUE_CZ,
    in_value_sk     => :VALUE_SK,
    in_value_pl     => :VALUE_PL,
    in_value_hu     => :VALUE_HU
);


