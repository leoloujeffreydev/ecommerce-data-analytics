/* LJ Dev Commerce | Phase 5.9: Business Rules and Database Integrity
Objective: Inspect database-enforced constraints and required columns.
Business rules must come from approved project documentation; this script
does not invent rules based on column names. */
-- 5.9.1 Declared constraints
SELECT n.nspname AS table_schema,t.relname AS table_name,c.conname AS constraint_name,
 CASE c.contype WHEN 'c' THEN 'CHECK' WHEN 'u' THEN 'UNIQUE'
 WHEN 'p' THEN 'PRIMARY KEY' WHEN 'f' THEN 'FOREIGN KEY'
 ELSE c.contype::text END AS constraint_type,
 c.convalidated AS is_validated,pg_get_constraintdef(c.oid) AS definition
FROM pg_constraint c JOIN pg_class t ON t.oid=c.conrelid
JOIN pg_namespace n ON n.oid=t.relnamespace
WHERE n.nspname='commerce'
ORDER BY t.relname,constraint_type,c.conname;
-- 5.9.2 Required columns
SELECT table_name,ordinal_position,column_name,data_type,is_nullable,column_default
FROM information_schema.columns
WHERE table_schema='commerce' AND is_nullable='NO'
ORDER BY table_name,ordinal_position;
-- 5.9.3 Unvalidated constraints, if any
SELECT n.nspname AS table_schema,t.relname AS table_name,c.conname AS constraint_name,
 c.contype AS constraint_type,pg_get_constraintdef(c.oid) AS definition
FROM pg_constraint c JOIN pg_class t ON t.oid=c.conrelid
JOIN pg_namespace n ON n.oid=t.relnamespace
WHERE n.nspname='commerce' AND NOT c.convalidated
ORDER BY t.relname,c.conname;
