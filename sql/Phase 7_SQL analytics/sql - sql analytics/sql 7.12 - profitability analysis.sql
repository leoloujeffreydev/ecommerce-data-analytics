
/*
PROJECT: LJ Dev Commerce
PHASE: 7 - SQL Analytics
TASK: SQL 7.12 - Profitability Analysis
STATUS: FINAL CONSOLIDATED SCRIPT
QUERIES: 5

PURPOSE
Validate profitability using completed orders, line-level sales amounts,
and current product costs. Reconcile the aggregate, discount treatment,
product-level results, and individual sales lines.

TABLES
commerce.sales_order
commerce.sales_order_item
commerce.product
information_schema.columns

VALIDATION
Expected reconciled totals:
- Completed orders: 15
- Sales lines: 19
- Units sold: 21
- Eligible sales: AED 26,870.00
- Estimated product cost: AED 21,510.00
- Estimated gross profit: AED 5,360.00
- Estimated profit margin: 19.95%
- Difference from earlier AED 7,603 benchmark: -AED 2,243.00

WHY THIS IS NEEDED
Profitability must use a verified cost field and consistent order-line grain.
Order header and line amounts must not be mixed in a way that duplicates sales.
Current product costs are estimates, not historical or audited costs.

EXPECTED RESULT
The aggregate, adjustment, product, and line-level outputs should reconcile
to the validated totals above.

NOTE
The earlier AED 7,603 benchmark remains unexplained and is not an adjustment.
Do not modify the data or add artificial adjustments to force a match.
Discounts are reflected through line_total; tax, shipping, and returns remain
excluded unless separately supported and approved.
*/

-- QUERY 1 OF 5: Product Cost Source Structure Validation
/*
PURPOSE
Confirm the product table's actual cost field and data type.

TABLES
information_schema.columns

VALIDATION
Verify that commerce.product contains the cost_price field.

EXPECTED RESULT
Product table columns and their data types, nullability, and numeric precision.
*/

SELECT
    column_name,
    data_type,
    is_nullable,
    numeric_precision,
    numeric_scale
FROM information_schema.columns
WHERE table_schema = 'commerce'
  AND table_name = 'product'
ORDER BY ordinal_position;


-- QUERY 2 OF 5: Overall Estimated Profitability Reconciliation
/*
PURPOSE
Calculate completed-order sales, estimated product cost, estimated gross profit,
margin, and variance from the earlier benchmark.

TABLES
commerce.sales_order
commerce.sales_order_item
commerce.product

VALIDATION
Use Completed orders only. Calculate cost at the order-line grain:
quantity * current product cost_price.

EXPECTED RESULT
15 orders; 19 lines; AED 26,870.00 sales; AED 21,510.00 estimated cost;
AED 5,360.00 estimated gross profit; 19.95% estimated margin.

NOTE
Current product costs are estimates. The AED 7,603 benchmark is retained only
for variance comparison; do not treat the variance as an adjustment.
*/

WITH completed_lines AS (
    SELECT
        so.sales_order_id,
        soi.sales_order_item_id,
        soi.product_id,
        soi.quantity,
        soi.line_total,
        p.cost_price,
        (soi.quantity * p.cost_price) AS estimated_product_cost
    FROM commerce.sales_order AS so
    INNER JOIN commerce.sales_order_item AS soi
        ON so.sales_order_id = soi.sales_order_id
    INNER JOIN commerce.product AS p
        ON soi.product_id = p.product_id
    WHERE so.order_status = 'Completed'
),
profitability AS (
    SELECT
        COUNT(DISTINCT sales_order_id) AS total_orders,
        COUNT(*) AS total_sales_lines,
        SUM(line_total) AS total_sales_aed,
        SUM(estimated_product_cost) AS estimated_product_cost_aed,
        SUM(line_total - estimated_product_cost)
            AS estimated_gross_profit_aed
    FROM completed_lines
)
SELECT
    total_orders,
    total_sales_lines,
    total_sales_aed,
    estimated_product_cost_aed,
    estimated_gross_profit_aed,
    ROUND(
        100.0 * estimated_gross_profit_aed
        / NULLIF(total_sales_aed, 0),
        2
    ) AS estimated_profit_margin_pct,
    estimated_gross_profit_aed - 7603.00
        AS variance_from_benchmark_aed
FROM profitability;


-- QUERY 3 OF 5: Discount and Line-Adjustment Reconciliation
/*
PURPOSE
Reconcile sales before discounts, recorded discounts, line_total after
line adjustments, and the resulting estimated profit.

TABLES
commerce.sales_order
commerce.sales_order_item
commerce.product

VALIDATION
Use Completed orders only. Compare quantity * unit_price with discount_amount
and line_total. Do not add discounts a second time to line_total.

EXPECTED RESULT
Sales before discount: AED 26,969.00
Recorded discounts: AED 99.00
Sales after line adjustments: AED 26,870.00
Estimated profit before line adjustments: AED 5,459.00
Estimated profit after line adjustments: AED 5,360.00
*/

