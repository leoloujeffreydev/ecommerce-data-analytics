
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.3 - PRODUCT PERFORMANCE REQUIREMENTS
SQL 6.20 - PRODUCT RETURN PERFORMANCE VALIDATION
============================================================

PURPOSE:
Validate return performance at the product level.

QUERY 1:
Summarize return counts, quantities and refund
amounts by product and return status.

VALIDATION:
- Identify products with recorded returns.
- Review return quantities and refund amounts.
- Keep return statuses separate.
- Confirm that product-level results reconcile
  with the return records.

WHY THIS IS NEEDED:
Product performance analysis may include return
metrics. Returns must be linked to the original
product and kept separate by status to avoid
misrepresenting completed returns.

EXPECTED RESULT:
One row per product and return status for products
with recorded returns.

IMPORTANT:
Do not treat pending returns as completed.
Null return quantities and refund amounts must
remain visible in the validation counts.

This is a read-only query.
============================================================
*/

SELECT
    p.product_id,
    p.product_name,
    r.return_status,
    COUNT(r.return_id) AS return_count,
    COUNT(r.return_quantity) AS returns_with_quantity,
    COALESCE(SUM(r.return_quantity), 0)
        AS total_return_quantity,
    COUNT(r.refund_amount) AS returns_with_refund,
    COALESCE(SUM(r.refund_amount), 0)
        AS total_refund_amount
FROM commerce."return" AS r
JOIN commerce.sales_order_item AS soi
    ON r.sales_order_item_id = soi.sales_order_item_id
JOIN commerce.product AS p
    ON soi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    r.return_status
ORDER BY
    p.product_name,
    r.return_status;