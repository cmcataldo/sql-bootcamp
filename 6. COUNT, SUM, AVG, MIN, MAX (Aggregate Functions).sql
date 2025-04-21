------------------------------------------------------------------------------------------------------------------------------------
-- 6. COUNT, SUM, AVG, MIN, MAX (Aggregate Functions)
------------------------------------------------------------------------------------------------------------------------------------
-- COUNT: Counts the total number of rows in the Person.Person table.
SELECT COUNT(*) AS TotalPeople
FROM Person.Person;

-- COUNT with WHERE: Counts the number of people with FirstName 'Ken'.
SELECT COUNT(*) AS Kens
FROM Person.Person
WHERE FirstName = 'Ken';

-- SUM:  This will give an error because there is no numeric column in Person.Person to sum.
--       It is included here to show the syntax.  A working example is shown later.
-- SELECT SUM(SomeNumericColumn) AS Total -- FROM Person.Person
-- SUM Example (using SalesOrderHeader - requires joining)
SELECT SUM(TotalDue) AS TotalSalesAmount
FROM Sales.SalesOrderHeader;

-- AVG:  Same as SUM, this will error in Person.Person
-- SELECT AVG(SomeNumericColumn) AS Average -- FROM Person.Person
-- AVG Example
SELECT AVG(TotalDue) AS AverageOrderAmount
FROM Sales.SalesOrderHeader;

-- MIN: Finds the minimum BusinessEntityID
SELECT MIN(BusinessEntityID) AS SmallestID
FROM Person.Person;

-- MAX: Finds the maximum BusinessEntityID
SELECT MAX(BusinessEntityID) AS LargestID
FROM Person.Person;