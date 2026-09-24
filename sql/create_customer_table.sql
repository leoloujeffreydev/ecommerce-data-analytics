CREATE TABLE commerce.customer (
    customer_id TEXT PRIMARY KEY,
    customer_name TEXT NOT NULL,
    email TEXT,
    phone TEXT,
    address TEXT,
    city TEXT,
    country TEXT,
    customer_status TEXT NOT NULL,
    created_date TIMESTAMP NOT NULL,
    created_by TEXT NOT NULL,
    updated_date TIMESTAMP NOT NULL,
    updated_by TEXT NOT NULL
);

SELECT *
FROM commerce.customer;