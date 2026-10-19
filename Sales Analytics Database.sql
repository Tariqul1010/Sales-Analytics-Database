-- SALES ANALYTICS DATABASE ASSIGNMENT
-- Database: analytics_db

-- =====================================================================
-- STEP 1: DATABASE SETUP
-- =====================================================================
CREATE DATABASE IF NOT EXISTS analytics_db;
USE analytics_db;

CREATE TABLE sales (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL,
    product VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    sales_amount DECIMAL(10, 2) NOT NULL
);

INSERT INTO sales (customer_name, region, product, quantity, sales_amount) VALUES
('Alice Smith', 'North', 'Laptop', 1, 1200.00),
('Bob Johnson', 'South', 'Smartphone', 2, 1600.00),
('Charlie Brown', 'East', 'Tablet', 3, 900.00),
('David Miller', 'West', 'Monitor', 2, 500.00),
('Eva Green', 'North', 'Smartphone', 1, 800.00),
('Frank White', 'South', 'Laptop', 2, 2400.00),
('Grace Black', 'East', 'Headphones', 5, 250.00),
('Henry Adams', 'West', 'Tablet', 1, 300.00),
('Ivy Taylor', 'North', 'Monitor', 1, 250.00),
('Jack Nelson', 'South', 'Headphones', 4, 200.00),
('Karen Hill', 'East', 'Laptop', 1, 1200.00),
('Leo Carter', 'West', 'Smartphone', 3, 2400.00),
('Mia Dong', 'North', 'Tablet', 2, 600.00),
('Nathan Cruz', 'South', 'Monitor', 2, 500.00),
('Olivia Reed', 'East', 'Smartphone', 1, 800.00),
('Peter Parker', 'West', 'Laptop', 1, 1200.00),
('Quinn Fabray', 'North', 'Headphones', 3, 150.00),
('Rachel Green', 'South', 'Tablet', 2, 600.00),
('Sam Winchester', 'East', 'Monitor', 4, 1000.00),
('Thomas Wayne', 'West', 'Headphones', 2, 100.00);

-- Verify data loaded correctly
SELECT * FROM sales;


-- =====================================================================
-- STEP 2: BASIC SELECT QUERIES
-- =====================================================================

-- Query 1: all records
SELECT * FROM sales;

-- Query 2: only product and sales_amount
SELECT 
product, 
sales_amount 
FROM sales;

-- Query 3: customer, product, quantity, amount
SELECT 
customer_name, 
product, 
quantity, 
sales_amount 
FROM sales;


-- =====================================================================
-- STEP 3: FILTERING WITH WHERE
-- =====================================================================

-- Query 1: North region only
SELECT * FROM sales 
WHERE region = 'North';

-- Query 2: a specific product
SELECT * FROM sales 
WHERE product = 'Laptop';

-- Query 3: sales_amount greater than a threshold
SELECT * FROM sales 
WHERE sales_amount > 1000;

-- Query 4: region AND product combined
SELECT * FROM sales 
WHERE region = 'South' AND product = 'Headphones';


-- =====================================================================
-- STEP 4: SORTING WITH ORDER BY
-- =====================================================================

-- Query 1: highest to lowest sales_amount
SELECT * FROM sales 
ORDER BY sales_amount DESC;

-- Query 2: lowest to highest sales_amount
SELECT * FROM sales 
ORDER BY sales_amount ASC;

-- Query 3: alphabetical by customer_name
SELECT * FROM sales 
ORDER BY customer_name ASC;

-- Query 4: region alphabetically, then sales_amount highest first
SELECT * FROM sales 
ORDER BY region ASC, sales_amount DESC;


-- =====================================================================
-- STEP 5: AGGREGATING DATA
-- =====================================================================

-- Query 1: total sales
SELECT SUM(sales_amount) AS total_sales 
FROM sales;

-- Query 2: number of orders
SELECT COUNT(order_id) AS total_orders 
FROM sales;

