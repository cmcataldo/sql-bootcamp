------------------------------------------------------------------------------------------------------------------------------------
-- 2. WHERE Clause (Filtering)
------------------------------------------------------------------------------------------------------------------------------------
-- Retrieves rows from the Person.Person table where the FirstName is 'Ken'.
-- The WHERE clause is used to filter rows based on a condition.
SELECT FirstName, LastName
FROM Person.Person
WHERE FirstName = 'Ken';

-- Retrieves rows where the FirstName is 'Ken' AND the LastName is 'Sanchez'.
-- Demonstrates using AND to combine multiple conditions in the WHERE clause.
SELECT FirstName, LastName
FROM Person.Person
WHERE FirstName = 'Ken' AND LastName = 'Sanchez';

-- Retrieves rows where the FirstName is 'Ken' OR the FirstName is 'Terri'.
-- Demonstrates using OR to combine multiple conditions.
SELECT FirstName, LastName
FROM Person.Person
WHERE FirstName = 'Ken' OR FirstName = 'Terri';

-- Retrieves rows where the LastName starts with 'S'.
-- Demonstrates using the LIKE operator with a wildcard (%) to find a pattern.
SELECT FirstName, LastName
FROM Person.Person
WHERE LastName LIKE 'S%';

-- Retrieves rows where the LastName contains 'son'
SELECT FirstName, LastName
FROM Person.Person
WHERE LastName LIKE '%son%';

-- Retrieves rows where the BusinessEntityID is greater than 200 and less than 300
SELECT FirstName, LastName, BusinessEntityID
FROM Person.Person
WHERE BusinessEntityID > 200 AND BusinessEntityID < 300;

-- Retrieves rows where the BusinessEntityID is between 200 and 300 (inclusive)
SELECT FirstName, LastName, BusinessEntityID
FROM Person.Person
WHERE BusinessEntityID BETWEEN 200 AND 300;