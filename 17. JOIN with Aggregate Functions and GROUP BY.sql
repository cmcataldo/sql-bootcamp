------------------------------------------------------------------------------------------------------------------------------------
-- 17.  JOIN with Aggregate Functions and GROUP BY
------------------------------------------------------------------------------------------------------------------------------------
-- Joining multiple tables and using aggregate functions with GROUP BY.
-- Find the total quantity of each product sold, and order by the quantity.
SELECT p.Name AS ProductName, SUM(sod.OrderQty) AS TotalQuantitySold
FROM Production.Product AS p
INNER JOIN Sales.SalesOrderDetail AS sod ON p.ProductID = sod.ProductID
INNER JOIN Sales.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE soh.OrderDate BETWEEN '20110101' AND '20111231'
GROUP BY p.Name
ORDER BY TotalQuantitySold DESC;