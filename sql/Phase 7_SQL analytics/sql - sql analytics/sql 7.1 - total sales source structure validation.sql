
/*
============================================================
PHASE 7 - SQL ANALYTICS
SQL 7.1 - TOTAL SALES SOURCE STRUCTURE VALIDATION
============================================================

PURPOSE:
Inspect the actual structure of the two sales tables
in the commerce schema for Total Sales validation.

TABLES:
1. sales_order
2. sales_order_item

VALIDATION:
- Identify available columns.
- Check each column's data type.
- Check whether NULL values are allowed.
- Identify potential monetary source fields.
- Identify potential order status and line amount fields.

WHY THIS IS NEEDED:
We need to confirm the actual source fields and their
data types before defining Total Sales.

The structure will help determine whether Total Sales
should use an order-level amount or the sum of line totals,
and how completed orders can be identified.

EXPECTED RESULT:
One row per column, showing its table, position,
name, data type and nullability.

NOTE:
This is a read-only query. It does not modify data.
It does not yet calculate Total Sales or assume
which monetary field is correct.
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
      'sales_order',
      'sales_order_item'
  )
ORDER BY
    table_name,
    ordinal_position;