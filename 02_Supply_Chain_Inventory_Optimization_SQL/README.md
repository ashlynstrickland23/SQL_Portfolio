# Supply Chain Inventory Optimization SQL Project

This project presents a simulated supply chain analytics engagement where raw inventory, supplier, warehouse, and purchase order data is transformed into a clean PostgreSQL reporting layer for operational and executive decision making.

The objective is to help leadership identify inventory risk, supplier delivery issues, warehouse capacity concerns, purchase order delays, and reporting accuracy gaps through SQL driven analysis. The final reporting views are designed to support business intelligence tools such as Power BI, QuickSight, or Tableau.

This project reflects a real world supply chain workflow where SQL is used to move from raw operational records to trusted reporting outputs that help reduce stock risk, improve supplier accountability, and support inventory planning.

## Dataset Overview

This project uses a simulated enterprise supply chain dataset created in PostgreSQL.

| Table | Row Count | Description |
|---|---:|---|
| Suppliers | 30 | Supplier details, regions, categories, lead times, ratings, and active status |
| Warehouses | 10 | Distribution centers, fulfillment centers, logistics hubs, and import locations |
| Products | 250 | Product catalog with SKU, category, supplier, cost, price, reorder point, and demand |
| Inventory Snapshots | 452,500 | Daily inventory records across products and warehouses |
| Latest Inventory Rows | 2,500 | Most recent product and warehouse inventory records used for reporting |
| Purchase Orders | 20,000 | Supplier purchase orders with expected delivery, actual delivery, status, and priority |
| Purchase Order Items | Generated Line Items | Product level purchase order detail with ordered units, received units, cost, and line value |

