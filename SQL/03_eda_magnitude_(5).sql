/*====================================================================================================================
 - MAGNITUDE
 - Compare the measure value by categories.
 - It helps understand the importance of different categories.
======================================================================================================================*/

-- 1. Find total customers by countries
select country,count(distinct customer_key) as total_customers
from dim_customers
group by country;

-- 2. Find total customers by gender
select gender,count(distinct customer_key) as total_customers
from dim_customers
group by gender;

-- 3. Find total customers by category
select 
p.category,
count(distinct customer_key) as total_customers
from fact_sales as fs
left join dim_products as p
on fs.product_key = p.product_key
group by p.category 
order by p.category ;

-- 4. Avg cost in each category
select category, avg(cost) as Avg_cost
from dim_products
group by category;

-- 5. Total revenue generate for each category
select p.category, sum(fs.sales_amount) as total_revenue
from fact_sales as fs
left join dim_products as p
on fs.product_key = p.product_key
group by p.category
order by total_revenue desc;

-- 6. Revenue generate by each customer
select 
c.customer_key,
concat(c.first_name,' ',c.last_name) as customer_name,
sum(fs.sales_amount) as total_revenue
from fact_sales as fs
left join dim_customers as c
on fs.customer_key = c.customer_key
group by 
c.customer_key,
c.first_name,
c.last_name
order by total_revenue desc;

-- 7. Distribution of sold items across countries
select 
c.country,
sum(fs.quantity) as total_quantity
from fact_sales as fs
left join dim_customers as c
on fs.customer_key = c.customer_key
group by 
c.country
order by total_quantity desc;



