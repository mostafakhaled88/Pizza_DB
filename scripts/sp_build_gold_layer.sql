/*
================================================================================
PROJECT: Pizza Sales Data Warehouse - Gold Layer
FILE: sp_build_gold_layer.sql
DESCRIPTION: 
    This stored procedure refreshes the Gold Layer views for the Pizza Sales 
    Data Warehouse project. It drops existing views, recreates them with 
    aggregated data, prints row counts, and tracks execution time. 
USAGE: 
    EXEC sp_build_gold_layer;
================================================================================
*/

CREATE OR ALTER PROCEDURE sp_build_gold_layer
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------------
    -- Track start time
    ------------------------------------------------------------------
    DECLARE @start_time DATETIME = GETDATE();
    PRINT '🔄 Refreshing Gold Layer...';

    ------------------------------------------------------------------
    -- 1. Drop old views if they exist
    ------------------------------------------------------------------
    DECLARE @views_to_drop TABLE (view_name NVARCHAR(128));
    INSERT INTO @views_to_drop (view_name)
    VALUES 
        ('vw_orders_daily_trend'),
        ('vw_orders_hourly_trend'),
        ('vw_sales_by_category'),
        ('vw_sales_by_size'),
        ('vw_top5_best_sellers'),
        ('vw_bottom5_worst_sellers'),
        ('vw_kpis_summary'),
        ('vw_orders_monthly_trend');  -- Added monthly trend here

    DECLARE @view_name NVARCHAR(128);
    DECLARE drop_cursor CURSOR FOR SELECT view_name FROM @views_to_drop;

    OPEN drop_cursor;
    FETCH NEXT FROM drop_cursor INTO @view_name;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF OBJECT_ID(@view_name, 'V') IS NOT NULL
        BEGIN
            PRINT 'Dropping view: ' + @view_name;
            EXEC('DROP VIEW ' + @view_name);
        END
        FETCH NEXT FROM drop_cursor INTO @view_name;
    END

    CLOSE drop_cursor;
    DEALLOCATE drop_cursor;

    ------------------------------------------------------------------
    -- 2. Create views and print row counts
    ------------------------------------------------------------------

    -- 2.1 Orders daily trend
    EXEC sp_executesql N'
        CREATE VIEW vw_orders_daily_trend AS
        SELECT DATENAME(WEEKDAY, order_date) AS day_name,
               COUNT(DISTINCT order_id) AS total_orders
        FROM dbo.PizzaSales_Clean
        GROUP BY DATENAME(WEEKDAY, order_date);
    ';
    DECLARE @daily_trend_count INT;
    SELECT @daily_trend_count = COUNT(*) FROM vw_orders_daily_trend;
    PRINT 'vw_orders_daily_trend rows: ' + CAST(@daily_trend_count AS NVARCHAR);

    -- 2.2 Orders hourly trend
    EXEC sp_executesql N'
        CREATE VIEW vw_orders_hourly_trend AS
        SELECT DATEPART(HOUR, order_time) AS order_hour,
               COUNT(DISTINCT order_id) AS total_orders
        FROM dbo.PizzaSales_Clean
        GROUP BY DATEPART(HOUR, order_time);
    ';
    DECLARE @hourly_trend_count INT;
    SELECT @hourly_trend_count = COUNT(*) FROM vw_orders_hourly_trend;
    PRINT 'vw_orders_hourly_trend rows: ' + CAST(@hourly_trend_count AS NVARCHAR);

    -- 2.3 Sales by category
    EXEC sp_executesql N'
        CREATE VIEW vw_sales_by_category AS
        SELECT pizza_category,
               SUM(quantity) AS total_pizzas_sold,
               SUM(total_price) AS total_revenue
        FROM dbo.PizzaSales_Clean
        GROUP BY pizza_category;
    ';
    DECLARE @category_count INT;
    SELECT @category_count = COUNT(*) FROM vw_sales_by_category;
    PRINT 'vw_sales_by_category rows: ' + CAST(@category_count AS NVARCHAR);

    -- 2.4 Sales by size
    EXEC sp_executesql N'
        CREATE VIEW vw_sales_by_size AS
        SELECT pizza_size,
               SUM(quantity) AS total_pizzas_sold,
               SUM(total_price) AS total_revenue
        FROM dbo.PizzaSales_Clean
        GROUP BY pizza_size;
    ';
    DECLARE @size_count INT;
    SELECT @size_count = COUNT(*) FROM vw_sales_by_size;
    PRINT 'vw_sales_by_size rows: ' + CAST(@size_count AS NVARCHAR);

    -- 2.5 Top 5 best sellers
    EXEC sp_executesql N'
        CREATE VIEW vw_top5_best_sellers AS
        SELECT TOP 5 pizza_name,
               SUM(quantity) AS total_sold
        FROM dbo.PizzaSales_Clean
        GROUP BY pizza_name
        ORDER BY total_sold DESC;
    ';
    PRINT 'vw_top5_best_sellers rows: 5';

    -- 2.6 Bottom 5 worst sellers
    EXEC sp_executesql N'
        CREATE VIEW vw_bottom5_worst_sellers AS
        SELECT TOP 5 pizza_name,
               SUM(quantity) AS total_sold
        FROM dbo.PizzaSales_Clean
        GROUP BY pizza_name
        ORDER BY total_sold ASC;
    ';
    PRINT 'vw_bottom5_worst_sellers rows: 5';

    -- 2.7 KPIs summary
    EXEC sp_executesql N'
        CREATE VIEW vw_kpis_summary AS
        SELECT 
            SUM(total_price) AS total_revenue,
            AVG(total_price) AS avg_order_value,
            SUM(quantity) AS total_pizzas_sold,
            COUNT(DISTINCT order_id) AS total_orders,
            CAST(1.0 * SUM(quantity) / COUNT(DISTINCT order_id) AS DECIMAL(5,2)) AS avg_pizzas_per_order
        FROM dbo.PizzaSales_Clean;
    ';
    PRINT 'vw_kpis_summary rows: 1';

    -- 2.8 Orders monthly trend
    EXEC sp_executesql N'
        CREATE VIEW vw_orders_monthly_trend AS
        SELECT 
            YEAR(order_date) AS order_year,
            MONTH(order_date) AS order_month,
            DATENAME(MONTH, order_date) AS month_name,
            COUNT(DISTINCT order_id) AS total_orders
        FROM dbo.PizzaSales_Clean
        GROUP BY YEAR(order_date), MONTH(order_date), DATENAME(MONTH, order_date);
    ';
    DECLARE @monthly_trend_count INT;
    SELECT @monthly_trend_count = COUNT(*) FROM vw_orders_monthly_trend;
    PRINT 'vw_orders_monthly_trend rows: ' + CAST(@monthly_trend_count AS NVARCHAR);

    ------------------------------------------------------------------
    -- 3. Finish and print execution time
    ------------------------------------------------------------------
    DECLARE @end_time DATETIME = GETDATE();
    PRINT '✅ Gold Layer refreshed successfully (all views ready for dashboard)';
    PRINT '⏱ Total execution time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

END;
GO
