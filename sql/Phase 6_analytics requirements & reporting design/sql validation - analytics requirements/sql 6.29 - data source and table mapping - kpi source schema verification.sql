
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.7 - DATA SOURCE AND TABLE MAPPING
SQL 6.29 - KPI SOURCE SCHEMA VERIFICATION
============================================================

PURPOSE:
Verify the actual source columns and data types
needed for the Phase 6 KPI mappings.

QUERY 1:
Inspect the schemas of the main KPI source tables.

VALIDATION:
- Confirm the relevant tables exist.
- Review column names and data types.
- Check nullability.
- Identify fields required for KPI calculations.

WHY THIS IS NEEDED:
The mapping workbook must reflect the implemented
PostgreSQL schema, not assumed or planned fields.

EXPECTED RESULT:
One row per column from the selected source tables,
including the table name, column name, data type
and nullability.

This is a read-only query.
============================================================
*/

SELECT
    table_name,
    ordinal_position,
    column_name,
    data_type,
    numeric_precision,
    numeric_scale,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'commerce'
  AND table_name IN (
      'sales_order',
      'sales_order_item',
      'product',
      'category',
      'customer',
      'return',
      'inventory',
      'inventory_movement'
  )
ORDER BY
    table_name,
    ordinal_position;