/* LJ Dev Commerce | Phase 5.4: Primary-Key Validation
Objective: Inventory PK definitions and their enforcement/validation state.
Composite PKs are shown in the inventory; no assumptions are made about keys. */
-- 5.4.1 PK columns
SELECT tc.table_schema, tc.table_name, tc.constraint_name,
       string_agg(kcu.column_name, ', ' ORDER BY kcu.ordinal_position) AS pk_columns
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
 ON kcu.constraint_catalog=tc.constraint_catalog
AND kcu.constraint_schema=tc.constraint_schema
AND kcu.constraint_name=tc.constraint_name
AND kcu.table_schema=tc.table_schema AND kcu.table_name=tc.table_name
WHERE tc.table_schema='commerce' AND tc.constraint_type='PRIMARY KEY'
GROUP BY tc.table_schema,tc.table_name,tc.constraint_name
ORDER BY tc.table_name;
-- 5.4.2 PK constraint status
SELECT n.nspname AS table_schema,t.relname AS table_name,c.conname AS constraint_name,
       c.convalidated AS is_validated,c.condeferrable AS is_deferrable,
       c.condeferred AS initially_deferred,pg_get_constraintdef(c.oid) AS definition
FROM pg_constraint c
JOIN pg_class t ON t.oid=c.conrelid
JOIN pg_namespace n ON n.oid=t.relnamespace
WHERE n.nspname='commerce' AND c.contype='p'
ORDER BY t.relname,c.conname;
