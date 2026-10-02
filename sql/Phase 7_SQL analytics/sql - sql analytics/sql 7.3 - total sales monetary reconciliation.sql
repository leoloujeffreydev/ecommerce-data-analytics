
/*
============================================================
PHASE 7 - SQL ANALYTICS
SQL 7.3 - TOTAL SALES MONETARY RECONCILIATION
============================================================

PURPOSE:
Compare order-level totals with the sum of order-line
totals for completed orders.

TABLES:
1. sales_order
2. sales_order_item

VALIDATION:
- Include completed orders only.
- Compare order_total with summed line_total.
- Identify differences between the two amounts.
- Include completed orders without matching line items.

WHY THIS IS NEEDED:
Total Sales must use a verified monetary source
and calculation grain to avoid double counting.

EXPECTED RESULT:
One row per completed order, showing the order-level
amount, summed line amount and their difference.

NOTE:
This is a read-only query. It does not modify data.
A difference of zero indicates that the two amounts
reconcile for that order.
============================================================
*/

SELECT
    so.sales_order_id,
    so.order_total,
    COALESCE(SUM(soi.line_total), 0) AS summed_line_total,
    so.order_total
        - COALESCE(SUM(soi.line_total), 0) AS difference
FROM commerce.sales_order AS so
LEFT JOIN commerce.sales_order_item AS soi
    ON so.sales_order_id = soi.sales_order_id
WHERE so.order_status = 'Completed'
GROUP BY
    so.sales_order_id,
    so.order_total
ORDER BY
    so.sales_order_id;