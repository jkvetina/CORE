CREATE OR REPLACE FORCE VIEW translated_messages_overview AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()    AS app_id
    FROM DUAL
)
SELECT
    t.message               AS out_message,
    t.message,
    --
    t.value_en,
    t.value_cz,
    t.value_sk,
    t.value_pl,
    t.value_hu
FROM translated_messages t
JOIN x
    ON x.app_id             = t.app_id;
--
COMMENT ON TABLE  translated_messages_overview      IS '[CORE - DASHBOARD] Translate messages/notifications';

