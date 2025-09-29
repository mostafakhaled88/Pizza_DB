/*=============================================================
  File: init_database.sql
  Purpose:
      - Create PizzaDB
      - Create tables for raw + clean workflow
==============================================================*/

-- 1. Create Database
IF DB_ID('PizzaDB') IS NULL
    CREATE DATABASE PizzaDB;
GO

USE PizzaDB;
GO

/*=============================================================
  Table: PizzaSales_Raw
  Purpose:
      - Stores raw data loaded directly from CSV
      - All columns as NVARCHAR to avoid load errors
==============================================================*/
IF OBJECT_ID('PizzaSales_Raw', 'U') IS NOT NULL
    DROP TABLE PizzaSales_Raw;
GO

CREATE TABLE PizzaSales_Raw
(
    order_id           NVARCHAR(50),
    pizza_id           NVARCHAR(50),
    pizza_name_id      NVARCHAR(50),
    quantity           NVARCHAR(50),
    order_date         NVARCHAR(50),
    order_time         NVARCHAR(50),
    unit_price         NVARCHAR(50),
    total_price        NVARCHAR(50),
    pizza_size         NVARCHAR(50),
    pizza_category     NVARCHAR(50),
    pizza_ingredients  NVARCHAR(MAX),
    pizza_name         NVARCHAR(255)
);
GO

/*=============================================================
  Table: PizzaSales_Clean
  Purpose:
      - Stores cleaned, typed, ready-to-use data
==============================================================*/
IF OBJECT_ID('PizzaSales_Clean', 'U') IS NOT NULL
    DROP TABLE PizzaSales_Clean;
GO

CREATE TABLE PizzaSales_Clean
(
    order_id        INT,
    order_date      DATE,
    order_time      TIME,
    pizza_id        INT,
    pizza_name_id   VARCHAR(50),
    pizza_name      VARCHAR(255),
    pizza_size      VARCHAR(20),
    pizza_category  VARCHAR(50),
    pizza_ingredients NVARCHAR(500),
    quantity        INT,
    unit_price      DECIMAL(7,2),
    total_price     DECIMAL(10,2)
);
GO



