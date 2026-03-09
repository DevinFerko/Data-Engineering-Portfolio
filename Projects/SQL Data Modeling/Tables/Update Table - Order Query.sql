-- Ensure the table exists before altering
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Orders' AND TABLE_SCHEMA = 'usr')
BEGIN
    CREATE TABLE usr.Orders (
        [Order ID] INT PRIMARY KEY,
        [Parent Order Row ID] INT,
        [Type] VARCHAR(50),
        [Reference Number] VARCHAR(255),
        [Invoice Reference] VARCHAR(255),
        [Status] VARCHAR(255),
        [Allocation Status] VARCHAR(255),
        [Inventory Status] VARCHAR(255),
        [Shipping Status] VARCHAR(255),
        [Payment Status] VARCHAR(255),
        [Channel ID] INT,
        [Channel Name] VARCHAR(255),
        [Billing City] VARCHAR(255),
        [Billing Country ID] INT,
        [Billing Country Code] VARCHAR(10),
        [Billing State] VARCHAR(255),
        [Billing Zip] VARCHAR(50),
        [Delivery City] VARCHAR(255),
        [Delivery Country ID] INT,
        [Delivery Country Code] VARCHAR(10),
        [Delivery State] VARCHAR(255),
        [Delivery Zip] VARCHAR(50),
        [Created By ID] INT,
        [Employee ID] INT,
        [Currency] VARCHAR(10),
        [Order Date] DATETIME,
        [Created At Date] DATETIME,
        [Tax Date] DATETIME,
        [Original Invoice Due Date] DATETIME,
        [Delivery Date] DATETIME,
        [Exchange Rate] DECIMAL(18,6),
        [Fixed Exchange Rate] DECIMAL(18,6),
        [Revenue] DECIMAL(18,2),
        [Tax] DECIMAL(18,2),
        [Net Value] DECIMAL(18,2),
        [Historical Order (Yes / No)] VARCHAR(3),
        [Is Dropship (Yes / No)] VARCHAR(3),
        [Lead Source ID] INT,
        [Lead Source Name] VARCHAR(255),
        [Payment Method Code] VARCHAR(50),
        [Payment Method] VARCHAR(255),
        [Cost Price ID] INT,
        [Price List ID] INT,
        [Shipping Method ID] INT,
        [Shipping Method] VARCHAR(255),
        [Warehouse ID] INT,
        [Supplier City] VARCHAR(255),
        [Supplier Company] VARCHAR(255),
        [Supplier Contact ID] INT,
        [Supplier Country Code] VARCHAR(10),
        [Supplier Country ID] INT,
        [Supplier State] VARCHAR(255),
        [Supplier Zip] VARCHAR(50),
        [Supplier Email] VARCHAR(255),
        [Supplier Name] VARCHAR(255)
    );
END;

-- 2. Update existing rows
UPDATE tgt
SET 
    tgt.[Parent Order Row ID] = src.[Parent Order Row ID],
    tgt.[Type] = src.[Type],
    tgt.[Reference Number] = src.[Reference Number],
    tgt.[Invoice Reference] = src.[Invoice Reference],
    tgt.[Status] = src.[Status],
    tgt.[Allocation Status] = src.[Allocation Status],
    tgt.[Inventory Status] = src.[Inventory Status],
    tgt.[Shipping Status] = src.[Shipping Status],
    tgt.[Payment Status] = src.[Payment Status],
    tgt.[Channel ID] = src.[Channel ID],
    tgt.[Channel Name] = src.[Channel Name],
    tgt.[Billing City] = src.[Billing City],
    tgt.[Billing Country ID] = src.[Billing Country ID],
    tgt.[Billing Country Code] = src.[Billing Country Code],
    tgt.[Billing State] = src.[Billing State],
    tgt.[Billing Zip] = src.[Billing Zip],
    tgt.[Delivery City] = src.[Delivery City],
    tgt.[Delivery Country ID] = src.[Delivery Country ID],
    tgt.[Delivery Country Code] = src.[Delivery Country Code],
    tgt.[Delivery State] = src.[Delivery State],
    tgt.[Delivery Zip] = src.[Delivery Zip],
    tgt.[Created By ID] = src.[Created By ID],
    tgt.[Employee ID] = src.[Employee ID],
    tgt.[Currency] = src.[Currency],
    tgt.[Order Date] = src.[Order Date],
    tgt.[Created At Date] = src.[Created At Date],
    tgt.[Tax Date] = src.[Tax Date],
    tgt.[Original Invoice Due Date] = src.[Original Invoice Due Date],
    tgt.[Delivery Date] = src.[Delivery Date],
    tgt.[Exchange Rate] = src.[Exchange Rate],
    tgt.[Fixed Exchange Rate] = src.[Fixed Exchange Rate],
    tgt.[Revenue] = src.[Revenue],
    tgt.[Tax] = src.[Tax],
    tgt.[Net Value] = src.[Net Value],
    tgt.[Historical Order (Yes / No)] = src.[Historical Order (Yes / No)],
    tgt.[Is Dropship (Yes / No)] = src.[Is Dropship (Yes / No)],
    tgt.[Lead Source ID] = src.[Lead Source ID],
    tgt.[Lead Source Name] = src.[Lead Source Name],
    tgt.[Payment Method Code] = src.[Payment Method Code],
    tgt.[Payment Method] = src.[Payment Method],
    tgt.[Cost Price ID] = src.[Cost Price ID],
    tgt.[Price List ID] = src.[Price List ID],
    tgt.[Shipping Method ID] = src.[Shipping Method ID],
    tgt.[Shipping Method] = src.[Shipping Method],
    tgt.[Warehouse ID] = src.[Warehouse ID],
    tgt.[Supplier City] = src.[Supplier City],
    tgt.[Supplier Company] = src.[Supplier Company],
    tgt.[Supplier Contact ID] = src.[Supplier Contact ID],
    tgt.[Supplier Country Code] = src.[Supplier Country Code],
    tgt.[Supplier Country ID] = src.[Supplier Country ID],
    tgt.[Supplier State] = src.[Supplier State],
    tgt.[Supplier Zip] = src.[Supplier Zip],
    tgt.[Supplier Email] = src.[Supplier Email],
    tgt.[Supplier Name] = src.[Supplier Name]
