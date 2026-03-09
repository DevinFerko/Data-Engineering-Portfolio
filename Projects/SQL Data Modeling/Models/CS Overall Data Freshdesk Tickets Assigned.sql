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
    --AND responder_id = '3036198812' -- For Testing
    GROUP BY 1, 2
    ORDER BY CAST(PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%SZ', created_at) AS DATE) DESC