CREATE VIEW stg.v_source_dates AS

SELECT CAST(order_purchase_timestamp AS DATE) AS full_date
FROM stg.orders

UNION ALL

SELECT CAST(order_approved_at AS DATE)
FROM stg.orders

UNION ALL

SELECT CAST(order_delivered_carrier_date AS DATE)
FROM stg.orders

UNION ALL

SELECT CAST(order_delivered_customer_date AS DATE)
FROM stg.orders

UNION ALL

SELECT CAST(order_estimated_delivery_date AS DATE)
FROM stg.orders

UNION ALL

SELECT CAST(shipping_limit_date AS DATE)
FROM stg.order_items

UNION ALL

SELECT CAST(review_creation_date AS DATE)
FROM stg.reviews

UNION ALL

SELECT CAST(review_answer_timestamp AS DATE)
FROM stg.reviews