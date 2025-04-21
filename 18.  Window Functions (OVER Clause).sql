------------------------------------------------------------------------------------------------------------------------------------
-- 18.  Window Functions (OVER Clause)
------------------------------------------------------------------------------------------------------------------------------------
-- ROW_NUMBER(): Assigns a unique sequential integer to each row within the partition.
-- Rank products within each category by ListPrice.
SELECT 
       ProductID,
       Name,
       ProductID,
       ListPrice,
       ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY ListPrice DESC) AS PriceRankInCategory
FROM Production.Product pp
ORDER BY pp.ProductID, ListPrice DESC;

-- RANK(): Assigns a rank to each row within the partition, with gaps for ties.
SELECT 
       ProductID,
       Name,
       ProductID,
       ListPrice,
       RANK() OVER (PARTITION BY ProductID ORDER BY ListPrice DESC) AS PriceRankInCategory
FROM Production.Product pp
ORDER BY pp.ProductID, ListPrice DESC;

-- DENSE_RANK(): Assigns a rank to each row within the partition, with no gaps for ties.
SELECT 
       ProductID,
       Name,
       ProductID,
       ListPrice,
       DENSE_RANK() OVER (PARTITION BY ProductID ORDER BY ListPrice DESC) AS PriceRankInCategory
FROM Production.Product pp
ORDER BY pp.ProductID, ListPrice DESC;

-- SUM() OVER():  Calculate a rolling sum of sales.
SELECT 
    SalesOrderID,
    OrderDate,
    TotalDue,
    SUM(TotalDue) OVER (ORDER BY OrderDate) AS RunningTotal
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '20110701' AND '20110831'
ORDER BY OrderDate;