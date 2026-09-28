# Phase 5 — PostgreSQL Validation

**Project:** LJ Dev Commerce — E-commerce Data Analytics  
**Database:** `lj_dev_commerce`  
**Schema:** `commerce`  
**PostgreSQL:** 18.1  
**Validation scope:** Sections 5.1–5.10

## Purpose

This document records the PostgreSQL validation checks completed for the LJ Dev Commerce analytics project. It distinguishes database metadata and integrity checks from source-to-target reconciliation and documents the known inventory movement loading exception.

## Validation summary

| Section | Validation | Result | Notes |
|---|---|---|---|
| 5.1 | Database and table inventory | Passed | Connected to `lj_dev_commerce`; 13 base tables were found in the `commerce` schema. |
| 5.2 | Database row counts | Passed for target counts | Counts were returned for all 13 tables. `inventory_movement` contains 0 rows and is a documented dependency exception. |
| 5.3 | Table structure | Passed after Customer correction | The 13 table structures were rechecked. Customer nullability and `is_active` were aligned with the revised data dictionary. |
| 5.4 | Primary keys | Passed | 13 primary keys were found and reported as validated. |
| 5.5 | Foreign keys | Passed | 14 foreign keys were found and reported as validated. |
| 5.6 | Referential integrity | Passed for existing target rows | All 14 checked relationships reported 0 orphan rows. The empty `inventory_movement` table limits what this establishes for movement data. |
| 5.7 | Cross-table relationship checks | Passed | Foreign-key relationship and primary-key metadata checks completed. The latest no-FK-table query returned no rows. |
| 5.8 | Source-target reconciliation checks | Partially complete | Target row counts and target primary-key metadata were checked. Full source-to-target comparison of row counts, key values, and field values is not established by these checks alone. |
| 5.9 | Business rules and constraints | Passed for executed checks | Constraint validation, required-column nullability, and unvalidated-constraint checks completed. Section 5.9.3 returned an empty result. |
| 5.10 | PostgreSQL readiness metadata assessment | Metadata check complete; manual review required | 13 base tables, 13 primary keys, 14 foreign keys, and 0 unvalidated constraints. The SQL output explicitly requires manual review of Sections 5.1–5.9 and is not a complete readiness sign-off. |

## Target table row counts

The target row-count query (Section 5.2) returned the following values. Section 5.8.1 returned the same counts.

| Table | PostgreSQL rows |
|---|---:|
| `category` | 6 |
| `customer` | 15 |
| `inventory` | 19 |
| `inventory_movement` | 0 |
| `marketing_campaign` | 4 |
| `payment` | 20 |
| `product` | 15 |
| `return` | 4 |
| `sales_order` | 20 |
| `sales_order_item` | 26 |
| `shipment` | 14 |
| `supplier` | 8 |
| `warehouse` | 3 |
| **Total** | **154** |

These are PostgreSQL target counts. Their agreement between Sections 5.2 and 5.8.1 confirms consistency between those two target-count checks; it does not by itself prove source-to-target reconciliation.

## Key validation findings

- The database contains 13 base tables in the `commerce` schema.
- All 13 tables have a primary key, and all 14 declared foreign keys were reported as validated.
- Referential-integrity checks reported zero orphan rows across the 14 foreign-key relationships.
- The Customer table was corrected and revalidated against the revised data dictionary:
  - `email`, `phone`, and `address` are nullable.
  - `city`, `country`, and `is_active` are required.
  - `is_active` is Boolean.
- Section 5.9.3 returned no unvalidated constraints.
- Section 5.10 is a metadata summary only and explicitly requires manual review.

## Documented exception: `inventory_movement`

The `inventory_movement` source contains 26 records, while the PostgreSQL target table currently contains 0 records.

The load was intentionally blocked because movement record `INM026` references inventory ID `IN020`, which is absent from the completed inventory parent data (IDs `IN001`–`IN019`). The foreign-key dependency was preserved rather than bypassed.

**Handling:**
- Retain the source and clean/database-ready movement record.
- Do not invent or substitute an inventory ID.
- Do not delete `INM026` or bypass the foreign key to force the load.
- Keep the exception visible in validation and project documentation.

The zero-row result and zero-orphan result for this table do not demonstrate that its 26 source records have been loaded or reconciled. The exception remains unresolved pending a valid source-data or dependency resolution.

## Source-to-target reconciliation status

The completed SQL checks establish target row counts, target primary-key metadata, and several database integrity properties. They do **not** establish a complete source-to-target comparison for every dataset.

Before declaring full reconciliation, compare the relevant source/database-ready datasets with PostgreSQL for:
- row counts,
- primary-key values, and
- required field values / record-level consistency.

Record the evidence and outcome for each table. The `inventory_movement` discrepancy must remain an explicit exception rather than being reported as reconciled.

## Readiness conclusion

**PostgreSQL metadata and integrity checks:** completed with the results above.  
**Full source-to-target reconciliation:** not yet demonstrated by the available checks.  
**Overall readiness:** **not signed off** pending manual review and reconciliation of outstanding items, including the documented `inventory_movement` dependency exception.

This conclusion intentionally does not treat the Section 5.10 metadata result as a complete readiness sign-off.

## Validation files

The SQL validation scripts for Sections 5.1–5.10 are stored alongside this README:

- `5.1_database_table_inventory.sql`
- `5.2_database_row_counts.sql`
- `5.3_table_structure_validation.sql`
- `5.4_primary_key_validation.sql`
- `5.5_foreign_key_validation.sql`
- `5.6_referential_integrity.sql`
- `5.7_cross_table_relationship_validation.sql`
- `5.8_source_target_reconciliation.sql`
- `5.9_business_rules_integrity.sql`
- `5.10_postgresql_readiness_assessment.sql`
