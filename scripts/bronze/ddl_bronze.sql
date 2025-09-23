/*
=============================================================
Table: bronze.PizzaSales_Staging
=============================================================
Purpose:
    - Temporary landing zone for raw CSV import.
    - All columns stored as VARCHAR to avoid bulk insert errors.
    - Truncated before each load.
=============================================================
*/
IF OBJECT_ID('bronze.PizzaSales_Staging', 'U') IS NOT NULL
    DROP TABLE bronze.PizzaSales_Staging;
GO

CREATE TABLE bronze.PizzaSales_Staging
(
    pizza_id           VARCHAR(50),
    order_id           VARCHAR(50),
    pizza_name_id      VARCHAR(50),
    quantity           VARCHAR(50),
    order_date         VARCHAR(50),
    order_time         VARCHAR(50),
    unit_price         VARCHAR(50),
    total_price        VARCHAR(50),
    pizza_size         VARCHAR(10),
    pizza_category     VARCHAR(50),
    pizza_ingredients  VARCHAR(MAX),
    pizza_name         VARCHAR(255)
);
GO


/*
=============================================================
Table: bronze.PizzaSales
=============================================================
Purpose:
    - Holds cleansed Bronze data with correct datatypes.
    - Data is refreshed each time the procedure runs.
=============================================================
*/
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
    pizza_name         VARCHAR(255)
);
GO