WITH completed_lines AS (
    SELECT
        soi.quantity,
        soi.unit_price,
        soi.discount_amount,
        soi.line_total,
        p.cost_price,
        (soi.quantity * soi.unit_price) AS sales_before_discount,
        (soi.quantity * p.cost_price) AS estimated_product_cost
    FROM commerce.sales_order AS so
    INNER JOIN commerce.sales_order_item AS soi
        ON so.sales_order_id = soi.sales_order_id
    INNER JOIN commerce.product AS p
        ON soi.product_id = p.product_id
    WHERE so.order_status = 'Completed'
)
SELECT
    COUNT(*) AS total_sales_lines,
    SUM(quantity) AS total_units,
    SUM(sales_before_discount) AS sales_before_discount_aed,
    SUM(discount_amount) AS recorded_discounts_aed,
    SUM(sales_before_discount - line_total)
        AS difference_before_and_after_discount_aed,
    SUM(line_total) AS sales_after_line_adjustments_aed,
    SUM(estimated_product_cost) AS estimated_product_cost_aed,
    SUM(sales_before_discount - estimated_product_cost)
        AS estimated_profit_before_line_adjustments_aed,
    SUM(line_total - estimated_product_cost)
        AS estimated_profit_after_line_adjustments_aed,
    SUM(sales_before_discount - estimated_product_cost) - 7603.00
        AS variance_before_line_adjustments_aed,
    SUM(line_total - estimated_product_cost) - 7603.00
        AS variance_after_line_adjustments_aed
FROM completed_lines;


-- QUERY 4 OF 5: Product-Level Estimated Profitability
/*
PURPOSE
Calculate completed-order units, sales, estimated product cost, and estimated
gross profit by product.

TABLES
commerce.sales_order
commerce.sales_order_item
commerce.product

VALIDATION
Aggregate at product level using line_total for sales and quantity *
cost_price for estimated product cost.

EXPECTED RESULT
14 products, 21 units, AED 26,870.00 sales, AED 21,510.00 estimated cost,
and AED 5,360.00 estimated gross profit across all products.
*/

SELECT
    p.product_id,
    p.productname,
    SUM(soi.quantity) AS units_sold,
    SUM(soi.line_total) AS sales_aed,
    SUM(soi.quantity * p.cost_price) AS estimated_product_cost_aed,
    SUM(soi.line_total - (soi.quantity * p.cost_price))
        AS estimated_gross_profit_aed,
    ROUND(
        100.0 * SUM(soi.line_total - (soi.quantity * p.cost_price))
        / NULLIF(SUM(soi.line_total), 0),
        2
    ) AS estimated_profit_margin_pct
FROM commerce.sales_order AS so
INNER JOIN commerce.sales_order_item AS soi
    ON so.sales_order_id = soi.sales_order_id
INNER JOIN commerce.product AS p
    ON soi.product_id = p.product_id
WHERE so.order_status = 'Completed'
GROUP BY
    p.product_id,
    p.productname
ORDER BY
    estimated_gross_profit_aed DESC,
    p.productname;


-- QUERY 5 OF 5: Line-Level Estimated Profitability Audit
/*
PURPOSE
Expose the individual completed sales lines used in the profitability
calculation so that sales, cost, profit, and margin can be reviewed at source
grain.

TABLES
commerce.sales_order
commerce.sales_order_item
commerce.product

VALIDATION
Each row represents one sales-order line. Sum line_total and estimated cost
across these rows to reconcile with Query 2 and Query 4.

EXPECTED RESULT
19 completed sales lines and 21 units, reconciling to AED 26,870.00 sales,
AED 21,510.00 estimated product cost, and AED 5,360.00 estimated gross profit.

NOTE
The line-level output is an audit detail, not a separate aggregate KPI.
*/

SELECT
    so.sales_order_id,
    so.order_date,
    soi.sales_order_item_id,
    soi.product_id,
    p.productname,
    soi.quantity,
    soi.unit_price,
    soi.discount_amount,
    soi.line_total,
    p.cost_price AS current_unit_cost_aed,
    (soi.quantity * p.cost_price) AS estimated_product_cost_aed,
    (soi.line_total - (soi.quantity * p.cost_price))
        AS estimated_gross_profit_aed,
    ROUND(
        100.0 * (soi.line_total - (soi.quantity * p.cost_price))
        / NULLIF(soi.line_total, 0),
        2
    ) AS estimated_profit_margin_pct
FROM commerce.sales_order AS so
INNER JOIN commerce.sales_order_item AS soi
    ON so.sales_order_id = soi.sales_order_id
INNER JOIN commerce.product AS p
    ON soi.product_id = p.product_id
WHERE so.order_status = 'Completed'
ORDER BY
    so.order_date,
    so.sales_order_id,
    soi.sales_order_item_id;