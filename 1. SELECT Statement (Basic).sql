------------------------------------------------------------------------------------------------------------------------------------
-- 1. SELECT Statement (Basic)
------------------------------------------------------------------------------------------------------------------------------------
-- Retrieves all columns and all rows from the Person.Person table.
-- This is the most basic form of the SELECT statement.
SELECT *
FROM Person.Person;

-- Retrieves specific columns (FirstName, LastName, BusinessEntityID) from the Person.Person table.
-- This demonstrates how to select only the columns you need.
SELECT FirstName, LastName, BusinessEntityID
FROM Person.Person;