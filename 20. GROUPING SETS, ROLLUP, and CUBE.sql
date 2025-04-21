------------------------------------------------------------------------------------------------------------------------------------
-- 20.  GROUPING SETS, ROLLUP, and CUBE
------------------------------------------------------------------------------------------------------------------------------------
-- GROUPING SETS: Allows you to specify multiple grouping options in a single query.
SELECT
    SalesPersonID,
    CustomerID,
    SUM(TotalDue) AS TotalDue
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL
GROUP BY GROUPING SETS (SalesPersonID, CustomerID, (SalesPersonID, CustomerID))
ORDER BY SalesPersonID, CustomerID;

-- ROLLUP:  Generates subtotals for hierarchical grouping.
SELECT
    SalesPersonID,
    CustomerID,
    SUM(TotalDue) AS TotalDue
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL
GROUP BY ROLLUP (SalesPersonID, CustomerID)
ORDER BY SalesPersonID, CustomerID;

-- CUBE: Generates all possible subtotals for all combinations of the specified columns.
SELECT
    SalesPersonID,
    CustomerID,
    SUM(TotalDue) AS TotalDue
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL
GROUP BY CUBE (SalesPersonID, CustomerID)
ORDER BY SalesPersonID, CustomerID;