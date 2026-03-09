-- Ensure the table exists before altering
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Journals' AND TABLE_SCHEMA = 'usr')
BEGIN
    CREATE TABLE usr.Journals 
    (  
        [Journal ID] INT PRIMARY KEY,   
        [Contact ID] INT,  
        [Company] NVARCHAR(255),  
        [First Name] NVARCHAR(255),  
        [Last Name] NVARCHAR(255),  
        [Channel ID] INT,  
        [Channel] NVARCHAR(255),  
        [Email] NVARCHAR(255),  
        [Description] NVARCHAR(MAX),  
        [Created Contact ID] INT,  
        [Due Date] DATETIME,  
        [Journal Due Date] DATETIME,  
        [Journal Entered Date] DATETIME,  
        [Tax Date] DATETIME,  
        [Tax Reconciliation Date] DATETIME,  
        [Tax Code ID] NVARCHAR(50),  
        [Currency ID] INT,  
        [Exchange Rate] DECIMAL(18,6),  
        [Order ID] INT,  
        [Invoice Reference] NVARCHAR(255),  
        [Journal Type] NVARCHAR(50),  
        [Nominal Code] NVARCHAR(50),  
        [Nominal Code Name] NVARCHAR(255),  
        [Project ID] INT,  
        [Transaction Credit] DECIMAL(18,2),  
        [Transaction Debit] DECIMAL(18,2),  
        [Journal Credit] DECIMAL(18,2),  
        [Journal Debit] DECIMAL(18,2),  
        [Account Reference] NVARCHAR(255),  
        [Credit Limit] DECIMAL(18,2),  
        [Credit Term Days] INT,  
        [Financial Details Currency ID] INT,  
        [Discount Percent] DECIMAL(5,2),  
        [Lead Source ID] NVARCHAR(255),  
        [Lead Source] NVARCHAR(255),  
        [Price List ID] INT,  
        [Staff (Yes/No)] NVARCHAR(10),  
        [Supplier (Yes/No)] NVARCHAR(10),  
        [Trade Status] NVARCHAR(50)  
    );  
END;

