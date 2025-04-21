------------------------------------------------------------------------------------------------------------------------------------
-- 15.  ALL Operator
------------------------------------------------------------------------------------------------------------------------------------
-- ALL: Find products with a ListPrice greater than ALL of the ListPrices of product category 14.
SELECT ProductID, Name, ListPrice
FROM Production.Product
WHERE ListPrice > ALL (SELECT ListPrice FROM Production.Product WHERE ProductID = 14);