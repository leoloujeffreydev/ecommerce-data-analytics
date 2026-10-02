
/*
============================================================
PHASE 7 - SQL ANALYTICS
SQL 7.10 - INVENTORY SOURCE VALIDATION
QUERY 1 OF 1
============================================================

PURPOSE:
Inspect inventory-related tables and columns.

TABLES:
Information schema metadata.

VALIDATION:
- Identify inventory-related tables.
- Inspect column names, data types, and nullability.
- Locate current stock, reserved stock, and reorder
  fields, if present.

WHY THIS IS NEEDED:
Inventory calculations must use the actual database
structure without assuming unverified column names.

EXPECTED RESULT:
A list of inventory-related tables and their columns.

NOTE:
Read-only metadata query.
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
      table_name ILIKE '%inventory%'
      OR column_name ILIKE '%stock%'
      OR column_name ILIKE '%reorder%'
      OR column_name ILIKE '%reserved%'
  )
ORDER BY
    table_name,
    ordinal_position;