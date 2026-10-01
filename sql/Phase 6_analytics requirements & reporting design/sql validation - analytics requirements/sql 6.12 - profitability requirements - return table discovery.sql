
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.2 - PROFITABILITY REQUIREMENTS
SQL 6.12 - RETURN TABLE DISCOVERY
============================================================

PURPOSE:
Identify tables in the commerce schema whose names
contain the word 'return'.

QUERY 1:
List matching table names and their table types.

VALIDATION:
- Search for tables with 'return' in their names.
- Confirm whether a return-related table exists.
- Identify the exact table name for further validation.

WHY THIS IS NEEDED:
The previous query returned zero records from
information_schema.columns for sales_return.
We must verify the actual table name before
inspecting its columns or data.

EXPECTED RESULT:
A list of matching table names, if any.

NOTE:
This is a read-only query. It does not modify data.
============================================================
*/

SELECT
    table_name,
    table_type
FROM information_schema.tables
WHERE table_schema = 'commerce'
  AND table_name ILIKE '%return%'
ORDER BY table_name;