-- Query 3: average sales amount
SELECT AVG(sales_amount) AS avg_sale 
FROM sales;

-- Query 4: highest sales amount
SELECT MAX(sales_amount) AS highest_sale 
FROM sales;

-- Query 5: lowest sales amount
SELECT MIN(sales_amount) AS lowest_sale 
FROM sales;


-- =====================================================================
-- STEP 6: GROUPING DATA
-- =====================================================================

-- Query 1: total sales per region
SELECT region, SUM(sales_amount) AS total_sales
FROM sales
GROUP BY region;

-- Query 2: total sales per product
SELECT product, SUM(sales_amount) AS total_sales
FROM sales
GROUP BY product;

-- Query 3: number of orders per region
SELECT region, COUNT(*) AS order_count
FROM sales
GROUP BY region;

-- Query 4: total quantity sold per product
SELECT product, SUM(quantity) AS total_quantity
FROM sales
GROUP BY product;


-- =====================================================================
-- STEP 7: PRODUCTS TABLE (FOR JOINS)
-- =====================================================================

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL
);

INSERT INTO products (product_name, category) VALUES
('Laptop', 'Electronics'),
('Smartphone', 'Electronics'),
('Tablet', 'Electronics'),
('Monitor', 'Electronics'),
('Headphones', 'Accessories');

-- Verify products loaded correctly
SELECT * FROM products;


-- =====================================================================
-- STEP 8: SQL JOINS
-- =====================================================================

-- Query 1: INNER JOIN - full sales detail with category
SELECT 
s.order_id, 
s.customer_name, 
s.product, 
p.category, 
s.quantity, 
s.sales_amount
FROM sales s
INNER JOIN products p 
ON s.product = p.product_name;

-- Query 2: total sales by category
SELECT 
p.category, 
SUM(s.sales_amount) AS total_sales
FROM sales s
INNER JOIN products p 
ON s.product = p.product_name
GROUP BY p.category;

-- Query 3: all sales with corresponding category
SELECT 
s.order_id, 
s.product, p.category
FROM sales s
INNER JOIN products p 
ON s.product = p.product_name;


-- =====================================================================
-- STEP 9: DASHBOARD-STYLE ANALYTICAL QUERIES
-- =====================================================================

-- KPI 1: Total sales per category, highest first
SELECT 
p.category, 
SUM(s.sales_amount) AS total_sales
FROM sales s
INNER JOIN products p 
ON s.product = p.product_name
GROUP BY p.category
ORDER BY total_sales DESC;

-- KPI 2: Top-selling product (by total revenue)
SELECT 
product, 
SUM(sales_amount) AS total_sales
FROM sales
GROUP BY product
ORDER BY total_sales DESC
LIMIT 1;

-- KPI 3: Best-performing region
SELECT 
region, 
SUM(sales_amount) AS total_sales
FROM sales
GROUP BY region
ORDER BY total_sales DESC
LIMIT 1;

-- KPI 4: Total number of orders
SELECT COUNT(*) AS total_orders 
FROM sales;

-- KPI 5: Average order value
SELECT AVG(sales_amount) AS avg_order_value 
FROM sales;


-- =====================================================================
-- STEP 10: FINAL VALIDATION QUERIES
-- =====================================================================

-- Confirm row counts
SELECT COUNT(*) AS sales_row_count FROM sales;         -- expect 20
SELECT COUNT(*) AS products_row_count FROM products;   -- expect 5

-- Confirm every sales.product has a matching products.product_name
-- (should return 0 rows if the JOIN data is consistent)
SELECT DISTINCT s.product
FROM sales s
LEFT JOIN products p 
ON s.product = p.product_name
WHERE p.product_name IS NULL;

-- Confirm total sales matches sum of per-region totals
SELECT SUM(sales_amount) AS grand_total 
FROM sales;    -- expect 16950.00
