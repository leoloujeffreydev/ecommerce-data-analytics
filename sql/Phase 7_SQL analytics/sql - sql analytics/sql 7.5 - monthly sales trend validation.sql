
/*
============================================================
PHASE 7 - SQL ANALYTICS
SQL 7.5 - MONTHLY SALES TREND VALIDATION
QUERY 1 OF 1
============================================================

PURPOSE:
Calculate monthly sales, completed orders and average
order value.

TABLES:
1. commerce.sales_order

VALIDATION:
- Group completed orders by month.
- Calculate monthly sales.
- Count completed orders per month.
- Calculate monthly average order value.
- Reconcile monthly results with the overall KPIs.

WHY THIS IS NEEDED:
Monthly sales trends help analyze sales performance
over time and will support the Power BI dashboard.

EXPECTED RESULT:
One row per month with completed orders, including:
- Month start date
- Sales month (YYYY-MM)
- Total sales
- Total orders
- Average order value

Monthly sales and order counts should reconcile
with the overall KPIs if the underlying data
has not changed.

NOTE:
This is a read-only query.
Only orders with status 'Completed' are included.
The order_date column is used as the sales date.
============================================================
*/

SELECT
    DATE_TRUNC('month', order_date) AS month_start,
    TO_CHAR(
        DATE_TRUNC('month', order_date),
        'YYYY-MM'
    ) AS sales_month,
    SUM(order_total) AS total_sales,
    COUNT(DISTINCT sales_order_id) AS total_orders,
    ROUND(
        SUM(order_total)
        / NULLIF(COUNT(DISTINCT sales_order_id), 0),
        2
    ) AS average_order_value
FROM commerce.sales_order
WHERE order_status = 'Completed'
GROUP BY
    DATE_TRUNC('month', order_date)
ORDER BY
    month_start;