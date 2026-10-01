
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.5 - INVENTORY PERFORMANCE REQUIREMENTS
SQL 6.25 - INVENTORY STOCK COVERAGE AND CONSISTENCY
============================================================

PURPOSE:
Validate current inventory coverage and stock values.

QUERY 1:
Summarize inventory records by product and warehouse.

VALIDATION:
- Count inventory records.
- Review current, reserved and available stock.
- Identify stock below or equal to reorder level.
- Identify negative stock values.
- Compare available stock with current stock
  minus reserved stock.
- Identify inventory records with missing products.

WHY THIS IS NEEDED:
Inventory reporting depends on reliable stock
quantities and product relationships. Stock
consistency must be reviewed before defining
inventory KPIs.

EXPECTED RESULT:
One row per product and warehouse combination,
with stock quantities and validation indicators.

IMPORTANT:
The comparison between available stock and
current stock minus reserved stock is a
consistency check, not an assumed business rule.

This query does not modify inventory data.

This is a read-only query.
============================================================
*/

SELECT
    i.inventory_id,
    i.product_id,
    p.product_name,
    i.warehouse_id,
    i.current_stock,
    i.reserved_stock,
    i.available_stock,
    i.reorder_level,
    i.inventory_status,
    CASE
        WHEN i.current_stock < 0
          OR i.reserved_stock < 0
          OR i.available_stock < 0
        THEN 'Negative stock'
        WHEN i.available_stock <= i.reorder_level
        THEN 'At or below reorder level'
        ELSE 'Above reorder level'
    END AS stock_level_check,
    CASE
        WHEN i.available_stock =
             i.current_stock - i.reserved_stock
        THEN 'Matches'
        ELSE 'Does not match'
    END AS stock_consistency_check,
    CASE
        WHEN p.product_id IS NULL
        THEN 'Missing product'
        ELSE 'Matched'
    END AS product_match
FROM commerce.inventory AS i
LEFT JOIN commerce.product AS p
    ON i.product_id = p.product_id
ORDER BY
    i.warehouse_id,
    i.product_id,
    i.inventory_id;