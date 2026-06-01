-- =========================================================
-- DATA CLEANING
-- Objective:
-- Prepare clean sales data for analysis by removing
-- invalid or inconsistent records.
-- =========================================================

-- 1. ADD CLEAN DATE COLUMNS 
ALTER TABLE fact_sales
ADD COLUMN clean_order_date DATE,
ADD COLUMN clean_ship_date DATE,
ADD COLUMN clean_due_date DATE;


SET SQL_SAFE_UPDATES =0;
UPDATE fact_sales
SET
clean_order_date = 
CASE 
WHEN order_date LIKE '%/%' THEN STR_TO_DATE(order_date, '%Y/%m/%d')
WHEN order_date LIKE '%-%' THEN STR_TO_DATE(order_date, '%Y-%m-%d')
ELSE NULL
END,
clean_ship_date = 
CASE 
WHEN shipping_date LIKE '%/%' THEN STR_TO_DATE(shipping_date, '%Y/%m/%d')
WHEN shipping_date LIKE '%-%' THEN STR_TO_DATE(shipping_date, '%Y-%m-%d')
ELSE NULL
END,
clean_due_date = 
CASE 
WHEN due_date LIKE '%/%' THEN STR_TO_DATE(due_date, '%Y/%m/%d')
WHEN due_date LIKE '%-%' THEN STR_TO_DATE(due_date, '%Y-%m-%d')
ELSE NULL
END;
SET SQL_SAFE_UPDATES =1;

-- Notes:
-- Original date columns were stored as TEXT datatype.
-- Standardized DATE columns were created to support:
-- i. Time-series analysis
-- ii. Monthly and quarterly trend analysis
-- iii. Delivery performance analysis

-- 2. CHECKING DUPLICATE RECORDS
select order_number,product_key, count(1) as duplicate_orders
from fact_sales
group by order_number,product_key
having count(*)>1;

-- 3. CREATING DERIVED METRICS
-- adding column delivery days 
ALTER TABLE fact_sales
ADD COLUMN processing_days INT, 
ADD COLUMN expected_delivery_days INT,
ADD COLUMN transit_days INT;

-- processing_days = how long company took to ship the order
-- expected_delivery_days = promised delivery window
-- transit_days = transit/logistic time = due_date- shipping date
UPDATE fact_sales
SET processing_days = 
DATEDIFF(clean_ship_date, clean_order_date),
expected_delivery_days = 
DATEDIFF(clean_due_date, clean_order_date),
 transit_days = 
 DATEDIFF(clean_due_date, clean_ship_date);