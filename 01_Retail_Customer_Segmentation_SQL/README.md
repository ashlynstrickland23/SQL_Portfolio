# Retail Customer Segmentation SQL Project

This project demonstrates how raw retail sales data can be transformed into clean PostgreSQL reporting views for business intelligence and dashboard development.

The goal of this project is to show how SQL can be used to analyze customer behavior, segment customers, track revenue trends, evaluate product profitability, measure cohort retention, and validate dashboard ready reporting tables.

## Dataset Overview

This project uses a simulated enterprise retail dataset created in PostgreSQL.

| Table | Row Count | Description |
|---|---:|---|
| Customers | 5,000 | Customer profiles, segments, loyalty tiers, and acquisition channels |
| Orders | 50,000 | Order level transactions with dates, status, sales channel, and shipping details |
| Order Items | 100,140 | Product level line items with quantity, price, cost, and discounts |
| Products | 100 | Product catalog with brand, category, supplier, price, and cost |
| Suppliers | 20 | Supplier details, region, lead time, and rating |
| Warehouses | 8 | Fulfillment locations by city, state, and region |
| Returns | 8,762 | Returned orders with reasons, dates, and refund amounts |

## 🛠️ Tools Used

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![DBeaver](https://img.shields.io/badge/DBeaver-372923?style=for-the-badge&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-025E8C?style=for-the-badge&logo=database&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)
![Power BI Ready](https://img.shields.io/badge/Power_BI_Ready-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)

---

## 💡 Skills Demonstrated

![Database Creation](https://img.shields.io/badge/Database_Creation-6A0DAD?style=for-the-badge)
![Large Test Data](https://img.shields.io/badge/Large_Test_Data-1E90FF?style=for-the-badge)
![SQL Joins](https://img.shields.io/badge/SQL_Joins-008080?style=for-the-badge)
![CTEs](https://img.shields.io/badge/CTEs-FF8C00?style=for-the-badge)
![Window Functions](https://img.shields.io/badge/Window_Functions-DC143C?style=for-the-badge)
![RFM Segmentation](https://img.shields.io/badge/RFM_Segmentation-228B22?style=for-the-badge)
![Trend Analysis](https://img.shields.io/badge/Trend_Analysis-4682B4?style=for-the-badge)
![Product Profitability](https://img.shields.io/badge/Product_Profitability-2E8B57?style=for-the-badge)
![Cohort Retention](https://img.shields.io/badge/Cohort_Retention-FF69B4?style=for-the-badge)
![Dashboard Validation](https://img.shields.io/badge/Dashboard_Validation-B22222?style=for-the-badge)
![Reporting Views](https://img.shields.io/badge/Reporting_Views-4B0082?style=for-the-badge)

---

## Customer Segmentation Revenue Summary

This output shows customers grouped into RFM segments based on purchase activity, frequency, and revenue contribution.

The highest revenue segment is Champions with 721 customers and $24.2M in total revenue. At Risk High Value customers also represent a major opportunity, with 637 customers and $19.7M in revenue. This helps leadership quickly see which customer groups are driving the most value and which groups may need retention campaigns.

![Customer Segmentation Revenue Summary](screenshots/Customer%20Segmentation%20Revenue%20Summary.png)

---

## Monthly Sales Trends and Growth Analysis

This output shows monthly performance across total orders, unique customers, revenue, profit, average item revenue, and month over month growth.

The view shows monthly revenue ranging from about $5.3M to $6.4M, with March 2024 reaching $6.4M in revenue and 16.18% revenue growth from the previous month. This helps a business monitor sales trends, identify stronger months, and understand changes in revenue and profit over time.

![Monthly Sales Trends and Growth Analysis](screenshots/Monthly%20Sales%20Trends%20and%20Growth%20Analysis.png)

---

## Product Profitability and Ranking Analysis

This output ranks products by sales and profit performance.

The top product shown generated $2.15M in net sales, sold 2,167 units, and had an 81.33% profit margin. Another product had the highest profit rank with over $2.0M in profit and a 97.87% profit margin. This helps a business identify top performing products, high margin products, and products that may need pricing or return rate review.

![Product Profitability and Ranking Analysis](screenshots/Product%20Profitability%20and%20Ranking%20Analysis.png)

---

## Customer Cohort Retention Analysis

This output tracks customer retention by first purchase month and months since first order.

The January 2024 cohort started with 1,425 customers. One month later, 397 customers returned, giving a 27.86% retention rate. Two months later, 434 customers returned, giving a 30.46% retention rate. This helps a business understand repeat purchase behavior and whether customers continue engaging after their first order.

![Customer Cohort Retention Analysis](screenshots/Customer%20Cohort%20Retention%20Analysis.png)

---

## Executive RFM Segment Summary

This output provides a leadership ready summary of customer segments, revenue, profit, activity, return rate, and ranking.

Champions rank first with $24.2M in revenue, $11.3M in profit, and an average lifetime revenue of $33,637. At Risk High Value customers rank second with $19.6M in revenue and an average of 108 days since last order. This helps leadership prioritize retention, loyalty, and revenue growth strategies by customer group.

![Executive RFM Segment Summary](screenshots/Executive%20RFM%20Segment%20Summary.png)

---

## Dashboard Validation Summary

This output compares raw database values against the reporting view layer to check dashboard accuracy.

The customer count passed validation with 5,000 customers in both the raw table and reporting view. The order item count also passed with 100,140 rows. Metrics marked Review show where the reporting layer differs from the raw source data, such as raw order count versus reporting view order count. This helps a business catch reporting differences before dashboards are shared with decision makers.

![Dashboard Validation Summary](screenshots/Dashboard%20Validation%20Summary.png)
---

## Overall Business Value

This project demonstrates how SQL can turn raw transactional data into a reliable reporting layer that supports better business decisions. Instead of only querying individual tables, the project builds dashboard ready views that summarize customer behavior, sales trends, product profitability, cohort retention, and validation checks.

The analysis shows how a business can identify its highest value customers, monitor monthly revenue and profit movement, understand which products drive the most margin, measure repeat purchasing behavior, and catch reporting differences before dashboards are shared with leadership.

From an executive perspective, this type of SQL reporting layer helps teams move from raw data to trusted insights. It supports customer retention strategy, revenue growth planning, product performance reviews, dashboard quality control, and business intelligence reporting in tools like Power BI, QuickSight, or Tableau.

This project reflects an end to end analytics workflow: database creation, large scale test data generation, SQL transformation, business logic, reporting views, validation, and executive ready outputs.
