USE AdventureWorks2022;
GO

-- 1. Declare variables
DECLARE @jobId BINARY(16);
DECLARE @jobName NVARCHAR(128);
DECLARE @stepName NVARCHAR(128);
DECLARE @SQLCommand NVARCHAR(MAX);

-- 2. Set the job name
SET @jobName = N'Process AdventureWorks Sales Data (Dynamic SQL)';

-- 3. Insert a new job into sysjobs
BEGIN TRANSACTION
BEGIN TRY
    -- Insert the job
    INSERT INTO msdb.dbo.sysjobs (name, enabled, description)
    VALUES (@jobName, 1, N'This job processes sales data in the AdventureWorks database using dynamic SQL.');

    -- Get the job_id
    SELECT @jobId = job_id
    FROM msdb.dbo.sysjobs
    WHERE name = @jobName;

    -- 4. Add a job step to execute dynamic SQL
    SET @stepName = N'Execute Dynamic Sales Processing Logic';

    -- Construct the dynamic SQL command
    SET @SQLCommand = N'
        -- Begin dynamic SQL block
        USE AdventureWorks2022;

        -- 1. Update sales order totals
        UPDATE Sales.SalesOrderHeader
        SET TotalDue = SubTotal + TaxAmt + Freight
        WHERE Status = 1; -- Only for orders that are not yet finalized
        PRINT ''Sales order totals updated.'';

        -- 2. Insert into a sales summary table (example)
        -- Important:  Use CONVERT(DATE, GETDATE()) for date consistency
        INSERT INTO Sales.SalesSummary (OrderDate, TotalSales)
        SELECT CONVERT(DATE, OrderDate), SUM(TotalDue)
        FROM Sales.SalesOrderHeader
        WHERE OrderDate = CONVERT(DATE, GETDATE())
        GROUP BY CONVERT(DATE, OrderDate);
        PRINT ''Sales summary updated.'';

        -- 3.  Cleanup old data (Example)
        -- DELETE FROM  dbo.OldSalesData  --  Assume this table exists
        -- WHERE OrderDate < DATEADD(month, -6, GETDATE());
        -- PRINT ''Old data cleaned up.'';

        -- End dynamic SQL block
    ';

    INSERT INTO msdb.dbo.sysjobsteps (
        job_id,
        step_id,
        step_name,
        subsystem,
        command,
        database_name,
        on_success_action,
        on_fail_action
    )
    VALUES (
        @jobId,             -- job_id of the job
        1,                   -- Step ID (1 for the first step)
        @stepName,          -- Name of the step
        N'TSQL',            -- Subsystem (TSQL for Transact-SQL)
        @SQLCommand,        -- The dynamic SQL command string
        N'master',          -- Important:  Use master, the command explicitly uses AdventureWorks
        1,                   -- On success: Go to the next step
        2                    -- On failure: Quit reporting failure
    );

    -- 5. Schedule the job (optional - runs daily at 2:00 AM)
    INSERT INTO msdb.dbo.sysschedules (name, freq_type, freq_interval, active_start_time)
    VALUES (N'DailySalesProcessingDynamic', 4, 1, 20000);

    DECLARE @schedule_id INT;
    SELECT @schedule_id = schedule_id FROM msdb.dbo.sysschedules WHERE name = N'DailySalesProcessingDynamic';

    INSERT INTO msdb.dbo.sysjobservers (job_id, server_id, schedule_id, last_run_date, last_run_time, last_run_outcome)
    VALUES (@jobId, 0, @schedule_id, 0, 0, 0);

    COMMIT TRANSACTION;
    PRINT 'Job created successfully!';
END TRY
BEGIN CATCH
    -- If there's an error, rollback the transaction
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    -- Print the error message
    PRINT 'Error creating job: ' + ERROR_MESSAGE();
    THROW; -- Re-throw the error to the caller
END CATCH;
GO
