
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.2 - PROFITABILITY REQUIREMENTS
SQL 6.10 - HISTORICAL SALES AND PRODUCT COST COMPARISON
============================================================

PURPOSE:
Compare historical sales line values with the current
product cost values stored in commerce.product.

QUERY 1:
Display sales quantities, historical unit prices,
discounts, line totals and current product costs.

VALIDATION:
- Match each sales line to its product.
- Display the recorded sales price and discount.
- Calculate the estimated cost using current cost_price.
- Calculate indicative gross profit and margin.
- Identify whether the product cost is available.

WHY THIS IS NEEDED:
The sales order items preserve the unit price at the
time of sale, while product.cost_price may represent
the current cost.

This comparison helps assess whether current product
costs can reasonably support historical profitability
analysis.

CALCULATION ASSUMPTION:
Estimated Cost = Quantity * Current Product Cost
Indicative Gross Profit = Line Total - Estimated Cost
Indicative Margin = Gross Profit / Line Total * 100

IMPORTANT:
These profit and margin values are exploratory only.
They must NOT be treated as confirmed historical
profitability because the current cost may differ
from the cost at the time of sale.

All order statuses are included for inspection.
Cancelled, pending and shipped orders must be handled
according to the final KPI eligibility rules.

EXPECTED RESULT:
One row per sales order item, showing the historical
sales values, current cost and indicative profit.

NOTE:
This is a read-only query. It does not modify data.
============================================================
*/

SELECT
    soi.sales_order_item_id,
    soi.sales_order_id,
    so.order_date::date AS order_date,
    so.order_status,
    soi.product_id,
    p.product_name,
    soi.quantity,
    soi.unit_price,
    soi.discount_amount,
    soi.line_total,
    p.cost_price AS current_cost_price,
    ROUND(
        soi.quantity * p.cost_price,
        2
    ) AS estimated_cost,
    ROUND(
        soi.line_total - (soi.quantity * p.cost_price),
        2
    ) AS indicative_gross_profit,
    ROUND(
        (soi.line_total - (soi.quantity * p.cost_price))
        * 100.0 / NULLIF(soi.line_total, 0),
        2
    ) AS indicative_profit_margin_pct
FROM commerce.sales_order_item AS soi
JOIN commerce.sales_order AS so
    ON soi.sales_order_id = so.sales_order_id
JOIN commerce.product AS p
    ON soi.product_id = p.product_id
ORDER BY
    soi.sales_order_id,
    soi.sales_order_item_id;