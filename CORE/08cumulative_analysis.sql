-- Calculate the total sales per month 
-- and the running total of sales over time 
WITH monthly_sales AS (
  SELECT
    DATE_TRUNC('month', order_date)::DATE AS month,
    SUM(sales_amount * quantity) AS total_sales
  FROM gold.fact_sales
  WHERE order_date IS NOT NULL
  GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
  month,
  total_sales,
  SUM(total_sales) OVER (ORDER BY month) AS running_total
FROM monthly_sales
ORDER BY month;
