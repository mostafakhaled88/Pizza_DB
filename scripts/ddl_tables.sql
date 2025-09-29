/* =============================================================
   Script: ddl_tables.sql
   Purpose:
       - Create base tables for PizzaDB
       - raw.PizzaSales_Raw   → stores unprocessed data
       - clean.PizzaSales_Clean → stores cleaned, standardized data
============================================================= */

USE PizzaDB;
GO

---------------------------------------------------------------
-- Drop & recreate raw.PizzaSales_Raw
---------------------------------------------------------------
IF OBJECT_ID('raw.PizzaSales_Raw', 'U') IS NOT NULL
    DROP TABLE raw.PizzaSales_Raw;
GO

CREATE TABLE raw.PizzaSales_Raw
(
    order_id        VARCHAR(50),
    order_date      VARCHAR(50),
    order_time      VARCHAR(50),
    pizza_id        VARCHAR(50),
    pizza_name_id   VARCHAR(50),
    pizza_name      VARCHAR(250),
    pizza_size      VARCHAR(20),
    pizza_category  VARCHAR(50),
    pizza_ingredients VARCHAR(MAX),
    quantity        VARCHAR(50),
    unit_price      VARCHAR(50),
    total_price     VARCHAR(50)
);
GO

---------------------------------------------------------------
-- Drop & recreate clean.PizzaSales_Clean
---------------------------------------------------------------
IF OBJECT_ID('clean.PizzaSales_Clean', 'U') IS NOT NULL
    DROP TABLE clean.PizzaSales_Clean;
GO

CREATE TABLE clean.PizzaSales_Clean
(
    order_id        INT,
    order_date      DATE,
    order_time      TIME,
    pizza_id        INT,
    pizza_name_id   VARCHAR(50),
    pizza_name      VARCHAR(250),
    pizza_size      VARCHAR(20),
    pizza_category  VARCHAR(50),
    pizza_ingredients VARCHAR(MAX),
    quantity        INT,
    unit_price      DECIMAL(7,2),
    total_price     DECIMAL(10,2)
);
GO

PRINT ' Tables raw.PizzaSales_Raw and clean.PizzaSales_Clean created successfully.';
