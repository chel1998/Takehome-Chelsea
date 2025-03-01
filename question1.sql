SELECT TOP 5 p.BRAND, COUNT(t.RECEIPT_ID) as total_receipts
FROM Users as u
JOIN Transactions as t 
	ON u.ID = t.USER_ID
JOIN Products as p
	ON p.BARCODE = t.BARCODE
WHERE u.AGE >= 21
GROUP BY p.BRAND
ORDER BY total_receipts DESC;