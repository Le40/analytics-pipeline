IF OBJECT_ID('dw.ref_category_translation', 'U') IS NULL
BEGIN
    CREATE TABLE dw.ref_category_translation (
        product_category_name VARCHAR(150) PRIMARY KEY,
        product_category_name_english VARCHAR(150)
    );
END;