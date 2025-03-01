WITH YearlySales AS (
	SELECT
		YEAR(t.PURCHASE_DATE) AS sales_year,
		SUM(t.FINAL_SALE) AS annual_sales
	FROM Transactions as t
	GROUP BY YEAR(t.PURCHASE_DATE)
) ,
YoYGrowth AS (
	SELECT
		a.sales_year AS current_year,
		a.annual_sales AS current_sales,
		b.annual_sales AS previous_sales,
		((a.annual_sales - b.annual_sales) * 100.0/ ISNULL(b.annual_sales, 0)) AS yoy_growth_percent
	FROM YearlySales a
	LEFT JOIN YearlySales b ON a.sales_year = b.sales_year + 1
)
SELECT * FROM YoYGrowth
ORDER BY current_year DESC;