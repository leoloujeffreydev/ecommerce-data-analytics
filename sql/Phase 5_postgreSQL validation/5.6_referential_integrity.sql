/* LJ Dev Commerce | Phase 5.6: Referential Integrity
Objective: Count orphan values for single-column FKs declared on commerce tables.
Composite FKs are reported as not evaluated. Zero orphans in an empty child
table does not reconcile a blocked source load (e.g., inventory_movement). */
CREATE TEMP TABLE IF NOT EXISTS phase56_fk_orphan_results (
 child_table text, foreign_key_name text, child_column text,
 parent_table text, parent_column text, orphan_count bigint
) ON COMMIT PRESERVE ROWS;
TRUNCATE TABLE phase56_fk_orphan_results;
DO $$
DECLARE r record; q text; n bigint;
BEGIN
 FOR r IN
  SELECT cns.nspname cs,ch.relname ct,f.conname fn,pns.nspname ps,pa.relname pt,
         ca.attname cc,pa_col.attname pc,array_length(f.conkey,1) kc
  FROM pg_constraint f
  JOIN pg_class ch ON ch.oid=f.conrelid JOIN pg_namespace cns ON cns.oid=ch.relnamespace
  JOIN pg_class pa ON pa.oid=f.confrelid JOIN pg_namespace pns ON pns.oid=pa.relnamespace
  JOIN pg_attribute ca ON ca.attrelid=ch.oid AND ca.attnum=f.conkey[1]
  JOIN pg_attribute pa_col ON pa_col.attrelid=pa.oid AND pa_col.attnum=f.confkey[1]
  WHERE f.contype='f' AND cns.nspname='commerce'
  ORDER BY ch.relname,f.conname
 LOOP
  IF r.kc=1 THEN
   q:=format('SELECT count(*) FROM %I.%I c WHERE c.%I IS NOT NULL AND NOT EXISTS (SELECT 1 FROM %I.%I p WHERE p.%I=c.%I)',
             r.cs,r.ct,r.cc,r.ps,r.pt,r.pc,r.cc);
   EXECUTE q INTO n;
   INSERT INTO phase56_fk_orphan_results VALUES
    (format('%I.%I',r.cs,r.ct),r.fn,r.cc,format('%I.%I',r.ps,r.pt),r.pc,n);
  ELSE
   INSERT INTO phase56_fk_orphan_results VALUES
    (format('%I.%I',r.cs,r.ct),r.fn||' [composite: not evaluated]',NULL,
     format('%I.%I',r.ps,r.pt),NULL,NULL);
  END IF;
 END LOOP;
END $$;
SELECT * FROM phase56_fk_orphan_results ORDER BY child_table,foreign_key_name;
