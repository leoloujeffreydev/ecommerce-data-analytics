
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.7 - DATA SOURCE AND TABLE MAPPING
SQL 6.31 - REFERENCED DIMENSION SCHEMA VERIFICATION
============================================================

PURPOSE:
Inspect the schemas of the additional dimension
tables referenced by the KPI source relationships.

QUERY 1:
Review columns and data types for marketing_campaign,
warehouse and supplier.

VALIDATION:
- Confirm the referenced tables exist.
- Identify columns available for reporting.
- Check data types and nullability.

WHY THIS IS NEEDED:
Campaign and warehouse analysis requires verified
dimension attributes. Supplier mapping should also
reflect the actual implemented schema.

EXPECTED RESULT:
One row per column in each selected table.

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
      'marketing_campaign',
      'warehouse',
      'supplier'
  )
ORDER BY
    table_name,
    ordinal_position;