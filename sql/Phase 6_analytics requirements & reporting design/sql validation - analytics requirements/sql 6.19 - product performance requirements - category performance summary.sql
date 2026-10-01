
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.3 - PRODUCT PERFORMANCE REQUIREMENTS
SQL 6.19 - CATEGORY PERFORMANCE SUMMARY
============================================================

PURPOSE:
Summarize recorded product sales by category.

QUERY 1:
Calculate product count, units sold, sales amount
and sales contribution for each category.

VALIDATION:
- Compare sales performance across categories.
- Identify categories with no recorded sales.
- Calculate each category's share of total sales.
- Check that category sales reconcile to total
  product sales.

WHY THIS IS NEEDED:
Category-level reporting helps users understand
which product groups contribute to recorded sales.

EXPECTED RESULT:
One row per category, including any uncategorized
products, with sales and contribution figures.

IMPORTANT:
All order statuses are included for this analysis.
This is a coverage summary, not the final eligible-
sales KPI. Category names are not assumed because
the category lookup table has not yet been verified.

This is a read-only query.
============================================================
*/

WITH category_sales AS (
    SELECT
        p.category_id,
        COUNT(DISTINCT p.product_id) AS product_count,
        COUNT(DISTINCT soi.product_id)
            AS products_with_sales,
        COALESCE(SUM(soi.quantity), 0)
            AS total_units_sold,
        COALESCE(SUM(soi.line_total), 0)
            AS total_line_sales
    FROM commerce.product AS p
    LEFT JOIN commerce.sales_order_item AS soi
        ON p.product_id = soi.product_id
    GROUP BY
        p.category_id
)
SELECT
    category_id,
    product_count,
    products_with_sales,
    total_units_sold,
    total_line_sales,
    ROUND(
        100.0 * total_line_sales
        / NULLIF(SUM(total_line_sales) OVER (), 0),
        2
    ) AS sales_contribution_pct
FROM category_sales
ORDER BY
    total_line_sales DESC,
    category_id;