
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SQL 6.4 - SALES LINE CALCULATION VALIDATION
============================================================

PURPOSE:
Check the arithmetic consistency of sales order lines.

VALIDATION:
- Calculate quantity multiplied by unit_price.
- Subtract discount_amount.
- Compare the calculated amount with line_total.
- Identify any differences.

WHY THIS IS NEEDED:
A matching order_total and sum of line_total values
does not independently prove that each line amount
was calculated correctly.

ASSUMPTION TO TEST:
Expected line_total =
(quantity * unit_price) - discount_amount

EXPECTED RESULT:
One row per sales order item, showing the stored
and calculated line amounts and validation status.

NOTE:
This query tests the stated calculation assumption.
It does not modify data. Any differences will need
review before confirming the formula.
============================================================
*/

SELECT
    sales_order_item_id,
    sales_order_id,
    quantity,
    unit_price,
    discount_amount,
    line_total,
    ROUND(
        (quantity * unit_price) - discount_amount,
        2
    ) AS calculated_line_total,
    ROUND(
        line_total -
        ((quantity * unit_price) - discount_amount),
        2
    ) AS amount_difference,
    CASE
        WHEN line_total =
             (quantity * unit_price) - discount_amount
            THEN 'MATCH'
        ELSE 'MISMATCH'
    END AS validation_status
FROM commerce.sales_order_item
ORDER BY sales_order_id, sales_order_item_id;