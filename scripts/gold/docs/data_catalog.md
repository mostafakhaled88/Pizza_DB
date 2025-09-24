# 📘 Pizza Sales Data Warehouse – Data Catalog

This document describes the datasets, tables, and views across the **Bronze, Silver, and Gold layers** of the Pizza Sales Data Warehouse.  
It serves as metadata documentation for analysts, engineers, and dashboard developers.

---

## 1. 🍂 Bronze Layer
**Purpose:** Store raw ingested data from source CSVs with minimal transformations.  

### Tables
| Object | Type   | Description |
|--------|--------|-------------|
| `bronze.PizzaSales_Staging` | Table | Raw import from CSV. All fields are loaded as text (`VARCHAR`). Temporary landing zone. |
| `bronze.PizzaSales` | Table | Parsed version of staging with proper data types. Uses `TRY_CAST` for safe conversion. Invalid values become `NULL`. |

**Columns**
- `pizza_id (INT)` – Unique ID of pizza item.  
- `order_id (INT)` – Order transaction ID.  
- `pizza_name_id (VARCHAR)` – Pizza name reference ID.  
- `quantity (INT)` – Number of pizzas ordered.  
- `order_date (DATE)` – Order date (NULL if invalid).  
- `order_time (TIME)` – Order time.  
- `unit_price (DECIMAL(7,2))` – Price per pizza.  
- `total_price (DECIMAL(10,2))` – Extended price (quantity × unit price).  
- `pizza_size (VARCHAR)` – Pizza size (S, M, L, XL, XXL).  
- `pizza_category (VARCHAR)` – Pizza type (Classic, Supreme, Veggie, etc.).  
- `pizza_ingredients (VARCHAR)` – Comma-separated list of ingredients.  
- `pizza_name (VARCHAR)` – Full pizza name.  

---

## 2. 🥈 Silver Layer
**Purpose:** Provide a cleaned and standardized dataset for analytics.  

### Tables
| Object | Type | Description |
|--------|------|-------------|
| `silver.PizzaSales_Clean` | Table | Deduplicated and cleaned data with standardized formats. Serves as the single source for Gold views. |

**Enhancements**
- Standardized **pizza size** mapping:  
  - `S = Regular`  
  - `M = Medium`  
  - `L = Large`  
  - `XL = X-Large`  
  - `XXL = XX-Large`  
- Cleaned/validated `order_date` values.  
- Truncated/cleaned overly long text fields.  
- Ensured numeric consistency for price columns.  

---

## 3. 🥇 Gold Layer
**Purpose:** Business-ready aggregated data exposed as views for reporting, KPIs, and dashboards.  

### Views
| View | Description | Key Metrics |
|------|-------------|-------------|
| `gold.vw_KPI` | High-level business KPIs | Total Orders, Total Revenue, Total Pizzas Sold, Average Order Value |
| `gold.vw_TrendTotalOrders` | Trend analysis over time | Orders & Revenue by Day |
| `gold.vw_PercentageSales` | Contribution analysis | % of Sales by Pizza Category & Size |
| `gold.vw_BestWorstSellers` | Performance ranking | Best & Worst selling pizzas by Revenue and Quantity |
| `gold.vw_TimelineSlicer` | Timeline support | Distinct dates for dashboard slicers |

---

## 4. 📊 Dashboard Layer
**Purpose:** Final consumption by end-users via visualization tools (Power BI, Excel).  

### Pizza Sales Overview Dashboard
- **KPIs**  
  - Total Orders  
  - Total Revenue  
  - Average Order Value (AOV)  
  - Total Pizzas Sold  
- **Trends**  
  - Orders & Revenue over time (daily/weekly/monthly)  
- **Contribution Analysis**  
  - % of Sales by Pizza Category  
  - % of Sales by Pizza Size  
- **Ranking**  
  - Best & Worst Sellers  
- **Filters & Slicers**  
  - Timeline Slicer  
  - Pizza Category / Size filters  

---

## 5. 🔗 Data Flow Summary
1. **Source CSV** → Ingested into `bronze.PizzaSales_Staging`.  
2. Parsed & typed into `bronze.PizzaSales`.  
3. Cleaned & standardized into `silver.PizzaSales_Clean`.  
4. Exposed as business-friendly **Gold Views**.  
5. Consumed in **Power BI / Excel dashboards**.  

---

📌 **Owner:** Data Engineering Team  
📌 **Last Updated:** 2025-09-24  

