IF OBJECT_ID('stg.sellers', 'U') IS NULL
BEGIN
    CREATE TABLE stg.sellers (
        seller_id VARCHAR(32) NOT NULL,
        seller_zip_code_prefix INT NOT NULL,
        seller_city NVARCHAR(100) NOT NULL,
        seller_state CHAR(2) NOT NULL
    );
END;