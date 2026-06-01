-- ===================================================================================
-- CHANGE OVER TREND ANALYSIS
-- to analyze how our business has been doing over the years, over the time
 -- =======================================================================================
 -- ANALYZE PERFORMACE OVER THE TIME
 -- 1.CHANGE OVER THE YEARS 
 -- we can analyze following from the result 
 -- i.) is the revenue increasing or decreasing over time like what is the best year or worst year
 -- ii.) are we gaining customers over the time
 -- iii.) giving high level long term view over data
 select 
 year(clean_order_date) as order_year, 
 sum(sales_amount) as total_sales,
 sum(quantity) as total_quantity,
 count(distinct customer_key) as total_customers
 from fact_sales
 where clean_order_date is not null and 
 year(clean_order_date) is not null 
 group by year(clean_order_date)
 order by order_year;
 
 -- INSIGHTS:-
 -- 1.  Sales peaked significantly in 2013.
 -- 2. 2010 amd 2014 show unsually low sales, indicating incomplete yearly data.
 -- 3. Customer count grew substantially until 2013.
 -- 4. Further validation is needed to confirm data completeness. 
 
 
 -- 2. CHANGE OVER THE MONTHS
 -- result - Through this, we get detailed insight to discover seasonality in our data 
select 
 date_format(clean_order_date,'%Y-%m') as month_year,
 sum(sales_amount) as total_sales,
 sum(quantity) as total_quantity,
 count(distinct customer_key) as total_customers
 from fact_sales
 where clean_order_date is not null 
 group by date_format(clean_order_date,'%Y-%m') 
 order by month_year;
 
 -- Month wise sales insights:-
 -- i. sales showed fluctuations and partial decline during 2012 compared to 2011.
 -- ii. strong growth in sales, quantity, and customers was observed throughout 2013.
 -- iii. peak monthly sales were achieved in Dec-2013.
 -- iv. Higher sales performance was observed during Q4 months (Oct-Dec)
 -- v. Jan-2024 data appears incomplete due to unusually low sales values.
 
 -- 3. QUARTER-WISE TREND
 with cte as 
( select *, quarter(clean_order_date) as quarter_month
 from fact_sales
 where clean_order_date is not null
 )
 
 select 
 year(clean_order_date) as order_year, quarter_month,
 sum(sales_amount) as total_sales,
 count(distinct customer_key) as total_customer,
 sum(quantity) as total_quantity
 from cte
 group by year(clean_order_date),quarter_month
 order by order_year,quarter_month;
 
 -- Quarter-wise Insights:
-- • Q4 recorded the highest sales across most years, indicating strong seasonal demand.
-- • Sales declined during early 2012 compared to 2011 but recovered in later quarters.
-- • Significant business growth was observed across all quarters in 2013.
-- • Customer count and quantity sold increased substantially during 2013.
-- • Overall business performance showed strong upward momentum after 2012.


-- 4. YEAR-OVER-YEAR (YOY) GROWTH 
with total_sales_year_wise as 
(select year(clean_order_date) as order_year, sum(sales_amount) as total_sales
from fact_sales
where clean_order_date is not null
group by year(clean_order_date)
),
total_prev_sales as 
(select *,
lag(total_sales,1,total_sales) over(order by order_year) as prev_sales
from total_sales_year_wise)

select order_year, round((total_sales - prev_sales) * 100 / prev_sales, 2) as YOY
from total_prev_sales;

-- Year-over-Year Insights:
-- • Business sales declined by ~17% in 2012 compared to 2011.
-- • Sales grew significantly in 2013 with ~180% YoY growth.
-- • 2010 and 2014 YoY values are not fully reliable due to partial-year data availability.



-- ========================================================================
-- CUMULATIVE ANALYSIS
--  AGGREGATING THE DATA PROGRESSIVELY OVER TIME 
-- ========================================================================
-- running total sales by year
-- moving average sales by month
-- 1. TOTAL SALES PER YEAR AND RUNNING TOTAL OF SALES OVER TIME
with total_month_sales as 
(select 
year(clean_order_date) as order_Year, 
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from fact_sales
where clean_order_date is not null
group by year(clean_order_date)
)
select order_year, total_sales,
sum(total_sales) over(order by order_year) as cumulative_sales,
sum(total_customers) over(order by order_year) as cumulative_customers,
sum(total_quantity) over(order by order_year) as cumulative_quantity
from total_month_sales ;

-- Cumulative Analysis Insights:
-- • Cumulative sales increased significantly over time, especially during 2013.
-- • Customer and quantity growth accelerated rapidly after 2012.
-- • 2013 contributed the largest share to overall business growth.
-- • 2014 values appear incomplete due to partial-year data.
