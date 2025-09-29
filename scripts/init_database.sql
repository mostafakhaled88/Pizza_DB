/* =============================================================
   Script: init_database.sql
   Purpose:
       - Initialize PizzaDB environment
       - Create database (if missing)
       - Create schemas for raw & clean layers
       - Set recommended database options

   Usage:
       Run this script once before deploying tables and procedures.
============================================================= */

---------------------------------------------------------------
-- 1. Create Database (safe check)
---------------------------------------------------------------
IF DB_ID('PizzaDB') IS NULL
    CREATE DATABASE PizzaDB;
GO

---------------------------------------------------------------
-- 2. Switch context to PizzaDB
---------------------------------------------------------------
USE PizzaDB;
GO

---------------------------------------------------------------
-- 3. Create Schemas
--    raw   = stores raw CSV loads
--    clean = stores cleaned & transformed data
---------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'raw')
    EXEC('CREATE SCHEMA raw');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'clean')
    EXEC('CREATE SCHEMA clean');
GO

---------------------------------------------------------------
-- 4. Set Recommended Database Options
---------------------------------------------------------------
ALTER DATABASE PizzaDB SET RECOVERY SIMPLE;         -- simplify logging
ALTER DATABASE PizzaDB SET ANSI_NULLS ON;           -- standard null handling
ALTER DATABASE PizzaDB SET QUOTED_IDENTIFIER ON;    -- enforce quoted identifiers
GO

PRINT 'Pizza DB environment initialized successfully.';
