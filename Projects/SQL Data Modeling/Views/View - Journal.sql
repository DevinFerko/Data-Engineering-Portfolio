CREATE OR ALTER VIEW usr.JournalView
AS
SELECT   
        j.jou_id AS [Journal ID],
        jt.jtr_sequence AS [Journal Sequence],  
        j.jou_contactId AS [Contact ID],  
        c.con_organisationName AS [Company],  
        c.con_firstName AS [First Name],  
        c.con_lastName AS [Last Name],  
        jtr_assignmentChannelId AS [Channel ID],  
        ch.chn_name AS [Channel],  
        c.con_emailsPRI AS [Email],  
        j.jou_description AS [Description],  
        j.jou_createdByContactId AS [Created Contact ID],  
        j.jou_dueDate AS [Due Date],
        j.jou_dueDate AS [Journal Due Date],  
        j.jou_createdOn AS [Journal Entered Date],  
        j.jou_taxDate AS [Tax Date],  
        j.jou_taxReconciliationDate AS [Tax Reconciliation Date],  
        jt.jtr_taxCode AS [Tax Code ID],  
        j.jou_currencyId AS [Currency ID],  
        j.jou_exchangeRate AS [Exchange Rate],  
        jt.jtr_orderId AS [Order ID],  
        jt.jtr_invoiceReference AS [Invoice Reference],  
        j.jou_journalTypeCode AS [Journal Type],  
        jt.jtr_nominalCode AS [Nominal Code],  
        n.nom_name AS [Nominal Code Name],
        jt.jtr_assignmentProjectId AS [Project ID],  
        --o.ord_projectId AS [Project ID],  
        CASE WHEN jt.jtr_creditDebit = 'C' THEN jt.jtr_transactionAmount ELSE NULL END AS [Transaction Credit],  
        CASE WHEN jt.jtr_creditDebit = 'D' THEN jt.jtr_transactionAmount ELSE NULL END AS [Transaction Debit],
        --CASE WHEN jt.jtr_creditDebit = 'C' THEN jt.jtr_transactionAmount ELSE NULL END AS [Journal Credit],
        CAST(CASE
            WHEN jt.jtr_creditDebit = 'C' AND jt.jtr_nominalCode = 7700 THEN jt.jtr_changeValue
            WHEN jt.jtr_creditDebit = 'C' AND jt.jtr_nominalCode = 2299 THEN jt.jtr_changeValue 
            WHEN jt.jtr_creditDebit = 'C' AND j.jou_currencyId = 1 THEN jt.jtr_transactionAmount
            WHEN jt.jtr_creditDebit = 'C' AND j.jou_currencyId <> 1 AND j.jou_exchangeRate = 0 THEN jt.jtr_changeValue --Work Around for exchange rates of 0
            WHEN jt.jtr_creditDebit = 'C' AND j.jou_currencyId <> 1 AND j.jou_exchangeRate IS NOT NULL AND j.jou_exchangeRate <> 0 
                THEN jt.jtr_transactionAmount * (1.0 / j.jou_exchangeRate)
            ELSE NULL
        END AS DECIMAL(18, 2)) AS [Journal Credit],
        CAST(CASE 
            WHEN jt.jtr_creditDebit = 'D' AND jt.jtr_nominalCode = 7700 THEN jt.jtr_changeValue
            WHEN jt.jtr_creditDebit = 'D' AND jt.jtr_nominalCode = 2299 THEN jt.jtr_changeValue
            WHEN jt.jtr_creditDebit = 'D' AND j.jou_currencyId = 1 THEN jt.jtr_transactionAmount
            WHEN jt.jtr_creditDebit = 'D' AND j.jou_currencyId <> 1 AND j.jou_exchangeRate = 0 THEN jt.jtr_changeValue --Work Around for exchange rates of 0
            WHEN jt.jtr_creditDebit = 'D' AND j.jou_currencyId <> 1 AND j.jou_exchangeRate IS NOT NULL AND j.jou_exchangeRate <> 0 
                THEN jt.jtr_transactionAmount * (1.0 / j.jou_exchangeRate)
            ELSE NULL
        END AS DECIMAL(18, 2)) AS [Journal Debit],

        --CASE WHEN jt.jtr_creditDebit = 'D' THEN jt.jtr_transactionAmount ELSE NULL END AS [Journal Debit],  
        c.con_assignmentAccountReference AS [Account Reference],  
        c.con_financialDetailsCreditLimit AS [Credit Limit],  
        c.con_financialDetailsCreditTermDays AS [Credit Term Days],  
        c.con_financialDetailsCurrencyId AS [Financial Details Currency ID],  
        c.con_financialDetailsDiscountPercentage AS [Discount Percent],  
        jtr_assignmentLeadSourceId AS [Lead Source ID],  
        ls.lsc_name AS [Lead Source],  
        c.con_financialDetailsPriceListID AS [Price List ID],  
        CASE WHEN con_isStaff = 0 THEN 'No' ELSE 'Yes' END AS [Staff (Yes/No)],  
        CASE WHEN con_isStaff = 0 THEN 'No' ELSE 'Yes' END AS [Supplier (Yes/No)],  
        c.con_tradeStatus AS [Trade Status]  
    FROM dbo.tblJournal AS j  
    LEFT JOIN dbo.tblJournalTransaction AS jt ON j.jou_id = jt.jtr_jou_id  
    LEFT JOIN dbo.tblOrder AS o ON jt.jtr_orderId = o.ord_id  
    LEFT JOIN dbo.tblContact AS c ON j.jou_contactId = c.con_id  
    LEFT JOIN dbo.tblChannel AS ch ON jtr_assignmentChannelId = ch.chn_id  
    LEFT JOIN dbo.tblNominal AS n ON jt.jtr_nominalCode = n.nom_code  
    LEFT JOIN dbo.tblLeadSource AS ls ON c.con_assignmentLeadSourceId = ls.lsc_id