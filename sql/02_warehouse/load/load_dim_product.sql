INSERT INTO dw.dim_product (
    product_id,
    category_name,
    category_name_english,
    weight_g,
    length_cm,
    height_cm,
    width_cm
)
SELECT
    p.product_id,
    p.product_category_name,
    dt.product_category_name_english,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM stg.products AS p 

LEFT JOIN dw.ref_category_translation AS dt
    ON p.product_category_name = dt.product_category_name

WHERE NOT EXISTS (
    SELECT 1
    FROM dw.dim_product AS d
    WHERE d.product_id = p.product_id 
);