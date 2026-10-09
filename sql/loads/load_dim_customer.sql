INSERT INTO dw.dim_customer (customer_unique_id)
    SELECT DISTINCT c.customer_unique_id
    FROM stg.customers AS c 
    WHERE NOT EXISTS (
        SELECT 1
        FROM dw.dim_customer AS d
        WHERE d.customer_unique_id = c.customer_unique_id
    );