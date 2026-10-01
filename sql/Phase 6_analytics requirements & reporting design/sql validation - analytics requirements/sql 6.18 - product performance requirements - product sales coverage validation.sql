
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.3 - PRODUCT PERFORMANCE REQUIREMENTS
SQL 6.18 - PRODUCT SALES COVERAGE VALIDATION
============================================================

PURPOSE:
Validate product-level sales coverage and identify
products with no recorded sales.

QUERY 1:
Summarize sales quantity, line sales and order count
for each product.

VALIDATION:
- Confirm which products have recorded sales.
- Identify products with zero sales.
- Review product category assignments.
- Check whether product sales totals can be
  aggregated at product level.

WHY THIS IS NEEDED:
Product performance reporting requires reliable
product-level sales data. Including products with
zero sales helps distinguish unsold products from
products missing from the analysis.

EXPECTED RESULT:
One row per product, including products without
recorded sales.

IMPORTANT:
All order statuses are included for this coverage
check. This is not the final eligible-sales KPI.
Returns are excluded to avoid double counting.

This is a read-only query.
============================================================
*/

SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    COUNT(DISTINCT soi.sales_order_item_id)
        AS sales_line_count,
    COALESCE(SUM(soi.quantity), 0)
        AS total_units_sold,
    COALESCE(SUM(soi.line_total), 0)
        AS total_line_sales,
    COUNT(DISTINCT soi.sales_order_id)
        AS order_count
FROM commerce.product AS p
LEFT JOIN commerce.sales_order_item AS soi
    ON p.product_id = soi.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category_id
ORDER BY
    total_line_sales DESC,
    p.product_name;