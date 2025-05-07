USE AdventureWorks2022;
GO

-- Create a local temporary table to store product sales summary
CREATE TABLE #ProductSalesSummary (
    ProductID INT,
    ProductName NVARCHAR(256),
    TotalSales MONEY
);

-- Populate the local temporary table
INSERT INTO #ProductSalesSummary (ProductID, ProductName, TotalSales)
SELECT
    p.ProductID,
    p.Name,
    SUM(sod.LineTotal) AS TotalSales
FROM Production.Product AS p
JOIN Sales.SalesOrderDetail AS sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE soh.OrderDate >= DATEADD(year, -1, GETDATE()) -- Sales in the last year
GROUP BY p.ProductID, p.Name;

-- Create a global temporary table to store top-selling products
CREATE TABLE ##TopSellingProducts (
    ProductID INT,
    ProductName NVARCHAR(256),
    TotalSales MONEY,
    Rank INT
);

-- Populate the global temporary table with top 10 products from the local temp table
INSERT INTO ##TopSellingProducts (ProductID, ProductName, TotalSales, Rank)
SELECT TOP 10
    ProductID,
    ProductName,
    TotalSales,
    RANK() OVER (ORDER BY TotalSales DESC) AS Rank
FROM #ProductSalesSummary
ORDER BY TotalSales DESC;

-- Query the local temporary table to show all products
SELECT 'All Products (Last Year)' AS Source, *
FROM #ProductSalesSummary
ORDER BY TotalSales DESC;

-- Query the global temporary table to show the top 10 products
SELECT 'Top 10 Selling Products' AS Source, *
FROM ##TopSellingProducts;

-- Demonstrate using the global temp table in a separate query (simulating a different session)
-- In a real scenario, you'd open a new query window in SSMS to see this
SELECT 'Top 10 Products (Again)' AS Source, *
FROM ##TopSellingProducts
WHERE Rank <= 5;

-- Drop the local temporary table
DROP TABLE #ProductSalesSummary;

-- Drop the global temporary table
DROP TABLE ##TopSellingProducts;
GO