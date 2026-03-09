-- Step 1: Create the table if it doesn't exist
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'OrderItems' AND TABLE_SCHEMA = 'usr')
BEGIN
    CREATE TABLE usr.OrderItems (
        [Order Line ID] INT,
        [Order Id] INT,
        [Parent Order Row Id] INT,
        [Product ID] INT,
        [Product SKU] NVARCHAR(255),
        [Bundle Parent (Yes / No)] NVARCHAR(10),
        [Bundle Child (Yes / No)] NVARCHAR(10),
        [Bundle Product] NVARCHAR(255),
        [Currency Code] NVARCHAR(10),
        [Cost Currency Code] NVARCHAR(10),
        [Price Currency Code] NVARCHAR(10),
        [Amount] DECIMAL(18,2),
        [Tax] DECIMAL(18,2),
        [Discount] DECIMAL(18,2),
        [Unit Cost] DECIMAL(18,2),
        [Cost] DECIMAL(18,2),
        [Price] DECIMAL(18,2),
        [Quantity] INT,
        [Name] NVARCHAR(255),
        [Nominal Code] NVARCHAR(50),
        [Order Time] DATETIME,
        [Tax Code] NVARCHAR(50),
        [Tax Rate] DECIMAL(5,2),
        PRIMARY KEY ([Order Line ID]) -- Assuming this combination is unique
    )
END

-- Step 2: Update existing records
UPDATE target
SET 
    target.[Order Id] = source.[Order Id],
    target.[Parent Order Row Id] = source.[Parent Order Row Id],
    target.[Product ID] = source.[Product ID],
    target.[Product SKU] = source.[Product SKU],
    target.[Bundle Parent (Yes / No)] = source.[Bundle Parent (Yes / No)],
    target.[Bundle Child (Yes / No)] = source.[Bundle Child (Yes / No)],
    target.[Bundle Product] = source.[Bundle Product],
    target.[Currency Code] = source.[Currency Code],
    target.[Cost Currency Code] = source.[Cost Currency Code],
    target.[Price Currency Code] = source.[Price Currency Code],
    target.[Amount] = source.[Amount],
    target.[Tax] = source.[Tax],
    target.[Discount] = source.[Discount],
    target.[Unit Cost] = source.[Unit Cost],
    target.[Cost] = source.[Cost],
    target.[Price] = source.[Price],
    target.[Quantity] = source.[Quantity],
    target.[Name] = source.[Name],
    target.[Nominal Code] = source.[Nominal Code],
    target.[Order Time] = source.[Order Time],
    target.[Tax Code] = source.[Tax Code],
    target.[Tax Rate] = source.[Tax Rate]
FROM usr.OrderItems AS target
INNER JOIN (
    -- Source Data
    SELECT DISTINCT
        orl_id AS [Order Line ID],
        orl_ord_id AS [Order Id],
        orl_parentOrderRowId AS [Parent Order Row Id],
        orl_productId AS [Product ID],
        orl_productSku AS [Product SKU],
        CASE WHEN orl_compositionBundleParent = 0 THEN 'No' ELSE 'Yes' END AS [Bundle Parent (Yes / No)],
        CASE WHEN orl_compositionBundleChild = 0 THEN 'No' ELSE 'Yes' END AS [Bundle Child (Yes / No)],
        CASE WHEN prd_compositionBundle = 0 THEN 'No' ELSE 'Yes' END AS [Bundle Product],
        orl_rowNetCurrencyCode AS [Currency Code],
        orl_itemCostCurrencyCode AS [Cost Currency Code],
        orl_itemCostCurrencyCode AS [Price Currency Code],
        orl_rowNetValue AS [Amount],
        orl_rowTaxValue AS [Tax],
        orl_discountPercentage AS [Discount],
        orl_itemCostValue AS [Unit Cost],
        (orl_itemCostValue * orl_quantity) AS [Cost],
        orl_productPriceValue AS [Price],
        orl_quantity AS [Quantity],
        orl_productName AS [Name],
        orl_nominalCode AS [Nominal Code],
        ord_placedOn AS [Order Time],
        orl_taxCode AS [Tax Code],
        orl_taxRate AS [Tax Rate]
    FROM dbo.tblOrderLine -- Using usr schema
    LEFT JOIN dbo.tblOrder ON orl_ord_id = ord_id
    LEFT JOIN dbo.tblProduct ON orl_ProductId = prd_id
) source 
ON target.[Order Line ID] = source.[Order Line ID] 

-- Step 3: Insert new rows
INSERT INTO usr.OrderItems (
    [Order Line ID], [Order Id], [Parent Order Row Id], [Product ID], [Product SKU], 
    [Bundle Parent (Yes / No)], [Bundle Child (Yes / No)], [Bundle Product], 
    [Currency Code], [Cost Currency Code], [Price Currency Code], [Amount], 
    [Tax], [Discount], [Unit Cost], [Cost], [Price], [Quantity], [Name], 
    [Nominal Code], [Order Time], [Tax Code], [Tax Rate]
)
SELECT DISTINCT
    orl_id, orl_ord_id, orl_parentOrderRowId, orl_productId, orl_productSku, 
    CASE WHEN orl_compositionBundleParent = 0 THEN 'No' ELSE 'Yes' END, 
    CASE WHEN orl_compositionBundleChild = 0 THEN 'No' ELSE 'Yes' END, 
    CASE WHEN prd_compositionBundle = 0 THEN 'No' ELSE 'Yes' END, 
    orl_rowNetCurrencyCode, orl_itemCostCurrencyCode, 
    orl_itemCostCurrencyCode, orl_rowNetValue,  orl_rowTaxValue, orl_discountPercentage, 
    orl_itemCostValue, (orl_itemCostValue * orl_quantity), orl_productPriceValue, 
    orl_quantity, orl_productName, orl_nominalCode, ord_placedOn, orl_taxCode, 
    orl_taxRate
FROM dbo.tblOrderLine 
LEFT JOIN dbo.tblOrder ON orl_ord_id = ord_id
LEFT JOIN dbo.tblProduct ON orl_ProductId = prd_id
WHERE NOT EXISTS (
    SELECT 1 FROM usr.OrderItems target
    WHERE target.[Order Line ID] = tblOrderLine.orl_id
)
