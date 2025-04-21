------------------------------------------------------------------------------------------------------------------------------------
-- 19.  Common Table Expressions (CTEs)
------------------------------------------------------------------------------------------------------------------------------------
-- CTE to find the average order value for each customer, and then select customers with orders above the average.
WITH CustomerOrderTotals AS (
    SELECT CustomerID, SUM(TotalDue) AS TotalOrderValue
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
),
AverageOrderValue AS (
    SELECT AVG(TotalOrderValue) AS AvgOrderValue
    FROM CustomerOrderTotals
)
SELECT cot.CustomerID, cot.TotalOrderValue
FROM CustomerOrderTotals AS cot
JOIN AverageOrderValue AS aov ON cot.TotalOrderValue > aov.AvgOrderValue
ORDER BY cot.TotalOrderValue DESC;