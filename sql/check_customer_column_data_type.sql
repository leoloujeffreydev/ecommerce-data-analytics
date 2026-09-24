SELECT
    ordinal_position,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'commerce'
  AND table_name = 'customer'
ORDER BY ordinal_position;

ALTER ROLE postgres WITH PASSWORD 'Dream99*';

select * from commerce.customer;