------------------------------------------------------------------------------------------------------------------------------------
-- 8. HAVING Clause (Filtering Groups)
------------------------------------------------------------------------------------------------------------------------------------
-- Groups the Person.Person table by Title and counts the number of people for each title,
-- but only includes titles where the count is greater than 100.  HAVING filters the result of the GROUP BY.
SELECT Title, COUNT(*) AS NumberOfPeople
FROM Person.Person
GROUP BY Title
HAVING COUNT(*) > 100
ORDER BY NumberOfPeople DESC;

-- Example using SalesOrderHeader
SELECT CustomerID, SUM(TotalDue) AS TotalAmountDue
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING SUM(TotalDue) > 100000  -- Only show customers with total orders greater than 100000
ORDER BY TotalAmountDue DESC;