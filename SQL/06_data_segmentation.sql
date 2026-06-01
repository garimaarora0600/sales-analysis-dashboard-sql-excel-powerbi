-- ==========================================================================
-- DATA SEGMENTATION
-- Group the data based on a specific range. 
-- Helps understand the correlation between two measures.
-- ===========================================================================
-- [measure] by [measure] eg Total no of products by sales range,
-- total customers by age

-- we're taking one measure and based on the range of this measure, we're building a new category
-- we're creating new categories based on a measure/segments and we're aggregating another measure based of this new segments

-- 1. SEGMENT PRODUCTS INTO COST RANGES AND COUNT HOW MANY PRODUCTS FALL INTO EACH SEGMENT
with products_segments as 
(
select 
product_key, 
product_key, 
product_name,
cost,
case when cost < 100 then 'Below 100'
	 when cost between 100 and 500 then '100-500'
     when cost between 500 and 1000 then '500-1000'
     else 'Above 1000'
end as cost_range
from dim_products
)

select 
cost_range, 
count(product_key) as total_products
from products_segments
group by cost_range
order by total_products desc;

-- Key Insights:
-- • Most products fall within the low-to-mid cost ranges, with products below 100 forming the largest segment.
-- • High-cost products (above 1000) represent the smallest share of the product portfolio.
-- • The product catalog is primarily concentrated around affordable and mid-range products.
-- • Premium-priced products are limited in number, indicating a focused high-value product strategy.

-- 2. GROUP CUSTOMERS INTO THREE SEGMENTS ON THEIR SPENDIN BEHAVIOUR:
--     - VIP : Customers at least 12 months of history and spending more than 5000.
--     - Regular: at least 12 months of history but spending 5000 or less
--     - New: lifespan less than 12 months.
--  AND FIND TOTAL NO OF CUSTOMERS BY EACH GROUP.
with customer_spending as 
(
select c.customer_key,
sum(fs.sales_amount) as total_spending,
-- lifespan - find first and last order
min(clean_order_date) as first_order,
max(clean_order_date) as last_order,
timestampdiff(month,min(clean_order_date) , max(clean_order_date)) as lifespan
from fact_sales as fs
left join dim_customers as c 
on fs.customer_key = c.customer_key
where clean_order_date is not null
group by c.customer_key
),
customer_ranges as 
(
select 
customer_key,
total_spending, 
lifespan, 
case when lifespan >= 12 and total_spending > 5000 then 'VIP'
	 when lifespan >= 12 and total_spending <= 5000 then 'Regular'
     else 'New'
end as customer_segment
from customer_spending
)

select customer_segment,
count(customer_key) as total_customers
from customer_ranges
group by customer_segment
order by total_customers desc;



-- Key Insights:
-- • Most customers fall under the New customer segment, indicating a large proportion of recently acquired customers.
-- • VIP customers represent a smaller but valuable customer group with high spending and long-term engagement.
-- • Regular customers form a limited portion of the customer base compared to New customers.
-- • The customer base appears to be heavily skewed toward newer customers rather than long-term retained customers.