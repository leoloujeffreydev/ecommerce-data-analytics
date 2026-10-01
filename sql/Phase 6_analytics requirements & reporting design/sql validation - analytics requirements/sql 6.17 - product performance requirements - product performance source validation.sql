
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.3 - PRODUCT PERFORMANCE REQUIREMENTS
SQL 6.17 - PRODUCT PERFORMANCE SOURCE VALIDATION
============================================================

PURPOSE:
Inspect the source columns required for product
performance analysis.

QUERY 1:
Retrieve the implemented columns of the product,
sales_order_item, sales_order and return tables.

VALIDATION:
- Identify product and category fields.
- Identify sales quantity and amount fields.
- Identify product and order relationship keys.
- Identify return quantity and relationship fields.
- Review column data types and nullability.

WHY THIS IS NEEDED:
Product performance measures depend on the actual
database schema. We must confirm the available fields
before defining calculations and joins.

EXPECTED RESULT:
A list of available columns, data types and nullability
for the four source tables.

IMPORTANT:
Do not infer category fields or other relationships
that are not present in the implemented schema.

NOTE:
This is a read-only query. It does not modify data.
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
      'product',
      'sales_order_item',
      'sales_order',
      'return'
  )
ORDER BY
    table_name,
    ordinal_position;