
/*
============================================================
PHASE 7 - SQL ANALYTICS
SQL 7.6 - PRODUCT SALES ANALYSIS
QUERY 1 OF 1
============================================================

PURPOSE:
Analyze sales performance for each product using
completed orders.

TABLES:
1. commerce.sales_order
2. commerce.sales_order_item

VALIDATION:
- Calculate the total quantity sold per product.
- Calculate total sales per product.
- Count the number of distinct completed orders
  containing each product.
- Verify that product sales reconcile with the
  overall sales figures where applicable.

WHY THIS IS NEEDED:
Product-level sales analysis helps identify which
products contribute to overall sales.

The results will support product performance
analysis in the Power BI dashboard.

EXPECTED RESULT:
One row per product containing:
- Product ID
- Units sold
- Total product sales
- Number of completed orders

NOTE:
This is a read-only query. It does not modify data.

Only completed orders are included.

The line_total column is used as the sales amount
because it was previously validated against
order_total for completed orders.

Products are grouped by product_id. Product names
are not included because their source and structure
have not yet been validated.
============================================================
*/

SELECT
    soi.product_id,
    SUM(soi.quantity) AS units_sold,
    SUM(soi.line_total) AS total_sales,
    COUNT(DISTINCT so.sales_order_id) AS total_orders
FROM commerce.sales_order_item AS soi
INNER JOIN commerce.sales_order AS so
    ON soi.sales_order_id = so.sales_order_id
WHERE so.order_status = 'Completed'
GROUP BY
    soi.product_id
ORDER BY
    total_sales DESC,
    soi.product_id;