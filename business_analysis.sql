/*
========================================================
OLIST E-COMMERCE DATA ANALYSIS (SQL SERVER)
Author: Angad Singh
Focus: KPI Computation + Business Insights
Dataset: Olist Brazilian E-Commerce Dataset

Scope:
- Delivered Orders Focus
- Revenue = price + freight_value
- Analysis Period: 2016–2018

Objective:
To evaluate marketplace performance, customer behavior,
delivery efficiency, seller contribution, and payment trends.
========================================================
*/


-- SALES


-- 1) Total Orders + Delivered Orders + Delivery Rate
SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_delivered_customer_date IS NOT NULL THEN 1 ELSE 0 END) AS delivered_orders,
    ROUND(
        100.0 * CAST(SUM(CASE WHEN order_delivered_customer_date IS NOT NULL THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*),
    2) AS delivered_rate_pct
FROM dw.orders;


-- 2) Total Revenue 
SELECT 
    SUM(oi.price + oi.freight_value) AS total_revenue_delivered
FROM dw.order_items oi
JOIN dw.orders o
    ON oi.order_id = o.order_id
WHERE LOWER(o.order_status) = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL;


-- 3) Revenue by Customer State   
SELECT
    c.customer_state,
    SUM(oi.price + oi.freight_value) AS revenue
FROM dw.orders o
JOIN dw.order_items oi
    ON o.order_id = oi.order_id
JOIN dw.customers c
    ON c.customer_id = o.customer_id
WHERE LOWER(o.order_status) = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY revenue DESC;


-- 4) Average Order Value (AOV) 
WITH order_totals AS
(
    SELECT 
        o.order_id,
        SUM(oi.price + oi.freight_value) AS order_value
    FROM dw.order_items oi
    JOIN dw.orders o
        ON oi.order_id = o.order_id
    WHERE LOWER(o.order_status) = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
    GROUP BY o.order_id
)
SELECT 
    ROUND(CAST(AVG(order_value) AS FLOAT), 2) AS avg_order_value
FROM order_totals;


-- 5) Monthly Revenue + Running Revenue 
WITH monthly_rev AS
(
    SELECT 
        YEAR(o.order_purchase_timestamp) AS order_year,
        MONTH(o.order_purchase_timestamp) AS order_month,
        SUM(oi.price + oi.freight_value) AS revenue
    FROM dw.orders o
    JOIN dw.order_items oi
        ON o.order_id = oi.order_id
    WHERE LOWER(o.order_status) = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
    GROUP BY YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp)
)
SELECT 
    order_year,
    order_month,
    revenue,
    SUM(revenue) OVER(ORDER BY order_year, order_month) AS running_revenue
FROM monthly_rev
ORDER BY order_year, order_month;


-- 6) Orders per Month (Volume Trend)  
SELECT
    YEAR(order_purchase_timestamp) AS order_year,
    MONTH(order_purchase_timestamp) AS order_month,
    datename(month, order_purchase_timestamp) month,
    COUNT(order_id) AS total_orders
FROM dw.orders
GROUP BY YEAR(order_purchase_timestamp),
         MONTH(order_purchase_timestamp),
             datename(month, order_purchase_timestamp)

ORDER BY order_year, order_month, month;


-- 7) Top 10 Categories by Revenue + Orders + AOV 
WITH category_data AS
(
    SELECT
        o.order_id,
        COALESCE(t.product_category_name_english, 'unknown') AS category_english,
        SUM(oi.price + oi.freight_value) AS order_value
    FROM dw.order_items oi
    JOIN dw.orders o 
        ON o.order_id = oi.order_id
    JOIN dw.products p 
        ON p.product_id = oi.product_id
    LEFT JOIN dw.product_category_name_translation t
        ON t.product_category_name = p.product_category_name
    WHERE LOWER(o.order_status) = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
    GROUP BY COALESCE(t.product_category_name_english, 'unknown'), o.order_id
)
SELECT TOP 10
    category_english,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(order_value) AS total_revenue,
    ROUND(CAST(AVG(order_value) AS FLOAT), 2) AS avg_order_value
FROM category_data
GROUP BY category_english
ORDER BY total_revenue DESC;


-- 8) Top 10 Products by Revenue 
SELECT TOP 10
    oi.product_id,
    SUM(oi.price + oi.freight_value) AS revenue
FROM dw.order_items oi
JOIN dw.orders o
    ON o.order_id = oi.order_id
WHERE LOWER(o.order_status) = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY oi.product_id
ORDER BY revenue DESC;



-- DELIVERY


-- 9) Average Delivery Days 
SELECT 
    ROUND(CAST(AVG(DATEDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date)) AS FLOAT), 2) AS avg_delivery_days
FROM dw.orders
WHERE LOWER(order_status) = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


-- 10) Late Delivery Rate 
SELECT
    COUNT(*) AS delivered_orders,
    SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) AS late_orders,
    ROUND(
        100.0 * SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) / COUNT(*),
    2) AS late_delivery_rate_pct
FROM dw.orders
WHERE LOWER(order_status) = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


