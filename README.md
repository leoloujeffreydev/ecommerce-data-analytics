# 🛒 E-Commerce Data Analytics Platform

### Enterprise-style analytics engineering & data analytics portfolio project

> 🚧 **Project Status: In Progress — Phases 1–7 completed; Phase 8 is next**

**Python · Pandas · PostgreSQL · SQL · Jupyter · Power BI · Git/GitHub**

---

## 📌 Project Overview

This is an end-to-end e-commerce data analytics and data engineering portfolio project designed to demonstrate practical work across the data lifecycle.

The project simulates a **UAE-based electronics e-commerce business** operating across multiple sales channels and operational systems.

The platform is being developed from the ground up:

**Source Data → Data Quality → Python ETL → PostgreSQL → SQL Analytics → Power BI**

All datasets in this repository are **simulated portfolio data** and do not represent confidential or proprietary company information.

---

## 🎯 Business Objective

The objective is to build a reliable analytical foundation that transforms operational data from multiple business systems into validated, structured, analysis-ready data.

The project addresses:

- Multiple source systems
- Different data structures and formats
- Data quality
- Source-to-target mapping
- Relational data modeling
- Referential integrity
- ETL validation
- Database reconciliation
- Business-oriented analytics

---

## 🏗️ Project Architecture

```text
┌─────────────────────────────────────────────────────────────┐
│                     SOURCE SYSTEMS                          │
├─────────────────────────────────────────────────────────────┤
│ CRM │ ERP │ Product Catalog │ Inventory │ Marketing         │
│ Shopify │ Amazon UAE │ Noon │ Zoho Books │ Courier Systems │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                 PYTHON / PANDAS ETL                         │
│                                                             │
│ Extract → Profile → Analyze → Transform → Validate          │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                  CLEAN / DB-READY DATA                      │
│                                                             │
│ Mapping → Datatype Validation → Key Validation              │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                     POSTGRESQL                              │
│                                                             │
│ Relational Model │ PK/FK │ Integrity │ Reconciliation       │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                    SQL ANALYTICS                            │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                     POWER BI                                │
│                                                             │
│ Data Model → Measures → Executive Dashboard                 │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔄 Standardized ETL Workflow

Each dataset follows a controlled ETL lifecycle.

### 1. Extract & Analyze
- Load raw source dataset
- Inspect structure and datatypes
- Profile data quality
- Identify issues
- Perform independent analyst review
- Document transformation decisions

### 2. Transform
- Create clean DataFrame
- Apply only approved transformations
- Preserve valid source values
- Maintain dataset lineage

### 3. Validate
- Validate transformations
- Validate data preservation
- Verify row and column structure
- Verify business rules

### 4. Clean CSV
- Export validated clean dataset
- Read the exported CSV back
- Verify preservation

### 5. Database Ready
- Define source-to-target mapping
- Build database-ready dataset from the exported CSV
- Validate target-compatible datatypes
- Validate required fields
- Validate keys and relationships

### 6. PostgreSQL
- Connect to PostgreSQL
- Create or verify target table
- Validate keys and dependencies
- Insert records
- Validate row counts
- Retrieve loaded records
- Reconcile source against database
- Perform database integrity validation

> **ETL implementation status:** The standardized ETL workflow is complete for the current datasets. Inventory Movement retains a documented PostgreSQL load dependency exception; referential integrity was not bypassed.

---

## 📊 ETL Progress

| Dataset | ETL | PostgreSQL | Validation | Status |
|---|---|---|---|---|
| Customer | ✅ | ✅ | ✅ | Completed |
| Supplier | ✅ | ✅ | ✅ | Completed |
| Category | ✅ | ✅ | ✅ | Completed |
| Warehouse | ✅ | ✅ | ✅ | Completed |
| Marketing Campaign | ✅ | ✅ | ✅ | Completed |
| Product | ✅ | ✅ | ✅ | Completed |
| Sales Order | ✅ | ✅ | ✅ | Completed |
| Sales Order Item | ✅ | ✅ | ✅ | Completed |
| Payment | ✅ | ✅ | ✅ | Completed |
| Shipment | ✅ | ✅ | ✅ | Completed |
| Return | ✅ | ✅ | ✅ | Completed |
| Inventory | ✅ | ✅ | ✅ | Completed |
| Inventory Movement | ✅ | ⛔ | ⚠️ | ETL completed; PostgreSQL load intentionally blocked by documented dependency exception |

> **Current status:** dataset ETL, PostgreSQL-wide validation, analytics requirements and reporting design, and Phase 7 SQL analytics are complete. The Inventory Movement load exception remains documented. Phase 8, Power BI Setup and Data Model, is next.

---

## 🧩 Simulated Source Systems

| Source System | Business Area |
|---|---|
| CRM | Customer Management |
| Procurement / ERP | Suppliers & Procurement |
| Product Catalog | Products & Categories |
| Zoho Inventory | Warehousing & Inventory |
| Marketing | Campaign Management |
| Shopify | E-Commerce Orders |
| Amazon UAE | Marketplace Orders |
| Noon | Marketplace Orders |
| Zoho Books | Customer Payments |
| Courier Systems | Shipments |
| Returns System | Customer Returns |

---

## 🧪 Data Quality & Validation

Data quality is treated as a core part of the ETL process.

Before transformation, each dataset is inspected for:

- Missing values
- Duplicate records
- Identifier uniqueness
- Invalid datatypes
- Date and timestamp validity
- Numeric validity
- Whitespace issues
- Business-rule violations
- Referential integrity
- Required-field compliance

### Validation Philosophy

**Inspect → Identify → Analyze → Decide → Transform → Validate → Load → Reconcile**

Transformations are based on documented findings and approved decisions rather than assumptions.

---

## 🗄️ PostgreSQL Data Platform

The PostgreSQL layer provides the relational database foundation for the project.

The database design incorporates:

- Primary keys
- Foreign keys
- Required fields
- Datatype controls
- Parent-child relationships
- Referential integrity
- Source-to-target mappings
- Database integrity validation

### Source → Database Reconciliation

After loading, the ETL process reconciles the database against the database-ready source dataset.

Validation includes:

- Row counts
- Column structure
- Record identifiers
- Field values
- Required fields
- Key uniqueness
- Referential integrity
- Business-rule validation

---

## 📈 SQL Analytics — Phase 7 Results

Phase 7 SQL analytics is complete. The following results were validated against the current simulated dataset. Monetary values are in AED.

| Metric | Validated Result |
|---|---:|
| Completed orders | 15 |
| Completed sales | AED 26,870.00 |
| Average order value | AED 1,791.33 |
| Sales lines | 19 |
| Units sold | 21 |
| Products represented in sales | 14 |
| Customers with completed purchases | 11 |
| Inventory records reconciled | 19 |
| Inventory records at or below reorder level | 3 |
| Estimated product cost | AED 21,510 |
| Estimated gross profit | AED 5,360 |
| Estimated gross margin | 19.95% |

### Interpretation and Reconciliation Notes

- Gross profit and gross margin are estimates based on available product-cost data.
- All observed monthly sales fall in July 2026; the dataset does not support a meaningful month-over-month comparison.
- The Completion Rate denominator and sales-channel definition remain unverified and are not presented as validated KPIs.
- Refunds remain separate from sales until net-sales treatment is defined.
- Estimated gross profit of AED 5,360 differs from a previous estimated benchmark of AED 7,603 by AED 2,243. The difference remains unexplained; no adjustment was made.
- Payment `PAY008` associated with order `SO007` has a documented AED 179 difference between the Zoho payment amount (AED 3,078) and Shopify order total (AED 3,257). No authoritative allocation or receipt was available to resolve it.
- Available stock is defined as current stock less reserved stock. Low stock is defined as available stock at or below the reorder level.

### Inventory Movement Exception

- The source and database-ready datasets contain 26 prepared Inventory Movement records.
- The PostgreSQL table contains 0 loaded rows because `INM026` references inventory record `IN020`, which is absent from the completed Inventory dataset.
- The foreign-key constraint was not bypassed. No source record was deleted, reassigned, or altered to force a load.
- This remains a documented dependency exception, not evidence that no real-world inventory movements occurred.

---

## 📁 Repository Structure

```text
ecommerce-data-analytics/
│
├── data/
│   ├── source datasets
│   ├── clean datasets
│   ├── consolidated datasets
│   └── metadata
│
├── documentation/
│   ├── business discovery
│   ├── business analysis
│   ├── data architecture
│   ├── database design
│   └── ETL foundation
│
├── notebooks/
│   ├── ETL notebooks
│   ├── bakup/
│   └── tests/
│
├── profiler/
│   ├── data profiler
│   └── tests
│
├── sql/
│   └── PostgreSQL scripts
│
├── z pre ETL data inspection findings/
│   └── dataset-specific findings
│
├── .gitignore
└── README.md
```

---

## 📚 Documentation

The repository contains documentation covering:

- Business discovery
- Business analysis
- Data architecture
- Enterprise database design
- ETL architecture
- Multiple-dataset ETL workflow
- Pre-ETL inspection
- Transformation decisions
- Source-to-target mapping
- Dataset relationships
- ETL load order

---

## 🧰 Technology Stack

### Data Processing
- Python
- Pandas
- NumPy

### Data Engineering
- Jupyter Notebook
- Python ETL
- Data profiling
- Data validation
- Source-to-target mapping

### Database
- PostgreSQL
- SQL
- Relational data modeling
- Primary / foreign keys
- Referential integrity

### Analytics
- Power BI
- DAX
- Power Query
- SQL analytics

### Development
- Git
- GitHub
- VS Code / Jupyter
- AI-assisted development

---

## 🤖 AI-Assisted Development

AI tools are used as part of the development workflow to accelerate:

- Code generation
- ETL notebook development
- Debugging
- Data-quality analysis
- Documentation
- SQL development
- Problem solving

Generated solutions are not treated as automatically correct.

The development process follows:

**AI Assistance → Human Review → Execution → Validation → Debugging → Integration**

The project owner personally runs and validates generated code, reviews transformation decisions, investigates errors, verifies database results, and integrates the final implementation into the project.

---

## 🚧 Current Project Status

### ✅ Completed

- Business discovery
- Business analysis
- Data architecture
- Enterprise database design
- Standardized Python / Pandas ETL for the current datasets
- PostgreSQL implementation and loading for eligible datasets
- PostgreSQL-wide validation, Sections **5.1–5.10**
- Database structure, primary-key, foreign-key, and referential-integrity checks
- Source-to-target reconciliation review
- Phase 6 — Analytics Requirements & Reporting Design
- Phase 7 — SQL analytics
- Phase 7 validation results and documented reconciliation findings
- Project roadmap and completion plan
- GitHub synchronization of the Phase 7 work (commit `95a94a6`)

### ⚠️ Documented Data / Database Exceptions

- Inventory Movement record **INM026** references InventoryRecordID **IN020**, which is not present in the completed Inventory dataset.
- The Inventory Movement PostgreSQL load was intentionally blocked by the enforced foreign-key constraint.
- All **26 records** remain in the source, clean CSV, and database-ready dataset. No record was deleted, reassigned, or altered to bypass the dependency.
- PostgreSQL-wide validation is complete, but the readiness assessment requires manual review; this is not an unconditional readiness sign-off.
- Estimated gross profit is AED 5,360 compared with a previous estimated benchmark of AED 7,603. The AED 2,243 difference remains unexplained.
- Payment `PAY008` associated with order `SO007` has a documented AED 179 difference between the Zoho payment amount and Shopify order total. It remains unresolved.

### 🔄 Next: Phase 8 — Power BI Setup and Data Model

Phase 8 is the next phase. It will establish the Power BI connection and data model, with relationships and measures validated against the completed Phase 7 SQL results.

The remaining planned work is:

1. Phase 8: Power BI setup and data model
2. Phase 9: Dashboard development
3. Phase 10: Final validation and portfolio documentation

---

## 🔎 Current Next Phase

**Phases 1–7 are complete.** Phase 7 SQL analytics has been validated and documented. The Inventory Movement dependency exception and the identified reconciliation differences remain visible and unresolved.

The next step is **Phase 8 — Power BI Setup and Data Model**. Dashboard development and final portfolio validation follow in Phases 9 and 10.

---

## 🗺️ Project Roadmap

```text
Business Discovery
       ↓
Business Analysis
       ↓
Data Architecture
       ↓
Enterprise Database Design
       ↓
Python / Pandas ETL
       ↓
PostgreSQL
       ↓
SQL Analytics
       ↓
Power BI Data Model
       ↓
Executive Dashboard
       ↓
Final Portfolio Project
```

---

## 💼 Portfolio Objective

This project demonstrates practical work across both **data analytics and data engineering workflows**.

Key areas demonstrated:

- Business process understanding
- Data architecture
- Data modeling
- Data quality
- Python / Pandas
- ETL development
- PostgreSQL
- SQL
- Data validation
- Data reconciliation
- Business intelligence
- Git / GitHub
- AI-assisted development

The goal is to deliver a complete analytical workflow from **raw operational data to business intelligence reporting**. Power BI modeling, dashboard development, and final portfolio validation remain planned work.

---

## 👤 Author

### Leolou Jeffrey C. Sanchez

**Data Analyst | IT Professional**

Bachelor of Science in Information Technology

📍 Dubai, UAE

[GitHub — leoloujeffreydev](https://github.com/leoloujeffreydev)

---

⭐ **This repository is actively being developed as part of my data analytics portfolio.**