-- Update existing records (DO NOT update Journal ID since it's a primary key)
UPDATE j
SET
    j.[Contact ID] = src.[Contact ID],  
    j.[Company] = src.[Company],  
    j.[First Name] = src.[First Name],  
    j.[Last Name] = src.[Last Name],  
    j.[Channel ID] = src.[Channel ID],  
    j.[Channel] = src.[Channel],  
    j.[Email] = src.[Email],  
    j.[Description] = src.[Description],  
    j.[Created Contact ID] = src.[Created Contact ID],  
    j.[Due Date] = src.[Due Date],  
    j.[Journal Due Date] = src.[Journal Due Date],  
    j.[Journal Entered Date] = src.[Journal Entered Date],  
    j.[Tax Date] = src.[Tax Date],  
    j.[Tax Reconciliation Date] = src.[Tax Reconciliation Date],  
    j.[Tax Code ID] = src.[Tax Code ID],  
    j.[Currency ID] = src.[Currency ID],  
    j.[Exchange Rate] = src.[Exchange Rate],  
    j.[Order ID] = src.[Order ID],  
    j.[Invoice Reference] = src.[Invoice Reference],  
    j.[Journal Type] = src.[Journal Type],  
    j.[Nominal Code] = src.[Nominal Code],  
    j.[Nominal Code Name] = src.[Nominal Code Name],  
    j.[Project ID] = src.[Project ID],  
    j.[Transaction Credit] = src.[Transaction Credit],  
    j.[Transaction Debit] = src.[Transaction Debit],  
    j.[Journal Credit] = src.[Journal Credit],  
    j.[Journal Debit] = src.[Journal Debit],  
    j.[Account Reference] = src.[Account Reference],  
    j.[Credit Limit] = src.[Credit Limit],  
    j.[Credit Term Days] = src.[Credit Term Days],  
    j.[Financial Details Currency ID] = src.[Financial Details Currency ID],  
    j.[Discount Percent] = src.[Discount Percent],  
    j.[Lead Source ID] = src.[Lead Source ID],  
    j.[Lead Source] = src.[Lead Source],  
    j.[Price List ID] = src.[Price List ID],  
    j.[Staff (Yes/No)] = src.[Staff (Yes/No)],  
    j.[Supplier (Yes/No)] = src.[Supplier (Yes/No)],  
    j.[Trade Status] = src.[Trade Status]  
FROM usr.Journals j  
JOIN (  
    SELECT DISTINCT  
        j.jou_id AS [Journal ID],  
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
        o.ord_projectId AS [Project ID],  
        CASE WHEN jt.jtr_creditDebit = 'C' THEN jt.jtr_transactionAmount ELSE NULL END AS [Transaction Credit],  
        CASE WHEN jt.jtr_creditDebit = 'D' THEN jt.jtr_transactionAmount ELSE NULL END AS [Transaction Debit],
        CASE WHEN jt.jtr_creditDebit = 'C' THEN jt.jtr_transactionAmount ELSE NULL END AS [Journal Credit],
        CASE WHEN jt.jtr_creditDebit = 'D' THEN jt.jtr_transactionAmount ELSE NULL END AS [Journal Debit],  
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
) AS src ON j.[Journal ID] = src.[Journal ID]
AND j.[Nominal Code] = src.[Nominal Code]
AND j.[Transaction Credit] = src.[Transaction Credit]
AND j.[Transaction Debit] = src.[Transaction Debit];

-- Insert new records if they don’t already exist
INSERT INTO usr.Journals (
    [Journal ID], [Contact ID], [Company], [First Name], [Last Name], [Channel ID], [Channel], [Email], 
    [Description], [Created Contact ID], [Due Date], [Journal Due Date], [Journal Entered Date], [Tax Date], [Tax Reconciliation Date], 
    [Tax Code ID], [Currency ID], [Exchange Rate], [Order ID], [Invoice Reference], [Journal Type], 
    [Nominal Code], [Nominal Code Name], [Project ID], [Transaction Credit], [Transaction Debit], [Journal Credit], [Journal Debit], 
    [Account Reference], [Credit Limit], [Credit Term Days], [Financial Details Currency ID], 
    [Discount Percent], [Lead Source ID], [Lead Source], [Price List ID], [Staff (Yes/No)], [Supplier (Yes/No)], [Trade Status]
)
SELECT DISTINCT  
    j.jou_id,  
    j.jou_contactId,  
    c.con_organisationName,  
    c.con_firstName,  
    c.con_lastName,  
    jtr_assignmentChannelId,  
    ch.chn_name,  
    c.con_emailsPRI,  
    j.jou_description,  
    j.jou_createdByContactId,  
    j.jou_dueDate,  
    j.jou_dueDate, 
    j.jou_createdOn,  
    j.jou_taxDate,  
    j.jou_taxReconciliationDate,  
    jt.jtr_taxCode,  
    j.jou_currencyId,  
    j.jou_exchangeRate,  
    jt.jtr_orderId,  
    jt.jtr_invoiceReference,  
    j.jou_journalTypeCode,  
    jt.jtr_nominalCode,  
    n.nom_name,  
    o.ord_projectId,  
    CASE WHEN jt.jtr_creditDebit = 'C' THEN jt.jtr_transactionAmount ELSE NULL END AS [Transaction Credit],  
    CASE WHEN jt.jtr_creditDebit = 'D' THEN jt.jtr_transactionAmount ELSE NULL END AS [Transaction Debit],
    CASE WHEN jt.jtr_creditDebit = 'C' THEN jt.jtr_transactionAmount ELSE NULL END AS [Journal Credit],
    CASE WHEN jt.jtr_creditDebit = 'D' THEN jt.jtr_transactionAmount ELSE NULL END AS [Journal Debit],  
    c.con_assignmentAccountReference,  
    c.con_financialDetailsCreditLimit,  
    c.con_financialDetailsCreditTermDays,  
    c.con_financialDetailsCurrencyId,  
    c.con_financialDetailsDiscountPercentage,  
    jtr_assignmentLeadSourceId,  
    ls.lsc_name,  
    c.con_financialDetailsPriceListID,  
    CASE WHEN con_isStaff = 0 THEN 'No' ELSE 'Yes' END,  
    CASE WHEN con_isStaff = 0 THEN 'No' ELSE 'Yes' END,  
    c.con_tradeStatus  
FROM dbo.tblJournal AS j  
LEFT JOIN dbo.tblJournalTransaction AS jt ON j.jou_id = jt.jtr_jou_id  
LEFT JOIN dbo.tblOrder AS o ON jt.jtr_orderId = o.ord_id  
LEFT JOIN dbo.tblContact AS c ON j.jou_contactId = c.con_id  
LEFT JOIN dbo.tblChannel AS ch ON jtr_assignmentChannelId = ch.chn_id  
LEFT JOIN dbo.tblNominal AS n ON jt.jtr_nominalCode = n.nom_code  
LEFT JOIN dbo.tblLeadSource AS ls ON c.con_assignmentLeadSourceId = ls.lsc_id  
WHERE NOT EXISTS (
    SELECT 1 
    FROM usr.Journals jn 
    WHERE 
        jn.[Journal ID] = j.jou_id 
        AND jn.[Nominal Code] = jt.jtr_nominalCode 
        AND ISNULL(jn.[Transaction Credit], 0) = ISNULL([Transaction Credit], 0) 
        AND ISNULL(jn.[Transaction Debit], 0) = ISNULL([Transaction Debit], 0)
);