
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.2 - PROFITABILITY REQUIREMENTS
SQL 6.9 - PRODUCT COST DATA VALIDATION
============================================================

PURPOSE:
Validate the actual cost_price values in the product
table before using them for profitability analysis.

QUERY 1:
Summarize product costs and identify unusual values.

VALIDATION:
- Count all products.
- Count products with zero cost.
- Count products with negative cost.
- Identify the minimum and maximum cost.
- Calculate the average cost.
- Count inactive products separately.

WHY THIS IS NEEDED:
A populated cost field does not automatically mean
that all cost values are suitable for profit analysis.
Zero or negative costs may require investigation.
Inactive products are included because they may still
be linked to historical sales.

EXPECTED RESULT:
One summary row showing the cost range, average,
product count and unusual cost counts.

NOTE:
This is a read-only query. It does not modify data.
A zero cost is flagged for review, not automatically
treated as an error.
============================================================
*/

SELECT
    COUNT(*) AS total_products,
    COUNT(*) FILTER (
        WHERE cost_price = 0
    ) AS zero_cost_products,
    COUNT(*) FILTER (
        WHERE cost_price < 0
    ) AS negative_cost_products,
    COUNT(*) FILTER (
        WHERE is_active = FALSE
    ) AS inactive_products,
    MIN(cost_price) AS minimum_cost,
    MAX(cost_price) AS maximum_cost,
    ROUND(AVG(cost_price), 2) AS average_cost
FROM commerce.product;