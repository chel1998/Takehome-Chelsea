WITH UserPurchaseStats AS (
	-- Calculate total spending, purchase frequency, and oldest account age
	SELECT 
		t.USER_ID,
		COUNT(t.RECEIPT_ID) AS total_purchases, -- Count total number of purchases
		COUNT(DISTINCT FORMAT(t.PURCHASE_DATE, 'yyyy-MM')) as purchase_frequency, -- Count unique months with purchases
		SUM(t.FINAL_SALE) as total_sales, -- Total amount spent by users
		DATEDIFF(YEAR, u.CREATED_DATE, GETDATE()) as account_age -- Account age in years
	FROM 
		Transactions as t
	INNER JOIN
		Users as u ON t.USER_ID = u.ID
	GROUP BY
		t.user_id, u.CREATED_DATE
),
TopSpenders AS (
	-- Identify users in the top 10% of total sales
	SELECT
		USER_ID
	FROM
		UserPurchaseStats
	WHERE
		total_sales >= (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY total_sales) OVER ())
),
TopBrands AS (
	-- Calculate the price dynamically
	SELECT TOP 5 p.BRAND,
				AVG(CASE
					WHEN t.FINAL_QUANTITY = 0 THEN 0
					ELSE t.FINAL_SALE/ t.FINAL_QUANTITY
				END) AS avg_price
			FROM Products AS p
			INNER JOIN Transactions AS t ON p.BARCODE = t.BARCODE
			GROUP BY p.BRAND
			ORDER BY avg_price DESC
),
LoyalPremiumBuyers AS (
	-- Identify users who frequently buy premium brands
	SELECT 
		t.USER_ID
	FROM
		Transactions AS t
	INNER JOIN
		Products AS p ON t.BARCODE = p.BARCODE
	WHERE
		p.BRAND IN (SELECT tb.BRAND FROM TopBrands AS tb)
	GROUP BY
		t.USER_ID
	HAVING
		COUNT(DISTINCT p.BRAND) <= 2 -- Ensure brand Loyalty by limiting to 1-2 brands
)
SELECT
	ups.USER_ID,
	ups.account_age,
	ups.total_purchases,
	ups.purchase_frequency,
	ups.total_sales
FROM
	UserPurchaseStats AS ups
INNER JOIN
	TopSpenders ts ON ups.user_id = ts.user_id
-- INNER JOIN
-- LoyalPremiumBuyers lpb ON ups.user_id = lpb.user_id
WHERE
	ups.account_age >= 2
	AND ups.purchase_frequency > = 2
ORDER BY
	ups.total_sales DESC;
				