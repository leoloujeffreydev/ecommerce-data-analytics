
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.2 - PROFITABILITY REQUIREMENTS
SQL 6.16 - FINAL PROFITABILITY RECONCILIATION
============================================================

PURPOSE:
Reconcile the validated sales, estimated costs,
estimated gross profit and recorded refunds.

QUERY 1:
Produce a consolidated profitability summary.

VALIDATION:
- Reconcile sales revenue with validated line totals.
- Reconcile current-cost estimates with sales items.
- Reconcile estimated gross profit.
- Summarize recorded refunds by return status.
- Keep estimated profitability separate from
  historical or accounting-confirmed profitability.

WHY THIS IS NEEDED:
The consolidated figures provide a documented basis
for closing the profitability requirements while
preserving known data limitations.

EXPECTED RESULT:
One summary row for sales, costs and estimated profit,
followed by a refund breakdown by return status.

IMPORTANT:
Current product costs are used for estimates only.
Refunds are shown separately and are not automatically
deducted from revenue.
Cancelled and other order statuses are not adjusted
in this reconciliation.

NOTE:
This is a read-only query. It does not modify data.
============================================================
*/

WITH sales_summary AS (
    SELECT
        COUNT(*) AS sales_item_count,
        SUM(soi.line_total) AS total_line_revenue,
        SUM(soi.quantity * p.cost_price)
            AS estimated_current_cost,
        SUM(
            soi.line_total - (soi.quantity * p.cost_price)
        ) AS estimated_gross_profit
    FROM commerce.sales_order_item soi
    JOIN commerce.product p
        ON soi.product_id = p.product_id
),
return_summary AS (
    SELECT
        return_status,
        COUNT(*) AS return_count,
        SUM(refund_amount) AS total_refunds
    FROM commerce."return"
    GROUP BY return_status
)
SELECT
    'PROFITABILITY' AS summary_type,
    s.sales_item_count AS record_count,
    s.total_line_revenue AS revenue_aed,
    s.estimated_current_cost AS estimated_cost_aed,
    s.estimated_gross_profit AS estimated_gross_profit_aed,
    NULL::numeric AS refunds_aed
FROM sales_summary s

UNION ALL

SELECT
    'RETURN: ' || r.return_status AS summary_type,
    r.return_count AS record_count,
    NULL::numeric AS revenue_aed,
    NULL::numeric AS estimated_cost_aed,
    NULL::numeric AS estimated_gross_profit_aed,
    r.total_refunds AS refunds_aed
FROM return_summary r

ORDER BY summary_type;