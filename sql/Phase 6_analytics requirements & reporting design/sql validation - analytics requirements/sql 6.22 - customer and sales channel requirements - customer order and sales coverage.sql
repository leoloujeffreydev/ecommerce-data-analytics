
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.4 - CUSTOMER & SALES CHANNEL REQUIREMENTS
SQL 6.22 - CUSTOMER ORDER AND SALES COVERAGE
============================================================

PURPOSE:
Validate customer order activity and sales coverage.

QUERY 1:
Summarize orders and order amounts by customer.

VALIDATION:
- Identify customers with and without orders.
- Count all orders and completed orders.
- Compare total order amounts with completed
  order amounts.
- Review customer-level order activity.

WHY THIS IS NEEDED:
Customer reporting requires a reliable link between
customers and their orders. Separating completed
orders helps prevent other order statuses from
being mistaken for completed sales.

EXPECTED RESULT:
One row per customer, including customers without
orders, with order counts and sales amounts.

IMPORTANT:
All statuses are included in total_order_amount.
completed_order_amount includes only Completed
orders. These figures are not interchangeable.

This is a read-only query.
============================================================
*/

SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    c.country,
    c.is_active,
    COUNT(so.sales_order_id) AS total_order_count,
    COUNT(so.sales_order_id) FILTER (
        WHERE so.order_status = 'Completed'
    ) AS completed_order_count,
    COALESCE(SUM(so.order_total), 0)
        AS total_order_amount,
    COALESCE(
        SUM(so.order_total) FILTER (
            WHERE so.order_status = 'Completed'
        ),
        0
    ) AS completed_order_amount
FROM commerce.customer AS c
LEFT JOIN commerce.sales_order AS so
    ON c.customer_id = so.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.city,
    c.country,
    c.is_active
ORDER BY
    completed_order_amount DESC,
    total_order_count DESC,
    c.customer_name;