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

This query groups customers into RFM customer segments and summarizes customer count, total revenue, and average order value. The output helps identify high value customers, loyal customers, inactive customers, and at risk customer groups for business decision making.

![Customer Segmentation Revenue Summary](screenshots/Customer%20Segmentation%20Revenue%20Summary.png)

---

## Monthly Sales Trends and Growth Analysis

This query summarizes monthly sales performance using a PostgreSQL reporting view. The output includes total orders, unique customers, revenue, profit, average item revenue, previous month revenue, and month over month growth percentages.

![Monthly Sales Trends and Growth Analysis](screenshots/Monthly%20Sales%20Trends%20and%20Growth%20Analysis.png)

---

## Product Profitability and Ranking Analysis

This query ranks products by revenue and profit while also showing total units sold, net sales, profit margin, return rate, revenue rank, and profit rank. This helps identify top performing products and products that may need review.

![Product Profitability and Ranking Analysis](screenshots/Product%20Profitability%20and%20Ranking%20Analysis.png)

---

## Customer Cohort Retention Analysis

This query tracks customer retention by cohort month and months since first order. It helps analyze whether customers continue purchasing after their first month.

![Customer Cohort Retention Analysis](screenshots/Customer%20Cohort%20Retention%20Analysis.png)

---

## Executive RFM Segment Summary

This view provides an executive ready summary of customer segments, revenue, profit, activity, return rate, and ranking. It is designed as a dashboard ready reporting table.

![Executive RFM Segment Summary](screenshots/Executive%20RFM%20Segment%20Summary.png)

---

## Dashboard Validation Summary

This validation query compares raw database values against the reporting view layer. Metrics marked as Review show where business rules or reporting filters create differences that should be checked before dashboard reporting.

![Dashboard Validation Summary](screenshots/Dashboard%20Validation%20Summary.png)

---

## Business Value

This project demonstrates how SQL can support business intelligence by creating a reliable reporting layer between raw database tables and dashboard tools. The final views can be connected to Power BI, QuickSight, Tableau, or other BI platforms for executive reporting.
