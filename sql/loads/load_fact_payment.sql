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
        fo.customer_key,
        fo.location_key,
        fo.date_key AS purchase_date_key,
        p.payment_type,
        p.payment_installments,
        p.payment_value
    FROM stg.payments AS p 

    JOIN dw.fact_order AS fo
        ON fo.order_id = p.order_id
        
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.fact_payment AS f
    WHERE f.order_id = p.order_id
        AND f.payment_sequential = p.payment_sequential
);