CREATE OR REPLACE VIEW translations_notifications AS
WITH x AS (
    SELECT /*+ MATERIALIZE */
        app.get_app_id()    AS app_id
    FROM DUAL
)
SELECT
    t.app_id,
    t.name,
    t.name                  AS name_old,
    --
    t.value_en,
    t.value_cz,
    t.value_sk,
    t.value_pl,
    t.value_hu
FROM translations t
JOIN x
    ON x.app_id             = t.app_id;
--
COMMENT ON TABLE  translations_notifications     IS '[CORE - DASHBOARD] Translate messages/notifications';

