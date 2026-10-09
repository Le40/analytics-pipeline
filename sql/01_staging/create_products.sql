IF OBJECT_ID('stg.products', 'U') IS NULL
BEGIN
    CREATE TABLE stg.products (
        product_id VARCHAR(32) NOT NULL,
        product_category_name NVARCHAR(100) NULL,
        product_name_lenght INT NULL,
        product_description_lenght INT NULL,
        product_photos_qty INT NULL,
        product_weight_g DECIMAL(10, 2) NULL,
        product_length_cm DECIMAL(10, 2) NULL,
        product_height_cm DECIMAL(10, 2) NULL,
        product_width_cm DECIMAL(10, 2) NULL
    );
END;