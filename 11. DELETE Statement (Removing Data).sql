------------------------------------------------------------------------------------------------------------------------------------
-- 11. DELETE Statement (Removing Data)
------------------------------------------------------------------------------------------------------------------------------------
-- Deletes the row we inserted.  Use WHERE clause to specify which rows to delete!
DELETE FROM Person.Person
WHERE LastName = 'Doe';

-- Verify the delete
SELECT * FROM Person.Person WHERE LastName = 'Doe';