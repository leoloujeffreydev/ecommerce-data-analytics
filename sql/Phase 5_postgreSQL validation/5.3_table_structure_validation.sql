/* LJ Dev Commerce | Phase 5.3: Table Structure Validation
Objective: Inspect actual columns, order, types, nullability and defaults.
Compare results with the approved Phase 3 data dictionary and mappings.
This query reports metadata; it does not decide whether differences are valid. */
SELECT table_name, ordinal_position, column_name, data_type, udt_name,
       character_maximum_length, numeric_precision, numeric_scale,
       is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'commerce'
ORDER BY table_name, ordinal_position;
