CREATE OR ALTER VIEW usr.OrdersView
AS
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