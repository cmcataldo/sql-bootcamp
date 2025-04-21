------------------------------------------------------------------------------------------------------------------------------------
-- 21. More Subquery Examples
------------------------------------------------------------------------------------------------------------------------------------

-- 21.1 Subquery in SELECT clause: returning a single value
-- Get the name of each product and its average list price.
SELECT
    p.Name AS ProductName,
    (SELECT AVG(ListPrice) FROM Production.Product) AS AverageListPrice
FROM Production.Product AS p;

-- 21.2 Subquery in SELECT clause: correlated subquery
-- Get the name of each product and its category's average list price.
SELECT
    p.Name AS ProductName,
    (SELECT AVG(ListPrice) FROM Production.Product WHERE ProductID = p.ProductID) AS CategoryAverageListPrice
FROM Production.Product AS p;

-- 21.3 Subquery with EXISTS:
-- Find all vendors who sell a product.
SELECT DISTINCT v.Name AS VendorName
FROM Purchasing.Vendor AS v
WHERE EXISTS (
    SELECT 1
    FROM Purchasing.ProductVendor AS pv
    WHERE v.BusinessEntityID = pv.BusinessEntityID
);

-- 21.4 Correlated Subquery with NOT EXISTS:
-- Find products that have never been sold.
SELECT p.ProductID, p.Name AS ProductName
FROM Production.Product AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM Sales.SalesOrderDetail AS sod
    WHERE p.ProductID = sod.ProductID
);

-- 21.5 Subquery returning a table (used with IN):
-- Find all employees in the same cities as 'Ken Sanchez'.
SELECT FirstName, LastName, City
FROM Person.Person AS p
JOIN Person.BusinessEntityAddress AS bea ON p.BusinessEntityID = bea.BusinessEntityID
JOIN Person.Address AS a ON bea.AddressID = a.AddressID
WHERE a.City IN (
    SELECT a2.City
    FROM Person.Person AS p2
    JOIN Person.BusinessEntityAddress AS bea2 ON p2.BusinessEntityID = bea2.BusinessEntityID
    JOIN Person.Address AS a2 ON bea2.AddressID = a2.AddressID
    WHERE p2.FirstName = 'Ken' AND p2.LastName = 'Sanchez'
);