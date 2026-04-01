WITH OrderCustomerMapping AS (
    SELECT 
        O.ord_id,
        O.ord_reference,
        O.ord_placedOn,
        O.ord_total,
        O.ord_net,
        O.ord_orderStatusName,
        P.par_email,
        P.par_addressFullName,
        P.par_type,
        -- Logic: Rank the 'appropriate' party record as 1
        ROW_NUMBER() OVER (
            PARTITION BY O.ord_id 
            ORDER BY 
                CASE 
                    WHEN O.ord_reference LIKE 'PO%' AND P.par_type = 'Delivery' THEN 1
                    WHEN O.ord_reference NOT LIKE 'PO%' AND P.par_type = 'Customer' THEN 1
                    ELSE 2 
                END ASC,
                O.ord_version DESC -- If multiple versions exist, take the latest
        ) AS BestEmailRank
    FROM [dbo].[tblOrder] AS O
    INNER JOIN [dbo].[tblOrderParty] AS P ON O.ord_id = P.par_ord_id
    WHERE 1=1
        -- Filter for EXACTLY yesterday (March 31, 2026) if needed
        --AND O.ord_placedOn >= '2026-03-31 00:00:00' 
        --AND O.ord_placedOn < '2026-04-01 00:00:00'
        
        -- Clean up references
        AND O.ord_reference NOT LIKE 'PO#%'
        AND O.ord_reference IS NOT NULL 
        AND O.ord_reference <> ''
)
SELECT 
    ord_id,
    ord_reference,
    ord_placedOn,
    ord_total,
    ord_net,
    ord_orderStatusName,
    par_email,
    par_addressFullName AS CustomerName,
    par_type AS SelectedPartyType
FROM OrderCustomerMapping
WHERE BestEmailRank = 1
ORDER BY ord_reference ASC;