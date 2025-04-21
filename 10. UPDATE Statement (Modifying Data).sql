------------------------------------------------------------------------------------------------------------------------------------
-- 10. UPDATE Statement (Modifying Data)
------------------------------------------------------------------------------------------------------------------------------------
-- Updates the FirstName of the row we just inserted.
UPDATE Person.Person
SET FirstName = 'Jonathan'
WHERE LastName = 'Doe';

-- Verify the update
SELECT * FROM Person.Person WHERE LastName = 'Doe';