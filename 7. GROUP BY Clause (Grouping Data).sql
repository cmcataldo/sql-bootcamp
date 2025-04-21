------------------------------------------------------------------------------------------------------------------------------------
-- 7. GROUP BY Clause (Grouping Data)
------------------------------------------------------------------------------------------------------------------------------------
-- Groups the Person.Person table by Title and counts the number of people for each title.
SELECT Title, COUNT(*) AS NumberOfPeople
FROM Person.Person
GROUP BY Title
ORDER BY NumberOfPeople DESC;

-- Example using SalesOrderHeader and CustomerID
SELECT CustomerID, SUM(TotalDue) AS TotalAmountDue
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY TotalAmountDue DESC;
