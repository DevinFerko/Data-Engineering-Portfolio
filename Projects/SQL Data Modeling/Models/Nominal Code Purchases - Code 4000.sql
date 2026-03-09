DECLARE @startOfPreviousMonth DATE = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0);
DECLARE @startOfCurrentMonth DATE = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0);


SELECT 
                j.[Journal ID] AS [ID]
                ,o.[Tax Date]
                ,o.[Type]
                ,j.[Tax Code ID]
                ,CONCAT(j.[Nominal Code], ' ', j.[Nominal Code Name]) AS [Account]
                ,j.[Company] AS [Contact]
                ,o.[Channel Name]
                ,CASE
                    WHEN j.[Lead Source ID] = 8 THEN 'Live Chat'
                    WHEN j.[Lead Source ID] = 7 THEN 'Email'
                    WHEN j.[Lead Source ID] = 5 THEN 'Telephone'
                    WHEN j.[Lead Source ID] = 15 THEN 'Live Chat> Telephone'
                    WHEN j.[Lead Source ID] = 9 THEN '3D Design'
                    WHEN j.[Lead Source ID] = 14 THEN 'Consultation'
                    WHEN j.[Lead Source ID] = 12 THEN 'Showroom'
                    WHEN j.[Lead Source ID] = 13 THEN 'Outreach'
                    WHEN j.[Lead Source ID] = 16 THEN 'Project'
                    WHEN j.[Lead Source ID] = 10 THEN 'Yotpo'
                    ELSE 'Not set'
                    END AS [Lead Source]
                ,j.[Description] AS [Details]
                ,o.[Order ID]
                ,j.[Invoice Reference]
                ,CASE WHEN j.[Tax Reconciliation Date] IS NULL THEN 'No' ELSE 'Yes' END AS 'Reconciled'
                ,CASE WHEN j.[Tax Reconciliation Date] IS NULL THEN NULL ELSE j.[Tax Reconciliation Date] END AS [Tax Reconciliation Date]
                ,o.[Currency]
                ,j.[Journal Debit] AS [Debit]
                ,j.[Journal Credit] AS [Credit]
                ,j.[Journal Debit] AS [Base Debit]
                ,j.[Journal Credit] AS [Base Credit]
                ,j.[Exchange Rate]
            FROM usr.Orders as o
            LEFT JOIN usr.Journals AS j on o.[Order ID] = j.[Order ID]
            WHERE o.[Tax Date] >= @startOfPreviousMonth AND o.[Tax Date] < @startOfCurrentMonth
            AND j.[Nominal Code] = 4000
            ORDER BY o.[Tax Date];