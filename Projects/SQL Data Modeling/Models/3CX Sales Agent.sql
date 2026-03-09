WITH QueueSegments AS (
  /* Identify all calls that entered a queue */
  SELECT 
    *,
    CAST(destination_dn_number AS STRING) AS q_num,
    destination_dn_name AS q_name,
  FROM
    `project_id.dataset.table`
  WHERE
    destination_entity_type = 'queue'
),
AgentSegments AS (
  /* Identify polling attempts to agents linked to those queue calls */
  SELECT DISTINCT
    p.cdr_id,
    p.originating_cdr_id,
    q.q_num,
    q.q_name,
    CAST(p.destination_dn_number AS STRING) AS ext_num,
    p.destination_dn_name AS ext_name,
    p.cdr_started_at,
    p.cdr_answered_at,
    p.cdr_ended_at,
    TIMESTAMP_DIFF(p.cdr_ended_at, p.cdr_answered_at, SECOND) AS talk_sec
  FROM
    `project_id.dataset.table` p
  INNER JOIN
    QueueSegments q ON p.originating_cdr_id = q.cdr_id
  WHERE
    p.creation_forward_reason = 'polling'
    AND p.destination_entity_type = 'extension'
),
QueueAgg AS (
  /* Aggregate stats for the Queue Summary rows */
  SELECT 
    CONCAT(q_num, ' ', IFNULL(q_name, '')) AS Queue,
    CAST(NULL AS STRING) AS Extension,
    COUNT(cdr_id) AS Queue_Received_Calls,
    COUNT(cdr_answered_at) AS Queue_Serviced_Calls,
    COUNTIF(cdr_answered_at IS NULL OR CAST(cdr_answered_at AS STRING) = 'null') AS Queue_Unanswered_Calls,
    0 AS Extension_Serviced_Calls,
    0 AS Extension_Polls,
    0 AS total_talk_sec,
    CAST(NULL AS STRING) AS AGENT,
    DATE(cdr_started_at) AS call_date
  FROM
    QueueSegments
  GROUP BY
    Queue, Extension, AGENT, call_date
),
AgentAgg AS (
  /* Aggregate stats for the Agent Detail rows */
  SELECT 
        CONCAT(q_num, ' ', IFNULL(q_name, '')) AS Queue,
    CAST(NULL AS STRING) AS Extension,
    COUNT(cdr_id) AS Queue_Received_Calls,
    COUNT(cdr_answered_at) AS Queue_Serviced_Calls,
    COUNTIF(cdr_answered_at IS NULL OR CAST(cdr_answered_at AS STRING) = 'null') AS Queue_Unanswered_Calls,
    0 AS Extension_Serviced_Calls,
    0 AS Extension_Polls,
    0 AS total_talk_sec,
    CAST(NULL AS STRING) AS AGENT,
    DATE(cdr_started_at) AS call_date
  FROM
    QueueSegments
  GROUP BY
    cdr_id, Queue, Extension, AGENT, call_date
),
Combined AS (
  /* Combine summary and detail rows */
  SELECT DISTINCT * FROM QueueAgg
  UNION ALL
  SELECT DISTINCT * FROM AgentAgg
)
SELECT 
  Queue,
  Extension,
  Queue_Received_Calls AS `Queue Received Calls`,
  Queue_Serviced_Calls AS `Queue Serviced Calls`,
  Queue_Unanswered_Calls AS `Queue Unanswered Calls`,
  Extension_Serviced_Calls AS `Extension Serviced Calls`,
  Extension_Polls AS `Extension Polls`,
  /* Format talk time as HH:MM:SS */
  FORMAT('%02d:%02d:%02d', 
    CAST(FLOOR(total_talk_sec / 3600) AS INT64), 
    CAST(FLOOR(MOD(total_talk_sec, 3600) / 60) AS INT64), 
    CAST(MOD(total_talk_sec, 60) AS INT64)) AS `Talk Time`,
  /* Format average talk time as HH:MM:SS */
  FORMAT('%02d:%02d:%02d', 
    CAST(FLOOR(SAFE_DIVIDE(total_talk_sec, Extension_Serviced_Calls) / 3600) AS INT64), 
    -- Fix applied here: CAST the division to INT64 before applying MOD
    CAST(FLOOR(MOD(CAST(SAFE_DIVIDE(total_talk_sec, Extension_Serviced_Calls) AS INT64), 3600) / 60) AS INT64), 
    CAST(MOD(CAST(SAFE_DIVIDE(total_talk_sec, Extension_Serviced_Calls) AS INT64), 60) AS INT64)) AS `Average Talk Time`,
  AGENT,
  FORMAT_DATE('%d/%m/%Y', call_date) AS call_date
FROM
  Combined
WHERE Queue = '808 !DRENCH: Sales Team'
  OR Queue = '830 !TAP WAREHOUSE : Sales Team'
  OR Queue = '834 !ONLY RADIATORS : Sales Team'

ORDER BY
  call_date DESC,
  Queue ASC,
  Extension NULLS FIRST;