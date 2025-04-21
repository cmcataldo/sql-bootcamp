------------------------------------------------------------------------------------------------------------------------------------
-- 12. JOINs (Combining Tables)
------------------------------------------------------------------------------------------------------------------------------------
-- INNER JOIN: Retrieves rows that have matching values in both tables.
-- Joins Person.Person and Sales.Customer on BusinessEntityID and PersonID
SELECT p.FirstName, p.LastName, c.CustomerID
FROM Person.Person AS p
INNER JOIN Sales.Customer AS c ON p.BusinessEntityID = c.PersonID;

-- LEFT JOIN (or LEFT OUTER JOIN): Returns all rows from the left table, and the matched rows from the right table.
-- If there is no match, the columns from the right table will be NULL.
SELECT p.FirstName, p.LastName, c.CustomerID
FROM Person.Person AS p
LEFT JOIN Sales.Customer AS c ON p.BusinessEntityID = c.PersonID;

-- RIGHT JOIN (or RIGHT OUTER JOIN):  Returns all rows from the right table, and the matched rows from the left table.
SELECT p.FirstName, p.LastName, c.CustomerID
FROM Person.Person AS p
RIGHT JOIN Sales.Customer AS c ON p.BusinessEntityID = c.PersonID;

-- FULL OUTER JOIN: Returns all rows when there is a match in either the left or right table.
SELECT p.FirstName, p.LastName, c.CustomerID
FROM Person.Person AS p
FULL OUTER JOIN Sales.Customer AS c ON p.BusinessEntityID = c.PersonID;

-- CROSS JOIN:  Returns the Cartesian product of the tables.  Every row in the first table is combined with every row in the second table.
--  Use with caution, as this can produce very large result sets!
SELECT p.FirstName, p.LastName, st.Name AS TerritoryName
FROM Person.Person AS p
CROSS JOIN Sales.SalesTerritory AS st;

-- Self Join: Join a table to itself.
-- Find all pairs of employees who live in the same city.  This requires joining the Person.Person table to itself
SELECT
    e1.FirstName + ' ' + e1.LastName AS Employee1,
    e2.FirstName + ' ' + e2.LastName AS Employee2
FROM
    Person.Person AS e1
INNER JOIN
    Person.Person AS e2 ON e1.BusinessEntityID <> e2.BusinessEntityID  -- Make sure they are not the same person
INNER JOIN
    Person.BusinessEntityAddress AS bea1 ON e1.BusinessEntityID = bea1.BusinessEntityID
INNER JOIN
    Person.Address AS a1 ON bea1.AddressID = a1.AddressID
INNER JOIN
    Person.BusinessEntityAddress AS bea2 ON e2.BusinessEntityID = bea2.BusinessEntityID
INNER JOIN
    Person.Address AS a2 ON bea2.AddressID = a2.AddressID
WHERE
    a1.City = a2.City
ORDER BY Employee1;