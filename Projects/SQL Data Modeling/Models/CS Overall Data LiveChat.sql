SELECT 
    agent_id AS `Agent`
    ,chats_count AS `Total chats`
    -- Satisfactoion (total chats/chats rated bad)?????
    ,first_response_time AS `First response time`
    ,(logged_in_time - not_accepting_chats_time) AS `Accepting time seconds`
    ,not_accepting_chats_time AS `Not accepting time seconds`
    ,logged_in_time AS `Logged in time`
    ,chatting_time AS `Chatting time seconds`

FROM `project_id.dataset.table` 
WHERE date = "2026-01-19" 
AND agent_id = '6ed2b4eb7c06fc5a432c90ad42b342cb'
ORDER BY agent_id