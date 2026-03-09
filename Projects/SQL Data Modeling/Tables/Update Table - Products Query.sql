-- Ensure the table exists before altering
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Products' AND TABLE_SCHEMA = 'usr')
BEGIN
    CREATE TABLE usr.Products 
    (  
        [Product ID] INT PRIMARY KEY
        ,[SKU] NVARCHAR(255)
        ,[Brand] NVARCHAR(255)
        ,[Barcode] NVARCHAR(255)
        ,[Ean] NVARCHAR(255)
        ,[Isbn] NVARCHAR(255)
        ,[Mpn] NVARCHAR(255)
        ,[Upc] NVARCHAR(255)
        ,[Name] NVARCHAR(255)
        ,[Bundle (Yes / No)] NVARCHAR(255)
        ,[Category ID] NVARCHAR(255)
        ,[Category] NVARCHAR(255)
        ,[Reporting Category] NVARCHAR(255)
        ,[Subcategory ID] INT
        ,[Sub Category] NVARCHAR(255)
        ,[Created Time] DATETIME
        ,[Height] DECIMAL(18,6)
        ,[Length] DECIMAL(18,6)
        ,[Volume] DECIMAL(18,6)
        ,[Width] DECIMAL(18,6)
        ,[Weight] DECIMAL(18,6)
        ,[Nominal Code Purchases] INT
        ,[Nominal Code Sales] INT
        ,[Nominal Code Stock] INT
        ,[Primary Supplier ID] INT
        ,[Supplier First Name] NVARCHAR(255)
        ,[Supplier Last Name] NVARCHAR(255)
        ,[Organisation Name] NVARCHAR(255)
        ,[Sales Channel] NVARCHAR(255)
        ,[Short Description] NVARCHAR(255)
        ,[Status] NVARCHAR(255)
        ,[Tax Code] NVARCHAR(255)
        ,[Type] INT
        --,[Currency ID] INT
        --,[Currency Code] NVARCHAR(255)
        --,[Price List ID] INT
        --,[Price List Name] NVARCHAR(255)
        --,[Price] DECIMAL(18,6)
        --,[Name] NVARCHAR(255)
        --,[Value ID] INT
        --,[Value] NVARCHAR(255) 
    );  
END;

