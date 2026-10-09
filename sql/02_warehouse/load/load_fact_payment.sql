INSERT INTO dw.fact_payment(
    order_id,
    payment_sequential,
    customer_key,
    purchase_date_key,
    payment_type,
    installments,
    payment_value
) 
    SELECT
        p.order_id,
        p.payment_sequential,
        dc.customer_key,
        dd.date_key AS purchase_date_key,
        p.payment_type,
        p.payment_installments,
        p.payment_value
    FROM stg.payments AS p 

    JOIN stg.orders AS o 
        ON o.order_id = p.order_id

    JOIN stg.customers AS c
        ON c.customer_id = o.customer_id

    JOIN dw.dim_customer AS dc
        ON dc.customer_unique_id = c.customer_unique_id

    JOIN dw.dim_date AS dd
        ON CAST(o.order_purchase_timestamp AS DATE) = dd.full_date
        
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.fact_payment AS f
    WHERE f.order_id = p.order_id
        AND f.payment_sequential = p.payment_sequential
);