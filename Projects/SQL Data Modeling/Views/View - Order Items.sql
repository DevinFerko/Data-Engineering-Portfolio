CREATE OR ALTER VIEW usr.OrderItemsView
AS
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
    FROM dbo.tblOrderLine
    LEFT JOIN dbo.tblOrder ON orl_ord_id = ord_id
    LEFT JOIN dbo.tblProduct ON orl_ProductId = prd_id