# Retail Customer Segmentation SQL Project

This project demonstrates how raw retail sales data can be transformed into clean PostgreSQL reporting views for business intelligence and dashboard development.

The goal of this project is to show how SQL can be used to analyze customer behavior, segment customers, track revenue trends, evaluate product profitability, measure cohort retention, and validate dashboard ready reporting tables.

## Dataset Overview

This project uses a simulated retail dataset created in PostgreSQL.

The database includes:

* 5,000 customers
* 50,000 orders
* 100,140 order item rows
* 100 products
* 20 suppliers
* 8 warehouses
* 8,762 returns

## Tools Used

* PostgreSQL
* DBeaver
* SQL
* GitHub
* Power BI ready reporting views

## Skills Demonstrated

* Database table creation
* Large test data generation
* SQL joins
* CTEs
* Window functions
* RFM customer segmentation
* Monthly sales trend analysis
* Product profitability analysis
* Cohort retention analysis
* Dashboard validation
* Reporting view development

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
