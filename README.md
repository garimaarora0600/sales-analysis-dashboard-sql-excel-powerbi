# Sales Analysis Dashboard using SQL, Excel and Power BI

## Project Overview

This is an end-to-end sales analysis project where I used SQL, Excel, and Power BI to analyze sales performance, customer behavior, product performance, and order trends.

The project includes data cleaning, validation, exploratory data analysis, customer and product-level reporting, Excel-based analysis, and an interactive Power BI dashboard.

The main objective of this project was to understand:

* Overall sales performance
* Monthly and yearly sales trends
* Product and category-level contribution
* Customer segmentation and customer value
* Order patterns by day of week
* High-performing products and customer groups

---

## Tools Used

* **SQL / MySQL**: Data cleaning, validation, EDA, trend analysis, customer and product reports
* **Excel**: Initial analysis, pivot tables, validation, and dashboarding
* **Power BI**: Data modeling, DAX measures, interactive dashboards, slicers, drill-downs, and visual storytelling
* **GitHub**: Project documentation and version control

---

## Project Workflow

1. Imported raw sales, customer, and product data into SQL.
2. Performed data cleaning and validation.
3. Conducted exploratory data analysis using SQL.
4. Created customer and product-level analytical reports using SQL.
5. Used Excel for pivot-based analysis and initial dashboarding.
6. Imported cleaned and processed data into Power BI.
7. Created a Date Table and built relationships between fact and report tables.
8. Created DAX measures for KPIs and time-based analysis.
9. Built a 3-page interactive Power BI dashboard.
10. Documented key insights and project files on GitHub.

---

## Repository Structure

```text
Sales-Analysis-Project/
│
├── SQL/
│   ├── 01_data_cleaning.sql
│   ├── 02_data_validation.sql
│   ├── 03_eda.sql
│   ├── 04_trend_analysis.sql
│   ├── 05_customer_report.sql
│   └── 06_product_report.sql
│
├── Dataset/
│   ├── raw/
│   │   ├── fact_sales.csv
│   │   ├── customers.csv
│   │   └── products.csv
│   │
│   ├── processed/
│   │   ├── customer_report.csv
│   │   └── product_report.csv
│   │
│   └── data_dictionary.md
│
├── Excel/
│   ├── sales_analysis_excel_workbook.xlsx
│   └── excel_dashboard_screenshot.png
│
├── PowerBI/
│   ├── sales_analysis_dashboard.pbix
│   ├── executive_sales_overview.png
│   ├── product_order_deep_dive.png
│   └── customer_analysis_dashboard.png
│
├── Insights/
│   └── key_insights.md
│
└── README.md
```

---

## SQL Analysis Performed

The SQL part of this project includes:

### 1. Data Cleaning

* Checked and handled missing values
* Cleaned date columns
* Standardized column formats
* Created clean date fields
* Verified invalid or inconsistent records

### 2. Data Validation

* Checked duplicate records
* Validated date ranges
* Verified sales, quantity, and customer/product keys
* Ensured cleaned data was ready for analysis

### 3. Exploratory Data Analysis

* Analyzed total sales, orders, customers, and quantity
* Checked category and subcategory performance
* Identified top-performing products
* Analyzed customer purchase behavior

### 4. Trend Analysis

* Year-wise sales trend
* Month-wise sales trend
* Quarter-wise sales trend
* Year-over-year growth
* Running total sales over time

### 5. Product Analysis

Created a product-level report including:

* Product name, category, subcategory, and cost
* Total sales
* Total orders
* Total quantity sold
* Total unique customers
* Product recency
* Average order revenue
* Average monthly revenue
* Product performance segment

### 6. Customer Analysis

Created a customer-level report including:

* Customer name and age group
* Total orders
* Total sales
* Total quantity purchased
* Customer lifespan
* Customer recency
* Average order value
* Average monthly spend
* Customer segment: New, Regular, VIP

---

## Excel Work

