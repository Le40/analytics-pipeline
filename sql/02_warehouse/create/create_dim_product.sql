IF OBJECT_ID('dw.dim_product', 'U') IS NULL
BEGIN
    CREATE TABLE dw.dim_product (
        product_key INT IDENTITY(1,1) PRIMARY KEY,
        product_id VARCHAR(32) NOT NULL UNIQUE,
        category_name NVARCHAR(100) NULL,
        category_name_english NVARCHAR(100) NULL,
        weight_g DECIMAL(10, 2) NULL,
        length_cm DECIMAL(10, 2) NULL,
        height_cm DECIMAL(10, 2) NULL,
        width_cm DECIMAL(10, 2) NULL
    );
END;