/*====================================================================================================================
 - DATE EXPLORATION
 - Identify the earliest and latest dates.
 - Understand the scope of data and timespan.
======================================================================================================================*/


-- 1. Find date of first and last order.
-- 2. how many years of sale are available?
select min(clean_order_date) as first_order_date, 
max(clean_order_date) as last_order_date,
timestampdiff(month, min(clean_order_date), max(clean_order_date)) as order_range_months
from fact_sales ;


-- 3. find the youngest and oldest customer
select 
min(birthdate) as youngest_birthdate,
timestampdiff(year, max(birthdate), curdate()) as youngest_age,
max(birthdate) as oldest_birthdate,
timestampdiff(year, min(birthdate), curdate()) as oldest_age
from dim_customers;