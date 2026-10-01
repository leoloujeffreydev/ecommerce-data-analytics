
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.6 - KPI AND METRIC DEFINITIONS
SQL 6.27 - SALES KPI STATUS BASIS
============================================================

PURPOSE:
Review order status, order counts and sales amounts
to support the definition of sales KPIs.

QUERY 1:
Summarize orders and order amounts by status.

VALIDATION:
- Count orders by status.
- Calculate order amounts by status.
- Reconcile total orders and sales with previous
  sales performance validations.
- Provide evidence for sales eligibility decisions.

WHY THIS IS NEEDED:
Sales KPIs need a consistent order-status basis.
The status distribution helps document the impact
of including or excluding different order statuses.

EXPECTED RESULT:
One row per order status with order count,
sales amount and average order amount.

IMPORTANT:
This query is descriptive. It does not decide
which statuses are eligible for every KPI.

This is a read-only query.
============================================================
*/

SELECT
    order_status,
    COUNT(*) AS order_count,
    SUM(order_total) AS total_order_amount,
    ROUND(AVG(order_total), 2)
        AS average_order_amount
FROM commerce.sales_order
GROUP BY
    order_status
ORDER BY
    order_status;