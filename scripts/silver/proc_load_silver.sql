/*
=============================================================
Procedure: silver.Load_PizzaSales_Clean
=============================================================
Purpose:
    - Loads the Silver layer from the Bronze layer for pizza sales.
    - Applies full cleaning, transformation, and standardization rules.
    - Tracks execution time and row count for monitoring.

Steps:
    1. Clears the existing Silver table.
    2. Inserts cleaned data from Bronze.PizzaSales:
        - Deduplicates rows
        - Converts data types to proper SQL types
        - Standardizes pizza sizes (S→Regular, M→Medium, etc.)
        - Trims text fields
        - Handles NULLs and missing values
        - Calculates total_price if missing
        - Filters out logically invalid rows
    3. Captures the number of rows inserted.
    4. Tracks total execution time.

Inputs:
    - Source: bronze.PizzaSales

Outputs:
    - Target: silver.PizzaSales_Clean
    - Prints:
        * Number of rows inserted
        * Execution time in milliseconds

Notes:
    - Uses TRY_CAST for safe type conversion; invalid values become NULL.
    - Should be scheduled as part of ETL refresh.
=============================================================
*/

CREATE OR ALTER PROCEDURE silver.Load_PizzaSales_Clean
AS
BEGIN
    SET NOCOUNT ON;

    ---------------------------------------------------------
    -- Track start time for performance monitoring
    ---------------------------------------------------------
    DECLARE @StartTime DATETIME2 = SYSDATETIME();
    DECLARE @EndTime   DATETIME2;
    DECLARE @ElapsedMs INT;
    DECLARE @RowsInserted INT;

    ---------------------------------------------------------
    -- 1. Clear existing Silver table
    ---------------------------------------------------------
    TRUNCATE TABLE silver.PizzaSales_Clean;

    ---------------------------------------------------------
    -- 2. Insert cleaned and transformed data from Bronze
    ---------------------------------------------------------
    INSERT INTO silver.PizzaSales_Clean
    (
        order_id, order_date, order_time, pizza_id, pizza_name_id, pizza_name,
        pizza_size, pizza_category, pizza_ingredients, quantity, unit_price, total_price
    )
    SELECT
        CAST(order_id AS INT) AS order_id,
        TRY_CAST(order_date AS DATE) AS order_date,
        TRY_CAST(order_time AS TIME) AS order_time,
        CAST(pizza_id AS INT) AS pizza_id,
        pizza_name_id,
        LTRIM(RTRIM(pizza_name)) AS pizza_name,
        -- Map pizza sizes to standardized values
        CASE UPPER(LTRIM(RTRIM(pizza_size)))
            WHEN 'S'   THEN 'Regular'
            WHEN 'M'   THEN 'Medium'
            WHEN 'L'   THEN 'Large'
            WHEN 'XL'  THEN 'xLarge'
            WHEN 'XXL' THEN 'xxLarge'
            ELSE 'Unknown'
        END AS pizza_size,
        -- Standardize pizza category, fill unknown if NULL
        CASE 
            WHEN pizza_category IS NULL THEN 'Unknown'
            ELSE LTRIM(RTRIM(pizza_category))
        END AS pizza_category,
        -- Trim ingredients string
        LTRIM(RTRIM(pizza_ingredients)) AS pizza_ingredients,
        -- Validate quantity and unit_price
        CASE WHEN TRY_CAST(quantity AS INT) > 0 THEN CAST(quantity AS INT) ELSE NULL END AS quantity,
        CASE WHEN TRY_CAST(unit_price AS DECIMAL(7,2)) > 0 THEN CAST(unit_price AS DECIMAL(7,2)) ELSE NULL END AS unit_price,
        -- Calculate total_price if missing or invalid
        CASE 
            WHEN total_price IS NULL OR TRY_CAST(total_price AS DECIMAL(10,2)) IS NULL THEN
                TRY_CAST(quantity AS INT) * TRY_CAST(unit_price AS DECIMAL(7,2))
            ELSE
                CAST(total_price AS DECIMAL(10,2))
        END AS total_price
    FROM
    (
        -- Deduplicate rows using ROW_NUMBER over key columns
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY order_id, pizza_id, pizza_name_id, quantity, order_date, order_time ORDER BY order_id) AS rn
        FROM bronze.PizzaSales
    ) t
    WHERE t.rn = 1
      AND order_id IS NOT NULL
      AND pizza_id IS NOT NULL
      AND TRY_CAST(quantity AS INT) > 0
      AND TRY_CAST(unit_price AS DECIMAL(7,2)) > 0;

    ---------------------------------------------------------
    -- 3. Capture number of rows inserted
    ---------------------------------------------------------
    SET @RowsInserted = @@ROWCOUNT;

    ---------------------------------------------------------
    -- 4. Track end time and calculate elapsed time
    ---------------------------------------------------------
    SET @EndTime = SYSDATETIME();
    SET @ElapsedMs = DATEDIFF(MILLISECOND, @StartTime, @EndTime);

    ---------------------------------------------------------
    -- 5. Print procedure summary
    ---------------------------------------------------------
    PRINT 'Silver.PizzaSales_Clean refresh completed successfully';
    PRINT 'Rows Inserted: ' + CAST(@RowsInserted AS VARCHAR(10));
    PRINT 'Execution Time (ms): ' + CAST(@ElapsedMs AS VARCHAR(20));
END;
GO
