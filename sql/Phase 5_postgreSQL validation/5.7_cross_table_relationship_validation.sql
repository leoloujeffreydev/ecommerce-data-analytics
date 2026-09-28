/* LJ Dev Commerce | Phase 5.7: Cross-Table Relationship Validation
Objective: Report relationships actually declared by FK constraints and list
base tables with no declared incoming or outgoing FK. Does not infer links
from similarly named columns or undocumented business assumptions. */
-- 5.7.1 Declared FK relationships
SELECT cn.nspname AS child_schema,ch.relname AS child_table,f.conname AS fk_name,
       string_agg(ca.attname,', ' ORDER BY k.ord) AS child_columns,
       pn.nspname AS parent_schema,pa.relname AS parent_table,
       string_agg(aa.attname,', ' ORDER BY k.ord) AS parent_columns,
       f.convalidated AS is_validated
FROM pg_constraint f
JOIN pg_class ch ON ch.oid=f.conrelid JOIN pg_namespace cn ON cn.oid=ch.relnamespace
JOIN pg_class pa ON pa.oid=f.confrelid JOIN pg_namespace pn ON pn.oid=pa.relnamespace
JOIN LATERAL unnest(f.conkey,f.confkey) WITH ORDINALITY k(child_attnum,parent_attnum,ord) ON true
JOIN pg_attribute ca ON ca.attrelid=ch.oid AND ca.attnum=k.child_attnum
JOIN pg_attribute aa ON aa.attrelid=pa.oid AND aa.attnum=k.parent_attnum
WHERE f.contype='f' AND cn.nspname='commerce'
GROUP BY cn.nspname,ch.relname,f.conname,pn.nspname,pa.relname,f.convalidated
ORDER BY ch.relname,f.conname;
-- 5.7.2 Tables with no declared FK link
WITH t AS (
 SELECT table_schema,table_name FROM information_schema.tables
 WHERE table_schema='commerce' AND table_type='BASE TABLE'
), linked AS (
 SELECT cn.nspname s,ch.relname t FROM pg_constraint f
 JOIN pg_class ch ON ch.oid=f.conrelid JOIN pg_namespace cn ON cn.oid=ch.relnamespace
 WHERE f.contype='f' AND cn.nspname='commerce'
 UNION
 SELECT pn.nspname,pa.relname FROM pg_constraint f
 JOIN pg_class pa ON pa.oid=f.confrelid JOIN pg_namespace pn ON pn.oid=pa.relnamespace
 WHERE f.contype='f' AND pn.nspname='commerce'
)
SELECT t.table_schema,t.table_name FROM t LEFT JOIN linked l
 ON l.s=t.table_schema AND l.t=t.table_name
WHERE l.t IS NULL ORDER BY t.table_name;
