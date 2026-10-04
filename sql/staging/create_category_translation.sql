IF OBJECT_ID('stg.category_translation', 'U') IS NULL
BEGIN
    CREATE TABLE stg.category_translation (
        product_category_name NVARCHAR(100) NOT NULL,
        product_category_name_english NVARCHAR(100) NOT NULL
    );
END;