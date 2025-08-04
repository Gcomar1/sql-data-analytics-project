
# 🏆 Golden Customers SQL Project

## 📊 Overview

This project is a comprehensive SQL case study designed to showcase real-world analytics using a **Gold-tier customer dataset**. It covers **end-to-end data analysis** practices using PostgreSQL and is ideal for recruiters and hiring managers seeking strong SQL expertise.

---

## 🧱 Dataset Structure

The project uses five core tables:

- `gold.dim_customers`: Customer demographics and profile data
- `gold.dim_products`: Product information including categories and cost
- `gold.fact_sales`: Transactional sales data
- `gold.report_customers`: Aggregated customer report (view)
- `gold.report_products`: Aggregated product report (view)

---

## 🧠 SQL Concepts Demonstrated

The project covers a wide range of intermediate to advanced SQL topics:

### 1. 🗃️ Create Database and Tables
- Creating normalized tables with appropriate data types and keys

### 2. 🔍 Database Exploration
- Exploring catalog and schema metadata

### 3. 🧑 Dimension Exploration
- Understanding customer and product dimensions

### 4. 📅 Date Range Exploration
- Calculating first and last order dates
- Determining data lifespan in months

### 5. 📏 Measure Exploration
- Exploring quantity, revenue, and price metrics

### 6. 🔢 Magnitude Analysis
- Total sales, average sales, and product/customer performance

### 7. 🥇 Ranking Analysis
- Using `RANK()` and `DENSE_RANK()` to find best/worst months or products

### 8. 📈 Change Over Time Analysis
- Yearly and monthly sales trends
- Growth/decline detection using `LAG()`

### 9. 📊 Cumulative Analysis
- Running totals using `SUM() OVER()`

### 10. 🚦 Performance Analysis
- Comparing sales to previous periods and average benchmarks

### 11. 🧩 Data Segmentation
- Customer segments: VIP, Regular, New based on sales and lifespan
- Product segments: High-performer, Mid-range, Low-performer

### 12. 🧮 Part to Whole Analysis
- Category/product contribution to total sales (percentages)

### 13. 📋 Customer Report (View)
- Summary view for each customer including:
  - Total orders, quantity, sales, lifespan
  - Segmentation and KPIs like AOV, monthly spend

### 14. 📋 Product Report (View)
- Summary view for each product including:
  - Total orders, customers, sales, recency, monthly revenue

---

## 🚀 Skills Highlighted

✅ PostgreSQL mastery  
✅ Analytical thinking  
✅ Window functions (`LAG()`, `RANK()`, `AVG() OVER()`)  
✅ CTEs & views  
✅ Business insights & KPI calculation

---

## 📁 Folder Structure

```
📦 golden_customers_sql_project
├── README.md
├── schema.sql
├── analysis_queries.sql
├── report_customers.sql
├── report_products.sql
└── sample_outputs/
```

---

## 🤝 Let's Connect

If you’re a recruiter or team lead looking for someone with strong data analysis & SQL capabilities — feel free to connect or view more of my work!

---

🛠️ **Built with**: PostgreSQL • SQL Analytics • GitHub
