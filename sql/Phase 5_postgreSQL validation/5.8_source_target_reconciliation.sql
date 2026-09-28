/* LJ Dev Commerce | Phase 5.8: Source-to-Target Reconciliation
Objective: Capture target-side counts and PK columns to support comparison
with approved database-ready source datasets.
Important: SQL cannot compare local CSVs unless source data is available to
PostgreSQL (e.g., approved staging load) or source results are supplied.
This script does not claim field-level reconciliation or invent source counts. */
-- 5.8.1 Exact target row counts
SELECT 'category' AS table_name, COUNT(*) AS target_row_count FROM commerce.category
UNION ALL SELECT 'customer', COUNT(*) FROM commerce.customer
UNION ALL SELECT 'inventory', COUNT(*) FROM commerce.inventory
UNION ALL SELECT 'inventory_movement', COUNT(*) FROM commerce.inventory_movement
UNION ALL SELECT 'marketing_campaign', COUNT(*) FROM commerce.marketing_campaign
UNION ALL SELECT 'payment', COUNT(*) FROM commerce.payment
UNION ALL SELECT 'product', COUNT(*) FROM commerce.product
UNION ALL SELECT 'return', COUNT(*) FROM commerce.return
UNION ALL SELECT 'sales_order', COUNT(*) FROM commerce.sales_order
UNION ALL SELECT 'sales_order_item', COUNT(*) FROM commerce.sales_order_item
UNION ALL SELECT 'shipment', COUNT(*) FROM commerce.shipment
UNION ALL SELECT 'supplier', COUNT(*) FROM commerce.supplier
UNION ALL SELECT 'warehouse', COUNT(*) FROM commerce.warehouse
ORDER BY table_name;
-- 5.8.2 Target primary-key columns
SELECT tc.table_name,kcu.column_name AS primary_key_column,kcu.ordinal_position
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
 ON kcu.constraint_catalog=tc.constraint_catalog
AND kcu.constraint_schema=tc.constraint_schema
AND kcu.constraint_name=tc.constraint_name
AND kcu.table_schema=tc.table_schema AND kcu.table_name=tc.table_name
WHERE tc.table_schema='commerce' AND tc.constraint_type='PRIMARY KEY'
ORDER BY tc.table_name,kcu.ordinal_position;
