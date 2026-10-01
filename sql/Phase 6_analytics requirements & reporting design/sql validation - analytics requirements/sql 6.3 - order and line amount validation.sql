
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SQL 6.3 - ORDER AND LINE AMOUNT VALIDATION
============================================================

PURPOSE:
Compare the stored order_total with the sum of the
line_total values for each order.

VALIDATION:
- Calculate the total line amount for each order.
- Compare it with the stored order_total.
- Identify orders with missing line items.
- Calculate the difference between the two amounts.

WHY THIS IS NEEDED:
We need to establish a reliable sales amount basis
before finalizing the Total Sales and Average Order
Value (AOV) definitions.

EXPECTED RESULT:
One row per order, showing:
- Order ID
- Order status
- Stored order total
- Sum of line totals
- Difference
- Validation status

INTERPRETATION:
MATCH: The order total equals the sum of line totals.
MISMATCH: The amounts differ.
NO LINE ITEMS: No associated order items were found.

NOTE:
This is a read-only query. It does not modify data.
A mismatch does not automatically mean the data is
incorrect; additional charges or adjustments may exist.
============================================================
*/

WITH line_totals AS (
    SELECT
        sales_order_id,
        COUNT(*) AS line_count,
        SUM(line_total) AS total_line_amount
    FROM commerce.sales_order_item
    GROUP BY sales_order_id
)
SELECT
    so.sales_order_id,
    so.order_status,
    so.order_total,
    COALESCE(lt.total_line_amount, 0) AS total_line_amount,
    ROUND(
        so.order_total - COALESCE(lt.total_line_amount, 0),
        2
    ) AS amount_difference,
    COALESCE(lt.line_count, 0) AS line_count,
    CASE
        WHEN lt.sales_order_id IS NULL
            THEN 'NO LINE ITEMS'
        WHEN so.order_total = lt.total_line_amount
            THEN 'MATCH'
        ELSE 'MISMATCH'
    END AS validation_status
FROM commerce.sales_order AS so
LEFT JOIN line_totals AS lt
    ON so.sales_order_id = lt.sales_order_id
ORDER BY
    so.sales_order_id;