# LJ Dev Commerce — Phase 7: SQL Analytics

**Portfolio project:** Retail / e-commerce analytics
**Technology:** PostgreSQL, SQL
**Status:** Complete — analytical queries and recorded outputs reviewed and validated
**Reporting currency:** AED

## Overview

Phase 7 applies PostgreSQL to the LJ Dev Commerce dataset to answer core sales, product, customer, inventory, and profitability questions. The work emphasizes clear business definitions, appropriate aggregation grain, reconciliation to source data, and transparent treatment of data limitations.

The analysis uses completed orders as the eligible basis for Total Sales, Total Orders, Average Order Value (AOV), and the profitability analysis. Order-header and order-line values are kept at their appropriate grains to avoid double counting.

## Scope completed

The Phase 7 SQL work covered the following areas:

| Task | Analysis | Status |
|---|---|---|
| 7.1 | Total Sales Source Structure Validation | Completed |
| 7.2 | Completed Order Status Validation | Completed |
| 7.3 | Total Sales Monetary Reconciliation | Completed |
| 7.4 | Sales Overview KPI Validation | Completed |
| 7.5 | Monthly Sales Trend Validation | Completed |
| 7.6 | Product Sales Analysis | Completed |
| 7.7 | Product Category Source Validation | Completed |
| 7.8 | Product Category Sales Analysis | Completed |
| 7.9 | Customer Sales Analysis | Completed |
| 7.10 | Inventory Source Validation | Completed |
| 7.11 | Inventory Performance Analysis | Completed |
| 7.12 | Profitability Analysis | Completed |

Each task was handled through SQL analysis and review of the PostgreSQL output. The task list describes the completed scope; it is not a claim that the SQL was executed as one combined batch.

## Key validated results

### Sales overview

| Metric | Validated result |
|---|---:|
| Completed orders | 15 |
| Completed-order sales | AED 26,870.00 |
| Average Order Value | AED 1,791.33 |
| Completed-order sales lines | 19 |
| Units sold | 21 |

AOV is calculated as eligible completed-order sales divided by eligible completed orders. The completed-order sales amount reconciles to the underlying order-line totals.

### Product and category analysis

- Product sales analysis reconciled to **14 products, 21 units, and AED 26,870** in completed-order sales.
- Category sales reconciled to the same completed-order sales total.
- Product and category analysis uses eligible line-level sales values and verified product/category relationships.

### Customer analysis

- **11 distinct customers** had completed purchases.
- Their completed purchases accounted for **15 orders and AED 26,870** in sales.
- Repeat purchasers are identified using completed-order counts; customer contact details are not required for reporting.

### Inventory analysis

- The available-stock calculation was checked against `current_stock - reserved_stock` across **19 inventory records**; stored and calculated values reconciled.
- **3 product/warehouse records** were at or below their reorder level under the selected operational rule.
- Inventory results represent the current snapshot, not historical stock levels.

### Profitability analysis (SQL 7.12)

Profitability is explicitly reported as **estimated**, because it uses current product costs rather than historical costs.

| Metric | Validated result |
|---|---:|
| Eligible completed-order sales | AED 26,870.00 |
| Estimated product cost | AED 21,510.00 |
| Estimated gross profit | AED 5,360.00 |
| Estimated profit margin | 19.95% |
| Earlier benchmark | AED 7,603.00 |
| Variance from earlier benchmark | -AED 2,243.00 |

The estimated gross profit reconciles as eligible sales less estimated product cost. The estimated margin is estimated gross profit divided by eligible sales.

The earlier AED 7,603 benchmark could not be reconciled to the validated calculation. Its AED 2,243 variance is documented as unexplained; it is **not** treated as an adjustment, and no artificial adjustment was introduced to force a match.

The profitability work also reconciled sales before and after recorded line adjustments, product-level profitability, and the individual completed sales lines.

## SQL approach and validation

The work includes source-structure checks, status filtering, aggregation, joins, common table expressions, calculated fields, and reconciliation checks. Calculations preserve the distinction between order headers and order lines.

Validation focused on:
- confirming source columns and calculation fields before use;
- applying the documented completed-order eligibility rule consistently;
- reconciling sales totals across overview, product, category, customer, and profitability analyses;
- comparing stored available stock with the selected calculation;
- reviewing profitability at aggregate, product, and sales-line levels; and
- recording unresolved differences and data dependencies rather than concealing them.

## Assumptions and limitations

- **Completed orders:** used for the specified sales and profitability KPIs. Other statuses are kept separate.
- **Estimated cost:** current `product.cost_price` is used; historical cost is unavailable in this analysis. Profit and margin must remain labelled estimated, not historical or audited.
- **Discounts:** recorded line adjustments are reflected through `line_total`. Discounts must not be subtracted twice.
- **Tax, shipping, and returns:** excluded from the profitability calculation unless separately supported and approved. Refunds are not netted from sales because net-sales treatment has not been defined.
- **Sales channel:** no reliable sales-channel field was verified. `campaign_id` and source-system names are not used as substitutes.
- **Monthly trend:** all eligible completed-order sales fall in July 2026 in the reviewed dataset, so a meaningful month-over-month comparison is not yet available.
- **Inventory movement:** 26 records were prepared, but the PostgreSQL target contains 0 rows because record `INM026` references missing inventory record `IN020`. The target is not interpreted as evidence of zero real-world movement. No mapping was invented, no source record was deleted, and the foreign-key constraint was not bypassed.
- **Completion Rate:** its denominator and status rules remain undefined; it was not implemented as a validated KPI.

## Deliverables and next phase

Phase 7 SQL Analytics is complete. The next planned stage is **Phase 8 — Power BI Setup and Data Model**, followed by Phase 9 dashboard development and Phase 10 final validation and portfolio documentation.

Phase 7 completion does not imply that the Power BI model, dashboard, or final portfolio acceptance testing has already been implemented.

---

**Project:** LJ Dev Commerce
**Phase:** 7 — SQL Analytics
**Status:** Complete
**Primary database:** PostgreSQL
**Currency:** AED
