# olist_sql_business_analysis
End-to-end SQL Server business analysis of Olist Brazilian E-Commerce dataset.

🛒 Olist E-Commerce Business Analysis (SQL Server)
📌 Project Overview

This project performs an end-to-end SQL-based business analysis of the Olist Brazilian E-Commerce dataset (2016–2018).

The objective is to evaluate:

Revenue performance

Geographic demand concentration

Customer behavior

Delivery efficiency

Seller contribution

Payment trends

Customer satisfaction

🗂 Dataset Source

Dataset: Olist Brazilian E-Commerce
Source: Kaggle
Link: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

🛠 Tools Used

SQL Server

Joins

Aggregations

Window Functions

CTEs (limited usage for clarity)

Business KPI derivation

📁 Project Structure
data/source/ → Raw CSV files
sql/ → Database creation + KPI + Business analysis scripts
📊 Key KPIs Computed

Total Orders

Delivered Orders

Delivery Rate

Total Revenue (price + freight)

Average Order Value

Monthly Revenue + Running Revenue

Revenue by State

Top Categories by Revenue

Late Delivery Rate

Average Delivery Days

Payment Type Mix

Review Score Distribution

Seller Revenue Ranking

Unique Customers by State

📈 Business Insights Summary
Overall Performance

Total Orders: 99,441

Delivered Rate: 97.02%

Total Revenue: 15.42M

Average Order Value: 159.81

Revenue Concentration

São Paulo generates 5.77M revenue.

Top 5 states contribute ~73.20% of total revenue.
→ Demand is highly concentrated geographically.

Growth & Seasonality

November 2017 recorded highest monthly revenue (1.15M).

Revenue grew ~53.54% MoM in November 2017.

Customer Behavior

Repeat customer rate: ~3%

Avg orders per customer: 1.03
→ Marketplace relies heavily on one-time buyers.

Delivery Performance

Average delivery time: 12.09 days

Late delivery rate: 8.11%

Avg delay (late orders): 8.87 days
→ Delivery delays present optimization opportunity.

Customer Satisfaction

Average review score: 4.16 / 5

59.22% orders receive 5-star rating
→ Overall sentiment strong, but ~10% 1-star reviews remain concern.

Payment Behavior

Credit card accounts for 78.46% of revenue.

Boleto accounts for 17.96%.
→ Installment-based payments likely support higher AOV.

🎯 Executive Summary

The Olist marketplace demonstrates strong operational reliability (97% delivery rate) and positive customer sentiment (4.16 average rating). However, revenue is highly concentrated in a few states and categories, and repeat customer rate is low (~3%), highlighting retention as the biggest growth opportunity.

Logistics optimization and customer retention strategies present the highest potential business impact.