-- Update existing records (DO NOT update Journal ID since it's a primary key)
UPDATE p
SET
    p.[Product ID] = src.[Product ID]
    ,p.[SKU] = src.[SKU]
    ,p.[Brand] = src.[Brand]
    ,p.[Barcode] = src.[Barcode]
    ,p.[Ean] = src.[Ean]
    ,p.[Isbn] = src.[Isbn]
    ,p.[Mpn] = src.[Mpn]
    ,p.[Upc] = src.[Upc]
    ,p.[Name] = src.[Name]
    ,p.[Bundle (Yes / No)] = src.[Bundle (Yes / No)]
    ,p.[Category ID] = src.[Category ID]
    ,p.[Category] = src.[Category]
    ,p.[Reporting Category] = src.[Reporting Category]
    ,p.[Subcategory ID] = src.[Subcategory ID]
    ,p.[Sub Category] = src.[Sub Category]
    ,p.[Created Time] = src.[Created Time]
    ,p.[Height] = src.[Height]
    ,p.[Length] = src.[Length]
    ,p.[Volume] = src.[Volume]
    ,p.[Width] = src.[Width]
    ,p.[Weight] = src.[Weight]
    ,p.[Nominal Code Purchases] = src.[Nominal Code Purchases]
    ,p.[Nominal Code Sales] = src.[Nominal Code Sales]
    ,p.[Nominal Code Stock] = src.[Nominal Code Stock]
    ,p.[Primary Supplier ID] = src.[Primary Supplier ID]
    ,p.[Supplier First Name] = src.[Supplier First Name]
    ,p.[Supplier Last Name] = src.[Supplier Last Name]
    ,p.[Organisation Name] = src.[Organisation Name]
    ,p.[Sales Channel] = src.[Sales Channel]
    ,p.[Short Description] = src.[Short Description]
    ,p.[Status] = src.[Status]
    ,p.[Tax Code] = src.[Tax Code]
    ,p.[Type] = src.[Type]
    --,p.[Currency ID] = src.[Currency ID]
    --,p.[Currency Code] = src.[Currency Code]
    --,p.[Price List ID] = src.[Price List ID]
    --,p.[Price List Name] = src.[Price List Name]
    --,p.[Price] = src.[Price]
    --,p.[Name] = src.[Name]
    --,p.[Value ID] = src.[Value ID]
    --,p.[Value] = src.[Value]

FROM usr.Products p  
JOIN (
    SELECT DISTINCT
    [Product ID] = prd_id
    ,[SKU] = prd_identitySKU
    ,[Brand] = brd_name
    ,[Barcode] = prd_identityBarcode
    ,[Ean] = prd_identityEAN
    ,[Isbn] = prd_identityISBN
    ,[Mpn] = prd_identityMPN
    ,[Upc] = prd_identityUPC
    ,[Name] = prd_firstChannelProductName
    ,[Bundle (Yes / No)] = CASE WHEN prd_bundle = 0 THEN 'No' ELSE 'Yes' END
    ,[Category ID] = prd_reportingCategoryId
    ,[Category] = bct_name
    ,[Reporting Category] = prd_reportingCategoryId
    ,[Subcategory ID] = prd_reportingSubcategoryId
    ,[Sub Category] = bct_name
    ,[Created Time] = prd_createdOn
    ,[Height] = prd_height
    ,[Length] = prd_length
    ,[Volume] = prd_volume
    ,[Width] = prd_width
    ,[Weight] = prd_weight
    ,[Nominal Code Purchases] = prd_nominalCodePurchases
    ,[Nominal Code Sales] = prd_nominalCodeSales
    ,[Nominal Code Stock] = prd_nominalCodeStock
    ,[Primary Supplier ID] = prd_primarySupplierId
    ,[Supplier First Name] = con_firstName
    ,[Supplier Last Name] = con_lastName
    ,[Organisation Name] = con_organisationName
    ,[Sales Channel] = psc_salesChannelName
    ,[Short Description] = prd_shortDescription
    ,[Status] = prd_status
    ,[Tax Code] = prd_financialDetailsTaxCodeCode
    ,[Type] = prd_productTypeId
    --,[Currency ID] = prp_currencyId
    --,[Currency Code] = prp_currencyCode
    --,[Price List ID] = prp_priceListId
    --,[Price List Name] = prc_name
    --,[Price] = prp_price1
    --,[Name] = pcf_name
    --,[Value ID] = pcf_id
    --,[Value] = pcf_value

    FROM
        dbo.tblProduct

    LEFT JOIN dbo.tblBrand ON prd_brandId = brd_id
    LEFT JOIN dbo.tblBrightpearlCategory ON prd_reportingCategoryId = bct_id
    LEFT JOIN dbo.tblProductSalesChannel ON prd_id = psc_prd_id
    LEFT JOIN dbo.tblProductPrice ON prd_id = prp_productId
    --LEFT JOIN dbo.tblPriceList ON prp_priceListId = prc_id   
    --LEFT JOIN dbo.tblProductCustomField ON prd_id = pcf_prd_id
    LEFT JOIN dbo.tblContact ON prd_primarySupplierId = con_id
) AS src ON p.[Product ID] = src.[Product ID];

-- Insert new records if they don’t already exist
INSERT INTO usr.Products (
        [Product ID], [SKU], [Brand], [Barcode], [Ean], [Isbn], [Mpn], [Upc], [Name], [Bundle (Yes / No)], [Category ID], [Category],
        [Reporting Category], [Subcategory ID], [Sub Category], [Created Time], [Height], [Length], [Volume], [Width], [Weight], [Nominal Code Purchases], 
        [Nominal Code Sales], [Nominal Code Stock], [Primary Supplier ID], [Supplier First Name], [Supplier Last Name], [Organisation Name], [Sales Channel], 
        [Short Description], [Status], [Tax Code], [Type] 
        --[Currency ID], 
        --[Currency Code]
)

SELECT DISTINCT  
    prd_id
    ,prd_identitySKU
    ,brd_name
    ,prd_identityBarcode
    ,prd_identityEAN
    ,prd_identityISBN
    ,prd_identityMPN
    ,prd_identityUPC
    ,prd_firstChannelProductName
    ,CASE WHEN prd_bundle = 0 THEN 'No' ELSE 'Yes' END
    ,prd_reportingCategoryId
    ,bct_name
    ,prd_reportingCategoryId
    ,prd_reportingSubcategoryId
    ,bct_name
    ,prd_createdOn
    ,prd_height
    ,prd_length
    ,prd_volume
    ,prd_width
    ,prd_weight
    ,prd_nominalCodePurchases
    ,prd_nominalCodeSales
    ,prd_nominalCodeStock
    ,prd_primarySupplierId
    ,con_firstName
    ,con_lastName
    ,con_organisationName
    ,psc_salesChannelName
    ,prd_shortDescription
    ,prd_status
    ,prd_financialDetailsTaxCodeCode
    ,prd_productTypeId
    --,prp_currencyId
    --,prp_currencyCode
    --,prp_priceListId
    --,prc_name
    --,prp_price1
    --,pcf_name
    --,pcf_id
    --,pcf_value

FROM
    dbo.tblProduct AS p

LEFT JOIN dbo.tblBrand ON prd_brandId = brd_id
LEFT JOIN dbo.tblBrightpearlCategory ON prd_reportingCategoryId = bct_id
LEFT JOIN dbo.tblProductSalesChannel ON prd_id = psc_prd_id
LEFT JOIN dbo.tblProductPrice ON prd_id = prp_productId
--LEFT JOIN dbo.tblPriceList ON prp_priceListId = prc_id   
--LEFT JOIN dbo.tblProductCustomField ON prd_id = pcf_prd_id
LEFT JOIN dbo.tblContact ON prd_primarySupplierId = con_id      
WHERE NOT EXISTS (
    SELECT 1 
    FROM usr.Products pr 
    WHERE 
        pr.[Product ID] = p.prd_id
);