FROM usr.Orders tgt
INNER JOIN (
    SELECT 
        ord_Id AS [Order Id],  
        ord_parentOrderId AS [Parent Order Row Id],
        ord_orderTypeCode AS [Type],
        ord_reference AS [Reference Number],
        ord_invoiceReference AS [Invoice Reference],
        ord_orderStatusName AS [Status],
        ord_allocationStatusCode AS [Allocation Status],
        ord_stockStatusCode AS [Inventory Status],
        ord_shippingStatusCode AS [Shipping Status],
        ord_orderPaymentStatus AS [Payment Status],
        ord_channelId AS [Channel ID],
        chn_name AS [Channel Name],
        
        [Billing City] = opB.par_addressLine3 --con_billingaddressLine3
        ,[Billing Country Id] = opB.par_countryId --con_billingcountryId
        ,[Billing Country Code] = opB.par_countryIsoCode --con_billingcountryIsoCode
        ,[Billing State] = opB.par_addressLine4 --con_billingaddressLine4
        ,[Billing Zip] = opB.par_postalCode --con_billingPostalCode
        
        ,[Delivery City] = opD.par_addressLine3 --con_defaultaddressLine3
        ,[Delivery Country Id] =opD.par_countryId --con_defaultcountryId
        ,[Delivery Country Code] = opD.par_countryIsoCode --con_defaultcountryIsoCode
        ,[Delivery State] = opD.par_addressLine4 --con_defaultaddressLine4
        ,[Delivery Zip] = opD.par_postalCode, --con_defaultPostalCode
                
        ord_createdById AS [Created By ID],
        ord_staffOwnerContactId AS [Employee ID],
        ord_orderCurrencyCode AS [Currency],
        ord_placedOn AS [Order Date],
        ord_createdOn AS [Created At Date],
        ord_invoicetaxDate AS [Tax Date],
        ord_invoicedueDate AS [Original Invoice Due Date],
        ord_deliveryDate AS [Delivery Date],
        ord_exchangeRate AS [Exchange Rate],
        ord_fixedExchangeRate AS [Fixed Exchange Rate],
        ord_total AS [Revenue],
        ord_taxAmount AS [Tax],
        ord_baseNet AS [Net Value],
        CASE WHEN ord_historicalOrder = 0 THEN 'No' ELSE 'Yes' END AS [Historical Order (Yes / No)],
        CASE WHEN ord_isDropship = 0 THEN 'No' ELSE 'Yes' END AS [Is Dropship (Yes / No)],
        ord_leadSourceId AS [Lead Source ID],
        lsc_name AS [Lead Source Name],
        cmp_paymentMethodCode AS [Payment Method Code],
        cmp_paymentType AS [Payment Method],
        ord_costPriceListId AS [Cost Price ID],
        ord_priceListId AS [Price List ID],
        ord_shippingMethodId AS [Shipping Method ID],
        shm_name AS [Shipping Method],
        ord_warehouseId AS [Warehouse ID],
        
        [Supplier City] =opS.par_addressLine3 --CASE WHEN con_isSupplier = 1 THEN con_defaultaddressLine3 ELSE NULL END
        ,[Supplier Company] = opS.par_companyName --CASE WHEN con_isSupplier = 1 THEN con_organisationName ELSE NULL END
        ,[Supplier Contact Id] = opS.par_contactId --CASE WHEN con_isSupplier = 1 THEN con_id ELSE NULL END
        ,[Supplier Country Code] = opS.par_countryIsoCode --CASE WHEN con_isSupplier = 1 THEN con_defaultcountryIsoCode ELSE NULL END
        ,[Supplier Country Id] = opS.par_countryId --CASE WHEN con_isSupplier = 1 THEN con_defaultcountryId ELSE NULL END
        ,[Supplier State] = opS.par_addressLine4 --CASE WHEN con_isSupplier = 1 THEN con_defaultaddressLine4 ELSE NULL END
        ,[Supplier Zip] = opS.par_postalCode --CASE WHEN con_isSupplier = 1 THEN con_defaultPostalCode ELSE NULL END
        ,[Supplier Email] = opS.par_email --CASE WHEN con_isSupplier = 1 THEN con_emailsPRI ELSE NULL END
        ,[Supplier Name] = opS.par_addressFullName --CASE WHEN con_isSupplier = 1 THEN CONCAT(con_firstName, ' ', con_lastName) ELSE NULL END
        
    FROM dbo.tblOrder
    LEFT JOIN dbo.tblOrderLine ON ord_Id = orl_ord_id
    LEFT JOIN dbo.tblContact ON ord_createdById = con_id
    LEFT JOIN dbo.tblLeadSource ON ord_leadSourceId = lsc_id
    LEFT JOIN dbo.tblCustomerPayment ON ord_id = cmp_orderId
    LEFT JOIN dbo.tblShippingMethod ON ord_shippingMethodId = shm_id
    LEFT JOIN dbo.tblChannel ON ord_channelId = chn_id
    LEFT JOIN dbo.tblOrderParty AS opD ON opD.par_ord_id=ord_id AND opD.par_type='delivery'
    LEFT JOIN dbo.tblOrderParty AS opB ON opB.par_ord_id=ord_id AND opB.par_type='billing'
    LEFT JOIN dbo.tblOrderParty AS opS ON opS.par_ord_id=ord_id AND opS.par_type='supplier'

    GROUP BY 
        ord_Id, ord_parentOrderId, ord_orderTypeCode, ord_reference, ord_invoiceReference, 
        ord_orderStatusName, ord_allocationStatusCode, ord_stockStatusCode, ord_shippingStatusCode, 
        ord_orderPaymentStatus, ord_channelId, chn_name, opB.par_addressLine3, opB.par_countryId, opB.par_countryIsoCode,
        opB.par_addressLine4, opB.par_postalCode, opD.par_addressLine3, opD.par_countryId, opD.par_countryIsoCode,
        opD.par_addressLine4, opD.par_postalCode, ord_createdById, ord_staffOwnerContactId, ord_orderCurrencyCode, 
        ord_placedOn, ord_createdOn, ord_invoicetaxDate, ord_invoicedueDate, ord_deliveryDate, 
        ord_exchangeRate, ord_fixedExchangeRate, ord_total, ord_taxAmount, ord_baseNet,
        ord_historicalOrder, ord_isDropship, ord_leadSourceId, lsc_name, cmp_paymentMethodCode, 
        cmp_paymentType, ord_costPriceListId, ord_priceListId, ord_shippingMethodId, shm_name, 
        ord_warehouseId, con_isSupplier, opS.par_addressLine3, opS.par_companyName, opS.par_contactId, opS.par_countryIsoCode, opS.par_countryId,
        opS.par_addressLine4, opS.par_postalCode, opS.par_email, opS.par_addressFullName
) src ON tgt.[Order ID] = src.[Order ID];

