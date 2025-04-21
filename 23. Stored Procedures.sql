USE AdventureWorks2022;  -- Or your specific AdventureWorks version

GO -- Important: Separates the CREATE PROCEDURE batch from other statements.

-- =============================================
-- Author:      Your Name or Company Name
-- Create date: <Creation Date, YYYY-MM-DD>
-- Description:	This stored procedure retrieves employee information
--              from the HumanResources.Employee table
-- =============================================
CREATE PROCEDURE dbo.GetEmployeeDetails
    -- Add the parameters for the stored procedure here
    @EmployeeID INT = NULL,  -- Input parameter: Employee ID (optional)
    @LastName NVARCHAR(50) = NULL -- Input parameter: Last Name (optional)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Declare variables for error handling
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    BEGIN TRY
        -- Select statement to retrieve employee details
        SELECT
            e.BusinessEntityID AS EmployeeID,
            p.FirstName,
            p.LastName,
            e.JobTitle,
            e.HireDate,
            e.OrganizationLevel,
            d.Name AS DepartmentName
        FROM HumanResources.Employee AS e
        INNER JOIN Person.Person AS p
            ON e.BusinessEntityID = p.BusinessEntityID
        INNER JOIN HumanResources.EmployeeDepartmentHistory AS edh
            ON e.BusinessEntityID = edh.BusinessEntityID
        INNER JOIN HumanResources.Department AS d
            ON edh.DepartmentID = d.DepartmentID
        WHERE 1 = 1  -- Start with a condition that is always true
            -- Add conditions based on input parameters
            AND (@EmployeeID IS NULL OR e.BusinessEntityID = @EmployeeID)
            AND (@LastName IS NULL OR p.LastName = @LastName)
        ORDER BY p.LastName, p.FirstName;

    END TRY
    BEGIN CATCH
        -- Assign error information to variables.
        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        -- Raise the error.
        RAISERROR (@ErrorMessage, -- Message text.
                   @ErrorSeverity, -- Severity.
                   @ErrorState     -- State.
                   );
    END CATCH;

    -- Added a comment here to indicate the end of the stored procedure.
END;
GO
-- Example execution:
-- To execute the stored procedure without any parameters (returns all employees):
-- EXEC dbo.GetEmployeeDetails;

-- To execute the stored procedure with an EmployeeID:
-- EXEC dbo.GetEmployeeDetails @EmployeeID = 1;

-- To execute the stored procedure with a Last Name:
-- EXEC dbo.GetEmployeeDetails @LastName = 'Johnson';

-- To execute the stored procedure with both EmployeeID and Last Name:
-- EXEC dbo.GetEmployeeDetails @EmployeeID = 1, @LastName = 'Johnson';