
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.2 - PROFITABILITY REQUIREMENTS
SQL 6.14 - RETURN QUANTITY AND AMOUNT CONSISTENCY
============================================================

PURPOSE:
Validate return quantities and refund amounts against
their associated sales order items.

QUERY 1:
Identify return records with potential inconsistencies.

VALIDATION:
1. Check whether each return references an existing
   sales order item.
2. Check whether the return's sales_order_id matches
   the order associated with that item.
3. Check whether total returned quantity exceeds
   the quantity sold.
4. Check whether total refunds exceed the original
   sales order item's line_total.

WHY THIS IS NEEDED:
These checks help determine whether return and refund
data can be used reliably in sales and profitability
analysis.

EXPECTED RESULT:
Zero rows if no inconsistencies are detected.

IMPORTANT:
Refunds above line_total are flagged for review;
they are not automatically considered errors.
All return statuses are included in this check.

NOTE:
This is a read-only query. It does not modify data.
============================================================
*/

WITH return_by_item AS (
    SELECT
        r.sales_order_item_id,
        COUNT(*) AS return_record_count,
        SUM(r.return_quantity) AS total_return_quantity,
        SUM(r.refund_amount) AS total_refund_amount,
        BOOL_OR(
            r.sales_order_id <> soi.sales_order_id
        ) AS order_id_mismatch
    FROM commerce."return" r
    LEFT JOIN commerce.sales_order_item soi
        ON r.sales_order_item_id = soi.sales_order_item_id
    GROUP BY
        r.sales_order_item_id
)
SELECT
    rbi.sales_order_item_id,
    rbi.return_record_count,
    soi.sales_order_id AS item_sales_order_id,
    rbi.total_return_quantity,
    soi.quantity AS quantity_sold,
    rbi.total_refund_amount,
    soi.line_total AS original_line_total,
    CASE
        WHEN soi.sales_order_item_id IS NULL
            THEN 'Missing sales order item'
        WHEN rbi.order_id_mismatch
            THEN 'Sales order ID mismatch'
        WHEN rbi.total_return_quantity > soi.quantity
            THEN 'Returned quantity exceeds quantity sold'
        WHEN rbi.total_refund_amount > soi.line_total
            THEN 'Refund exceeds original line total'
    END AS validation_issue
FROM return_by_item rbi
LEFT JOIN commerce.sales_order_item soi
    ON rbi.sales_order_item_id = soi.sales_order_item_id
WHERE
       soi.sales_order_item_id IS NULL
    OR rbi.order_id_mismatch
    OR rbi.total_return_quantity > soi.quantity
    OR rbi.total_refund_amount > soi.line_total
ORDER BY rbi.sales_order_item_id;