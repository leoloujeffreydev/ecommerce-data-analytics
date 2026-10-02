
/*
============================================================
PHASE 7 - SQL ANALYTICS
SQL 7.9 - CUSTOMER SALES ANALYSIS
============================================================

PURPOSE:
Validate customer source structures and analyze
completed sales by customer.

TABLES:
- commerce.sales_order
- Customer-related tables (to be identified)

VALIDATION:
1. Identify customer-related tables and columns.
2. Analyze completed sales by customer_id.

WHY THIS IS NEEDED:
Customer-level sales analysis helps measure customer
contribution to overall sales and identify purchasing
patterns.

EXPECTED RESULT:
- Verified customer source structure.
- Customer-level sales, order counts, and average
  order values.
- First and most recent completed order dates.

NOTE:
Execute one query at a time.
Both queries are read-only.
Sales are measured using sales_order.order_total.
Only completed orders are included.
Sales channel is not assumed or inferred.
============================================================
*/


/*
============================================================
QUERY 1 OF 2
CUSTOMER SOURCE STRUCTURE VALIDATION
============================================================

PURPOSE:
Identify customer-related tables and columns.

TABLES:
Information schema metadata.

VALIDATION:
- Identify customer-related tables.
- Identify customer_id and customer name columns.
- Check data types and nullability.

EXPECTED RESULT:
A list of customer-related tables and columns.

NOTE:
This is a read-only metadata query.
============================================================
*/

SELECT
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'commerce'
  AND (
      table_name ILIKE '%customer%'
      OR column_name ILIKE '%customer%'
  )
ORDER BY
    table_name,
    ordinal_position;


/*
============================================================
QUERY 2 OF 2
CUSTOMER SALES ANALYSIS
============================================================

PURPOSE:
Calculate completed sales performance by customer.

TABLES:
- commerce.sales_order

VALIDATION:
- Include completed orders only.
- Calculate total sales per customer.
- Count completed orders per customer.
- Calculate average order value.
- Identify first and latest completed order dates.

WHY THIS IS NEEDED:
To measure customer contribution to completed sales
using verified order-level monetary values.

EXPECTED RESULT:
One row per customer with completed sales,
order counts, average order value, and order dates.

NOTE:
This query uses customer_id directly and does not
assume customer name or other customer attributes.
============================================================
*/

SELECT
    customer_id,
    COUNT(*) AS total_orders,
    SUM(order_total) AS total_sales,
    ROUND(AVG(order_total), 2) AS average_order_value,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS latest_order_date
FROM commerce.sales_order
WHERE order_status = 'Completed'
GROUP BY
    customer_id
ORDER BY
    total_sales DESC,
    customer_id;