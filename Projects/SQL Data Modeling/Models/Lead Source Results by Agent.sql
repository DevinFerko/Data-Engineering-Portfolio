SELECT DISTINCT
    --o.ord_invoicetaxDate AS 'Tax Date' --Uncomment for filtering when entered into Tableau report 
    (c.con_firstName + ' ' + c.con_lastName) AS 'Assigned To',
    CASE
        WHEN o.ord_leadSourceId = 8 THEN 'LiveChat'
        WHEN o.ord_leadSourceId = 5 THEN 'Telephone'
        WHEN o.ord_leadSourceId = 7 THEN 'Email'
    END AS 'Lead Source Name',
    SUM(ol.orl_quantity) AS 'Items',
    APPROX_COUNT_DISTINCT(o.ord_id) AS 'Orders',
    o.ord_orderStatusName,
    SUM(ol.orl_itemCostValue) AS 'Cost',
    SUM(ol.orl_rowNetValue) AS 'Revenue',
    SUM(ol.orl_rowNetValue+ol.orl_rowTaxValue) AS 'Gross Revenue',
    SUM(ol.orl_rowNetValue-ol.orl_itemCostValue) AS 'Gross Profit'
FROM
    dbo.tblOrder AS o 
LEFT JOIN
    dbo.tblOrderLine AS ol ON o.ord_id = ol.orl_ord_id
LEFT JOIN
    dbo.tblContact AS c ON o.ord_staffOwnerContactId = c.con_id
WHERE
    o.ord_channelId IN (2, 7, 8)
    AND o.ord_orderTypeCode = 'SO'
    AND o.ord_invoicetaxDate IS NOT NULL
    AND o.ord_invoicetaxDate >= '2026/01/01'
    AND o.ord_invoicetaxDate <= '2026/01/31'
    AND c.con_firstName = 'Lottie' -- Comment out when placed in Tableau
    AND o.ord_orderStatusName IN ('Ready to Ship', 'Invoiced')
GROUP BY
    o.ord_leadSourceId, o.ord_orderStatusName, c.con_firstName, c.con_lastName, --o.ord_invoicetaxDate AS 'Tax Date' --Uncomment for filtering when entered into Tableau report