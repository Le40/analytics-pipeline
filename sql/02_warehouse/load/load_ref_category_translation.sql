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