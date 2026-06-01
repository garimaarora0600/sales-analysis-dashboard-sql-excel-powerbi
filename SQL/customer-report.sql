/*
=================================================================================================
CUSTOMER REPORT
=================================================================================================
Purpose:
	- This report consolidates key customer metrics and behaviours
    
Highlights:
	1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
       - total sales
       - total quantity purchased
       - lifespan (in months)
	4. Calculate valuable KPIs:
	   - recency (months since last year)
       - average order value
       - average monthly spend
====================================================================================================
*/
CREATE VIEW report_customers as 
 with base_query as (
/*--------------------------------------------------------------------------------------------------
1. BASE QUERY : Retrives core columns from tables
-----------------------------------------------------------------------------------------------------*/
 select 
 fs.order_number,
 fs.product_key, 
 fs.clean_order_date,
 fs.sales_amount,
 fs.quantity, 
 c.customer_key,
 c.customer_number,
 concat(c.first_name,' ',c.last_name) as customer_name,
 timestampdiff(year,c.birthdate, curdate()) as age -- need for age groups
 from fact_sales as fs
 left join dim_customers as c
 on fs.customer_key = c.customer_key
 where clean_order_date is not null
 )
 ,customer_aggregation as (
/*---------------------------------------------------------------------------
 2. CUSTOMER AGGREGATION: Summarizes key metrics at the customer level
----------------------------------------------------------------------------*/ 
 select 
 customer_key,
 customer_number,
 customer_name, 
 age,
 count(distinct order_number) as total_orders,
 sum(sales_amount) as total_sales,
 sum(quantity) as total_quantity, 
 count(distinct product_key) as total_products,
max(clean_order_date) as last_order,
timestampdiff(month,min(clean_order_date), max(clean_order_date)) as lifespan
from base_query
group by customer_key, customer_number, customer_name, age
)


select 
customer_key,
customer_number,
customer_name, 
age,
total_orders,
total_sales,
total_quantity, 
total_products,
lifespan,
case when age < 20 then 'Under 20'
	 when age between 20 and 29 then '20-29'
     when age between 30 and 39 then '30-39'
     when age between 40 and 49 then '40-49'
     else '50 and Above'
end as age_group,
case when lifespan >= 12 and total_sales > 5000 then 'VIP'
	 when lifespan >= 12 and total_sales <= 5000 then 'Regular'
     else 'New'
end as customer_segment,
last_order,
timestampdiff(month, last_order, curdate()) as recency, -- to get insight whether the customer is active/inactive
-- compute avg order value (AVO)
case when total_orders = 0 then 0
	 else round(total_sales/total_orders,2)
end as avg_order_value, -- edge case if total_orders are 0
-- compute avg monthly spend
case when lifespan = 0 then total_sales -- since customer exists for only one month, so get only total sales of customer
     else round(total_sales/lifespan,2)
end as avg_monthly_spends
from customer_aggregation;


-- take the whole query and put in the database as view so that we can share with others and would be easier to create a dashboard inorder to visualize the data

select * from report_customers;
 
 -- we can use the above to generate some insights
 select 
 age_group,
 count(customer_number) as total_customer,
 sum(total_sales) as total_sales
 from report_customers
 group by age_group;
 
 
 select 
 customer_segment,
 count(customer_number) as total_customer,
 sum(total_sales) as total_sales
 from report_customers
 group by customer_segment;