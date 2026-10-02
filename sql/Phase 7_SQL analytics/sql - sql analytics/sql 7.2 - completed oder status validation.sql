
/*
============================================================
PHASE 7 - SQL ANALYTICS
SQL 7.2 - COMPLETED ORDER STATUS VALIDATION
============================================================

PURPOSE:
Inspect the actual order status values and their
corresponding order counts.

TABLE:
sales_order

VALIDATION:
- Identify all distinct order status values.
- Count the orders for each status.
- Identify the actual completed order status.

WHY THIS IS NEEDED:
Total Sales must include completed orders only.
We need to verify the actual status values before
defining the Total Sales calculation.

EXPECTED RESULT:
One row per order status, showing the status
and its corresponding order count.

NOTE:
This is a read-only query. It does not modify data.
No status is assumed to represent completed orders.
============================================================
*/

SELECT
    order_status,
    COUNT(*) AS order_count
FROM commerce.sales_order
GROUP BY
    order_status
ORDER BY
    order_status;