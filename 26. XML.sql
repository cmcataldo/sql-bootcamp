USE AdventureWorks2022;
GO

-- 1. Working with XML in SQL Server
--    This section demonstrates how to query and manipulate XML data within SQL Server.

-- A. Querying XML data using XQuery
--    The following query retrieves product names and model descriptions from the
--    Production.ProductModel table, where the CatalogDescription column contains XML data.

SELECT
    ProductModelID,
    Name AS ProductName,
    CatalogDescription.value('(/ProductDescription/Summary)[1]', 'NVARCHAR(MAX)') AS ProductSummary,
    CatalogDescription.query('/ProductDescription/Features/Feature') AS ProductFeaturesXML,
    CatalogDescription
FROM Production.ProductModel
WHERE CatalogDescription IS NOT NULL;

GO

-- B. Modifying XML data using XQuery
--    This script updates the CatalogDescription XML in the Production.ProductModel table
--    by adding a new feature.
DECLARE @ProductModelID INT = 19; -- Example ProductModelID
DECLARE @NewFeature NVARCHAR(MAX) = N'<Feature>High Performance</Feature>';

UPDATE Production.ProductModel
SET CatalogDescription.modify('insert into (/ProductDescription/Features)[1]
                                 after (/ProductDescription/Features/Feature)[last()]
                                 ' + @NewFeature)
WHERE ProductModelID = @ProductModelID;

GO

-- C. Creating XML using FOR XML
--    This query retrieves product review data and formats it as an XML document.
SELECT
    pr.ProductID AS '@ProductID',  -- Attribute in the XML
    p.Name AS 'ProductName',
    pr.ReviewerName AS 'Reviewer',
    pr.Rating,
    pr.Comments
FROM Production.ProductReview AS pr
INNER JOIN Production.Product AS p ON pr.ProductID = p.ProductID
WHERE pr.ProductID IN (707, 708)  -- Limiting to specific products for demonstration
ORDER BY pr.ProductID, pr.ReviewDate
FOR XML PATH ('Review'), ROOT ('ProductReviews');

GO


-- 2. Using CLR Integration (C#) with SQL Server
--    This section demonstrates how to create and use a CLR stored procedure.
--    Note:  CLR integration needs to be enabled on the SQL Server instance.
--    This example assumes you have a C# assembly (MySqlClrLibrary.dll) deployed
--    to the SQL Server instance.  The C# code would contain a function to
--    concatenate strings.  Creating the C# DLL and deploying it is outside
--    the scope of this SQL script.

-- A. Create a CLR stored procedure in SQL Server
-- CREATE ASSEMBLY MySqlClrLibrary
-- FROM 'C:\MyAssemblies\MySqlClrLibrary.dll'  --  Path to your DLL
-- WITH PERMISSION_SET = SAFE;
-- GO

-- CREATE PROCEDURE dbo.ConcatenateStringsCLR
--     @string1 NVARCHAR (MAX),
--     @string2 NVARCHAR (MAX),
--     @result NVARCHAR (MAX) OUTPUT
-- AS EXTERNAL NAME MySqlClrLibrary.UserDefinedFunctions.ConcatenateStrings;
-- GO

-- B. Execute the CLR stored procedure
-- DECLARE @resultString NVARCHAR(MAX);
-- EXEC dbo.ConcatenateStringsCLR
--     @string1 = 'Hello, ',
--     @string2 = 'World!',
--     @result = @resultString OUTPUT;
-- SELECT @resultString AS ResultString;
-- GO

-- 3. Using SQL Server with JSON
-- This section demonstrates how to work with JSON data in SQL Server

--A. Creating JSON data
SELECT
    p.ProductID,
    p.Name AS ProductName,
    p.ProductNumber,
    p.Color,
    p.ListPrice
FROM Production.Product AS p
WHERE p.ProductID IN (707, 708, 709)
FOR JSON AUTO;

GO

--B. Querying JSON Data
DECLARE @json NVARCHAR(MAX);
SET @json = N'[
    {
        "ProductID": 707,
        "ProductName": "HL Road Touring - Red, 58",
        "ProductNumber": "HL-R68",
        "Color": "Red",
        "ListPrice": 3399.99
    },
    {
        "ProductID": 708,
        "ProductName": "HL Road Touring - Red, 62",
        "ProductNumber": "HL-R72",
        "Color": "Red",
        "ListPrice": 3399.99
    },
    {
        "ProductID": 709,
        "ProductName": "HL Road Touring - Black, 58",
        "ProductNumber": "HL-R58",
        "Color": "Black",
        "ListPrice": 3399.99
    }
]';

SELECT
    ProductID,
    ProductName,
    Color,
    ListPrice
FROM OPENJSON(@json)
WITH (
    ProductID INT '$.ProductID',
    ProductName NVARCHAR(100) '$.ProductName',
    Color NVARCHAR(20) '$.Color',
    ListPrice DECIMAL(10,2) '$.ListPrice'
);
GO
