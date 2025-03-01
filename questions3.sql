WITH UserGeneration AS (
    SELECT
		u.ID,
        CASE
            WHEN u.AGE BETWEEN 0 AND 24 THEN 'Gen Z'
            WHEN u.AGE BETWEEN 25 AND 40 THEN 'Millennials'
            WHEN u.AGE BETWEEN 41 AND 56 THEN 'Gen X'
            WHEN u.AGE BETWEEN 57 AND 75 THEN 'Baby Boomers'
            ELSE 'Silent' 
        END AS generation
	 FROM Users as u)
SELECT
	ug.generation,
	SUM(CASE WHEN p.CATEGORY_1 = 'Health & Wellness' THEN t.FINAL_SALE ELSE 0 END) AS health_and_wellness_sales,
	SUM(t.FINAL_SALE) AS total_sales,
	(SUM(CASE WHEN p.CATEGORY_1 = 'Health & Wellness' THEN t.FINAL_SALE ELSE 0 END) / SUM(t.FINAL_SALE)) * 100 AS percentage_of_sales
FROM UserGeneration as ug
JOIN Transactions as t 
	ON ug.ID = t.USER_ID
JOIN Products as p
	ON p.BARCODE = t.BARCODE
GROUP BY ug.generation;
