-- Tickets Resolved
SELECT
    responder_id AS agent_id,
    -- Use resolved_at if available, otherwise closed_at
    CAST(
        PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%SZ',
            COALESCE(NULLIF(resolved_at, ''), NULLIF(closed_at, ''))
    ) AS DATE
    ) AS resolved_date,
    COUNT(*) AS tickets_resolved
FROM `project_id.dataset.table`
WHERE
    (
        (resolved_at IS NOT NULL AND resolved_at != '')
        OR (closed_at IS NOT NULL AND closed_at != '')
    )
    AND status IN ('4', '5')   -- Resolved (4) or Closed (5)
    AND responder_id = '3045128476' -- Example agent ID
GROUP BY 1, 2
ORDER BY 1, 2 DESC;