-- 11) Average Freight Cost   
SELECT
    ROUND(AVG(CAST(oi.freight_value AS FLOAT)), 2) AS avg_freight_cost
FROM dw.order_items oi
JOIN dw.orders o
    ON o.order_id = oi.order_id
WHERE LOWER(o.order_status) = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL;


-- 12) Average Items per Order   
SELECT
    ROUND(
        CAST(COUNT(*) AS FLOAT) /
        COUNT(DISTINCT oi.order_id),
    2) AS avg_items_per_order
FROM dw.order_items oi
JOIN dw.orders o
    ON o.order_id = oi.order_id
WHERE LOWER(o.order_status) = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL;



-- SELLERS


-- 13) Total Sellers
SELECT COUNT(*) AS total_sellers
FROM dw.sellers;


-- 14) Top Sellers by Revenue + Rank 
WITH seller_revenue AS
(
    SELECT
        oi.seller_id,
        SUM(oi.price + oi.freight_value) AS revenue
    FROM dw.order_items oi
    JOIN dw.orders o
        ON o.order_id = oi.order_id
    WHERE LOWER(o.order_status) = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
    GROUP BY oi.seller_id
)
SELECT
    seller_id,
    revenue,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM seller_revenue
ORDER BY revenue_rank;



-- CUSTOMERS


-- 15) Total Unique Customers
SELECT COUNT(DISTINCT customer_unique_id) AS total_unique_customers
FROM dw.customers;


-- 16) Unique Customers by State
SELECT 
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM dw.customers
GROUP BY customer_state
ORDER BY unique_customers DESC;


-- 17) Top 10 States by Delivered Orders
SELECT TOP 10
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS delivered_orders
FROM dw.orders o
JOIN dw.customers c
    ON c.customer_id = o.customer_id
WHERE LOWER(o.order_status) = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY delivered_orders DESC;



-- PAYMENTS


-- 18) Payment Type Mix 
SELECT
    op.payment_type,
    COUNT(*) AS payment_rows,
    SUM(op.payment_value) AS total_payment_value
FROM dw.order_payments op
JOIN dw.orders o
    ON o.order_id = op.order_id
WHERE LOWER(o.order_status) = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY op.payment_type
ORDER BY total_payment_value DESC;



-- REVIEWS


-- 19) Review Score Distribution
SELECT 
    review_score,
    COUNT(*) AS total_reviews
FROM dw.order_reviews
GROUP BY review_score
ORDER BY review_score;




/*
========================================================
BUSINESS INSIGHTS SUMMARY (Derived from KPI Analysis)
Scope:
- Delivered orders focus
- Revenue = sum(price + freight_value)
========================================================

1) Overall Performance
- Total Orders: 99,441
- Delivered Orders: 96,478 ---- Delivered Rate: 97.02%
- Total Revenue (price + freight): 15.42M
- Average Order Value (AOV): 159.81

2) Revenue Concentration (Geography)
- São Paulo (SP) is the #1 state by both revenue and delivered orders:
  * Delivered Orders (SP): 40,494
  * Revenue (SP): 5.77M
- Top 5 states contribute ~73.20% of total revenue ---- demand is highly concentrated in a few regions.

3) Growth & Seasonality
- Highest revenue month: Nov 2017 (Revenue: 1.15M, Orders: 7,288)
- Revenue grew ~53.54% MoM in Nov 2017 vs Oct 2017 (strong seasonal spike).

4) Category Performance
- Top 10 categories contribute ~62.39% of total revenue ---- category sales are also concentrated.
- Top revenue categories include:
  * health_beauty (1.41M)
  * watches_gifts (1.26M)
  * bed_bath_table (1.23M)
  * sports_leisure (1.12M)
  * computers_accessories (1.03M)

5) Customer Behavior (Retention)
- Repeat customer rate (delivered orders): ~3.00%
- Avg orders per customer: 1.03
---- The marketplace is driven largely by one-time buyers; retention is a key opportunity area.

6) Logistics & Delivery Performance
- Average delivery time: 12.09 days (purchase ---- delivered)
- Late delivery rate: 8.11% of delivered orders
- Avg delay for late deliveries: 8.87 days late
---- Delays are not frequent but when they happen, they are significant.

7) Customer Satisfaction (Reviews)
- Average review score: 4.16 / 5
- Review distribution:
  * 5-star: 59.22%
  * 4-star: 19.71%
  * 3-star: 8.26%
  * 2-star: 3.05%
  * 1-star: 9.76%
---- Overall sentiment is strong, but ~1 in 10 orders still receive 1-star ratings.

8) Payment Behavior
- Revenue share by payment method:
  * Credit card: 78.46%
  * Boleto: 17.96%
  * Voucher: 2.22%
  * Debit card: 1.35%
---- Credit card dominates, but boleto is still a significant secondary payment mode.

========================================================
Executive Summary:
Olist shows strong delivery completion (97%) and high average rating (~4.16), but revenue is concentrated in a few states/categories and repeat customers are very low (~3%). 
Logistics delays (8.11%) remain a meaningful lever to improve customer satisfaction, while retention initiatives offer the biggest growth opportunity.
========================================================
*/