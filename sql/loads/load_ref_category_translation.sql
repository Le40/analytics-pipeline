SET XACT_ABORT ON;
BEGIN TRANSACTION;

-- 1. Load original translations
INSERT INTO dw.ref_category_translation (
    product_category_name,
    product_category_name_english
)
SELECT DISTINCT
    t.product_category_name,
    t.product_category_name_english
FROM stg.category_translation AS t
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.ref_category_translation AS d
    WHERE d.product_category_name = t.product_category_name
);

-- 2. Add missing translations
INSERT INTO dw.ref_category_translation
SELECT v.product_category_name, v.product_category_name_english
FROM (VALUES
    ('pc_gamer', 'gaming_pc'),
    ('portateis_cozinha_e_preparadores_de_alimentos',
     'portable_kitchen_and_food_preparation')
) AS v(product_category_name, product_category_name_english)
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.ref_category_translation AS d
    WHERE d.product_category_name = v.product_category_name
);

-- 3. Update existing products
UPDATE p
SET p.category_name_english = t.product_category_name_english
FROM dw.dim_product AS p
JOIN dw.ref_category_translation AS t
    ON p.category_name = t.product_category_name;

COMMIT;