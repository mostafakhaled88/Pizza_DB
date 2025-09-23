/*
=============================================================
Create Database and Schemas for Pizza Sales Data Warehouse
=============================================================
Script Purpose:
    - Drops and recreates the 'PizzaDW' database.
    - Creates three schemas: bronze, silver, and gold.
    - Sets the foundation for a layered architecture.

WARNING:
    Running this script will DROP the entire 'PizzaDW' database if it exists. 
    ALL DATA in the database will be permanently deleted. 
    Proceed with caution and ensure you have proper backups.
=============================================================
*/

USE master;
GO

-------------------------------------------------------------
-- 1. Drop and Recreate Database
-------------------------------------------------------------
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'PizzaDW')
BEGIN
    ALTER DATABASE PizzaDW SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE PizzaDW;
END;
GO

CREATE DATABASE PizzaDW;
GO

USE PizzaDW;
GO

-------------------------------------------------------------
-- 2. Create Schemas
-------------------------------------------------------------
-- Raw landing data from source systems
CREATE SCHEMA bronze;
GO

-- Cleaned, transformed, business-ready tables
CREATE SCHEMA silver;
GO

-- Final curated data for reporting/analytics (usually Views)
CREATE SCHEMA gold;
GO
