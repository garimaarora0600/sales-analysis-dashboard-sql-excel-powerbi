-- ============================================================================
-- DATA VALIDATION
-- Objective:
-- Identify invalid, missing, duplicate or inconsistent records in the 
-- sales dataset before analysis.
-- ============================================================================ 
-- 1. CHECK TOTAL RECORD COUNT
select count(*) as total_rows
from fact_sales;

-- 2. CHECK NULL VALUES
select *
from fact_sales
where order_number is null
	or product_key is null
    or customer_key is null
    or clean_order_date is null
    or order_number is null
    or sales_amount is null;
    
-- 3. CHECK INVALID DATES
select *
from fact_sales
where year(clean_order_date) is null ;
-- Observation:
-- Some records contain invalid or blank clean_order_date values. 

select *
from fact_sales
where shipping_date is null and year(shipping_date) is null;

select *
from fact_sales
where clean_due_date is null and year(clean_due_date) is null;

-- 4. CHECK DUPLICATE ORDER NUMBER
select order_number,count(1) as duplicate_orders 
from fact_sales
group by order_number
having count(*)>1;

-- Observation:
-- Duplicate orders represent 
-- i. multiple products in same order
-- ii. duplicate records

-- 5. CHECK NEGATIVE VALUES
select *
from fact_sales
where sales_amount < 0 
	or quantity < 0
    or price < 0;

-- 6. CHECK SHIPPING DATE BEFORE clean_order_date
select *
from fact_sales
where shipping_date < clean_order_date;

-- 7. CHECK DUE DATE BEFORE clean_order_date
select *
from fact_sales
where clean_due_date < clean_order_date;

-- 8. CHECK DUE DATE BEFORE SHIP DATE
select *
from fact_sales
where clean_clean_due_date < clean_ship_date;

-- 9. VALIDATE DATE CONVERSION

SELECT *
FROM fact_sales
WHERE clean_clean_order_date IS NULL
   OR clean_ship_date IS NULL
   OR clean_clean_due_date IS NULL;
   
-- 10. Operational Date Validation:
-- Derived columns were created to evaluate fulfillment timelines:
-- processing_days = ship_date - order_date
-- expected_delivery_days = due_date - order_date
-- transit_days = due_date - ship_date
--
-- Validation showed that these values were constant across all orders:
-- processing_days = 7 days
-- transit_days = 5 days
-- expected_delivery_days = 12 days
--
-- Since there was no variation, detailed operational/SLA analysis was not included.
-- These columns were retained for future operational analysis if actual delivery data becomes available.
   