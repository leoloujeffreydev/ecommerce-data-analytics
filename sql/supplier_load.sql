-- ============================================================
-- 11.1 Inspect Existing PostgreSQL Schema
-- Purpose:
-- Confirm which tables currently exist in the commerce schema.
-- This prevents accidentally recreating existing tables.
-- ============================================================

SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_schema = 'commerce'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- ============================================================
-- 11.2 Inspect Existing Customer Table
-- Purpose:
-- Review the existing Customer target-table structure,
-- including column names, data types, and nullability.
--
-- This allows the Supplier table implementation to follow
-- the established PostgreSQL database conventions.
-- ============================================================

SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'commerce'
  AND table_name = 'customer'
ORDER BY ordinal_position;

-- ============================================================
-- 11.2b Inspect Existing Customer Constraints
-- Purpose:
-- Identify the primary key, foreign keys, and unique constraints
-- currently defined on the Customer target table.
--
-- This helps us follow the established database conventions
-- when defining the Supplier target table.
-- ============================================================

SELECT
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name
FROM information_schema.table_constraints AS tc
LEFT JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
    AND tc.table_name = kcu.table_name
WHERE tc.table_schema = 'commerce'
  AND tc.table_name = 'customer'
ORDER BY
    tc.constraint_type,
    kcu.ordinal_position;

-- ============================================================
-- 11.3 Supplier Source-to-Target Mapping
-- Purpose:
-- Document how the validated Python Supplier dataset maps
-- from source-style field names to the established
-- PostgreSQL commerce.supplier target schema.
--
-- The mapping follows the Phase 3 Enterprise Database Design.
-- ============================================================

-- Source: SupplierCode       → Target: supplier_id
-- Source: SupplierName       → Target: supplier_name
-- Source: ContactPerson      → Target: contact_person
-- Source: EmailAddress       → Target: email
-- Source: PhoneNumber        → Target: phone
-- Source: StreetAddress      → Target: address
-- Source: City               → Target: city
-- Source: Country            → Target: country
-- Source: ActiveFlag         → Target: is_active
-- Source: CreatedOn          → Target: created_date
-- Source: CreatedByUser      → Target: created_by
-- Source: ModifiedOn         → Target: updated_date
-- Source: ModifiedByUser     → Target: updated_by

-- ============================================================
-- 11.4 Create Supplier Target Table
-- Purpose:
-- Create the PostgreSQL Supplier master table using the
-- established LJ Dev Commerce database design.
--
-- The table is created under the commerce schema.
-- supplier_id is the primary key and corresponds to the
-- source SupplierCode field.
--
-- The IF NOT EXISTS clause prevents an existing Supplier
-- table from being recreated accidentally.
-- ============================================================

CREATE TABLE IF NOT EXISTS commerce.supplier (
    supplier_id TEXT PRIMARY KEY,
    supplier_name TEXT NOT NULL,
    contact_person TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT NOT NULL,
    address TEXT NOT NULL,
    city TEXT NOT NULL,
    country TEXT NOT NULL,
    is_active BOOLEAN NOT NULL,
    created_date TIMESTAMP NOT NULL,
    created_by TEXT NOT NULL,
    updated_date TIMESTAMP NOT NULL,
    updated_by TEXT NOT NULL
);

-- ============================================================
-- 11.4b Verify Supplier Target Table
-- Purpose:
-- Confirm that the commerce.supplier table was created with
-- the expected columns and data types.
-- ============================================================

SELECT
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'commerce'
  AND table_name = 'supplier'
ORDER BY ordinal_position;

-- ============================================================
-- 11.5 Verify Supplier Primary Key
-- Purpose:
-- Confirm that supplier_id is defined as the primary key
-- of the commerce.supplier table.
--
-- This ensures SupplierCode from the source dataset is
-- correctly represented as the unique Supplier identifier
-- in PostgreSQL.
-- ============================================================

SELECT
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
    AND tc.table_name = kcu.table_name
WHERE tc.table_schema = 'commerce'
  AND tc.table_name = 'supplier'
  AND tc.constraint_type = 'PRIMARY KEY';


-- ============================================================
-- 11.13 Verify Loaded Supplier Data
-- Purpose:
-- Confirm that the Supplier records loaded by the Python ETL
-- process are present in the commerce.supplier target table.
--
-- The expected result is 8 Supplier records.
-- ============================================================

SELECT
    supplier_id,
    supplier_name,
    contact_person,
    email,
    phone,
    address,
    city,
    country,
    is_active,
    created_date,
    created_by,
    updated_date,
    updated_by
FROM commerce.supplier
ORDER BY supplier_id;
