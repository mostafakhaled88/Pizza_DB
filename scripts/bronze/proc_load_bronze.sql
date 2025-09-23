/*
=============================================================
Procedure: bronze.Load_PizzaSales
=============================================================
Purpose:
    - Automates refresh of Bronze layer data.
    - Steps:
        1. Clear both staging and final bronze tables.
        2. Bulk insert raw CSV into staging (all VARCHAR).
        3. Insert from staging into bronze.PizzaSales 
           with proper type casting.
    - Tracks execution time for monitoring.

Inputs:
    - CSV File: C:\SQLData\pizza_sales\pizza_sales.csv

Outputs:
    - Reloaded bronze.PizzaSales with clean datatypes.

Notes:
    - Uses TRY_CAST for safe conversion (invalid values → NULL).
=============================================================
*/
CREATE OR ALTER PROCEDURE bronze.Load_PizzaSales
AS
BEGIN
    SET NOCOUNT ON;

    ---------------------------------------------------------
    -- Track start time
    ---------------------------------------------------------
    DECLARE @StartTime DATETIME2 = SYSDATETIME();
    DECLARE @EndTime   DATETIME2;
    DECLARE @ElapsedMs INT;

    ---------------------------------------------------------
    -- 1. Clear existing data
    ---------------------------------------------------------
    TRUNCATE TABLE bronze.PizzaSales_Staging;
    TRUNCATE TABLE bronze.PizzaSales;

    ---------------------------------------------------------
    -- 2. Bulk insert raw CSV into Staging (all text)
    ---------------------------------------------------------
    BULK INSERT bronze.PizzaSales_Staging
    FROM 'C:\SQLData\pizza_sales.csv'
    WITH
    (
        FIRSTROW = 2,              -- Skip header row
        FIELDTERMINATOR = ',',     -- CSV delimiter
        ROWTERMINATOR = '0x0d0a',  -- Windows line break
        TABLOCK,                   -- Performance optimization
        CODEPAGE = '65001'         -- UTF-8 encoding support
    );

    ---------------------------------------------------------
    -- 3. Insert into final Bronze table with type casting
    ---------------------------------------------------------
    INSERT INTO bronze.PizzaSales
    (
        pizza_id, order_id, pizza_name_id, quantity,
        order_date, order_time, unit_price, total_price,
        pizza_size, pizza_category, pizza_ingredients, pizza_name
    )
    SELECT
        TRY_CAST(pizza_id AS INT),
        TRY_CAST(order_id AS INT),
        pizza_name_id,
        TRY_CAST(quantity AS INT),
        TRY_CAST(order_date AS DATE),   -- safe date parse
        TRY_CAST(order_time AS TIME),   -- safe time parse
        TRY_CAST(unit_price AS DECIMAL(7,2)),
        TRY_CAST(total_price AS DECIMAL(10,2)),
        pizza_size,
        pizza_category,
        pizza_ingredients,
        pizza_name
    FROM bronze.PizzaSales_Staging;

    ---------------------------------------------------------
    -- Track end time & print duration
    ---------------------------------------------------------
    SET @EndTime = SYSDATETIME();
    SET @ElapsedMs = DATEDIFF(MILLISECOND, @StartTime, @EndTime);

    PRINT 'Bronze.PizzaSales refresh completed successfully';
    PRINT 'Execution Time (ms): ' + CAST(@ElapsedMs AS VARCHAR(20));
END;
GO
