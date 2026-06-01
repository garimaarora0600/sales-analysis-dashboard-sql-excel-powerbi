/*====================================================================================================================
 - RANKING ANALYSIS
 - Order the values of dimensions by measure.
 - Top N Performers | Bottom N Performers.
======================================================================================================================*/
 -- 1. Which five products generate the highest revenue.
 select fs.product_key, p.product_name,
 sum(fs.sales_amount) as total_revenue
 from fact_sales as fs
 left join dim_products as p
 on fs.product_key = p.product_key
 group by fs.product_key, p.product_name
 order by total_revenue desc
 limit 5;
 
 select fs.product_key, p.product_name,
 sum(fs.sales_amount) as total_revenue,
 row_number() over(order by sum(fs.sales_amount) desc) as rnk
 from fact_sales as fs
 left join dim_products as p
 on fs.product_key = p.product_key
 group by fs.product_key, p.product_name
 order by total_revenue desc
 limit 5;
 
 -- 2. 5 worse performing products in term of sales
 select fs.product_key, p.product_name,
 sum(fs.sales_amount) as total_revenue
 from fact_sales as fs
 left join dim_products as p
 on fs.product_key = p.product_key
 group by fs.product_key, p.product_name
 order by total_revenue 
 limit 5;
 
 -- 3 . top 10 customers who have generated the highest revenue
 select c.customer_key, 
 concat(c.first_name,' ', c.last_name) as customer_name,
 sum(fs.sales_amount) as total_revenue
 from fact_sales as fs
 left join dim_customers as c
 on fs.customer_key = c.customer_key
 group by c.customer_key, c.first_name, c.last_name
 order by total_revenue desc
 limit 10;
 
 
 -- 4. The 3 customers with the fewest orders placed
 select c.customer_key, 
 concat(c.first_name,' ', c.last_name) as customer_name,
 count(distinct fs.order_number) as total_orders
 from fact_sales as fs
 left join dim_customers as c
 on  c.customer_key = fs.customer_key 
 group by c.customer_key, c.first_name, c.last_name
 order by total_orders
 limit 3;