Excel was used for initial analysis and validation before building the final Power BI dashboard.

The Excel work includes:

* Pivot table-based analysis
* Sales and category summaries
* Customer and product-level checks
* Initial dashboard/charts for sales analysis
* Data validation before Power BI reporting

---

## Power BI Dashboard

The Power BI report contains 3 dashboard pages.

### 1. Executive Sales Overview

This page provides a high-level business summary.

It includes:

* Total Sales
* Total Orders
* Total Customers
* Total Quantity
* Average Order Value
* Monthly Sales Trend
* Top 10 Products by Sales
* Sales by Category
* Sales by Customer Segment
* Sales by Product Segment

![Executive Sales Overview](PowerBI/executive_sales_overview.png)

---

### 2. Product & Order Deep Dive

This page focuses on product and order-level analysis.

It includes:

* Orders by Day of Week
* Quantity Sold by Day of Week
* Order Trend Drill-down
* Category to Subcategory Sales Drill-down
* Product-level matrix with sales, quantity, and orders

![Product & Order Deep Dive](PowerBI/product_order_deep_dive.png)

---

### 3. Customer Analysis Dashboard

This page focuses on customer behavior and customer value.

It includes:

* Total Customers
* VIP Customers
* Average Monthly Spend
* Average Order Value
* Average Recency
* Average Customer Lifespan
* Customer Segment Distribution
* Customer Distribution by Age Group
* Average Monthly Spend by Customer Segment
* Average Lifespan by Customer Segment
* Top 10 Customers by Sales
* Customer Segment Quality Table

---

## Key DAX Measures

Some important DAX measures used in the Power BI dashboard:

Total Sales = SUM(fact_sales[sales_amount])

Total Orders = DISTINCTCOUNT(fact_sales[order_number])

Total Customers = DISTINCTCOUNT(fact_sales[customer_key])

Total Quantity = SUM(fact_sales[quantity])

Average Order Value = DIVIDE([Total Sales], [Total Orders])

Sales Previous Year =
CALCULATE(
    [Total Sales],
    SAMEPERIODLASTYEAR('Date Table'[Date])
)


YoY Growth % =
DIVIDE(
    [Total Sales] - [Sales Previous Year],
    [Sales Previous Year]
)

Running Total Sales =
CALCULATE(
    [Total Sales],
    FILTER(
        ALL('Date Table'[Date]),
        'Date Table'[Date] <= MAX('Date Table'[Date])
    )
)

VIP Customers =
CALCULATE(
    DISTINCTCOUNT(customer_report[customer_key]),
    customer_report[customer_segment] = "VIP"
)

Avg Customer Recency =
AVERAGE(customer_report[recency])

Avg Customer Lifespan =
AVERAGE(customer_report[lifespan])


## Key Insights

* Bikes contributed the highest share of total revenue.
* New customers formed the largest customer segment.
* VIP and Regular customers showed higher average lifespan compared to New customers.
* Top-selling products were mostly from the Bikes category.
* Orders were distributed fairly evenly across weekdays.
* Customer age distribution showed that the majority of customers belonged to older age groups.
* Product and customer segmentation helped identify high-value customers and high-performing products.

---

## Business Impact

This dashboard can help business stakeholders:

* Track overall sales performance
* Identify top-performing products and categories
* Understand customer segments and spending behavior
* Monitor customer recency and lifespan
* Analyze order trends by weekday and month
* Make data-driven decisions for sales, marketing, and customer retention

---

## How to Use This Repository

1. Open the SQL files in the `SQL/` folder to view data cleaning, validation, and analysis queries.
2. View the datasets in the `Dataset/` folder.
3. Open the Excel workbook from the `Excel/` folder for pivot-based analysis.
4. Open the `.pbix` file from the `PowerBI/` folder to explore the interactive dashboard.
5. View dashboard screenshots directly in the README.

---

## Author

**Garima Arora**
Data Analyst Portfolio Project
