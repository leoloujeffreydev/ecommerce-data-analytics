
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.6 - KPI AND METRIC DEFINITIONS
SQL 6.28 - RETURN RATE BASIS VALIDATION
============================================================

PURPOSE:
Review return quantities, refund amounts and return
statuses to establish the return-rate basis.

QUERY 1:
Summarize returns by status and compare returned
quantities with the original sold quantities.

VALIDATION:
- Count return records by status.
- Calculate returned quantities and refund amounts.
- Compare returned quantities with sold quantities.
- Reconcile the totals with previous return validation.

WHY THIS IS NEEDED:
Return rate requires a consistent definition of
which returns qualify and which sold quantities
form the denominator.

EXPECTED RESULT:
One row per return status, including return count,
returned quantity, refund amount and original
sold quantity.

IMPORTANT:
This query is descriptive. It does not assume that
approved, completed or pending returns are eligible.

This is a read-only query.
============================================================
*/

SELECT
    r.return_status,
    COUNT(*) AS return_count,
    SUM(r.return_quantity) AS returned_quantity,
    SUM(r.refund_amount) AS refund_amount,
    SUM(soi.quantity) AS original_sold_quantity
FROM commerce."return" AS r
JOIN commerce.sales_order_item AS soi
    ON r.sales_order_item_id = soi.sales_order_item_id
GROUP BY
    r.return_status
ORDER BY
    r.return_status;