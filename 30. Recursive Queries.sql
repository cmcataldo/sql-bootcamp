USE AdventureWorks2022;
GO

-- Recursive query to display the employee hierarchy
WITH EmployeeHierarchy AS (
    -- Anchor member: Select the top-level employees (those with no reports to)
    SELECT
        BusinessEntityID,
        LoginID,
        OrganizationNode,
        ManagerID,
        FirstName,
        LastName,
        0 AS Level,  -- Start at level 0
        CAST(FirstName + ' ' + LastName AS VARCHAR(MAX)) AS FullNamePath
    FROM HumanResources.Employee AS e
    JOIN Person.Person AS p ON e.BusinessEntityID = p.BusinessEntityID
    WHERE ManagerID IS NULL

    UNION ALL

    -- Recursive member: Select the employees who report to those in the previous level
    SELECT
        e.BusinessEntityID,
        e.LoginID,
        e.OrganizationNode,
        e.ManagerID,
        p.FirstName,
        p.LastName,
        Level + 1,  -- Increment the level for each recursion
        CAST(eh.FullNamePath + ' -> ' + p.FirstName + ' ' + p.LastName AS VARCHAR(MAX)) AS FullNamePath
    FROM HumanResources.Employee AS e
    JOIN Person.Person AS p ON e.BusinessEntityID = p.BusinessEntityID
    INNER JOIN EmployeeHierarchy AS eh ON e.ManagerID = eh.BusinessEntityID
)
-- Select the results from the recursive CTE
SELECT
    BusinessEntityID,
    LoginID,
    OrganizationNode,
    ManagerID,
    FirstName,
    LastName,
    Level,
    FullNamePath
FROM EmployeeHierarchy
ORDER BY OrganizationNode;
GO
