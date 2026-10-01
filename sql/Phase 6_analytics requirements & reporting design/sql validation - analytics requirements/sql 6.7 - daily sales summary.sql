
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SQL 6.7 - DAILY SALES SUMMARY
============================================================

PURPOSE:
Summarize daily order counts and amounts by order status.

QUERY 1:
Show daily order counts and order amounts, broken
down by status.

VALIDATION:
- Group orders by order date.
- Count orders per day and status.
- Sum order amounts per day and status.

WHY THIS IS NEEDED:
Daily summaries help establish the available level
of detail for sales reporting and reveal how orders
are distributed within the reporting period.

EXPECTED RESULT:
One row per date and order status, showing the
order count and total order amount.

IMPORTANT:
This is a descriptive summary. It does not determine
KPI eligibility. Order statuses remain separate.

NOTE:
This is a read-only query. It does not modify data.
============================================================
*/

SELECT
    order_date::date AS order_day,
    order_status,
    COUNT(*) AS order_count,
    SUM(order_total) AS total_order_amount
FROM commerce.sales_order
GROUP BY
    order_date::date,
    order_status
ORDER BY
    order_day,
    order_status;