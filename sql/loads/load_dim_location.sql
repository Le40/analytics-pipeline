INSERT INTO dw.dim_location (zip_code_prefix, city, state)
    SELECT DISTINCT
        c.customer_zip_code_prefix,
        c.customer_city,
        c.customer_state 
    FROM stg.customers AS c 
    WHERE NOT EXISTS(
        SELECT 1
        FROM dw.dim_location AS l 
        WHERE l.zip_code_prefix = c.customer_zip_code_prefix
            AND l.city = c.customer_city
            AND l.state = c.customer_state
    );