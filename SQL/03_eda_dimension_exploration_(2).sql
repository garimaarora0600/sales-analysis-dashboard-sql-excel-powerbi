/*====================================================================================================================
 - DIMENSION EXPLORATION
 - Identifying the unique values(or categories) in each dimension.
 - Recognizing how data might be grouped or segmented, which is useful for later analysis.
======================================================================================================================*/

-- 1. EXPLORE ALL COUNTRIES OUR CUSTOMERS COME FROM
select distinct(country)
from dim_customers;

-- insight - customers come from six different countries.

-- 2.EXPLORE ALL THE PRODUCT CATEGORIES "THE MAJOR DIVISIONS"
select distinct category, subcategory, product_name
from dim_products
order by 1,2,3;


-- Key Insights:
-- • The product catalog is organized in a three-level hierarchy: Category → Subcategory → Product.
-- • For example, the Accessories category contains subcategories such as Helmets and Lights.
-- • Each subcategory further contains individual products, such as Sport-100 Helmet and Helmet-Blue under Helmets.
-- • This hierarchical structure enables businesses to analyze performance at multiple levels, from broad category trends to individual product performance.
-- • The hierarchy also supports drill-down analysis, helping identify which products and subcategories contribute most within a category.
-- • Aggregating only category gives four rows, while aggregating by product gives you 100+  rows 


