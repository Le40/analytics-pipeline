 INSERT INTO dw.fact_order(
    order_id,
    customer_key,
    location_key,
    purchase_date_key,
    delivery_date_key,
    status,
    purchase_timestamp,
    approved_timestamp,
    carrier_delivery_timestamp,
    customer_delivery_timestamp,
    estimated_delivery_timestamp
 )   
    SELECT
        o.order_id,
        dc.customer_key,
        dl.location_key,
        purchase_date.date_key AS purchase_date_key,
        delivery_date.date_key AS delivery_date_key,
        o.order_status,
        o.order_purchase_timestamp,
        o.order_approved_at,
        o.order_delivered_carrier_date,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date
    FROM stg.orders AS o 

    JOIN stg.customers AS c 
        ON o.customer_id = c.customer_id

    JOIN dw.dim_customer AS dc 
        ON c.customer_unique_id = dc.customer_unique_id

    JOIN dw.dim_location AS dl 
        ON c.customer_zip_code_prefix = dl.zip_code_prefix 
        AND c.customer_city = dl.city
        AND c.customer_state = dl.state

    JOIN dw.dim_date AS purchase_date
        ON CAST(o.order_purchase_timestamp AS DATE) = purchase_date.full_date

    LEFT JOIN dw.dim_date AS delivery_date
        ON CAST(o.order_delivered_customer_date AS DATE) = delivery_date.full_date
        
WHERE NOT EXISTS(
    SELECT 1
    FROM dw.fact_order AS f  
    WHERE f.order_id = o.order_id
);




