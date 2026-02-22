--USE Olist;
--GO

-------- Creating DW Tables

---- Category Translation
--CREATE TABLE dw.product_category_name_translation (
--    product_category_name NVARCHAR(50) PRIMARY KEY,
--    product_category_name_english NVARCHAR(50) NOT NULL
--);

---- Products
--CREATE TABLE dw.products (
--    product_id NVARCHAR(32) PRIMARY KEY,
--    product_category_name NVARCHAR(50),
--    product_name_lenght INT,
--    product_description_lenght INT,
--    product_photos_qty INT,
--    product_weight_g INT,
--    product_length_cm INT,
--    product_height_cm INT,
--    product_width_cm INT
--);

---- Customers
--CREATE TABLE dw.customers (
--    customer_id NVARCHAR(32) PRIMARY KEY,
--    customer_unique_id NVARCHAR(32) NOT NULL,
--    customer_zip_code_prefix INT,
--    customer_city NVARCHAR(100),
--    customer_state NCHAR(2)
--);

---- Sellers
--CREATE TABLE dw.sellers (
--    seller_id NVARCHAR(32) PRIMARY KEY,
--    seller_zip_code_prefix INT,
--    seller_city NVARCHAR(100),
--    seller_state NCHAR(2)
--);

---- Orders
--CREATE TABLE dw.orders (
--    order_id NVARCHAR(32) PRIMARY KEY,
--    customer_id NVARCHAR(32) NOT NULL,
--    order_status NVARCHAR(20),
--    order_purchase_timestamp DATETIME2,
--    order_approved_at DATETIME2,
--    order_delivered_carrier_date DATETIME2,
--    order_delivered_customer_date DATETIME2,
--    order_estimated_delivery_date DATETIME2
--);

---- Order Items
--CREATE TABLE dw.order_items (
--    order_id NVARCHAR(32),
--    order_item_id INT,
--    product_id NVARCHAR(32),
--    seller_id NVARCHAR(32),
--    shipping_limit_date DATETIME2,
--    price DECIMAL(12,2),
--    freight_value DECIMAL(12,2),
--    CONSTRAINT PK_order_items PRIMARY KEY (order_id, order_item_id)
--);

---- Payments
--CREATE TABLE dw.order_payments (
--    order_id NVARCHAR(32),
--    payment_sequential INT,
--    payment_type NVARCHAR(30),
--    payment_installments INT,
--    payment_value DECIMAL(12,2),
--    CONSTRAINT PK_order_payments PRIMARY KEY (order_id, payment_sequential)
--);

---- Reviews
--CREATE TABLE dw.order_reviews (
--    review_id NVARCHAR(32),
--    order_id NVARCHAR(32),
--    review_score INT,
--    review_comment_title NVARCHAR(255),
--    review_comment_message NVARCHAR(2000),
--    review_creation_date DATETIME2,
--    review_answer_timestamp DATETIME2,
--    CONSTRAINT PK_order_reviews PRIMARY KEY (review_id, order_id)
--);


------ Inserting Values in DW Tables


------ CATEGORY TRANSLATION 
--INSERT INTO dw.product_category_name_translation
--SELECT
--    TRIM(product_category_name),
--    TRIM(product_category_name_english)
--FROM raw.product_category_name_translation;


------ PRODUCTS 
--INSERT INTO dw.products
--SELECT
--    TRIM(product_id),
--    TRIM(product_category_name),
--    product_name_lenght,
--    product_description_lenght,
--    product_photos_qty,
--    product_weight_g,
--    product_length_cm,
--    product_height_cm,
--    product_width_cm
--FROM raw.products;


------ CUSTOMERS 
--INSERT INTO dw.customers
--SELECT
--    TRIM(customer_id),
--    TRIM(customer_unique_id),
--    customer_zip_code_prefix,
--    TRIM(customer_city),
--    TRIM(customer_state)
--FROM raw.customers;


------ SELLERS 
--INSERT INTO dw.sellers
--SELECT
--    TRIM(seller_id),
--    seller_zip_code_prefix,
--    TRIM(seller_city),
--    TRIM(seller_state)
--FROM raw.sellers;


------ ORDERS 
--INSERT INTO dw.orders
--SELECT
--    TRIM(order_id),
--    TRIM(customer_id),
--    TRIM(order_status),
--    TRY_CONVERT(datetime2(0), TRIM(order_purchase_timestamp)),
--    TRY_CONVERT(datetime2(0), NULLIF(TRIM(order_approved_at), '')),
--    TRY_CONVERT(datetime2(0), NULLIF(TRIM(order_delivered_carrier_date), '')),
--    TRY_CONVERT(datetime2(0), NULLIF(TRIM(order_delivered_customer_date), '')),
--    TRY_CONVERT(datetime2(0), TRIM(order_estimated_delivery_date))
--FROM raw.orders;


------ ORDER ITEMS 
--INSERT INTO dw.order_items
--SELECT
--    TRIM(order_id),
--    order_item_id,
--    TRIM(product_id),
--    TRIM(seller_id),
--    TRY_CONVERT(datetime2(0), TRIM(shipping_limit_date)),
--    TRY_CONVERT(decimal(12,2), price),
--    TRY_CONVERT(decimal(12,2), freight_value)
--FROM raw.order_items;


------ PAYMENTS 
--INSERT INTO dw.order_payments
--SELECT
--    TRIM(order_id),
--    payment_sequential,
--    TRIM(payment_type),
--    payment_installments,
--    TRY_CONVERT(decimal(12,2), payment_value)
--FROM raw.order_payments;


------ REVIEWS 
--INSERT INTO dw.order_reviews
--SELECT
--    TRIM(review_id),
--    TRIM(order_id),
--    review_score,
--    TRIM(review_comment_title),
--    TRIM(review_comment_message),
--    TRY_CONVERT(datetime2(0), TRIM(review_creation_date)),
--    TRY_CONVERT(datetime2(0), NULLIF(TRIM(review_answer_timestamp), ''))
--FROM raw.order_reviews;



---- Defining Foreign Keys


--ALTER TABLE dw.orders
--ADD CONSTRAINT FK_orders_customers
--FOREIGN KEY (customer_id) REFERENCES dw.customers(customer_id);

--ALTER TABLE dw.order_items
--ADD CONSTRAINT FK_items_orders
--FOREIGN KEY (order_id) REFERENCES dw.orders(order_id);

--ALTER TABLE dw.order_items
--ADD CONSTRAINT FK_items_products
--FOREIGN KEY (product_id) REFERENCES dw.products(product_id);

--ALTER TABLE dw.order_items
--ADD CONSTRAINT FK_items_sellers
--FOREIGN KEY (seller_id) REFERENCES dw.sellers(seller_id);

--ALTER TABLE dw.order_payments
--ADD CONSTRAINT FK_payments_orders
--FOREIGN KEY (order_id) REFERENCES dw.orders(order_id);

--ALTER TABLE dw.order_reviews
--ADD CONSTRAINT FK_reviews_orders
--FOREIGN KEY (order_id) REFERENCES dw.orders(order_id);