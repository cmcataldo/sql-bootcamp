------------------------------------------------------------------------------------------------------------------------------------
-- 13. Subqueries
------------------------------------------------------------------------------------------------------------------------------------
-- Subquery in WHERE clause:  Find products that have a list price greater than the average list price.
SELECT ProductID, Name, ListPrice
FROM Production.Product
WHERE ListPrice > (SELECT AVG(ListPrice) FROM Production.Product)
ORDER BY ListPrice;

-- Subquery in FROM clause (Derived Table):  Find the total sales for each product category.
SELECT pc.Name AS CategoryName, TotalSales
FROM (SELECT sod.ProductID, SUM(LineTotal) AS TotalSales
      FROM Sales.SalesOrderDetail AS sod
      JOIN Production.Product AS p ON sod.ProductID = p.ProductID
      GROUP BY ProductID) AS SalesByCategory
JOIN Production.ProductCategory AS pc ON SalesByCategory.ProductID = pc.ProductCategoryID
ORDER BY TotalSales DESC;