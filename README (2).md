# Supply Chain Management & Analytics Dashboard

## 📌 Project Description

**Supply Chain Management & Analytics Dashboard** is an end-to-end data analytics project that analyzes **12,000 order records across 20 warehouses, 5 global regions, and 5 product categories**. The project uses **Excel, SQL, Power BI, and Tableau** to evaluate sales, profitability, delivery performance, fulfillment, forecasting, lead time, shipping modes, inventory, and supplier performance.

The dashboards transform transactional supply chain data into interactive **KPIs, trends, visualizations, and business insights**, helping identify opportunities to improve delivery reliability, reduce delays and backorders, optimize shipping modes, and understand revenue concentration.

**Tools:** Excel | SQL | Power BI | Tableau

**Key KPIs:** 12K Orders | $193.99M Revenue | $68.54M Gross Profit | 66.03% On-Time Delivery | 96.9% Forecast Accuracy | 3.12% Backorder Rate | 4.93 Days Avg. Lead Time


## 🎯 Project Objective

The main objective is to analyze supply chain performance and identify opportunities to improve delivery reliability, fulfillment, inventory and backorder management, demand forecasting, shipping-mode utilization, revenue and profitability, lead-time performance, and regional/supplier performance.

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| **Excel** | Data analysis, KPI calculations, dashboarding and exploratory analysis |
| **SQL** | Data querying, aggregation and supply chain performance analysis |
| **Power BI** | Interactive KPI dashboards, trends, regional and supplier analysis |
| **Tableau** | Interactive visual analytics and supply chain performance visualization |

## 2. SQL Supply Chain Analysis

The SQL component builds a relational supply chain database and performs KPI analysis across orders, inventory, customers, products, suppliers, and warehouses.

### Database Tables

- `dim_product`
- `dim_supplier`
- `dim_warehouse`
- `dim_customer`
- `fact_orders`
- `fact_inventory`

### SQL Analysis Includes

- Total Orders
- Total Sales Revenue
- Average Order Value (AOV)
- Orders by Region
- Stock on Hand
- Reorder Percentage
- Average Lead Time
- Inventory Turnover Ratio
- Procurement Cost
- Transportation Cost
- Total Supply Chain Cost
- Cost per Unit
- On-Time Delivery %
- Average Delay
- Orders by Ship Mode
- Transport Mode Utilization
- Forecast Accuracy
- Fill Rate
- Backorder Rate
- Demand vs Actual Sales Trend

The SQL workflow also creates reusable KPI tables for reporting and dashboard integration.

# 📊 Dashboard Sequence

## 1. Excel Supply Chain Dashboard

The Excel dashboard provides an overview of key supply chain KPIs including total orders, revenue, gross profit, delay days, AOV, inventory turnover ratio, on-time delivery, fill rate, and backorder rate.

It also includes forecast accuracy, orders by shipping mode, average lead time, supply chain cost, revenue by product category, and interactive filters.


---

## 3. Power BI Supply Chain Dashboard

### Supply Chain Overview

The Power BI overview analyzes total sales, orders, profit, transportation cost, on-time delivery, fill rate, profit margin, average lead time, delivery status, ship-mode/backorder performance, and product-level sales and profitability.


### Performance Trends

The second Power BI page analyzes forecast trends, on-time delivery by region, category-wise revenue, supplier-tier revenue, order quantity, shipped quantity, shipment variance, and backorder rate.


---

## 4. Tableau Supply Chain Dashboard

The Tableau dashboard provides interactive visualization of total orders, on-time delivery, total sales revenue, inventory turnover ratio, average delay, fill rate, orders by country, orders by ship mode, average lead time, forecast accuracy, transport mode utilization, and top categories by revenue.


---

# 📈 Key Performance Indicators

| KPI | Result |
|---|---:|
| Total Orders | **12,000** |
| Total Revenue | **$193.99M** |
| Gross Profit | **$68.54M** |
| Profit Margin | **35.33%** |
| On-Time Delivery | **66.03%** |
| Average Delay | **1.46 days** |
| Backorder Rate | **3.12%** |
| Fill Rate | **96.78%** |
| Forecast Accuracy | **96.9%** |
| Average Lead Time | **4.93 days** |
| Inventory Turnover Ratio | **81.29K** |
| Average Order Value | **$16.17K** |

# 🔍 Key Insights

- **Revenue concentration:** Electronics generates approximately **$152.66M**, about **78.7% of total revenue**.
- **Delivery performance:** Only about **66% of orders are delivered on time**, indicating an opportunity to improve delivery reliability.
- **Delay performance:** Average delay is approximately **1.46 days**.
- **Backorders:** The backorder rate is approximately **3.1%**, highlighting inventory availability opportunities.
- **Forecasting:** Forecast accuracy is approximately **96.9%**, indicating strong demand-planning performance.
- **Shipping mode:** Road is the largest shipping mode with approximately **4.64K orders**, followed by Air with approximately **3.60K orders**.
- **Category dependency:** The strong concentration of revenue in Electronics suggests an opportunity to diversify category contribution.

# 🔄 Project Workflow

```text
Raw Supply Chain Data
        ↓
Data Cleaning & Preparation
        ↓
Excel Analysis
        ↓
SQL Queries & Aggregation
        ↓
Power BI Dashboard
        ↓
Tableau Dashboard
        ↓
KPI & Trend Analysis
        ↓
Business Insights & Recommendations
```

# 💡 Business Recommendations

- Improve delivery processes to increase on-time delivery.
- Investigate recurring causes of delivery delays.
- Optimize inventory levels to reduce backorders.
- Continue strengthening demand forecasting.
- Review the heavy dependence on Road and Air shipping modes.
- Evaluate opportunities to diversify revenue beyond Electronics.
- Monitor regional, supplier, and product-level performance regularly.

# 📂 Repository Structure

```text
Supply-Chain-Management/
│
├── README.md
│
├── Excel/
│   └── Supply Chain Management Dashboard.xlsx
│
├── SQL/
│   └── Supply Chain Management Workbench.sql
│
├── Power-BI/
│   └── Supply Chain Management Dashboard.pbix
│
├── Tableau/
│   └── Supply Chain Management Dashboard.twbx
│
├── Presentation/
│   └── Supply Chain Management PPT.pptx
│
```

# 👤 Project Author

- **Dhairya Yadav**

## 📌 Project Summary

This project demonstrates an end-to-end approach to **Supply Chain Analytics**, combining Excel, SQL, Power BI, and Tableau to analyze operational and financial performance.

The analysis indicates that **demand planning is strong**, while **delivery performance and revenue concentration** are the major areas requiring attention.
