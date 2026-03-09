WITH
  -- Tickets Assigned
  tickets_assigned AS (
    SELECT
      responder_id AS agent_id,
      -- Safely convert STRING to DATE, handling potential empty strings
      CAST(PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%SZ', created_at) AS DATE) AS date,
      COUNT(*) AS tickets_assigned
    FROM `project_id.dataset.table`
    WHERE
      responder_id IS NOT NULL
      AND created_at IS NOT NULL
      AND created_at != ''  -- Exclude empty strings
    GROUP BY 1, 2
  ),

  -- Tickets Resolved
  tickets_resolved AS (
    SELECT
      responder_id AS agent_id,
      -- Use resolved_at if available, otherwise closed_at
      CAST(
        PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%SZ',
          COALESCE(NULLIF(resolved_at, ''), NULLIF(closed_at, ''))
      ) AS DATE
    ) AS date,
    COUNT(*) AS tickets_resolved
    FROM `project_id.dataset.table`
    WHERE
      (
      (resolved_at IS NOT NULL AND resolved_at != '')
      OR (closed_at IS NOT NULL AND closed_at != '')
      )
    AND status IN ('4', '5')   -- Resolved (4) or Closed (5)
    GROUP BY 1, 2
  ),

  -- Responses that day
  agent_responses AS (
    SELECT
      c.user_id AS agent_id,
      -- Safely convert STRING to DATE, handling potential empty strings
      CAST(PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%SZ', c.created_at) AS DATE) AS date,
      COUNT(*) AS responses
    FROM `project_id.dataset.table` AS c
    INNER JOIN `project_id.dataset.table` AS a
      ON c.user_id = a.agent_id
    WHERE
      c.created_at IS NOT NULL AND c.created_at != ''  -- Exclude empty strings
    GROUP BY 1, 2
  )
SELECT
  a.agent_id AS Agent_Id,
  a.contact_name AS Agent_Name,
  d.date,
  COALESCE(ta.tickets_assigned, 0) AS tickets_assigned,
  COALESCE(tr.tickets_resolved, 0) AS tickets_resolved,
  COALESCE(ar.responses, 0) AS responses
FROM
  (
    -- Get all distinct dates present in any metric
    SELECT DISTINCT date
    FROM
      (
        SELECT date FROM `tickets_assigned`
        UNION DISTINCT
        SELECT date FROM `tickets_resolved`
        UNION DISTINCT
        SELECT date FROM `agent_responses`
      )
  ) AS d
CROSS JOIN `project_id.dataset.table` AS a
LEFT JOIN `tickets_assigned` AS ta
  ON a.agent_id = ta.agent_id AND d.date = ta.date
LEFT JOIN `tickets_resolved` AS tr
  ON a.agent_id = tr.agent_id AND d.date = tr.date
LEFT JOIN `agent_responses` AS ar
  ON a.agent_id = ar.agent_id AND d.date = ar.date
ORDER BY d.date DESC, Agent_Name;