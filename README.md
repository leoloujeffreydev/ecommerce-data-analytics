# 🛒 E-Commerce Data Analytics Platform

### Enterprise-style analytics engineering & data analytics portfolio project

> 🚧 **Project Status: In Progress**

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

> **ETL implementation status:** The standardized ETL workflow has now been completed across the project's current datasets. Inventory Movement is retained with a documented PostgreSQL load dependency exception rather than bypassing referential integrity.

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
| Inventory Movement | ⚠️ | ⛔ | ⚠️ | ETL completed; PostgreSQL load blocked by documented dependency exception |

> **Current focus:** completing PostgreSQL-wide validation and finalizing the analytics layer before moving into SQL analytics and Power BI.

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
- ETL workflow standardization
- Multiple-dataset ETL framework
- Customer ETL
- Supplier ETL
- Category ETL
- Warehouse ETL
- Marketing Campaign ETL
- Product ETL
- Sales Order ETL
- Sales Order Item ETL
- Payment ETL
- Shipment ETL
- Return ETL
- Inventory ETL
- Inventory Movement ETL
- PostgreSQL loading for validated datasets
- Database validation
- Source-to-database reconciliation
- GitHub repository setup

### ⚠️ Documented Data / Database Exception

- Inventory Movement record **INM026** references InventoryRecordID **IN020**, which is not present in the completed Inventory dataset.
- The Inventory Movement PostgreSQL load was therefore intentionally blocked by the enforced foreign key constraint.
- The source, clean CSV, and database-ready Inventory Movement dataset retain all **26 records**; no source record was deleted, reassigned, or modified to bypass the dependency.
- The unresolved relationship remains documented for later review.

### 🔄 In Progress

- PostgreSQL-wide database validation
- SQL analytics layer
- Analytical SQL queries
- Power BI data model
- Executive dashboard

---

## 🔎 Current Next Phase

The ETL implementation is complete for the current project scope. The next stage is to validate the PostgreSQL platform as a whole before building the analytics layer.

Planned next steps:

1. PostgreSQL-wide validation
2. Cross-table referential integrity and reconciliation
3. SQL analytics layer
4. Power BI data model
5. Executive dashboard
6. Final portfolio documentation

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

The final goal is to deliver a complete analytical workflow from **raw operational data to business intelligence reporting**.

---

## 👤 Author

### Leolou Jeffrey C. Sanchez

**Data Analyst | IT Professional**

Bachelor of Science in Information Technology

📍 Dubai, UAE

[GitHub — leoloujeffreydev](https://github.com/leoloujeffreydev)

---

⭐ **This repository is actively being developed as part of my data analytics portfolio.**
