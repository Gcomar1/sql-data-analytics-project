--FIND TOTAL CUSTOMER BY COUNTRY 
SELECT
    dc.country,
    COUNT(DISTINCT customer_id) as num_of_coustmers
from gold.dim_customers dc
GROUP BY country
ORDER BY num_of_coustmers DESC

--FIND TOTAL CUSTOMER BY GENDER
    SELECT
    dc.gender ,
    COUNT(DISTINCT customer_id) as num_of_coustmers
from gold.dim_customers dc
GROUP BY dc.gender
ORDER BY num_of_coustmers DESC

-- Find total products by category
    SELECT
    dp.category ,
    COUNT(DISTINCT product_id) as num_of_prod
from gold.dim_products dp
GROUP BY category
ORDER BY num_of_prod DESC

-- What is the average costs in each category?
    SELECT
    dp.category ,
    COUNT(DISTINCT product_id) as num_of_prod,
    AVG(cost) as avg_cost
from gold.dim_products dp
GROUP BY category
ORDER BY 3 DESC

-- What is the total revenue generated for each category?
    SELECT
    dp.category ,
    COUNT(DISTINCT product_id) as num_of_prod,
    SUM(fs.sales_amount) as sales_amount
from gold.dim_products dp
LEFT join gold.fact_sales fs on dp.product_key = fs.product_key
GROUP BY category
ORDER BY 3 DESC

-- What is the distribution of sold items across countries?
SELECT
    dc.country,
    COUNT(fs.quantity) as total_qauntity
from gold.dim_customers dc
LEFT JOIN gold.fact_sales fs on dc.customer_key = fs.customer_key
GROUP BY dc.country
