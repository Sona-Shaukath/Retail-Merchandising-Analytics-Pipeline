-- ==========================================
-- 1. DATABASE SCHEMA SETUP
-- ==========================================

-- Create the Products Table
CREATE TABLE inventory_products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10, 2),
    unit_cost DECIMAL(10, 2)
);

-- Create the Sales Table
CREATE TABLE retail_sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    quantity_sold INT,
    sale_date DATE
);

-- Create the Inventory Levels Table
CREATE TABLE current_inventory (
    product_id INT PRIMARY KEY,
    current_stock_level INT,
    reorder_point INT
);

-- ==========================================
-- 2. MOCK DATA INSERTION
-- ==========================================

-- Populate Products (Mixture of tech accessories and apparel)
INSERT INTO inventory_products VALUES (101, 'Wireless Ergonomic Mouse', 'Electronics', 60.00, 20.00); 
INSERT INTO inventory_products VALUES (102, 'Ultra-Wide Monitor 34"', 'Electronics', 400.00, 300.00); 
INSERT INTO inventory_products VALUES (103, 'Organic Cotton Hoodie', 'Apparel', 80.00, 25.00);     
INSERT INTO inventory_products VALUES (104, 'Leather Desk Mat', 'Office Supplies', 45.00, 15.00);  

-- Populate 30-Day Sales (MySQL Safe Date Functions)
INSERT INTO retail_sales VALUES (1, 101, 15, DATE_SUB(CURRENT_DATE, INTERVAL 5 DAY));
INSERT INTO retail_sales VALUES (2, 101, 15, DATE_SUB(CURRENT_DATE, INTERVAL 12 DAY));
INSERT INTO retail_sales VALUES (3, 102, 2,  DATE_SUB(CURRENT_DATE, INTERVAL 2 DAY));
INSERT INTO retail_sales VALUES (4, 102, 1,  DATE_SUB(CURRENT_DATE, INTERVAL 20 DAY));
INSERT INTO retail_sales VALUES (5, 103, 40, DATE_SUB(CURRENT_DATE, INTERVAL 4 DAY));
INSERT INTO retail_sales VALUES (6, 103, 50, DATE_SUB(CURRENT_DATE, INTERVAL 15 DAY));
INSERT INTO retail_sales VALUES (7, 104, 0,  DATE_SUB(CURRENT_DATE, INTERVAL 25 DAY)); 

-- Populate Inventory Levels
INSERT INTO current_inventory VALUES (101, 120, 40);  
INSERT INTO current_inventory VALUES (102, 8, 5);     
INSERT INTO current_inventory VALUES (103, 15, 30);    
INSERT INTO current_inventory VALUES (104, 50, 10);
