USE AdventureWorks2022;
GO

-- =============================================
-- Author:      Your Name or Company Name
-- Create date: <Creation Date, YYYY-MM-DD>
-- Description:	This view retrieves sales order details, combining
--              information from SalesOrderHeader and SalesOrderDetail.
-- =============================================
CREATE VIEW dbo.SalesOrderDetailsView
AS
-- Select the columns you want in the view
SELECT
    soh.SalesOrderID,
    soh.OrderDate,
    soh.CustomerID,
    p.FirstName + ' ' + p.LastName AS CustomerName,  -- Get customer name
    sod.SalesOrderDetailID,
    sod.ProductID,
    prod.Name AS ProductName,             -- Get product name
    sod.OrderQty,
    sod.UnitPrice,
    sod.LineTotal,
    soh.TotalDue
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesOrderDetail AS sod
    ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Production.Product AS prod
    ON sod.ProductID = prod.ProductID
INNER JOIN Sales.Customer AS c
    ON soh.CustomerID = c.CustomerID
INNER JOIN Person.Person AS p
    ON c.PersonID = p.BusinessEntityID;
GO

-- Example usage of the view:
-- SELECT * FROM dbo.SalesOrderDetailsView
-- WHERE OrderDate >= '2023-01-01';
