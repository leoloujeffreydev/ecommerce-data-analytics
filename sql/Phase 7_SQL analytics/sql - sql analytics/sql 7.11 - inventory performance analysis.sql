
/*
============================================================
PHASE 7 - SQL ANALYTICS
SQL 7.11 - INVENTORY PERFORMANCE ANALYSIS
============================================================

PURPOSE:
Validate available stock calculations and identify
inventory records at or below their reorder levels.

TABLES:
- commerce.inventory
- commerce.product

VALIDATION:
1. Compare stored available_stock with the agreed formula.
2. Identify inventory records at or below reorder_level.

WHY THIS IS NEEDED:
Inventory analysis must distinguish available stock from
reserved stock and identify potential replenishment needs.

EXPECTED RESULT:
- Inventory-level stock reconciliation.
- Inventory records at or below their reorder levels.

NOTE:
Execute one query at a time.
Both queries are read-only.
Available stock is defined as:
current_stock - reserved_stock.
The reorder check uses available stock.
============================================================
*/


/*
============================================================
QUERY 1 OF 2
AVAILABLE STOCK RECONCILIATION
============================================================

PURPOSE:
Compare stored available_stock with the agreed calculation.

TABLES:
- commerce.inventory
- commerce.product

VALIDATION:
- Calculate current_stock - reserved_stock.
- Compare calculated and stored available_stock.
- Identify discrepancies.

EXPECTED RESULT:
One row per inventory record, including stored and
calculated available stock and reconciliation status.
============================================================
*/

SELECT
    i.inventory_id,
    i.product_id,
    p.product_name,
    i.warehouse_id,
    i.current_stock,
    i.reserved_stock,
    i.available_stock AS stored_available_stock,
    i.current_stock - i.reserved_stock
        AS calculated_available_stock,
    i.reorder_level,
    CASE
        WHEN i.available_stock =
             i.current_stock - i.reserved_stock
            THEN 'Matched'
        ELSE 'Mismatch'
    END AS reconciliation_status
FROM commerce.inventory AS i
LEFT JOIN commerce.product AS p
    ON p.product_id = i.product_id
ORDER BY
    i.product_id,
    i.warehouse_id;


/*
============================================================
QUERY 2 OF 2
INVENTORY AT OR BELOW REORDER LEVEL
============================================================

PURPOSE:
Identify inventory records whose available stock is
at or below the defined reorder level.

TABLES:
- commerce.inventory
- commerce.product

VALIDATION:
- Calculate available stock using current_stock minus
  reserved_stock.
- Compare calculated available stock with reorder_level.
- Report the gap relative to the reorder level.

EXPECTED RESULT:
Zero or more inventory records at or below their
reorder levels, ordered by available stock ascending.

NOTE:
This identifies records for review; it does not
automatically create purchase orders.
============================================================
*/

SELECT
    i.inventory_id,
    i.product_id,
    p.product_name,
    i.warehouse_id,
    i.current_stock,
    i.reserved_stock,
    i.current_stock - i.reserved_stock
        AS available_stock,
    i.reorder_level,
    i.reorder_level -
        (i.current_stock - i.reserved_stock)
        AS reorder_level_gap,
    i.inventory_status
FROM commerce.inventory AS i
LEFT JOIN commerce.product AS p
    ON p.product_id = i.product_id
WHERE i.current_stock - i.reserved_stock
      <= i.reorder_level
ORDER BY
    available_stock ASC,
    i.product_id,
    i.warehouse_id;