-- 3. Insert new rows
INSERT INTO usr.Orders (
    [Order ID], [Parent Order Row ID], [Type], [Reference Number], [Invoice Reference], 
    [Status], [Allocation Status], [Inventory Status], [Shipping Status], [Payment Status],
    [Channel ID], [Channel Name], [Billing City], [Billing Country ID], [Billing Country Code],
    [Billing State], [Billing Zip], [Delivery City], [Delivery Country ID], [Delivery Country Code],
    [Delivery State], [Delivery Zip], [Created By ID], [Employee ID], [Currency], [Order Date],
    [Created At Date], [Tax Date], [Original Invoice Due Date], [Delivery Date], [Exchange Rate],
    [Fixed Exchange Rate], [Revenue], [Tax], [Net Value],
    [Historical Order (Yes / No)], [Is Dropship (Yes / No)], [Lead Source ID], [Lead Source Name],
    [Payment Method Code], [Payment Method], [Cost Price ID], [Price List ID], 
    [Shipping Method ID], [Shipping Method], [Warehouse ID], [Supplier City], 
    [Supplier Company], [Supplier Contact ID], [Supplier Country Code], [Supplier Country ID], 
    [Supplier State], [Supplier Zip], [Supplier Email], [Supplier Name]
)
SELECT 
    ord_Id, ord_parentOrderId, ord_orderTypeCode, ord_reference, ord_invoiceReference,
    ord_orderStatusName, ord_allocationStatusCode, ord_stockStatusCode, ord_shippingStatusCode, ord_orderPaymentStatus,
    ord_channelId, chn_name, opB.par_addressLine3, opB.par_countryId, opB.par_countryIsoCode,
    opB.par_addressLine4, opB.par_postalCode, opD.par_addressLine3, opD.par_countryId, opD.par_countryIsoCode,
    opD.par_addressLine4, opD.par_postalCode, ord_createdById, ord_staffOwnerContactId, ord_orderCurrencyCode, ord_placedOn,
    ord_createdOn, ord_invoicetaxDate, ord_invoicedueDate, ord_deliveryDate, ord_exchangeRate,
    ord_fixedExchangeRate, ord_total, ord_taxAmount, ord_baseNet, 
    CASE WHEN ord_historicalOrder = 0 THEN 'No' ELSE 'Yes' END, 
    CASE WHEN ord_isDropship = 0 THEN 'No' ELSE 'Yes' END, 
    ord_leadSourceId, lsc_name,
    cmp_paymentMethodCode, cmp_paymentType, ord_costPriceListId, ord_priceListId, ord_shippingMethodId, shm_name,
    ord_warehouseId, opS.par_addressLine3, opS.par_companyName, opS.par_contactId, opS.par_countryIsoCode, opS.par_countryId,
    opS.par_addressLine4, opS.par_postalCode, opS.par_email, opS.par_addressFullName
