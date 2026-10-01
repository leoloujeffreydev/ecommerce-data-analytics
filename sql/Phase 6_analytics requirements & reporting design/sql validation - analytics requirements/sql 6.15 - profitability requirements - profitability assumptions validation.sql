
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.2 - PROFITABILITY REQUIREMENTS
SQL 6.15 - PROFITABILITY ASSUMPTIONS VALIDATION
============================================================

PURPOSE:
Review the available data supporting profitability
calculations and identify limitations.

QUERY 1:
Summarize sales costs, revenue and return refunds.

VALIDATION:
- Compare current product costs with sales line records.
- Identify the number of sales items with valid product costs.
- Summarize return refunds by status.
- Identify whether historical cost data is available.

WHY THIS IS NEEDED:
Profitability calculations require a defensible cost basis
and clearly defined return treatment. Current product costs
may not represent costs at the time of each sale.

EXPECTED RESULT:
A summary of available profitability inputs and
return refunds, with limitations documented.

IMPORTANT:
Current product costs are not automatically historical
costs. Refunds are not automatically deductions from
revenue until return eligibility rules are approved.

NOTE:
This is a read-only query. It does not modify data.
============================================================
*/

SELECT
    COUNT(*) AS sales_item_count,
    COUNT(p.product_id) AS items_with_product,
    COUNT(p.cost_price) AS items_with_current_cost,
    COUNT(*) FILTER (
        WHERE p.cost_price IS NULL
    ) AS items_missing_current_cost,
    SUM(soi.line_total) AS total_line_revenue,
    SUM(soi.quantity * p.cost_price)
        AS estimated_cost_at_current_price,
    SUM(soi.line_total - (soi.quantity * p.cost_price))
        AS estimated_gross_profit_at_current_cost,
    (
        SELECT COUNT(*)
        FROM commerce."return"
    ) AS return_record_count,
    (
        SELECT SUM(refund_amount)
        FROM commerce."return"
    ) AS total_recorded_refunds
FROM commerce.sales_order_item soi
LEFT JOIN commerce.product p
    ON soi.product_id = p.product_id;