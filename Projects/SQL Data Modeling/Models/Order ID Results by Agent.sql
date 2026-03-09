SELECT DISTINCT 
    o.ord_id AS 'Order ID',
    o.ord_orderStatusName AS 'Status',
    SUM(ol.orl_rowNetValue) AS 'Net Value',
    o.ord_orderCurrencyCode AS 'Order Currancy',
    o.ord_createdOn AS 'Date Created',
    o.ord_parentOrderId AS 'Parent Order ID',
    o.ord_leadSourceId AS 'Lead Source ID',
    CASE
        WHEN o.ord_leadSourceId = 8 THEN 'LiveChat'
        WHEN o.ord_leadSourceId = 5 THEN 'Telephone'
        WHEN o.ord_leadSourceId = 7 THEN 'Email'
    END AS 'Lead Source Name',
    o.ord_channelId AS 'Channel ID',
    (c.con_firstName + ' ' + c.con_lastName) AS 'Assigned To'
FROM
    dbo.tblOrder AS o
LEFT JOIN
    dbo.tblOrderLine AS ol ON o.ord_id = ol.orl_ord_id
LEFT JOIN
    dbo.tblContact AS c ON o.ord_staffOwnerContactId = c.con_id
WHERE
    o.ord_orderTypeCode = 'SO'
    AND o.ord_id = 2294098
GROUP BY
    o.ord_id,
    o.ord_orderStatusName,
    o.ord_orderCurrencyCode,
    o.ord_createdOn,
    o.ord_parentOrderId,
    o.ord_leadSourceId,
    o.ord_channelId,
    c.con_firstName, 
    c.con_lastName