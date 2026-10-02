
/*
============================================================
PHASE 7 - SQL ANALYTICS
SQL 7.7 - PRODUCT CATEGORY SOURCE VALIDATION
============================================================

PURPOSE:
Validate the product and category source structures
before performing category sales analysis.

TABLES:
- commerce.product
- Category-related tables (to be identified)

VALIDATION:
1. Identify product table columns and data types.
2. Identify category table columns and data types.
3. Verify the category relationship before joining.

WHY THIS IS NEEDED:
The product category relationship must be verified
before calculating category-level sales.

EXPECTED RESULT:
- Verified product table structure.
- Identified category table and its columns.
- Verified category relationship, if available.

NOTE:
Execute one query at a time.
Review each result before proceeding.
Both queries are read-only metadata queries.
============================================================
*/


/*
============================================================
QUERY 1 OF 2
PRODUCT TABLE STRUCTURE VALIDATION
============================================================

PURPOSE:
Identify product-related tables and columns.

TABLES:
Information schema metadata.

VALIDATION:
- Identify product table columns.
- Confirm product_id and category_id.
- Check data types and nullability.

EXPECTED RESULT:
Product-related tables and their columns.
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
      table_name ILIKE '%product%'
      OR column_name ILIKE '%product%'
  )
ORDER BY
    table_name,
    ordinal_position;


/*
============================================================
QUERY 2 OF 2
CATEGORY TABLE STRUCTURE VALIDATION
============================================================

PURPOSE:
Identify category-related tables and columns.

TABLES:
Information schema metadata.

VALIDATION:
- Identify category-related tables.
- Identify category ID and category name columns.
- Inspect data types and nullability.

WHY THIS IS NEEDED:
The category table must be verified before joining
it to the product table for category sales analysis.

EXPECTED RESULT:
A list of category-related tables and their columns.

NOTE:
Execute only after validating Query 1.
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
      table_name ILIKE '%categor%'
      OR column_name ILIKE '%categor%'
  )
ORDER BY
    table_name,
    ordinal_position;