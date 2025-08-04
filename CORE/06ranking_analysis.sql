-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking

SELECT
    dp.product_name,
    SUM(fs.sales_amount * fs.quantity) AS total_revenue
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp ON fs.product_key = dp.product_key
GROUP BY dp.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Complex but Flexibly Ranking Using Window Functions
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

---- What are the 5 worst-performing products in terms of sales?

SELECT
    dp.product_name,
    SUM(fs.sales_amount * fs.quantity) AS total_revenue
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp ON fs.product_key = dp.product_key
GROUP BY dp.product_name
ORDER BY total_revenue 
LIMIT 5;

---- Find the top 10 customers who have generated the highest revenue
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    COUNT(fs.customer_key) AS num_of_processes
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers c ON fs.customer_key = c.customer_key
GROUP BY c.first_name, c.last_name
ORDER BY num_of_processes DESC
LIMIT 10;


------ The 3 customers with the fewest orders placed
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    COUNT(fs.customer_key) AS num_of_processes
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers c ON fs.customer_key = c.customer_key
GROUP BY c.first_name, c.last_name
ORDER BY num_of_processes 
LIMIT 3;
