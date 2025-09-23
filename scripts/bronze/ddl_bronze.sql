-------------------------------------------------------------
-- Bronze Layer: Raw Pizza Sales Table
-------------------------------------------------------------
IF OBJECT_ID('bronze.PizzaSales', 'U') IS NOT NULL
    DROP TABLE bronze.PizzaSales;
GO

CREATE TABLE bronze.PizzaSales
(
    pizza_id           INT,
    order_id           INT,
    pizza_name_id      VARCHAR(50),
    quantity           INT,
    order_date         DATE,
    order_time         TIME,
    unit_price         DECIMAL(7,2),
    total_price        DECIMAL(10,2),
    pizza_size         VARCHAR(10),
    pizza_category     VARCHAR(50),
    pizza_ingredients  VARCHAR(MAX),
    pizza_name         VARCHAR(255),

    -- Metadata columns for ETL tracking
    load_timestamp     DATETIME DEFAULT(GETDATE())
);
GO
