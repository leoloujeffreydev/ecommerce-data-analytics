
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.2 - PROFITABILITY REQUIREMENTS
SQL 6.11 - RETURN TABLE STRUCTURE VALIDATION
============================================================

PURPOSE:
Inspect the actual structure of the return table
in the commerce schema.

QUERY 1:
List all columns in commerce."return", including
their data types and nullability.

VALIDATION:
- Identify return status and date fields.
- Identify sales order and order item references.
- Identify returned quantity and refund amount fields.
- Check which fields allow NULL values.

WHY THIS IS NEEDED:
Returns and refunds may affect net sales and
profitability calculations. We need to confirm
the available fields before defining adjustment rules.

EXPECTED RESULT:
One row per column, showing its table name,
column position, column name, data type and nullability.

NOTE:
The table name is enclosed in double quotes because
RETURN is a PostgreSQL keyword.

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
  AND table_name = 'return'
ORDER BY ordinal_position;