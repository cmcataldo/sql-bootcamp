USE AdventureWorks2022;
GO

-- Create a new database for the data warehouse
CREATE DATABASE AdventureWorksDW2022;
GO

USE AdventureWorksDW2022;
GO

-- 1. Create Dimension Tables
--    Dimension tables hold descriptive attributes that are used to analyze data in the fact table.

-- A. DimDate
--    A date dimension table is essential for time-based analysis.
CREATE TABLE dbo.DimDate (
    DateKey INT PRIMARY KEY,
    FullDate DATE,
    DayOfMonth INT,
    DayName VARCHAR(20),
    DayOfWeek INT,
    Month INT,
    MonthName VARCHAR(20),
    Quarter INT,
    Year INT,
    IsWeekend BIT
);
GO

-- Populate DimDate (for a 10-year range)
DECLARE @StartDate DATE = '2020-01-01';
DECLARE @EndDate DATE = '2029-12-31';
DECLARE @CurrentDate DATE = @StartDate;

WHILE @CurrentDate <= @EndDate
BEGIN
    INSERT INTO dbo.DimDate (
        DateKey,
        FullDate,
        DayOfMonth,
        DayName,
        DayOfWeek,
        Month,
        MonthName,
        Quarter,
        Year,
        IsWeekend
    )
    VALUES (
        CONVERT(INT, REPLACE(CONVERT(VARCHAR(10), @CurrentDate, 112), '.', '')), -- YYYYMMDD
        @CurrentDate,
        DAY(@CurrentDate),
        DATENAME(DAY, @CurrentDate),
        DATEPART(WEEKDAY, @CurrentDate),
        MONTH(@CurrentDate),
        DATENAME(MONTH, @CurrentDate),
        DATEPART(QUARTER, @CurrentDate),
        YEAR(@CurrentDate),
        CASE WHEN DATEPART(WEEKDAY, @CurrentDate) IN (1, 7) THEN 1 ELSE 0 END -- 1=Sunday, 7=Saturday
    );
    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
END;
GO

-- B. DimProduct
--    Product dimension table from Production.Product
CREATE TABLE dbo.DimProduct (
    ProductKey INT PRIMARY KEY IDENTITY,
    ProductID INT,
    ProductName NVARCHAR(256),
    ProductNumber NVARCHAR(25),
    Color NVARCHAR(15),
    ListPrice MONEY,
    Size NVARCHAR(50),
    ProductLine NVARCHAR(50),
    ModelName NVARCHAR(256),
    CategoryName NVARCHAR(256)
);
GO

-- Populate DimProduct
INSERT INTO dbo.DimProduct (
    ProductID,
    ProductName,
    ProductNumber,
    Color,
    ListPrice,
    Size,
    ProductLine,
    ModelName,
    CategoryName
)
SELECT
    p.ProductID,
    p.Name,
    p.ProductNumber,
    p.Color,
    p.ListPrice,
    p.Size,
    p.ProductLine,
    pm.Name AS ModelName,
    pc.Name AS CategoryName
FROM AdventureWorks2022.Production.Product AS p
LEFT JOIN AdventureWorks2022.Production.ProductModel AS pm
    ON p.ProductModelID = pm.ProductModelID
LEFT JOIN AdventureWorks2022.Production.ProductSubcategory AS psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
LEFT JOIN AdventureWorks2022.Production.ProductCategory AS pc
    ON psc.ProductCategoryID = pc.ProductCategoryID;
GO

-- C. DimCustomer
--    Customer dimension table from Sales.Customer and Person.Person
CREATE TABLE dbo.DimCustomer (
    CustomerKey INT PRIMARY KEY IDENTITY,
    CustomerID INT,
    PersonID INT,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Gender NCHAR(1),
    EmailAddress NVARCHAR(50),
    PhoneNumber NVARCHAR(25),
    City NVARCHAR(30),
    StateProvinceName NVARCHAR(50),
    CountryRegionName NVARCHAR(50)
);
GO

-- Populate DimCustomer
INSERT INTO dbo.DimCustomer (
    CustomerID,
    PersonID,
    FirstName,
    LastName,
    Gender,
    EmailAddress,
    PhoneNumber,
    City,
    StateProvinceName,
    CountryRegionName
)
SELECT
    c.CustomerID,
    c.PersonID,
    p.FirstName,
    p.LastName,
    p.Demographics.value('(/Individual/Gender)[1]', 'NCHAR(1)') AS Gender,
    e.EmailAddress,
    pp.PhoneNumber,
    a.City,
    sp.Name AS StateProvinceName,
    cr.Name AS CountryRegionName
FROM AdventureWorks2022.Sales.Customer AS c
INNER JOIN AdventureWorks2022.Person.Person AS p
    ON c.PersonID = p.BusinessEntityID
LEFT JOIN AdventureWorks2022.Person.EmailAddress AS e
    ON p.BusinessEntityID = e.BusinessEntityID
LEFT JOIN AdventureWorks2022.Person.PersonPhone AS pp
    ON p.BusinessEntityID = pp.BusinessEntityID
LEFT JOIN AdventureWorks2022.Person.BusinessEntityAddress AS bea
	ON p.BusinessEntityID = bea.BusinessEntityID
LEFT JOIN AdventureWorks2022.Person.Address AS a
	ON bea.AddressID = a.AddressID
LEFT JOIN AdventureWorks2022.Person.StateProvince AS sp
	ON a.StateProvinceID = sp.StateProvinceID
LEFT JOIN AdventureWorks2022.Person.CountryRegion AS cr
	ON sp.CountryRegionCode = cr.CountryRegionCode;
GO

-- 2. Create Fact Table
--    The fact table stores the measurements or metrics that result from business events.

-- A. FactSalesOrder
--    This fact table stores sales order information.
CREATE TABLE dbo.FactSalesOrder (
    SalesOrderKey INT PRIMARY KEY IDENTITY,
    SalesOrderID INT,
    DateKey INT FOREIGN KEY REFERENCES dbo.DimDate(DateKey),
    CustomerKey INT FOREIGN KEY REFERENCES dbo.DimCustomer(CustomerKey),
    ProductKey INT FOREIGN KEY REFERENCES dbo.DimProduct(ProductKey),
    OrderQty SMALLINT,
    UnitPrice MONEY,
    LineTotal MONEY,
    TaxAmt MONEY,
    Freight MONEY,
    TotalDue MONEY
);
GO

-- Populate FactSalesOrder
INSERT INTO dbo.FactSalesOrder (
    SalesOrderID,
    DateKey,
    CustomerKey,
    ProductKey,
    OrderQty,
    UnitPrice,
    LineTotal,
    TaxAmt,
    Freight,
    TotalDue
)
SELECT
    soh.SalesOrderID,
    CONVERT(INT, REPLACE(CONVERT(VARCHAR(10), soh.OrderDate, 112), '.', '')), -- YYYYMMDD
    dc.CustomerKey,
    dp.ProductKey,
    sod.OrderQty,
    sod.UnitPrice,
    sod.LineTotal,
    soh.TaxAmt,
    soh.Freight,
    soh.TotalDue
FROM AdventureWorks2022.Sales.SalesOrderHeader AS soh
INNER JOIN AdventureWorks2022.Sales.SalesOrderDetail AS sod
    ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN dbo.DimCustomer AS dc
    ON soh.CustomerID = dc.CustomerID
INNER JOIN dbo.DimProduct AS dp
    ON sod.ProductID = dp.ProductID;
GO
