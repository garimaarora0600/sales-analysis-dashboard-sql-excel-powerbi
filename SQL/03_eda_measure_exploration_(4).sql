/*====================================================================================================================
 - MEASURES EXPLORATION
 - Calculate the key metric of the business (Big Numbers)
 - Highest level of aggregation | Lowest level of details
======================================================================================================================*/
-- 1. Find the total sales
select sum(sales_amount) as total_sales
from fact_sales;

-- 2. find how many items are sold
select sum(quantity) as total_quantity
from fact_sales;

--  3. find the average selling price
select avg(price) as avg_price
from fact_sales;


-- 4. find the total number of orders
select count(distinct order_number) as total_orders
from fact_sales;

--  5. find the total number of products
select count(distinct product_key) as total_products
from fact_sales;

-- 6. find the total number of customers
 select count(distinct customer_key) as total_customers
from fact_sales;

-- 7. Generate a report that shows all the key metric of the business
select 'Total Sales' as measure_name ,sum(sales_amount) as measure_value from fact_sales
union all 
select 'Total Quantity' as measure_name,sum(quantity) as total_quantity from fact_sales
union all 
select 'Average Price' as measure_name,avg(price) as avg_price from fact_sales
union all
select 'Total Quantity' as measure_name, count(distinct order_number) as total_orders from fact_sales
union all 
select 'Total Products' as measure_name,count(distinct product_key) as total_products from fact_sales
union all 
select 'Total Customers' as measure_name,count(distinct customer_key) as total_customers from fact_sales