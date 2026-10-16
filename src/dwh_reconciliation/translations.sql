SELECT
    -- 1. Categories without translations
    (
        SELECT COUNT(*)
        FROM (
            SELECT category_name
            FROM dw.dim_product
            WHERE category_name IS NOT NULL

            EXCEPT

            SELECT product_category_name
            FROM dw.ref_category_translation
        ) AS differences
    ) AS missing_categories,

    -- 2. Translations that differ from staging
    (
        SELECT COUNT(*)
        FROM (
            SELECT product_category_name, product_category_name_english
            FROM stg.category_translation

            EXCEPT

            SELECT product_category_name, product_category_name_english
            FROM dw.ref_category_translation
        ) AS differences
    ) AS incorrect_translations,

    -- 3. Product translations inconsistent with reference
    (
        SELECT COUNT(*)
        FROM (
            SELECT category_name, category_name_english
            FROM dw.dim_product
            WHERE category_name IS NOT NULL

            EXCEPT

            SELECT product_category_name, product_category_name_english
            FROM dw.ref_category_translation
        ) AS differences
    ) AS inconsistent_products;