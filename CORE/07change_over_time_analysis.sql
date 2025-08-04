SELECT * FROM gold.dim_customers
SELECT * FROM gold.dim_products
SELECT * FROM gold.fact_sales LIMIT 20; 


---SHOWN TOTAL SALES IN EACH YEAR--- 
--
SELECT
    EXTRACT(YEAR from fs.order_date) as years,
    COUNT(DISTINCT customer_key) as num_of_coustmer,
    SUM(sales_amount * quantity)as total_sales
FROM gold.fact_sales fs
WHERE fs.order_date is not null and fs.sales_amount  is not null  and quantity is not null 
GROUP BY years
ORDER BY 1
LIMIT 10 ;
    --THE DATA SHOW INFO FROM 2010 -> 2014
----------------------------------------------------------------------
---- TO SHOW IN MONTHS IN SPECFIC YEAR 
SELECT
    CAST(date_trunc('month', fs.order_date) as date) AS order_date,
    --or this 
   -- EXTRACT(YEAR from fs.order_date) as years, 
   -- EXTRACT(MONTH from fs.order_date) as months,
    COUNT(DISTINCT fs.customer_key) AS num_of_customers,
    SUM(fs.sales_amount * fs.quantity) AS total_sales
FROM gold.fact_sales fs
WHERE fs.order_date IS NOT NULL
GROUP BY date_trunc('month', fs.order_date)
ORDER BY date_trunc('month', fs.order_date);
------------------------------------------------
--AVGERAGE OF EACH YEAR
SELECT
    EXTRACT(YEAR from fs.order_date) as years,
    COUNT(DISTINCT customer_key) as num_of_coustmer,
    round(AVG(sales_amount * quantity)) as  total_sales
FROM gold.fact_sales fs
WHERE fs.order_date is not null and fs.sales_amount  is not null  and quantity is not null 
GROUP BY years
ORDER BY 1
LIMIT 10 ;
--------------------------------------
--SHOW THE BEST MONTH IN EACH YEAR 
with period_report as
(
SELECT
    EXTRACT(YEAR FROM fs.order_date) AS years,
    EXTRACT(MONTH FROM fs.order_date) AS months,
    sum(sales_amount * quantity) as total_sales
FROM gold.fact_sales fs
WHERE fs.order_date IS NOT NULL
GROUP BY years, months
)
SELECT *
FROM (
    SELECT 
        years,
        months,
        total_sales,
        RANK() OVER (PARTITION BY years ORDER BY total_sales DESC) AS sales_rank
    FROM period_report
) ranked
WHERE sales_rank = 1
ORDER BY years;

----------------------------------------------------
--  GET MIN OF TOTAL SALES MONTH IN EACH YEAR 
with period_report as
(
SELECT
    EXTRACT(YEAR FROM fs.order_date) AS years,
    EXTRACT(MONTH FROM fs.order_date) AS months,
    sum(sales_amount * quantity) as total_sales
FROM gold.fact_sales fs
WHERE fs.order_date IS NOT NULL
GROUP BY years, months
)
SELECT *
FROM (
    SELECT 
        years,
        months,
        total_sales,
        RANK() OVER (PARTITION BY years ORDER BY total_sales ) AS sales_rank
    FROM period_report
) ranked
WHERE sales_rank = 1
ORDER BY years;