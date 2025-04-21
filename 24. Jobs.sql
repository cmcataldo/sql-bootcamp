USE AdventureWorks2022;
GO

-- 1. Declare variables
DECLARE @jobId BINARY(16);
DECLARE @jobName NVARCHAR(128);
DECLARE @stepName NVARCHAR(128);

-- 2. Set the job name
SET @jobName = N'Process AdventureWorks Sales Data';

-- 3. Insert a new job into sysjobs
BEGIN TRANSACTION
BEGIN TRY
    -- Insert the job
    INSERT INTO msdb.dbo.sysjobs (name, enabled, description)
    VALUES (@jobName, 1, N'This job processes sales data in the AdventureWorks database.');

    -- Get the job_id
    SELECT @jobId = job_id
    FROM msdb.dbo.sysjobs
    WHERE name = @jobName;

    -- 4. Add a job step to execute a stored procedure (or a series of commands)
    SET @stepName = N'Execute Sales Processing Logic';
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
        N'-- Your sales processing logic here.  For example:
          -- 1. Update sales order totals
          UPDATE Sales.SalesOrderHeader
          SET TotalDue = SubTotal + TaxAmt + Freight
          WHERE Status = 1; -- Only for orders that are not yet finalized

          -- 2. Insert into a sales summary table (example)
          -- INSERT INTO Sales.SalesSummary (OrderDate, TotalSales)
          -- SELECT OrderDate, SUM(TotalDue)
          -- FROM Sales.SalesOrderHeader
          -- WHERE OrderDate = CONVERT(DATE, GETDATE());

          -- 3.  Cleanup old data (Example)
          -- DELETE FROM  dbo.OldSalesData
          -- WHERE OrderDate < DATEADD(month, -6, GETDATE());
          ',
        N'AdventureWorks2022', -- Database name
        1,                   -- On success: Go to the next step (1 = Succeeded)
        2                    -- On failure: Quit reporting failure (2 = Failed)
    );

    -- 5. Schedule the job (optional - runs daily at 2:00 AM)
    INSERT INTO msdb.dbo.sysschedules (name, freq_type, freq_interval, active_start_time)
    VALUES (N'DailySalesProcessing', 4, 1, 20000); -- Daily, every 1 day, starting at 02:00

    DECLARE @schedule_id INT;
    SELECT @schedule_id = schedule_id FROM msdb.dbo.sysschedules WHERE name = N'DailySalesProcessing';

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
