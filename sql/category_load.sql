-- ============================================================
-- LJ Dev Commerce
-- Category PostgreSQL Load
-- ============================================================
--
-- Purpose:
--   Load the validated clean Category dataset into PostgreSQL.
--
-- Source:
--   notebooks/product_catalog_categories_clean.csv
--
-- ETL flow:
--   Raw Category
--        ↓
--   Profile
--        ↓
--   Transform / Clean
--        ↓
--   Validate
--        ↓
--   Clean Category CSV
--        ↓
--   PostgreSQL
--
-- Important:
--   The raw Category dataset is NOT loaded directly.
--   Only the validated clean dataset is used.
--
-- Target schema:
--   commerce
--
-- Target table:
--   category
-- ============================================================

-- ============================================================
-- 1. INSPECT EXISTING COMMERCE TABLES
-- ============================================================
--
-- Confirm what currently exists in the commerce schema
-- before creating the Category table.
-- ============================================================

SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_schema = 'commerce'
ORDER BY table_name;

-- ============================================================
-- 2. INSPECT EXISTING SUPPLIER TABLE
-- ============================================================
--
-- Supplier is already implemented in the commerce schema.
-- We use its actual implementation as the project's
-- database precedent rather than guessing Category's design.
-- ============================================================

SELECT
    column_name,
    data_type,
    character_maximum_length,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'commerce'
  AND table_name = 'supplier'
ORDER BY ordinal_position;

-- ============================================================
-- 3. INSPECT SUPPLIER CONSTRAINTS
-- ============================================================
--
-- Identify the existing primary key and other constraints.
-- ============================================================

SELECT
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
    AND tc.table_name = kcu.table_name
WHERE tc.table_schema = 'commerce'
  AND tc.table_name = 'supplier'
ORDER BY
    tc.constraint_type,
    tc.constraint_name,
    kcu.ordinal_position;

-- ============================================================
-- 4. CATEGORY SOURCE-TO-TARGET MAPPING
-- ============================================================
--
-- Source fields are mapped to the target PostgreSQL schema
-- defined in Phase 3 Enterprise Database Design.
--
-- Source column       → Target column
-- ------------------------------------------------------------
-- CategoryCode        → category_id
-- CategoryName        → category_name
-- Description         → category_description
-- ActiveFlag          → is_active
-- CreatedOn           → created_date
-- CreatedByUser       → created_by
-- ModifiedOn          → updated_date
-- ModifiedByUser      → updated_by
--
-- Target data types:
--   category_id          → text
--   category_name        → text
--   category_description → text
--   is_active            → boolean
--   created_date         → timestamp without time zone
--   created_by           → text
--   updated_date         → timestamp without time zone
--   updated_by           → text
--
-- Primary Key:
--   category_id
--
-- Foreign Keys:
--   None
--
-- Parent-child relationship:
--   Category (1) → Product (M)
--
-- Product will reference Category through category_id.
-- ============================================================


-- ============================================================
-- 5. CREATE CATEGORY TABLE
-- ============================================================
--
-- Target table:
--   commerce.category
--
-- Schema is based on the documented Category target design.
--
-- Primary Key:
--   category_id
--
-- Foreign Keys:
--   None
--
-- Category is a parent entity for Product.
-- Product.category_id will reference category.category_id.
-- ============================================================

CREATE TABLE IF NOT EXISTS commerce.category (
    category_id          text PRIMARY KEY,
    category_name        text NOT NULL,
    category_description text NOT NULL,
    is_active            boolean NOT NULL,
    created_date         timestamp without time zone NOT NULL,
    created_by           text NOT NULL,
    updated_date         timestamp without time zone NOT NULL,
    updated_by           text NOT NULL
);

-- ============================================================
-- 6. VERIFY CATEGORY TABLE STRUCTURE
-- ============================================================
--
-- Confirm that the PostgreSQL table matches the documented
-- Category target schema before loading any data.
-- ============================================================

SELECT
    column_name,
    data_type,
    character_maximum_length,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'commerce'
  AND table_name = 'category'
ORDER BY ordinal_position;

-- ============================================================
-- 7. VERIFY CATEGORY PRIMARY KEY
-- ============================================================

SELECT
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
    AND tc.table_name = kcu.table_name
WHERE tc.table_schema = 'commerce'
  AND tc.table_name = 'category'
ORDER BY
    tc.constraint_type,
    tc.constraint_name,
    kcu.ordinal_position;

-- ============================================================
-- 8. LOAD CLEAN CATEGORY DATA
-- ============================================================
--
-- Source:
--   product_catalog_categories_clean.csv
--
-- Only the validated clean dataset is loaded.
--
-- Source-to-target mapping:
--   CategoryCode        → category_id
--   CategoryName        → category_name
--   Description         → category_description
--   ActiveFlag          → is_active
--   CreatedOn           → created_date
--   CreatedByUser       → created_by
--   ModifiedOn          → updated_date
--   ModifiedByUser      → updated_by
--
-- The source column names are retained in the CSV.
-- The PostgreSQL target uses the documented target names.
-- ============================================================

select * from commerce.category;

