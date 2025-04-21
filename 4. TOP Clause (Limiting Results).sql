------------------------------------------------------------------------------------------------------------------------------------
-- 4. TOP Clause (Limiting Results)
------------------------------------------------------------------------------------------------------------------------------------
-- Retrieves the top 10 rows from the Person.Person table.
SELECT TOP 10 *
FROM Person.Person;

-- Retrieves the top 5 rows, ordered by LastName.
SELECT TOP 5 FirstName, LastName
FROM Person.Person
ORDER BY LastName;