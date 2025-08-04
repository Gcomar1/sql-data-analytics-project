/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which categories contribute the most to overall sales?

--total sales = 29,356,250


/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - Compare performance across categories.
    - Identify which categories contribute most to total revenue.
    - Highlight major contributors for prioritization.
===============================================================================
*/

WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.sales_amount IS NOT NULL
    GROUP BY p.category
)

SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    ROUND(
        (total_sales * 100.0) / SUM(total_sales) OVER (), 2
    ) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;


