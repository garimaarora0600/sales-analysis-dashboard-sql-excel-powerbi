/* 
=============================================================================================================
PRODUCT REPORT
=============================================================================================================
Purpose:
	- This report consolidates key product and behaviours.

Highlights:
	1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
	   - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
	4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
*/
CREATE VIEW report_products as
with base_query as (
/*--------------------------------------------------------------------------------------------------
1. BASE QUERY : Retrives core columns from tables
-----------------------------------------------------------------------------------------------------*/
select 
p.product_key,
p.product_name,
p.category, 
p.subcategory,
p.cost,
fs.sales_amount,
fs.order_number,
fs.customer_key,
fs.quantity,
fs.clean_order_date
from fact_sales as fs 
left join dim_products as p
on fs.product_key = p.product_key
),
product_aggregation as (
/*---------------------------------------------------------------------------
 2. PRODUCT AGGREGATION: Summarizes key metrics at the product level
----------------------------------------------------------------------------*/ 
select 
product_key, 
product_name,
category, 
subcategory,
count(distinct order_number) as total_orders,
sum(sales_amount) as total_revenue,
sum(quantity) as total_quantity,
max(clean_order_date) as last_order,
timestampdiff(month,min(clean_order_date), max(clean_order_date)) as lifespan,
count(distinct customer_key) as total_customers
from base_query
group by product_key, product_name, category, subcategory
)

select 
product_key, 
product_name,
category, 
subcategory,
total_orders,
total_revenue,
total_quantity,
total_customers,
lifespan,
case when total_revenue < 200000 then 'Low Performer'
	 when total_revenue between 200000 and 800000 then 'Mid Performer'
     else 'High Performer'
end as product_segment,
timestampdiff(month, last_order , curdate()) as recency,
-- calculate average order revenue
case when total_orders = 0 then 0
	 else round(total_revenue/total_orders,2)
end as avg_order_revenue,
-- calculate average monthly revenue
case when lifespan = 0 then total_revenue
	 else round(total_revenue/lifespan,2)
end as avg_monthly_revenue
from product_aggregation
order by total_revenue desc;


select * from report_products;


-- Key Insights:
-- • The Bikes category is the primary revenue driver, with Mountain-200 and Road-150 variants contributing the highest sales.
-- • High-performing products generate substantial revenue despite comparatively lower order volumes, indicating strong product pricing and value.
-- • Accessories products such as Water Bottles, Helmets, and Tire Tubes dominate order frequency, showing strong recurring customer demand.
-- • Low-priced accessory products contribute heavily to customer engagement, while premium bikes contribute most to overall revenue.
-- • The business relies on a combination of high-value bike sales and high-frequency accessory purchases to sustain overall performance.