
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SQL 6.6 - SALES AMOUNT BY ORDER STATUS
============================================================

PURPOSE:
Summarize order counts and sales amounts by status.

VALIDATION:
- Count orders for each status.
- Calculate the total order amount per status.
- Calculate the average order amount per status.

WHY THIS IS NEEDED:
Different order statuses may require different
eligibility rules for Total Sales and AOV.
This query provides the amounts associated with
each status so the KPI definitions can be reviewed.

EXPECTED RESULT:
One row per order status, showing:
- Order count
- Total order amount
- Average order amount

IMPORTANT:
This is a descriptive validation. It does not decide
which statuses are eligible for each KPI.
Cancelled orders are shown separately and are not
automatically included in completed sales.

NOTE:
This is a read-only query. It does not modify data.
============================================================
*/

SELECT
    order_status,
    COUNT(*) AS order_count,
    SUM(order_total) AS total_order_amount,
    ROUND(AVG(order_total), 2) AS average_order_amount
FROM commerce.sales_order
GROUP BY order_status
ORDER BY order_status;