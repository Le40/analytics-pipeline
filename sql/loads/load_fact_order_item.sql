INSERT INTO dw.fact_order_item(
    order_id ,
    order_item_id,
    product_key,
    seller_key,
    purchase_date_key,
    shipping_limit_timestamp,
    price,
    freight_value
)    
    SELECT
        oi.order_id,
        oi.order_item_id,
        dp.product_key,
        ds.seller_key,
        dd.date_key AS purchase_date_key,
        oi.shipping_limit_date,
        oi.price,
        oi.freight_value
    FROM stg.order_items AS oi 

    JOIN stg.orders as o
        ON o.order_id = oi.order_id

    JOIN dw.dim_date as dd
        ON CAST(o.order_purchase_timestamp AS DATE) = dd.full_date

    JOIN dw.dim_product AS dp
        ON dp.product_id = oi.product_id

    JOIN dw.dim_seller AS ds
        ON ds.seller_id = oi.seller_id

WHERE NOT EXISTS(
    SELECT 1
    FROM dw.fact_order_item as f 
    WHERE f.order_id = oi.order_id
        AND f.order_item_id = oi.order_item_id
);