------------------------------------------------------------------------------------------------------------------------------------
-- 14.  EXISTS Operator
------------------------------------------------------------------------------------------------------------------------------------
-- Uses EXISTS to find products that have been sold at least once.
SELECT ProductID, Name
FROM Production.Product AS p
WHERE EXISTS (SELECT 1 FROM Sales.SalesOrderDetail AS sod WHERE p.ProductID = sod.ProductID);