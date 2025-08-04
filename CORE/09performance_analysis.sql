WITH yearly_product_sales AS (
    SELECT
        EXTRACT(YEAR FROM f.order_date)::INT AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY 
        EXTRACT(YEAR FROM f.order_date)::INT,
        p.product_name
)
SELECT
    order_year,
    product_name,
    current_sales,
    
    -- Average sales across years for each product
    ROUND(AVG(current_sales) OVER (PARTITION BY product_name), 2) AS avg_sales,
    
    -- Difference from average
    ROUND(current_sales - AVG(current_sales) OVER (PARTITION BY product_name), 2) AS diff_avg,
    
    -- Categorical label
    CASE 
        WHEN current_sales > AVG(current_sales) OVER (PARTITION BY product_name) THEN 'Above Avg'
        WHEN current_sales < AVG(current_sales) OVER (PARTITION BY product_name) THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,

    -- Year-over-Year comparisons
  COALESCE(LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year), 0) AS py_sales,
    COALESCE(current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year), 0) AS diff_py,
          
    CASE 
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change

FROM yearly_product_sales
ORDER BY product_name, order_year;
