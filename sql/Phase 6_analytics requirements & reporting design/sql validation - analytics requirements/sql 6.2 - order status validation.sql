
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SQL 6.2 - ORDER STATUS VALIDATION
============================================================

PURPOSE:
Identify the order statuses currently stored in
commerce.sales_order.

VALIDATION:
- List each distinct order status.
- Count the number of orders per status.
- Calculate the percentage of total orders per status.

WHY THIS IS NEEDED:
Order eligibility must be defined separately for each
KPI. Cancelled orders must be excluded from completed
orders, but other statuses need to be reviewed before
we finalize the rules.

EXPECTED RESULT:
One row per order status, with its order count
and percentage of all orders.

NOTE:
This is a read-only query. It does not modify data.
============================================================
*/

SELECT
    order_status,
    COUNT(*) AS order_count,
    ROUND(
        COUNT(*) * 100.0 /
        NULLIF(SUM(COUNT(*)) OVER (), 0),
        2
    ) AS percentage_of_orders
FROM commerce.sales_order
GROUP BY order_status
ORDER BY order_count DESC, order_status;