SELECT [BundleID]=p.prd_id
      ,[BundleSKU]=p.prd_identitySKU
	  ,[BundleName]=p.prd_firstChannelProductName
      ,[ComponentID]=pbc_child_prd_id
      ,[ComponentSKU]=c.prd_identitySKU
	  ,[ComponentName]=c.prd_firstChannelProductName
      ,[ComponentQty]=pbc_child_qty
	  ,[ComponentUnitWeight]=c.prd_weight
      ,[TotalComponentWeight]=c.prd_weight*pbc_child_qty
      ,[ComponentUnitCost]=ISNULL(com_cos.prp_price1,0)
      ,[TotalComponentCost]=ISNULL(com_cos.prp_price1,0)*pbc_child_qty
      ,[ComponentSalesPrice]=ISNULL(com_sel.prp_price1,0)
      ,[TotalSalesPrice]=ISNULL(com_sel.prp_price1,0)*pbc_child_qty
      ,[ComponentMargin]=CASE WHEN ISNULL(com_sel.prp_price1,0) > 0 THEN (ISNULL(com_sel.prp_price1,0)-ISNULL(com_cos.prp_price1,0))/ISNULL(com_sel.prp_price1,0) ELSE NULL END
      ,[BundleSalesPrice]=ISNULL(bun_sel.prp_price1,0)
      ,[BundleTotalMargin]=margin_total
      ,[BundleDiscount]=bundle_discount
FROM dbo.tblProduct p
JOIN dbo.tblProductBundleComponent ON pbc_prd_id=p.prd_id
JOIN dbo.tblProduct c ON pbc_child_prd_id=c.prd_id
JOIN dbo.tblProductPrice com_cos ON com_cos.prp_productId=pbc_child_prd_id
JOIN dbo.tblProductPrice com_sel ON com_sel.prp_productId=pbc_child_prd_id
JOIN dbo.tblProductPrice bun_sel ON bun_sel.prp_productId=p.prd_id

LEFT JOIN (
	SELECT parent_prd_id
	      ,[margin_total]=CASE WHEN AVG(parent_sell)<>0 THEN (AVG(parent_sell)-SUM(child_cost_qty))/AVG(parent_sell) ELSE NULL END
	      ,[bundle_discount]=CASE WHEN SUM(child_sell_qty)<>0 THEN (SUM(child_sell_qty)-AVG(parent_sell))/SUM(child_sell_qty) ELSE NULL END
	      ,[item_cost_sum]=SUM(child_cost_qty)
	      ,[item_sell_sum]=SUM(child_sell_qty)
	FROM (
		SELECT p.prd_id AS parent_prd_id
		      ,[child_cost_qty]=ISNULL(com_cos.prp_price1,0)*pbc_child_qty
		      ,[child_sell_qty]=ISNULL(com_sel.prp_price1,0)*pbc_child_qty
		      ,[parent_sell]=ISNULL(bun_sel.prp_price1,0)
		FROM dbo.tblProduct p
		JOIN dbo.tblProductBundleComponent ON pbc_prd_id=p.prd_id
		JOIN dbo.tblProduct c ON pbc_child_prd_id=c.prd_id
		JOIN dbo.tblProductPrice com_cos ON com_cos.prp_productId=pbc_child_prd_id
		JOIN dbo.tblProductPrice com_sel ON com_sel.prp_productId=pbc_child_prd_id
		JOIN dbo.tblProductPrice bun_sel ON bun_sel.prp_productId=p.prd_id
		WHERE 1=1
		AND com_cos.prp_priceListId=1
		AND com_sel.prp_priceListId=3
		AND bun_sel.prp_priceListId=3
	) qTotals
	GROUP BY parent_prd_id
) qTotals ON qTotals.parent_prd_id = P.prd_id

WHERE 1=1
AND p.prd_status<>'ARCHIVED'
AND com_cos.prp_priceListId=1
AND com_sel.prp_priceListId=3
AND bun_sel.prp_priceListId=3