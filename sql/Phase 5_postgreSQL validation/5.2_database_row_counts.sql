/* LJ Dev Commerce | Phase 5.2: Database Row Counts
Objective: Capture exact row counts for expected project tables.
A missing table causes an error; do not interpret it as zero rows.
inventory_movement may be empty due to the documented INM026 -> IN020
dependency exception. Do not alter data to force a count match. */
SELECT 'category' AS table_name, COUNT(*) AS row_count FROM commerce.category
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
