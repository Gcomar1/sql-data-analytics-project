-- Drop the view if it exists
DROP VIEW IF EXISTS gold.report_products;

-- Create the view
CREATE VIEW gold.report_products AS

WITH base_query AS (
    -- 1) Base Query: Join sales and product info
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
),

product_aggregations AS (
    -- 2) Aggregated metrics at product level
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        DATE_PART('month', AGE(MAX(order_date), MIN(order_date)))::INT AS lifespan,
        MAX(order_date) AS last_sale_date,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        ROUND(AVG(CASE WHEN quantity = 0 THEN NULL ELSE sales_amount::NUMERIC / quantity END), 1) AS avg_selling_price
    FROM base_query
    GROUP BY product_key, product_name, category, subcategory, cost
)

-- 3) Final report output
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,
    DATE_PART('month', AGE(CURRENT_DATE, last_sale_date))::INT AS recency_in_months,
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,
    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,
    
    -- Average Order Revenue (AOR)
    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE ROUND(total_sales::NUMERIC / total_orders, 2)
    END AS avg_order_revenue,

    -- Average Monthly Revenue
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE ROUND(total_sales::NUMERIC / lifespan, 2)
    END AS avg_monthly_revenue

FROM product_aggregations;

SELECT * FROM gold.report_products 