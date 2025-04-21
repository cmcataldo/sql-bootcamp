------------------------------------------------------------------------------------------------------------------------------------
-- 3. ORDER BY Clause (Sorting)
------------------------------------------------------------------------------------------------------------------------------------
-- Retrieves all columns from Person.Person and sorts the results by LastName in ascending order (default).
SELECT *
FROM Person.Person
ORDER BY LastName;

-- Sorts the results by LastName in descending order.
SELECT *
FROM Person.Person
ORDER BY LastName DESC;

-- Sorts by LastName ascending, then FirstName ascending.
SELECT *
FROM Person.Person
ORDER BY LastName ASC, FirstName ASC;