## 🛠️ Tools Used

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![DBeaver](https://img.shields.io/badge/DBeaver-372923?style=for-the-badge&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-025E8C?style=for-the-badge&logo=database&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)
![Power BI Ready](https://img.shields.io/badge/Power_BI_Ready-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)

## 💡 Skills Demonstrated

![Inventory Analysis](https://img.shields.io/badge/Inventory_Analysis-228B22?style=for-the-badge)
![Supplier Performance](https://img.shields.io/badge/Supplier_Performance-1E90FF?style=for-the-badge)
![Purchase Order Analysis](https://img.shields.io/badge/Purchase_Order_Analysis-6A0DAD?style=for-the-badge)
![Warehouse Reporting](https://img.shields.io/badge/Warehouse_Reporting-FF8C00?style=for-the-badge)
![Stock Risk Logic](https://img.shields.io/badge/Stock_Risk_Logic-DC143C?style=for-the-badge)
![SQL Joins](https://img.shields.io/badge/SQL_Joins-008080?style=for-the-badge)
![CTEs](https://img.shields.io/badge/CTEs-4682B4?style=for-the-badge)
![Reporting Views](https://img.shields.io/badge/Reporting_Views-4B0082?style=for-the-badge)
![Data Validation](https://img.shields.io/badge/Data_Validation-B22222?style=for-the-badge)
![Executive Reporting](https://img.shields.io/badge/Executive_Reporting-2E8B57?style=for-the-badge)

## Inventory Health Summary

This output summarizes the latest inventory position by stock status across all warehouse and product combinations.

The analysis shows 1,394 healthy product warehouse combinations with 2.7M available units and $627.4M in inventory value. It also identifies 428 overstock records representing $356.3M in inventory value, along with 406 reorder needed records and 266 critical stock records.

From a business perspective, this helps leadership understand where inventory is balanced, where capital may be tied up in excess stock, and where replenishment action may be needed. This type of view supports inventory planning, working capital management, and operational risk monitoring.

![Inventory Health Summary](screenshots/Inventory%20Health%20Summary.png)

## Supplier Performance Summary

This output ranks suppliers by delivery performance, fill rate, volume, spend, and performance tier.

The screenshot highlights suppliers with low on time delivery rates, including suppliers around 31 percent to 35 percent on time delivery. Several suppliers are marked as Delivery Risk, with total spend exceeding $100M for some supplier relationships.

From a business perspective, this helps procurement and operations teams identify supplier reliability issues before they impact customer fulfillment. A business could use this view to renegotiate supplier terms, prioritize backup vendors, monitor late deliveries, and improve supply chain accountability.

![Supplier Performance Summary](screenshots/Supplier%20Performance%20Summary.png)

## Stockout Risk Analysis

This output evaluates product level inventory risk using available units, inbound units, average daily demand, days of inventory, and recommended reorder quantity.

The screenshot shows products currently classified as Overstock Risk, with some products carrying more than 200 days of inventory. While this is not an immediate stockout issue, it signals that inventory dollars may be tied up in products that are not moving quickly enough.

From a business perspective, this helps teams identify both shortage risk and excess inventory risk. Overstocked products may require pricing review, promotion planning, demand forecasting adjustments, or purchasing changes to prevent unnecessary carrying costs.

![Stockout Risk Analysis](screenshots/Stockout%20Risk%20Analysis.png)

## Warehouse Inventory Summary

This output summarizes inventory performance by warehouse, including total SKUs, stockout count, critical stock count, reorder needed count, overstock count, available units, inventory value, and capacity usage.

The screenshot shows each warehouse carrying 250 SKUs, with inventory values ranging from about $99.4M to $114.5M. Charlotte Logistics Hub shows the highest inventory value at $114.5M, while several warehouses show stockout or critical stock records that require review.

From a business perspective, this helps leadership compare inventory health across warehouse locations. It can support warehouse capacity planning, regional replenishment decisions, transfer planning, and operational performance reviews.

![Warehouse Inventory Summary](screenshots/Warehouse%20Inventory%20Summary.png)

## Purchase Order Delivery Analysis

This output shows purchase order level delivery performance by supplier and warehouse.

The screenshot highlights late purchase orders with delivery delays of 9 days. It includes expected delivery date, actual delivery date, delivery status, fill rate, and purchase order value. Several late orders still show high fill rates, which helps separate delivery timing issues from quantity fulfillment issues.

From a business perspective, this helps operations teams identify delayed shipments, quantify supplier delivery issues, and understand which late orders carry the most financial impact. This type of view supports supplier scorecards, procurement follow up, and fulfillment risk management.

![Purchase Order Delivery Analysis](screenshots/Purchase%20Order%20Delivery%20Analysis.png)

## Supply Chain Validation Summary

This output compares raw database values against the reporting view layer to confirm that key metrics reconcile correctly.

The validation summary shows all core metrics passing with zero difference, including 30 suppliers, 10 warehouses, 250 products, 20,000 purchase orders, and 2,500 latest inventory product warehouse rows.

From a business perspective, this step helps ensure that reporting outputs are reliable before they are connected to a dashboard or shared with leadership. It demonstrates a quality control process that checks whether the reporting layer matches the source database.

![Supply Chain Validation Summary](screenshots/Supply%20Chain%20Validation%20Summary.png)

## Overall Business Value

This project demonstrates how SQL can support supply chain decision making by creating a trusted reporting layer between raw operational data and executive dashboards.

The analysis helps a business monitor inventory health, identify excess stock, detect products that need replenishment, compare warehouse performance, track supplier delivery reliability, review delayed purchase orders, and validate reporting accuracy.

From an executive perspective, this reporting layer supports better decisions around procurement, inventory planning, warehouse operations, supplier management, working capital, and fulfillment risk. Instead of relying on disconnected spreadsheets or raw system exports, the business receives clean SQL views that can feed directly into BI dashboards and recurring operational reports.

This project reflects an end to end analytics workflow: database creation, large scale test data generation, SQL transformation, operational business logic, reporting views, validation checks, and executive ready outputs.

---

[← Back to Main README](../README.md)
