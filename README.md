# 🍕 Pizza Sales Data Warehouse Project

## 📌 Overview
This project builds a **Data Warehouse** for pizza sales data using the **Medallion Architecture** (Bronze → Silver → Gold).  
The goal is to transform raw transactional data into **business-ready insights** for dashboards in **Power BI**.

---

## 🎯 Business Problem
A pizza chain needs to track sales performance across categories, sizes, and time.  
They want to answer questions like:
- What are the **best and worst-selling pizzas**?
- How do sales vary by **size, category, or day of the week**?
- What is the **monthly revenue trend**?
- Which products drive the **highest profit margins**?

---

## 🏗️ Architecture

![Data Architecture](docs/data_architecture.png)

- **Bronze Layer:** Raw CSV/Excel files → staged in SQL Server.  
- **Silver Layer:** Cleaned and validated data (date formats, null handling, numeric conversions).  
- **Gold Layer:** Business-ready views and **Star Schema** model for reporting.  

---

## 📂 Project Structure

Pizza_DB/
│
├── datasets/ # Raw data files (CSV/Excel)
├── sql/ # SQL scripts (Bronze, Silver, Gold)
│ ├── bronze.sql
│ ├── silver.sql
│ ├── gold_views.sql
│
├── docs/ # Documentation & diagrams
│ ├── data_architecture.png
│ ├── erd.png
│
└── README.md

---

## 🗄️ Data Model (Star Schema)

![ERD](docs/erd.png)

- **Fact Table**
  - `fact_sales` (order_id, date_id, pizza_id, customer_id, quantity, total_price)
- **Dimensions**
  - `dim_date` (date_id, order_date, day, month, year, weekday)
  - `dim_pizza` (pizza_id, name, size, category, ingredients)
  - `dim_customer` (customer_id, city, country, phone)
  - `dim_store` (store_id, location, region)

---

## 🔄 ETL Pipeline
1. **Bronze → Silver**
   - Clean order dates & times  
   - Standardize column names  
   - Remove duplicates & nulls  
   - Ensure numeric formats (quantity, prices)

2. **Silver → Gold**
   - Build fact & dimension tables  
   - Create business views (revenue by category, sales by day, top products)  
   - Index for performance  

---

## 📊 Key Insights
- **Top 3 Best-Selling Pizzas:** Margherita L, Pepperoni M, BBQ Chicken L  
- **Highest Revenue Category:** Classic pizzas (35% of total revenue)  
- **Sales Trend:** Weekend sales are 22% higher than weekdays  
- **Size Effect:** Large pizzas generate the most revenue, but Medium has the highest volume  

---

## 🛠️ Tech Stack
- **Database:** SQL Server  
- **ETL:** SQL (stored procedures & views)  
- **Visualization:** Power BI (Dashboards & Reports)  
- **Version Control:** GitHub  

---

## 🚀 How to Run
1. Clone repo:
   ```bash
   git clone https://github.com/mostafakhaled88/Pizza_DB.git
