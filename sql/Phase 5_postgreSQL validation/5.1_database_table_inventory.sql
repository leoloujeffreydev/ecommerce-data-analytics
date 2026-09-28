/* LJ Dev Commerce | Phase 5.1: Database and Table Inventory
Objective: Identify the active database and objects in commerce.
Read-only inspection; no database objects or data are modified. */
-- 5.1.1 Connection details
SELECT current_database() AS database_name, current_schema() AS current_schema,
       current_user AS connected_user, version() AS postgresql_version;
-- 5.1.2 Tables and views
SELECT table_schema, table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'commerce'
ORDER BY table_name;
