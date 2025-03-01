SELECT TOP 5 p.BRAND, SUM(t.FINAL_SALE) as total_sales
FROM Transactions as t
INNER JOIN Products as p
	ON t.BARCODE = p.BARCODE
WHERE p.CATEGORY_2 = 'Dips & Salsa'
GROUP BY p.BRAND
ORDER BY total_sales DESC;