FROM dbo.tblOrder
LEFT JOIN dbo.tblOrderLine ON ord_Id = orl_ord_id
    LEFT JOIN dbo.tblContact ON ord_createdById = con_id
    LEFT JOIN dbo.tblLeadSource ON ord_leadSourceId = lsc_id
    LEFT JOIN dbo.tblCustomerPayment ON ord_id = cmp_orderId
    LEFT JOIN dbo.tblShippingMethod ON ord_shippingMethodId = shm_id
    LEFT JOIN dbo.tblChannel ON ord_channelId = chn_id
    LEFT JOIN dbo.tblOrderParty AS opD ON opD.par_ord_id=ord_id AND opD.par_type='delivery'
    LEFT JOIN dbo.tblOrderParty AS opB ON opB.par_ord_id=ord_id AND opB.par_type='billing'
    LEFT JOIN dbo.tblOrderParty AS opS ON opS.par_ord_id=ord_id AND opS.par_type='supplier'
    
WHERE NOT EXISTS (
    SELECT 1 
    FROM usr.Orders orr 
    WHERE 
        orr.[Order ID] = ord_id 
)

    GROUP BY 
        ord_Id, ord_parentOrderId, ord_orderTypeCode, ord_reference, ord_invoiceReference, 
        ord_orderStatusName, ord_allocationStatusCode, ord_stockStatusCode, ord_shippingStatusCode, 
        ord_orderPaymentStatus, ord_channelId, chn_name, opB.par_addressLine3, opB.par_countryId, opB.par_countryIsoCode,
        opB.par_addressLine4, opB.par_postalCode, opD.par_addressLine3, opD.par_countryId, opD.par_countryIsoCode,
        opD.par_addressLine4, opD.par_postalCode, ord_createdById, ord_staffOwnerContactId, ord_orderCurrencyCode, 
        ord_placedOn, ord_createdOn, ord_invoicetaxDate, ord_invoicedueDate, ord_deliveryDate, 
        ord_exchangeRate, ord_fixedExchangeRate, ord_total, ord_taxAmount, ord_baseNet,
        ord_historicalOrder, ord_isDropship, ord_leadSourceId, lsc_name, cmp_paymentMethodCode, 
        cmp_paymentType, ord_costPriceListId, ord_priceListId, ord_shippingMethodId, shm_name, 
        ord_warehouseId, con_isSupplier, opS.par_addressLine3, opS.par_companyName, opS.par_contactId, opS.par_countryIsoCode, opS.par_countryId,
        opS.par_addressLine4, opS.par_postalCode, opS.par_email, opS.par_addressFullName