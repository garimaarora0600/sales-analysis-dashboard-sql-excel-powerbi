\# Data Dictionary - Sales Analytics Dashboard

This data dictionary documents the tables, columns, derived KPIs, business rules, and data quality notes used in the Sales Analytics Dashboard project. The project analyzes sales trends, product performance, customer segmentation, and revenue contribution using SQL, Excel, and Power BI.





\## Table Descriptions



| Table Name 				 			   |		Description 					     |

|------------------------------------------------------------------|-----------------------------------------------------------------|

| fact\_sales 				 			   | Transaction-level sales table containing order, product,        |

|					 			   | customer, date, sales, quantity, and delivery-related fields.   |

|------------------------------------------------------------------|-----------------------------------------------------------------| 

| dim\_products 				 			   | Product dimension table containing product details such as      |

|								   | product name, category, subcategory, cost, and product line.    | 					    |------------------------------------------------------------------|-----------------------------------------------------------------|

| dim\_customers 						   | Customer dimension table containing customer details such as    |

|								   | customer key, customer name, birthdate, gender, and customer    |

|								   | attributes. 						     |

|------------------------------------------------------------------|-----------------------------------------------------------------|

| product\_report 				                   | Product-level aggregated report created for product performance |

|							           | analysis. 							     |

|------------------------------------------------------------------|-----------------------------------------------------------------|

| customer\_segments 						   | Customer-level segmentation output based on customer lifespan   |

|							           | and total spending. 					     |

|------------------------------------------------------------------|-----------------------------------------------------------------|





\## fact\_sales



| Column Name 		 		      |            Data Type 		| 			Description 				   	|

|---------------------------------------------|---------------------------------|-----------------------------------------------------------------------|

| order\_number 				      | 	Text 			| Unique identifier for each sales order. 				|

| product\_key 				      | 	Integer 		| Product identifier used to join with dim\_products. 			|

| customer\_key 				      | 	Integer 		| Customer identifier used to join with dim\_customers. 			|

| order\_date 				      | 	Text 			| Original order date before cleaning. 					|

| shipping\_date 			      | 	Text 			| Original shipping date before cleaning. 				|

| due\_date 				      | 	Text 			| Original due date before cleaning. 					|

| sales\_amount 				      | 	Numeric 		| Revenue generated from the sale transaction. 				|

| quantity 				      | 	Integer 		| Number of units sold in the transaction. 				|

| price 				      | 	Numeric 		| Unit price of the product. 						|

| clean\_order\_date 			      | 	Date 			| Cleaned order date converted into proper DATE format. 		|

| clean\_ship\_date 			      |  	Date			| Cleaned shipping date converted into proper DATE format. 		|

| clean\_due\_date 			      | 	Date 			| Cleaned due date converted into proper DATE format. 			|

|---------------------------------------------|---------------------------------|-----------------------------------------------------------------------|



\## dim\_products



| Column Name 		 		      |            Data Type 		| 			Description 				   	|

|---------------------------------------------|---------------------------------|-----------------------------------------------------------------------|

| product\_key 				      | 	Integer 		| Unique product identifier used for joins. 				|

| product\_id 				      | 	Text 			| Product ID from the source system. 					|

| product\_number 			      | 	Text 			| Product code or product number. 					|

| product\_name 				      | 	Text 			| Name of the product.  						|

| category\_id 				      | 	Text 			| Technical or internal category identifier. 				|

| category 				      |		Text 			| Business-level product category such as Bikes, Accessories, or 	|

|					      |					| Clothing. 								|

| subcategory 				      | 	Text 			| More detailed product grouping under category. 			|

| maintenance 				      | 	Text 			| Product maintenance-related attribute, if available. 			|

| cost 					      | 	Numeric 		| Product cost value. 							|	

| product\_line 				      | 	Text 			| Product line or product family. 					|

| start\_date 				      | 	Date/Text 		| Product start date from the source system. 				|

|---------------------------------------------|---------------------------------|-----------------------------------------------------------------------|





\## dim\_customers



| Column Name 		 		      |            Data Type 		| 			Description 				   	|

