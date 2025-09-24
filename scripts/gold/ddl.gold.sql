/*
=============================================================
GOLD LAYER VIEWS FOR DASHBOARDS & REPORTING
=============================================================
Purpose:
    - Transform cleaned Silver layer into consumable views
      for BI dashboards (Power BI / Tableau / Excel).
    - Views created:
        1. vw_KPI                → KPI cards (Total Orders, Revenue, Quantity, AOV)
        2. vw_TrendTotalOrders   → Orders & Revenue trend over time
        3. vw_PercentageSales    → % contribution of categories to sales
        4. vw_BestWorstSellers   → Best & worst sellers (pizza level)
        5. vw_TimelineSlicer     → Distinct dates for slicers
        6. vw_PizzaSizeSales     → Sales by pizza size (S, M, L, XL, XXL)
=============================================================
*/

-------------------------------------------------------------
-- Ensure schema exists
-------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'gold')
    EXEC('CREATE SCHEMA gold');
GO

-------------------------------------------------------------
-- 1. KPI View
-------------------------------------------------------------
CREATE OR ALTER VIEW gold.vw_KPI AS
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(total_price) AS total_revenue,
    SUM(quantity) AS total_quantity_sold,
    CAST(SUM(total_price) * 1.0 / COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS avg_order_value
FROM silver.PizzaSales_Clean;
GO

-------------------------------------------------------------
-- 2. Trend for Total Orders
-------------------------------------------------------------
CREATE OR ALTER VIEW gold.vw_TrendTotalOrders AS
SELECT
    CAST(order_date AS DATE) AS order_date,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(total_price) AS total_revenue
FROM silver.PizzaSales_Clean
WHERE order_date IS NOT NULL
GROUP BY CAST(order_date AS DATE);
GO

-------------------------------------------------------------
-- 3. Percentage of Sales by Category
-------------------------------------------------------------
CREATE OR ALTER VIEW gold.vw_PercentageSales AS
SELECT
    pizza_category,
    SUM(total_price) AS category_revenue,
    CAST(SUM(total_price) * 100.0 / SUM(SUM(total_price)) OVER() AS DECIMAL(5,2)) AS pct_of_sales
FROM silver.PizzaSales_Clean
GROUP BY pizza_category;
GO

-------------------------------------------------------------
-- 4. Best and Worst Sellers
-------------------------------------------------------------
CREATE OR ALTER VIEW gold.vw_BestWorstSellers AS
WITH PizzaRevenue AS (
    SELECT
        pizza_name,
        SUM(quantity) AS total_quantity,
        SUM(total_price) AS total_revenue
    FROM silver.PizzaSales_Clean
    GROUP BY pizza_name
)
SELECT
    pizza_name,
    total_quantity,
    total_revenue
FROM PizzaRevenue;
-- NOTE: Apply ORDER BY / TOP N in dashboard or query, not inside the view
GO


-------------------------------------------------------------
-- 5. Timeline Slicer Support
-------------------------------------------------------------
CREATE OR ALTER VIEW gold.vw_TimelineSlicer AS
SELECT DISTINCT CAST(order_date AS DATE) AS order_date
FROM silver.PizzaSales_Clean
WHERE order_date IS NOT NULL;
GO

-------------------------------------------------------------
-- 6. Pizza Size Sales Analysis
-- Used for pie/bar charts (size contribution %)
-------------------------------------------------------------
CREATE OR ALTER VIEW gold.vw_PizzaSizeSales AS
SELECT
    pizza_size,
    SUM(quantity) AS total_quantity,
    SUM(total_price) AS total_revenue,
    CAST(SUM(total_price) * 100.0 / SUM(SUM(total_price)) OVER() AS DECIMAL(5,2)) AS pct_of_sales
FROM silver.PizzaSales_Clean
GROUP BY pizza_size;
GO
