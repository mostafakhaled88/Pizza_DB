/*=============================================================
  File: sp_load_raw_data.sql
  Procedure: sp_load_raw_data
  Purpose:
      - Bulk loads pizza sales data from CSV into PizzaSales_Raw
      - Clears old data before inserting new data
      - Reports number of rows inserted and execution time
==============================================================*/

USE PizzaDB;
GO

-- Drop existing procedure if exists
IF OBJECT_ID('sp_load_raw_data', 'P') IS NOT NULL
    DROP PROCEDURE sp_load_raw_data;
GO

CREATE PROCEDURE sp_load_raw_data
AS
BEGIN
    SET NOCOUNT ON; -- Prevent extra result sets

    DECLARE @StartTime DATETIME, @EndTime DATETIME, @RowsInserted INT;

    -- Record start time
    SET @StartTime = GETDATE();

    -- 1. Clear old data
    TRUNCATE TABLE PizzaSales_Raw;
    PRINT 'Old data cleared from PizzaSales_Raw.';

    -- 2. Load new data from CSV
    BULK INSERT PizzaSales_Raw
    FROM 'C:\SQLData\pizza_sales.csv'  -- <<< Change path to your CSV file
    WITH
    (
        FIRSTROW = 2,                -- Skip header row
        FIELDTERMINATOR = ',',       -- CSV delimiter
        ROWTERMINATOR = '\n',        -- Line break
        CODEPAGE = '65001',          -- UTF-8 encoding
        TABLOCK
    );

    -- 3. Get number of rows inserted
    SELECT @RowsInserted = COUNT(*) FROM PizzaSales_Raw;

    -- Record end time
    SET @EndTime = GETDATE();

    -- Print completion messages
    PRINT 'Raw data load completed successfully.';
    PRINT CONCAT('Total rows inserted: ', @RowsInserted);
    PRINT CONCAT('Time taken (seconds): ', DATEDIFF(SECOND, @StartTime, @EndTime));
END;
GO
