IF OBJECT_ID('dw_dim_customer', 'U') IS NULL
BEGIN
    CREATE TABLE dw.dim_customer (
        customer_key INT IDENTITY(1,1) PRIMARY KEY,
        customer_unique_id VARCHAR(32) NOT NULL UNIQUE
    );
END;