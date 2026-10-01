
/*
============================================================
PHASE 6 - ANALYTICS REQUIREMENTS
SECTION 6.2 - PROFITABILITY REQUIREMENTS
SQL 6.13 - RETURN DATA VALIDATION
============================================================

PURPOSE:
Validate the return records in commerce."return".

QUERY 1:
Summarize return records by return status.

VALIDATION:
- Count returns per status.
- Calculate total refund amounts per status.
- Count missing return dates.
- Count missing return quantities.
- Count missing refund amounts.

WHY THIS IS NEEDED:
Return and refund information may affect net sales
and profitability. We need to understand the actual
records and identify missing values before defining
return-related KPIs.

EXPECTED RESULT:
One row per return status, showing return counts,
refund totals and missing-value counts.

IMPORTANT:
A NULL refund amount is not automatically zero.
Return statuses must be reviewed before deciding
which refunds qualify for analysis.

NOTE:
This is a read-only query. It does not modify data.
============================================================
*/

SELECT
    return_status,
    COUNT(*) AS return_count,
    SUM(refund_amount) AS total_refund_amount,
    COUNT(*) FILTER (
        WHERE return_date IS NULL
    ) AS missing_return_dates,
    COUNT(*) FILTER (
        WHERE return_quantity IS NULL
    ) AS missing_return_quantities,
    COUNT(*) FILTER (
        WHERE refund_amount IS NULL
    ) AS missing_refund_amounts
FROM commerce."return"
GROUP BY return_status
ORDER BY return_status;