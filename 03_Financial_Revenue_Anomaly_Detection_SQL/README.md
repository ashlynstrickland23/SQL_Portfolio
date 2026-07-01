# Financial Revenue Anomaly Detection SQL Project

This project presents a simulated finance and subscription revenue analytics engagement where raw customer, subscription, invoice, payment, refund, and dispute data is transformed into a clean PostgreSQL reporting layer for executive decision making.

The objective is to help leadership monitor revenue performance, identify unusual revenue movement, detect high risk customers, review refund and dispute exposure, flag duplicate payments, assess renewal risk, and validate reporting accuracy before financial metrics are used in dashboards.

This project reflects a real world finance analytics workflow where SQL is used to move from raw billing records to trusted reporting views that support revenue operations, finance teams, customer success, and executive reporting.

---

## Dataset Overview

This project uses a simulated enterprise finance dataset created in PostgreSQL.

| Table | Row Count | Description |
|---|---:|---|
| Customers | 10,000 | Customer profiles with industry, region, segment, acquisition channel, and active status |
| Subscriptions | 15,000 | Subscription records with plan, billing cycle, status, contract dates, and recurring revenue |
| Invoices | 80,000 | Invoice level billing records with invoice amount, tax, discounts, total amount, status, and due dates |
| Payments | 58,534 | Payment transactions with method, processor, status, amount, and transaction reference |
| Refunds | 10,017 | Refund records with reason, status, amount, customer, invoice, and payment reference |
| Payment Disputes | 1,475 | Dispute records with reason, status, amount, and payment reference |

---

