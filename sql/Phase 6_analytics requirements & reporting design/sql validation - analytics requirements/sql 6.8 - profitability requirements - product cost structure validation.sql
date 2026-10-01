
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.2 - PROFITABILITY REQUIREMENTS
SQL 6.8 - PRODUCT COST STRUCTURE VALIDATION
============================================================

PURPOSE:
Inspect the structure of commerce.product to identify
fields that may support profitability analysis.

QUERY 1:
List the columns, data types and nullability of the
product table.

VALIDATION:
- Identify any product cost or purchase price fields.
- Check their data types.
- Check whether they allow NULL values.
- Identify other potentially relevant price fields.

WHY THIS IS NEEDED:
Gross Profit and Profit Margin require a reliable
cost basis. We must verify the actual available
fields before defining these metrics.

EXPECTED RESULT:
One row per product table column, including its
name, data type and nullability.

NOTE:
This is a read-only query. It does not modify data.
Do not assume that a selling price is a product cost.
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
  AND table_name = 'product'
ORDER BY ordinal_position;