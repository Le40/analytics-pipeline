IF OBJECT_ID('dw.dim_seller', 'U') IS NULL
BEGIN 
    CREATE TABLE dw.dim_seller (
        seller_key INT IDENTITY(1,1) PRIMARY KEY,
        seller_id VARCHAR(32) NOT NULL UNIQUE,
        zip_code_prefix INT NOT NULL,
        city NVARCHAR(100) NOT NULL,
        state CHAR(2) NOT NULL
    );
END;