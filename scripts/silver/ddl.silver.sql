/*
=============================================================
Table: silver.PizzaSales_Clean
=============================================================
Purpose:
    - Stores cleaned, standardized pizza sales data from Bronze.
    - Flat table (single table) for analysis and Gold layer views.
=============================================================
*/
IF OBJECT_ID('silver.PizzaSales_Clean', 'U') IS NOT NULL
    DROP TABLE silver.PizzaSales_Clean;
GO

CREATE TABLE silver.PizzaSales_Clean
(
    order_id        INT,
    order_date      DATE,
    order_time      TIME,
    pizza_id        INT,
    pizza_name_id   VARCHAR(50),
    pizza_name      VARCHAR(250),
    pizza_size      VARCHAR(20),
    pizza_category  VARCHAR(20),
    pizza_ingredients VARCHAR(MAX),
    quantity        INT,
    unit_price      DECIMAL(7,2),
    total_price     DECIMAL(10,2)
);
GO
