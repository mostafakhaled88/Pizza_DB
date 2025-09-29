-- =============================================
---File:sp_load_pizza_sales_clean
---Procedure: sp_load_pizza_sales_clean
-- Description:   Cleans and loads pizza sales data from raw table into a deduplicated, type-correct Silver table
-- =============================================
CREATE OR ALTER PROCEDURE sp_load_pizza_sales_clean
AS
BEGIN
    SET NOCOUNT ON;  -- Prevent extra result sets from interfering with output

    -- =============================================
    -- Step 0: Record start time for execution timing
    -- =============================================
    DECLARE @StartTime DATETIME = GETDATE();
    DECLARE @RowCount INT;

    -- =============================================
    -- Step 1: Drop existing Silver table if it exists
    -- =============================================
    IF OBJECT_ID('dbo.PizzaSales_Clean', 'U') IS NOT NULL
        DROP TABLE dbo.PizzaSales_Clean;

    -- =============================================
    -- Step 2: Create the cleaned Silver table
    -- =============================================
    CREATE TABLE dbo.PizzaSales_Clean (
        pizza_id INT,
        order_id INT,
        pizza_name_id VARCHAR(50),
        quantity INT,
        order_date DATE,
        order_time TIME,
        unit_price DECIMAL(10,2),
        total_price DECIMAL(10,2),
        pizza_size VARCHAR(10),
        pizza_category VARCHAR(50),
        pizza_ingredients VARCHAR(2000),   -- extended to prevent truncation
        pizza_name VARCHAR(255)            -- extended to prevent truncation
    );

    -- =============================================
    -- Step 3: Deduplicate and convert data types
    -- =============================================
    ;WITH CTE_Dedup AS (
        SELECT 
            pizza_id,
            order_id,
            pizza_name_id,
            quantity,
            TRY_CONVERT(DATE, order_date, 103) AS order_date,  -- Convert dd/MM/yyyy to DATE
            TRY_CONVERT(TIME, order_time, 108) AS order_time,  -- Convert hh:mm:ss to TIME
            TRY_CONVERT(DECIMAL(10,2), unit_price) AS unit_price,
            TRY_CONVERT(DECIMAL(10,2), total_price) AS total_price,
            pizza_size,
            pizza_category,
            pizza_ingredients,
            pizza_name,
            ROW_NUMBER() OVER (
                PARTITION BY order_id, pizza_id, order_date, order_time
                ORDER BY (SELECT NULL)  -- Arbitrary order for deduplication
            ) AS rn
        FROM dbo.PizzaSales_Raw
    )
    INSERT INTO dbo.PizzaSales_Clean
    SELECT
        pizza_id,
        order_id,
        pizza_name_id,
        quantity,
        order_date,
        order_time,
        unit_price,
        total_price,
        pizza_size,
        pizza_category,
        pizza_ingredients,
        pizza_name
    FROM CTE_Dedup
    WHERE rn = 1;  -- Keep only first record per duplicate group

    -- =============================================
    -- Step 4: Log number of rows inserted and execution time
    -- =============================================
    SET @RowCount = @@ROWCOUNT;  -- Number of rows inserted

    DECLARE @EndTime DATETIME = GETDATE();
    DECLARE @DurationSeconds INT = DATEDIFF(SECOND, @StartTime, @EndTime);

    PRINT ' Deduplication & type conversion complete.';
    PRINT ' Rows inserted into PizzaSales_Clean: ' + CAST(@RowCount AS VARCHAR);
    PRINT ' Execution time: ' + CAST(@DurationSeconds AS VARCHAR) + ' seconds.';
END;
GO
