/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SQL 6.1 - SALES TABLE STRUCTURE VALIDATION
============================================================

PURPOSE:
Inspect the actual structure of the two sales tables
in the commerce schema.

TABLES:
1. sales_order
2. sales_order_item

VALIDATION:
- Identify available columns.
- Check each column's data type.
- Check whether NULL values are allowed.

WHY THIS IS NEEDED:
These tables are the main sources for sales analysis.
We need to confirm the actual fields before defining
Total Sales, Total Orders, AOV and other KPIs.

EXPECTED RESULT:
One row per column, showing its table, position,
name, data type and nullability.

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
      'sales_order',
      'sales_order_item'
  )
ORDER BY
    table_name,
    ordinal_position;