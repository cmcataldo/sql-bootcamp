------------------------------------------------------------------------------------------------------------------------------------
-- 9. INSERT Statement (Adding Data)
------------------------------------------------------------------------------------------------------------------------------------
-- Inserts a new row into the Person.Person table.  You'll need to provide values for the columns.
-- Note:  You should replace the values with valid data.  BusinessEntityID must be unique.
INSERT INTO Person.Person (BusinessEntityID, PersonType, FirstName, LastName)
VALUES (20000, 'EM', 'John', 'Doe');  --  <--- Replace with your values.

-- Verify the insert (and then delete it in the next section)
SELECT * FROM Person.Person WHERE FirstName = 'John' AND LastName = 'Doe';