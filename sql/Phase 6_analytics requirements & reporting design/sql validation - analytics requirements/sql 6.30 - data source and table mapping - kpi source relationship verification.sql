
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.7 - DATA SOURCE AND TABLE MAPPING
SQL 6.30 - KPI SOURCE RELATIONSHIP VERIFICATION
============================================================

PURPOSE:
Verify the declared foreign-key relationships
needed for KPI source mapping.

QUERY 1:
List foreign keys for the main KPI source tables.

VALIDATION:
- Identify source and referenced tables.
- Identify the linked columns.
- Confirm relationships for KPI joins.
- Identify any required relationships not enforced
  by a declared foreign key.

WHY THIS IS NEEDED:
KPI mappings must use actual database relationships
to avoid incorrect joins and double counting.

EXPECTED RESULT:
One row per declared foreign key for the
selected source tables.

IMPORTANT:
This query lists declared constraints only.
It does not validate data completeness or prove
that every possible analytical join is correct.

This is a read-only query.
============================================================
*/

SELECT
    tc.table_name AS source_table,
    kcu.column_name AS source_column,
    ccu.table_name AS referenced_table,
    ccu.column_name AS referenced_column,
    tc.constraint_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
   AND tc.constraint_schema = kcu.constraint_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON tc.constraint_name = ccu.constraint_name
   AND tc.constraint_schema = ccu.constraint_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.constraint_schema = 'commerce'
  AND tc.table_name IN (
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
    tc.table_name,
    tc.constraint_name,
    kcu.ordinal_position;