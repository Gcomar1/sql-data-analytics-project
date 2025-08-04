/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/*Segment products into cost ranges and 
count how many products fall into each segment*/

WITH product_segments AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE 
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)
SELECT 
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

---------------
/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
WITH customer_sales AS (
    SELECT
        dc.customer_key,
        CONCAT(dc.first_name, ' ', dc.last_name) AS full_name,
        MIN(fs.order_date) AS first_order_date,
        CURRENT_DATE AS today,
        EXTRACT(YEAR FROM AGE(CURRENT_DATE, MIN(fs.order_date))) * 12 +
        EXTRACT(MONTH FROM AGE(CURRENT_DATE, MIN(fs.order_date))) AS months_active,
        SUM(fs.sales_amount) AS total_spending
    FROM gold.dim_customers dc
    LEFT JOIN gold.fact_sales fs 
        ON dc.customer_key = fs.customer_key
    WHERE fs.order_date IS NOT NULL
    GROUP BY dc.customer_key, full_name
),
segmented_customers AS (
    SELECT
        customer_key,
        full_name,
        months_active,
        total_spending,
        CASE
            WHEN months_active < 12 THEN 'New'
            WHEN months_active >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN months_active >= 12 AND total_spending <= 5000 THEN 'Regular'
        END AS customer_segment
    FROM customer_sales
)
SELECT 
    customer_segment,
    COUNT(*) AS total_customers
FROM segmented_customers
GROUP BY customer_segment
ORDER BY 
    CASE customer_segment
        WHEN 'VIP' THEN 1
        WHEN 'Regular' THEN 2
        WHEN 'New' THEN 3
    END;
