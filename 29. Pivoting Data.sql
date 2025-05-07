USE AdventureWorks2022;
GO

-- Pivot query to show sales by territory and year
SELECT
    SalesTerritoryRegion,  -- Non-pivoted column
    [2020],             -- Pivoted columns
    [2021],
    [2022]
FROM
(
    -- Subquery to get the data to be pivoted
    SELECT
        st.Name AS SalesTerritoryRegion,
        YEAR(soh.OrderDate) AS SalesYear,
        SUM(soh.TotalDue) AS SalesAmount
    FROM Sales.SalesOrderHeader AS soh
    JOIN Sales.SalesTerritory AS st
        ON soh.TerritoryID = st.TerritoryID
    WHERE soh.OrderDate BETWEEN '20200101' AND '20221231'  -- Limiting to the years we want
    GROUP BY
        st.Name,
        YEAR(soh.OrderDate)
) AS SourceTable
PIVOT
(
    -- Aggregation function and column to aggregate
    SUM(SalesAmount)
    FOR SalesYear IN ([2020], [2021], [2022])  -- Column to pivot and values to become columns
) AS PivotTable;
GO