|---------------------------------------------|---------------------------------|-----------------------------------------------------------------------|

| customer\_key 				      | 	Integer 		| Unique customer identifier used for joins. 				|

| customer\_id 				      | 	Text 			| Customer ID from the source system. 					|

| first\_name 				      | 	Text 			| Customer first name. 							|

| last\_name 				      | 	Text 			| Customer last name.	 						|

| birthdate 				      | 	Date 			| Customer birthdate after cleaning. 					|

| gender 				      | 	Text 			| Customer gender. 							|

| marital\_status 			      | 	Text 			| Customer marital status. 						|

| country 				      | 	Text 			| Customer country, if available. 					|

|---------------------------------------------|---------------------------------|-----------------------------------------------------------------------|







\## Derived KPIs and Metrics



| KPI / Field 				      | Formula / Logic 			     | 			      Description 			        |

|---------------------------------------------|----------------------------------------------|------------------------------------------------------------------|

| Total Revenue 			      | SUM(sales\_amount) 			     | Total sales revenue generated. 					|

| Total Orders 				      | COUNT(DISTINCT order\_number) 		     | Total number of unique orders. 					|

| Total Quantity 			      | SUM(quantity)				     |Total units sold.							|

| Total Customers 			      | COUNT(DISTINCT customer\_key) 		     | Total unique customers. 						|

| Average Order Revenue 		      | Total Revenue / Total Orders    	     | Average revenue generated per order. 				|

| Monthly Sales 			      | SUM(sales\_amount) 			     | Used to analyze monthly revenue trends.				|

|					      | grouped by month 		             |  								|

| Quarterly Sales 			      | SUM(sales\_amount) grouped by quarter         | Used to analyze quarterly performance. 				|

| YoY Growth % 				      | (Current Year Sales - Previous Year Sales)   | Measures year-over-year revenue growth.				| 

|					      | / Previous Year Sales \* 100 		     | 									|

| Cumulative Sales 			      | Running SUM(sales\_amount) over time 	     | Tracks accumulated sales over time. 				|

| Category Contribution % 		      | Category Sales / Overall Sales \* 100 	     | Measures each category’s contribution to total revenue. 		|

| Product Contribution % 		      | Product Sales / Overall Sales \* 100 	     | Measures each product’s contribution to total revenue. 		|

| Recency 				      | Months since last order date 		     | Measures how recently a product or customer was active. 		|

|---------------------------------------------|----------------------------------------------|------------------------------------------------------------------|





\## Business Rules



| Rule Name 				      | Logic 					        | 				Description 			|

|---------------------------------------------|-------------------------------------------------|---------------------------------------------------------------|

| High Performer Product 		      | total\_revenue > 800000 				| Products with high revenue contribution. 			|

| Mid Performer Product 		      | total\_revenue BETWEEN 200000 AND 800000 	| Products with moderate revenue contribution. 			|

| Low Performer Product 	              | total\_revenue < 200000 				| Products with low revenue contribution. 			|

| VIP Customer 				      | lifespan >= 12 months AND total\_spending > 5000 | Long-term high-value customers. 				|

| Regular Customer    			      | lifespan >= 12 months AND total\_spending <= 5000| Long-term customers with moderate or low spending. 		|

| New Customer 				      | lifespan < 12 months 			     	| Recently acquired customers. 					|

|---------------------------------------------|-------------------------------------------------|---------------------------------------------------------------|



\## Data Quality and Validation Notes



* Original date fields were stored as text and converted into proper DATE format using SQL.
* Null checks were performed on important fields such as order date, product key, customer key, sales amount, quantity, and price.
* Duplicate checks were performed during data validation.
* Cleaned date columns were created for order date, ship date, due date, and birthdate.
* 2010 and 2014 contain partial-year data, so YoY trends for those years were interpreted carefully.
* Operational date metrics were validated:
* processing\_days remained constant at 7 days.
* transit\_days remained constant at 5 days.
* expected\_delivery\_days remained constant at 12 days.
* Since operational date fields showed no variation and actual delivery date was not available, detailed SLA or delay analysis was not included.









