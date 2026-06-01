-- ========================================================================
-- PERFORMANCE ANALYSIS
-- ========================================================================

-- 1. Analyze the yearly performance of products by comparing each product's sales to both its average sales performance and the previous year's sales.
with product_yearly_sales as (
select year(fs.clean_order_date) as order_year ,
p.product_key,p.product_name, 
sum(fs.sales_amount) as current_sales
from fact_sales as fs
left join dim_products as p
on fs.product_key = p.product_key
where clean_order_date is not null
group by year(clean_order_date), p.product_key,p.product_name
)

-- YEAR-OVER-YEAR ANALYSIS
select 
order_year, 
product_key, 
product_name, 
current_sales,
round(
	avg(current_sales) over(partition by product_key) ,
    2
	)as avg_sales,
round(
	current_sales - avg(current_sales) over(partition by product_key),
	2
	) as diff_avg,
	case 
    when round(current_sales - avg(current_sales) over(partition by product_key),2) >0 
    then 'Above average'
    when round(current_sales - avg(current_sales) over(partition by product_key),2) < 0 
    then 'Below average'
    else 'Average'
end as avg_change,
lag(current_sales) over(partition by product_key order by order_year) as prev_year_sales,
ifnull(current_sales - lag(current_sales) over(partition by product_key order by order_year),0) as diff_py,
case 
	when round(current_sales - lag(current_sales) over(partition by product_key order by order_year),2) > 0 
    then 'Increase'
    when round(current_sales - lag(current_sales) over(partition by product_key order by order_year),2) < 0 
    then 'Decrease'
    else 'No Change'
end as py_change
from product_yearly_sales
order by product_name, product_key, order_year


-- Insights:
-- • Several products showed significant YoY growth during 2013.
-- • Some products consistently performed above their historical average sales.
-- • Product performance varied across years, indicating changing customer demand trends.
-- • Multiple products showed declining sales compared to previous years, highlighting potential business risks.