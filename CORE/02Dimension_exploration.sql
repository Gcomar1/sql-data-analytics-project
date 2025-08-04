-- Retrieve a list of unique countries from which customers originate
SELECT DISTINCT
            country
from gold.dim_customers


-- Retrieve a list of unique categories, subcategories, and products

SELECT DISTINCT
    d.category,
    d.subcategory,
    d.product_name
FROM gold.dim_products d
ORDER BY 1, 2, 3
