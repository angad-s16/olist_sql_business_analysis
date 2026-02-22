# olist_sql_business_analysis
End-to-end SQL Server business analysis of Olist Brazilian E-Commerce dataset.

# 🛒 Olist E-Commerce Business Analysis
## 📌 Project Overview

This project performs an end-to-end SQL-based business analysis of the Olist Brazilian E-Commerce dataset (2016–2018).

The objective is to evaluate:

- Revenue performance  
- Geographic demand concentration  
- Customer behavior  
- Delivery efficiency  
- Seller contribution  
- Payment trends  
- Customer satisfaction  

The analysis is built using SQL Server with structured KPI computation and business-driven insights.

---

## 🗂 Dataset Source

- **Dataset:** Olist Brazilian E-Commerce Public Dataset  
- **Source:** Kaggle  
- **Link:** https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

---

## 🛠 Tools & Techniques Used

- SQL Server  
- Joins (Primary & Foreign Key Relationships)  
- Aggregations (SUM, COUNT, AVG)  
- Window Functions (Running Revenue, Ranking)  
- CTEs (Minimal usage for clarity)  
- Business KPI Derivation  

---

## 📊 Key KPIs Computed

- Total Orders  
- Delivered Orders  
- Delivery Rate (%)  
- Total Revenue (price + freight_value)  
- Average Order Value (AOV)  
- Monthly Revenue & Running Revenue  
- Revenue by Customer State  
- Top Categories by Revenue  
- Top Products by Revenue  
- Average Delivery Days  
- Late Delivery Rate (%)  
- Average Freight Cost  
- Average Items per Order  
- Total Sellers  
- Seller Revenue Ranking  
- Total Unique Customers  
- Customers by State  
- Payment Type Mix  
- Review Score Distribution  

---

# 📈 Business Insights Summary

## 1️⃣ Overall Performance

- **Total Orders:** 99,441  
- **Delivered Orders:** 96,478  
- **Delivery Rate:** 97.02%  
- **Total Revenue:** 15.42M  
- **Average Order Value:** 159.81  

The platform demonstrates strong operational reliability with a high delivery completion rate and stable order value.

---

## 2️⃣ Revenue Concentration (Geography)

- São Paulo (SP) generates **5.77M revenue** and **40,494 delivered orders**.
- The **Top 5 states contribute ~73.20% of total revenue**.

Revenue is highly concentrated in a few major regions, indicating geographic dependency.

---

## 3️⃣ Growth & Seasonality

- Highest revenue month: **November 2017 (1.15M revenue, 7,288 orders)**.
- Revenue grew **~53.54% MoM in November 2017**.

The business exhibits seasonal spikes, especially during peak shopping months.

---

## 4️⃣ Category Performance

- Top 10 categories contribute **~62.39% of total revenue**.
- Leading categories:
  - health_beauty (1.41M)
  - watches_gifts (1.26M)
  - bed_bath_table (1.23M)
  - sports_leisure (1.12M)
  - computers_accessories (1.03M)

Revenue is driven by a limited number of dominant categories.

---

## 5️⃣ Customer Behavior & Retention

- **Repeat Customer Rate:** ~3%  
- **Average Orders per Customer:** 1.03  

The marketplace is primarily driven by one-time buyers, indicating a strong opportunity for retention-focused strategies.

---

## 6️⃣ Delivery Performance

- **Average Delivery Time:** 12.09 days  
- **Late Delivery Rate:** 8.11%  
- **Average Delay (Late Orders):** 8.87 days  

While delivery completion is high, delays when they occur are significant and may impact customer experience.

---

## 7️⃣ Customer Satisfaction

- **Average Review Score:** 4.16 / 5  
- Review Distribution:
  - 5-star: 59.22%
  - 4-star: 19.71%
  - 3-star: 8.26%
  - 2-star: 3.05%
  - 1-star: 9.76%

Overall customer sentiment is positive, but nearly 10% of orders receive 1-star ratings, indicating service gaps.

---

## 8️⃣ Payment Behavior

- Credit Card: **78.46% of revenue**
- Boleto: **17.96%**
- Voucher: 2.22%
- Debit Card: 1.35%

Credit card dominates transactions, with installment payments likely supporting higher-value purchases.

---

# 🎯 Executive Summary

Olist demonstrates strong delivery reliability (97% delivery rate) and high customer satisfaction (4.16 average rating). However, revenue is geographically concentrated and repeat customer rate is low (~3%), highlighting customer retention as the largest growth opportunity.

Operational improvements in logistics and targeted retention initiatives could significantly enhance long-term marketplace performance.

---

## 🚀 Future Enhancements

- Integrating Tableau dashboard for visualization
- Delivery delay vs review score correlation analysis
- Seller performance benchmarking
- Cohort-based customer retention analysis
