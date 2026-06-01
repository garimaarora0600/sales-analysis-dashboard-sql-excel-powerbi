-- ================================================================================
-- PART TO WHOLE PROPORTIONAL ANALYSIS
-- Analyze how an individual part is performing compared to the overall, allowing us
-- to understand which category has the greatest impact on the business.
-- =================================================================================

-- ([Measure]/Total[Measure])*100 by [dimension]
-- sales/total_Sales *100 by category  
-- qauntity/total_quantity *100 by country
 
 -- 1. Which categories contribute the most to overall sales?
with category_sales as(
select 
p.category,
sum(sales_amount) as total_sales
from fact_sales as fs
left join dim_products as p
on fs.product_key = p.product_key
group by p.category
),
overall_category_sales as 
(select 
category, 
total_sales,
sum(total_sales) over() as overall_sales
from category_sales
)

select *,
concat(
round((total_sales/overall_sales)*100,2),'%' )as percentage_total
from overall_category_sales
order by percentage_total desc;


-- Category Contribution Insights:
-- • Bikes contributed the highest share of overall sales (~96.5%), making it the primary revenue-driving category.
-- • Accessories and Clothing contributed only a small percentage of total sales.
-- • Business revenue is highly concentrated in the Bikes category, indicating strong dependence on a single product category.
-- • Low contribution from Accessories and Clothing may indicate opportunities for cross-selling or category expansion.


-- 2. ORDERS CONTRIBUTION BY PRODUCT
with total_orders as 
(
select fs.product_key,p.product_name,
count(distinct order_number) as total_orders
from fact_sales as fs
left join dim_products as p
on fs.product_key = p.product_key
group by fs.product_key, p.product_name
),
overall_orders as 
(select product_key, product_name, total_orders,
sum(total_orders) over() as overall_orders
from total_orders)
select product_key, product_name,
concat(
round((total_orders/overall_orders)*100,2),'%' )as percentage_total
from overall_orders
order by total_orders desc;

-- Key Insights:
-- • Accessories products contribute the highest share of total orders across the business.
-- • Water Bottle - 30 oz. is the most frequently ordered product, contributing over 7% of total orders.
-- • Premium bicycle products drive revenue, while accessory products drive purchase frequency.
-- • The business shows strong recurring demand for low-cost accessory products such as tire tubes, helmets, and patch kits.



-- 3. PRODUCT CONTRTIBUTION TO SALES
with product_sales as(
select 
fs.product_key,
p.product_name,
sum(sales_amount) as total_sales
from fact_sales as fs
left join dim_products as p
on fs.product_key = p.product_key
group by fs.product_key, p.product_name
),
overall_product_sales as 
(
select 
  product_key,
  product_name, 
  total_sales,
sum(total_sales) over() as overall_sales
from product_sales
) 

select *,
concat(
round((total_sales/overall_sales)*100,2),'%' )as percentage_total
from overall_product_sales
order by percentage_total desc;

-- Key Insights:
-- • Mountain-200 product variants are the highest revenue-generating products, each contributing over 4% of total sales.
-- • Revenue is heavily concentrated among a limited number of premium bicycle products.
-- • Top-performing products mainly belong to the Bikes category, reinforcing Bikes as the primary business revenue driver.
-- • Multiple variants of Mountain-200 and Road-150 products consistently appear among top-selling products, indicating strong customer demand for these product lines.