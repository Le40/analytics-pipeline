INSERT INTO dw.dim_seller (
    seller_id,
    zip_code_prefix,
    city,
    state
)
SELECT
    s.seller_id,
    s.seller_zip_code_prefix,
    s.seller_city,
    s.seller_state
FROM stg.sellers AS s 
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.dim_seller AS d 
    WHERE d.seller_id = s.seller_id 
); 