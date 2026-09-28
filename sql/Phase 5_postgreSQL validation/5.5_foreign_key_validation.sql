/* LJ Dev Commerce | Phase 5.5: Foreign-Key Validation
Objective: Inventory declared FKs and inspect definitions and validation status.
Actual orphan-record checks are performed in Section 5.6. */
SELECT cn.nspname AS child_schema,ch.relname AS child_table,fk.conname AS foreign_key_name,
       pn.nspname AS parent_schema,pa.relname AS parent_table,
       pg_get_constraintdef(fk.oid) AS foreign_key_definition,
       fk.convalidated AS is_validated,fk.condeferrable AS is_deferrable,
       fk.condeferred AS initially_deferred
FROM pg_constraint fk
JOIN pg_class ch ON ch.oid=fk.conrelid
JOIN pg_namespace cn ON cn.oid=ch.relnamespace
JOIN pg_class pa ON pa.oid=fk.confrelid
JOIN pg_namespace pn ON pn.oid=pa.relnamespace
WHERE fk.contype='f' AND cn.nspname='commerce'
ORDER BY ch.relname,fk.conname;
