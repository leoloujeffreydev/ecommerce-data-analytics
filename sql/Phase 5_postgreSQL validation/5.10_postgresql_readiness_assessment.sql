/* LJ Dev Commerce | Phase 5.10: PostgreSQL Readiness Assessment
Objective: Summarize observable schema metadata at the end of Phase 5.
This is not an automatic sign-off. Review all results from Sections 5.1-5.9,
including source reconciliation and documented exceptions, before assigning
the final project readiness status. */
WITH project_tables AS (
 SELECT table_name FROM information_schema.tables
 WHERE table_schema='commerce' AND table_type='BASE TABLE'
), cs AS (
 SELECT COUNT(*) FILTER(WHERE c.contype='p') AS primary_key_count,
        COUNT(*) FILTER(WHERE c.contype='f') AS foreign_key_count,
        COUNT(*) FILTER(WHERE NOT c.convalidated) AS unvalidated_constraint_count
 FROM pg_constraint c JOIN pg_class t ON t.oid=c.conrelid
 JOIN pg_namespace n ON n.oid=t.relnamespace
 WHERE n.nspname='commerce'
)
SELECT current_database() AS database_name,current_user AS connected_user,
       (SELECT COUNT(*) FROM project_tables) AS base_table_count,
       cs.primary_key_count,cs.foreign_key_count,cs.unvalidated_constraint_count,
       CASE WHEN (SELECT COUNT(*) FROM project_tables)=0
              THEN 'REVIEW REQUIRED: no base tables found in commerce schema'
            WHEN cs.unvalidated_constraint_count>0
              THEN 'REVIEW REQUIRED: unvalidated constraints exist'
            ELSE 'METADATA CHECK COMPLETE: manual review of Sections 5.1-5.9 required'
       END AS metadata_assessment,
       'Do not treat this metadata result as a complete readiness sign-off.'
       AS assessment_note
FROM cs;
