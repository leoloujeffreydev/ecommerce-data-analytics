
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.5 - INVENTORY PERFORMANCE REQUIREMENTS
SQL 6.26 - INVENTORY MOVEMENT COVERAGE VALIDATION
============================================================

PURPOSE:
Validate the actual inventory movement data
available for reporting.

QUERY 1:
Summarize loaded inventory movements by movement
type and check their inventory relationships.

VALIDATION:
- Count loaded movement records.
- Identify movement types and quantities.
- Check whether movement records link to inventory.
- Identify the available movement date range.

WHY THIS IS NEEDED:
Inventory movement reporting and historical stock
trends require actual loaded movement records.
Prepared but unloaded data cannot be used as
evidence of historical inventory activity.

EXPECTED RESULT:
One row per movement type, with record counts,
quantity totals, date range and relationship checks.
If no records are loaded, the query returns no rows.

IMPORTANT:
This query only inspects loaded records. It does
not load, alter or repair inventory movements.

This is a read-only query.
============================================================
*/

SELECT
    im.movement_type,
    COUNT(*) AS movement_count,
    SUM(im.quantity_change) AS net_quantity_change,
    MIN(im.movement_date) AS first_movement_date,
    MAX(im.movement_date) AS last_movement_date,
    COUNT(*) FILTER (
        WHERE i.inventory_id IS NOT NULL
    ) AS matched_inventory_count,
    COUNT(*) FILTER (
        WHERE i.inventory_id IS NULL
    ) AS unmatched_inventory_count
FROM commerce.inventory_movement AS im
LEFT JOIN commerce.inventory AS i
    ON im.inventory_id = i.inventory_id
GROUP BY
    im.movement_type
ORDER BY
    im.movement_type;