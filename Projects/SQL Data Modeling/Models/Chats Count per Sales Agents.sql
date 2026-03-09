SELECT DISTINCT
  SUM(chats_count)
FROM
  `project_id.dataset.table`
WHERE date_yyyymmdd >= '20251201'
  AND date_yyyymmdd <= '20260104'
  AND agent_id IN (
      'XXXX')