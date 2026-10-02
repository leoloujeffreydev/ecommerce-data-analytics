
/*
============================================================
PHASE 7 - SQL ANALYTICS
SQL 7.8 - PRODUCT CATEGORY SALES ANALYSIS
============================================================

PURPOSE:
Analyze completed sales by product category and identify
products with missing or invalid category assignments.

TABLES:
- commerce.sales_order
- commerce.sales_order_item
- commerce.product
- commerce.category

VALIDATION:
1. Summarize completed sales by category.
2. Identify products with missing or unmatched categories.

WHY THIS IS NEEDED:
To analyze category-level sales and identify gaps in
product category assignments.

EXPECTED RESULT:
- Category sales summary.
- Products with missing or invalid categories.

NOTE:
Execute one query at a time.
Both queries are independent and read-only.
============================================================
*/


/*
============================================================
QUERY 1 OF 2
CATEGORY SALES SUMMARY
============================================================

PURPOSE:
Calculate completed sales by product category.

VALIDATION:
- Completed orders only.
- Total units sold.
- Total sales.
- Number of products sold.
- Number of distinct orders.

EXPECTED RESULT:
One row per category, including Uncategorized
when applicable.
============================================================
*/

SELECT
    COALESCE(c.category_name, 'Uncategorized')
        AS category_name,
    COUNT(DISTINCT p.product_id)
        AS products_sold,
    SUM(soi.quantity)
        AS units_sold,
    SUM(soi.line_total)
        AS total_sales,
    COUNT(DISTINCT so.sales_order_id)
        AS total_orders
FROM commerce.sales_order_item AS soi
INNER JOIN commerce.sales_order AS so
    ON so.sales_order_id = soi.sales_order_id
INNER JOIN commerce.product AS p
    ON p.product_id = soi.product_id
LEFT JOIN commerce.category AS c
    ON c.category_id = p.category_id
WHERE so.order_status = 'Completed'
GROUP BY
    c.category_id,
    c.category_name
ORDER BY
    total_sales DESC,
    category_name;


/*
============================================================
QUERY 2 OF 2
PRODUCTS WITH MISSING OR INVALID CATEGORIES
============================================================

PURPOSE:
Identify products with completed sales that have
missing or unmatched category assignments.

VALIDATION:
- Include completed orders only.
- Identify missing category_id values.
- Identify unmatched category_id values.
- Calculate affected products' units and sales.

EXPECTED RESULT:
Zero or more rows showing affected products and
their completed sales.
============================================================
*/

SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    CASE
        WHEN p.category_id IS NULL
            THEN 'Missing category_id'
        ELSE 'Unmatched category_id'
    END AS category_issue,
    SUM(soi.quantity) AS units_sold,
    SUM(soi.line_total) AS total_sales,
    COUNT(DISTINCT so.sales_order_id) AS total_orders
FROM commerce.sales_order_item AS soi
INNER JOIN commerce.sales_order AS so
    ON so.sales_order_id = soi.sales_order_id
INNER JOIN commerce.product AS p
    ON p.product_id = soi.product_id
LEFT JOIN commerce.category AS c
    ON c.category_id = p.category_id
WHERE so.order_status = 'Completed'
  AND c.category_id IS NULL
GROUP BY
    p.product_id,
    p.product_name,
    p.category_id
ORDER BY
    total_sales DESC,
    p.product_id;