## 🛠️ Tools Used

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![DBeaver](https://img.shields.io/badge/DBeaver-372923?style=for-the-badge&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-025E8C?style=for-the-badge&logo=database&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)
![Power BI Ready](https://img.shields.io/badge/Power_BI_Ready-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)

---

## 💡 Skills Demonstrated

![Revenue Analysis](https://img.shields.io/badge/Revenue_Analysis-228B22?style=for-the-badge)
![Anomaly Detection](https://img.shields.io/badge/Anomaly_Detection-DC143C?style=for-the-badge)
![Customer Risk](https://img.shields.io/badge/Customer_Risk-FF8C00?style=for-the-badge)
![Refund Analysis](https://img.shields.io/badge/Refund_Analysis-1E90FF?style=for-the-badge)
![Dispute Monitoring](https://img.shields.io/badge/Dispute_Monitoring-6A0DAD?style=for-the-badge)
![Renewal Risk](https://img.shields.io/badge/Renewal_Risk-2E8B57?style=for-the-badge)
![Duplicate Detection](https://img.shields.io/badge/Duplicate_Detection-B22222?style=for-the-badge)
![SQL Joins](https://img.shields.io/badge/SQL_Joins-008080?style=for-the-badge)
![CTEs](https://img.shields.io/badge/CTEs-4682B4?style=for-the-badge)
![Window Functions](https://img.shields.io/badge/Window_Functions-4B0082?style=for-the-badge)
![Data Validation](https://img.shields.io/badge/Data_Validation-B22222?style=for-the-badge)
![Executive Reporting](https://img.shields.io/badge/Executive_Reporting-2E8B57?style=for-the-badge)

---

## Monthly Revenue Anomaly Summary

This output shows monthly finance performance across invoice volume, active customers, gross revenue, refunds, net revenue, collected revenue, month over month revenue movement, and anomaly status.

The analysis shows monthly gross revenue ranging from about $30.6M to $35.6M, with net revenue reaching $34.4M in March 2025. The model flags months such as May 2024 and October 2024 as Positive Revenue Spike, while June 2024, November 2024, February 2025, and June 2025 are flagged as Negative Revenue Drop.

From a business perspective, this helps finance and executive teams quickly identify unusual revenue movement. Instead of waiting for manual review, leadership can use this view to investigate revenue drops, understand refund impact, and monitor whether monthly performance is within an expected range.

![Monthly Revenue Anomaly Summary](screenshots/Monthly%20Revenue%20Anomaly%20Summary.png)

---

## Customer Revenue Risk Summary

This output ranks customers by net revenue while also showing invoice count, overdue invoices, refund invoices, dispute invoices, overdue invoice rate, refund invoice rate, and financial risk group.

The top customer shown generated $766K in net revenue across 35 invoices, with 3 overdue invoices and 4 refund invoices. Other high revenue customers are flagged as High Financial Risk when overdue activity, disputes, or refund patterns indicate potential collection or revenue risk.

From a business perspective, this view helps finance, customer success, and account management teams prioritize high value customers that need attention. A business can use this analysis to reduce bad debt risk, improve collections follow up, protect strategic accounts, and monitor customers with repeated billing exceptions.

![Customer Revenue Risk Summary](screenshots/Customer%20Revenue%20Risk%20Summary.png)

---

## Refund and Dispute Risk Analysis

This output highlights customers with the highest refund and dispute exposure.

The top customer shown has $370.6K in gross revenue, $104.2K refunded, $23.0K disputed, and a refund amount rate of 28.12 percent. Several customers are flagged as High Exception Risk due to elevated refund rates, dispute activity, or large dollar exposure.

From a business perspective, this helps teams identify where revenue is being reduced after invoicing. High refund or dispute activity can point to service issues, billing problems, customer dissatisfaction, contract confusion, or fraud review needs. This view supports finance controls, customer experience improvements, and revenue protection.

![Refund and Dispute Risk Analysis](screenshots/Refund%20and%20Dispute%20Risk%20Analysis.png)

---

## Subscription Renewal Risk Summary

This output identifies subscriptions that may be at risk based on contract end timing, subscription status, overdue invoice count, monthly recurring revenue, and net revenue.

The screenshot shows several Strategic and Enterprise customers marked as High Renewal Risk, with monthly recurring revenue above $35K and overdue invoice activity. Some records also show negative days until contract end, indicating contracts that have already passed the renewal date and need review.

From a business perspective, this helps customer success and revenue teams prioritize renewal conversations before revenue is lost. High MRR customers with overdue invoices or expired contract dates should be reviewed quickly to protect recurring revenue and reduce churn risk.

![Subscription Renewal Risk Summary](screenshots/Subscription%20Renewal%20Risk%20Summary.png)

---

## Duplicate Payment Detection

This output identifies potential duplicate payment records by grouping successful payments with the same invoice, customer, payment date, payment method, processor, and payment amount.

The screenshot shows duplicate payment groups with duplicate counts of 2, including payment amounts above $50K. For example, one invoice shows two successful payments for $50,311.20 on the same payment date and processor.

From a business perspective, duplicate payment detection is important for financial controls and customer trust. This analysis helps billing teams catch possible duplicate charges, prevent incorrect revenue reporting, reduce refund requests, and improve payment quality checks.

![Duplicate Payment Detection](screenshots/Duplicate%20Payment%20Detection.png)

---

## Financial Validation Summary

This output compares raw database values against the reporting view layer to validate reporting accuracy.

The validation summary shows invoices, payments, refunds, disputes, and subscriptions passing with zero difference. It also shows Customer Count marked as Review because the reporting view only includes customers with invoice activity, while the raw customer table contains all 10,000 customers.

From a business perspective, this validation step helps ensure that finance reporting is accurate before metrics are used in dashboards or executive meetings. It also shows where business rules create expected differences between raw source tables and reporting views.

![Financial Validation Summary](screenshots/Financial%20Validation%20Summary.png)

---

## Overall Business Value

This project demonstrates how SQL can support finance and revenue operations by creating a trusted reporting layer between raw billing data and executive dashboards.

The analysis helps a business monitor revenue trends, detect unusual monthly revenue movement, identify customers with financial risk, review refund and dispute exposure, flag duplicate payments, evaluate renewal risk, and validate reporting accuracy.

From an executive perspective, this type of SQL reporting layer supports better decisions around revenue performance, customer retention, collections, billing controls, renewal management, and financial reporting quality. Instead of relying on manual spreadsheet review, the business receives repeatable SQL views that can feed directly into Power BI, QuickSight, Tableau, or monthly finance reports.

This project reflects an end to end analytics workflow: database creation, large scale test data generation, SQL transformation, anomaly logic, customer risk scoring, duplicate detection, validation checks, and executive ready outputs.
