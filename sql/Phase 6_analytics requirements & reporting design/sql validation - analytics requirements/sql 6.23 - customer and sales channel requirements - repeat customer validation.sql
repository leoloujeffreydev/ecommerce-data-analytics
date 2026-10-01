
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.4 - CUSTOMER & SALES CHANNEL REQUIREMENTS
SQL 6.23 - REPEAT CUSTOMER VALIDATION
============================================================

PURPOSE:
Validate customer purchase frequency using completed
orders.

QUERY 1:
Classify customers based on their number of
completed orders.

VALIDATION:
- Count customers with zero completed orders.
- Identify one-time completed purchasers.
- Identify repeat completed purchasers.
- Calculate completed order amounts by customer.

WHY THIS IS NEEDED:
Repeat purchasing is a useful customer performance
metric. Only completed orders are counted here to
avoid treating pending, shipped or cancelled orders
as completed purchases.

EXPECTED RESULT:
One row per customer with completed order counts,
purchase classification and completed sales amount.

IMPORTANT:
Repeat purchase is defined here as at least two
completed orders. This is a reporting definition,
not a measure of long-term customer retention.

This is a read-only query.
============================================================
*/

WITH customer_purchases AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(so.sales_order_id) FILTER (
            WHERE so.order_status = 'Completed'
        ) AS completed_order_count,
        COALESCE(
            SUM(so.order_total) FILTER (
                WHERE so.order_status = 'Completed'
            ),
            0
        ) AS completed_sales
    FROM commerce.customer AS c
    LEFT JOIN commerce.sales_order AS so
        ON c.customer_id = so.customer_id
    GROUP BY
        c.customer_id,
        c.customer_name
)
SELECT
    customer_id,
    customer_name,
    completed_order_count,
    CASE
        WHEN completed_order_count = 0
            THEN 'No completed purchases'
        WHEN completed_order_count = 1
            THEN 'One-time purchaser'
        ELSE 'Repeat purchaser'
    END AS purchase_classification,
    completed_sales
FROM customer_purchases
ORDER BY
    completed_order_count DESC,
    completed_sales DESC,
    customer_name;