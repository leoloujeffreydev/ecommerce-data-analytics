
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.4 - CUSTOMER & SALES CHANNEL REQUIREMENTS
SQL 6.21 - CUSTOMER AND CHANNEL SOURCE VALIDATION
============================================================

PURPOSE:
Inspect the database fields required for customer
and sales channel analysis.

QUERY 1:
Retrieve the implemented columns of the customer,
sales_order and sales_order_item tables.

VALIDATION:
- Identify customer identification fields.
- Confirm the customer-to-order relationship.
- Identify available customer attributes.
- Check whether a sales channel field exists.
- Confirm fields needed for customer sales analysis.

WHY THIS IS NEEDED:
Customer and channel requirements must be based
on the actual database schema. We must not assume
that channel or customer attributes exist.

EXPECTED RESULT:
A list of available columns, data types and
nullability for the three source tables.

IMPORTANT:
Do not infer missing customer attributes or
sales channel fields.

This is a read-only query.
============================================================
*/

SELECT
    table_name,
    ordinal_position,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'commerce'
  AND table_name IN (
      'customer',
      'sales_order',
      'sales_order_item'
  )
ORDER BY
    table_name,
    ordinal_position;