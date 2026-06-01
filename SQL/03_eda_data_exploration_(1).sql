/*====================================================================================================================
 DATA EXPLORATION
======================================================================================================================*/

-- 1. explore all objects in the database
select * from information_schema.tables;

-- 2. explore all columns in database
select * from information_schema.columns
where table_name = 'dim_customers'

