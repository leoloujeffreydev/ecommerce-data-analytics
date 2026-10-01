
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.5 - INVENTORY PERFORMANCE REQUIREMENTS
SQL 6.24 - INVENTORY SOURCE VALIDATION
============================================================

PURPOSE:
Inspect the available inventory source fields.

QUERY 1:
Retrieve the implemented columns of the inventory
and inventory_movement tables.

VALIDATION:
- Identify inventory record and product keys.
- Identify stock quantity fields.
- Identify movement quantity and type fields.
- Identify inventory dates and statuses.
- Confirm which fields are available for reporting.

WHY THIS IS NEEDED:
Inventory requirements must be based on the
implemented schema and actual data availability.
We must distinguish available inventory records
from prepared but unloaded movement records.

EXPECTED RESULT:
A list of available columns, data types and
nullability for both inventory tables.

IMPORTANT:
Do not infer missing inventory records or
assume that prepared movement data is loaded.

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
      'inventory',
      'inventory_movement'
  )
ORDER BY
    table_name,
    ordinal_position;