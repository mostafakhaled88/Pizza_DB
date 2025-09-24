# 🍕 Pizza Sales Data Warehouse Project

## 📌 Overview
This project builds a **Data Warehouse** for pizza sales data, following the **Medallion Architecture** (Bronze → Silver → Gold).  
The goal is to clean, validate, and transform raw sales data into **business-ready views** that can power dashboards and reports in **Power BI/Tableau**.

---

## 🏗️ Architecture
![Data Architecture](docs/data_architecture.png)

- **Source** → CSV/Excel files (`PizzaSales.csv`)  
- **Bronze Layer** → Raw staging tables (exact copy of source)  
- **Silver Layer** → Cleaned & validated tables (data types, null handling, date parsing)  
- **Gold Layer** → Business views (sales KPIs, best/worst sellers, daily trends)  
- **BI/Reports** → Power BI / Tableau dashboards  

---

## 🔄 Data Flow
![Data Flow](docs/data_flow.png)

1. **Raw Data** → Ingested from CSV/Excel into `bronze.PizzaSales`.  
2. **Bronze → Silver** → Clean transformations applied:  
   - Fix invalid `order_date` formats  
   - Drop or correct nulls  
   - Ensure numeric consistency (`unit_price`, `total_price`)  
3. **Silver → Gold** → Create analytical views:  
   - `vw_TotalSales`  
   - `vw_BestWorstSellers`  
   - `vw_SalesByCategory`  
   - `vw_DailySalesTrend`  
4. **Gold → BI** → Final consumption layer for dashboards.  

---

## 📊 Data Catalog
See [data_catalog.md](docs/data_catalog.md) for detailed table documentation.

---

## 📂 Project Structure
PizzaSales_DW/
│── docs/
│ ├── data_architecture.png
│ ├── data_flow.png
│ ├── data_catalog.md
│
│── sql/
│ ├── bronze.sql
│ ├── silver.sql
│ ├── gold_views.sql
│
│── README.md


---

## 🛠️ Tech Stack
- **Database:** SQL Server  
- **ETL:** SQL Stored Procedures  
- **Modeling:** Medallion Architecture (Bronze/Silver/Gold)  
- **Visualization:** Power BI / Tableau  
- **Docs:** Markdown + Diagrams (Draw.io)  

---

## 🚀 How to Run
1. Create database in SQL Server:  
   ```sql
   CREATE DATABASE PizzaSalesDW;
Run Bronze Layer script (sql/bronze.sql) to load raw data.

Run Silver Layer script (sql/silver.sql) to clean and validate.

Run Gold Layer script (sql/gold_views.sql) to create business views.

Connect Power BI/Tableau to the Gold schema for reporting.

---

## 📈 Example Dashboards

---

Total Sales Overview

Best & Worst Sellers

Sales by Category & Size

Daily Sales Trends


---

## 📑 Documentation

---

Data Catalog

Data Architecture

Data Flow
---
## 👤 Author
---

Mostafa Khaled Farag
📍 Cairo, Egypt
📧 mosta.mk@gmail.com

🔗 LinkedIn
 | GitHub
