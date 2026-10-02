
/*
============================================================
PHASE 7 - SQL ANALYTICS
SQL 7.4 - SALES OVERVIEW KPI VALIDATION
============================================================

PURPOSE:
Calculate the core sales overview KPIs.

TABLE:
commerce.sales_order

VALIDATION:
- Include completed orders only.
- Calculate Total Sales from order_total.
- Count distinct completed orders.
- Calculate AOV using Total Sales / Total Orders.
- Round AOV to 2 decimal places.

EXPECTED RESULT:
Total Sales: AED 26,870
Total Orders: 15
AOV: AED 1,791.33

NOTE:
This is a read-only query.
============================================================
*/

SELECT
    SUM(order_total) AS total_sales,
    COUNT(DISTINCT sales_order_id) AS total_orders,
    ROUND(
        SUM(order_total)
        / NULLIF(COUNT(DISTINCT sales_order_id), 0),
        2
    ) AS average_order_value
FROM commerce.sales_order
WHERE order_status = 'Completed';