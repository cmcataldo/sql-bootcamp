------------------------------------------------------------------------------------------------------------------------------------
-- 16.  CASE Statement (Conditional Logic)
------------------------------------------------------------------------------------------------------------------------------------
-- Use CASE to categorize products based on their ListPrice.
SELECT ProductID, Name, ListPrice,
       CASE
           WHEN ListPrice < 50 THEN 'Low Price'
           WHEN ListPrice >= 50 AND ListPrice < 200 THEN 'Medium Price'
           WHEN ListPrice >= 200 THEN 'High Price'
           ELSE 'Unknown'
       END AS PriceCategory
FROM Production.Product
ORDER BY ListPrice;